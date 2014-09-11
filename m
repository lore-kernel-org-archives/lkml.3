Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaIKAx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 20:53:28 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:57263 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbaIKAxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 20:53:25 -0400
Date: Thu, 11 Sep 2014 00:50:00 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v8] tpm_tis: verify interrupt during init
In-Reply-To: <20140908220238.GB6204@obsidianresearch.com>
Message-ID: <alpine.LNX.2.11.1409110010290.700@localhost.localdomain>
References: <20140827173142.GA11183@obsidianresearch.com> <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain> <20140827214743.GC11183@obsidianresearch.com> <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain> <20140828165348.GE11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain> <20140830174920.GA26218@obsidianresearch.com> <alpine.LNX.2.11.1408302229001.579@localhost.localdomain> <20140902172015.GD13956@obsidianresearch.com> <alpine.LNX.2.11.1409021954110.1026@localhost.localdomain>
 <20140908220238.GB6204@obsidianresearch.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 8 Sep 2014, Jason Gunthorpe wrote:
> On Tue, Sep 02, 2014 at 08:22:58PM +0000, Scot Doyle wrote:
>
>> It's spending that time (now 3 seconds) in tpm_tis_send_data.
>
> Due to request_locality?

The first command transmitted (TPM_CAP_PROP) in tpm_get_timeouts goes 
through tpm_tis_send which calls tpm_tis_send_data before setting up 
polling mode for the interrupt test. In tpm_tis_send_data, the last call 
to wait_for_tpm_stat is still timing out.

One solution would be to move the test from tpm_tis_send to 
tpm_tis_send_data. Another would be to expand the test in tpm_tis_send to 
include the call to tpm_tis_send_data.

The latter seems safer, since it provides more opportunity for an IRQ to 
be generated. E.g. I'm not sure if TPM_CAP_PROP always generates an IRQ. 
But the problem with this approach is that tpm_tis_send becomes a bit 
messy. So this patch wraps tpm_tis_send in an attempt to keep the code 
clean. (Is there a better name for the wrapped function than 
tpm_tis_send_main?)

Thoughts?

With this patch, the output becomes:
[    4.264619] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
[    4.311628] tpm_tis 00:08: [Firmware Bug]: TPM interrupt not working, polling instead

P.S. My apologies for revisiting this issue after it seemed to be 
finalized.

---
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..2dbd652 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -75,6 +75,10 @@ enum tis_defaults {
 #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))

+struct priv_data {
+	bool irq_tested;
+};
+
 static LIST_HEAD(tis_chips);
 static DEFINE_MUTEX(tis_lock);

@@ -338,12 +342,27 @@ out_err:
 	return rc;
 }

+static void disable_interrupts(struct tpm_chip *chip)
+{
+	u32 intmask;
+	intmask =
+	    ioread32(chip->vendor.iobase +
+		     TPM_INT_ENABLE(chip->vendor.locality));
+	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
+		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
+	iowrite32(intmask,
+		  chip->vendor.iobase +
+		  TPM_INT_ENABLE(chip->vendor.locality));
+	free_irq(chip->vendor.irq, chip);
+	chip->vendor.irq = 0;
+}
+
 /*
  * If interrupts are used (signaled by an irq set in the vendor structure)
  * tpm.c can skip polling for the data to be available as the interrupt is
  * waited for here
  */
-static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
+static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	int rc;
 	u32 ordinal;
@@ -373,6 +392,28 @@ out_err:
 	return rc;
 }

+static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	int rc, irq;
+	struct priv_data *priv = chip->vendor.priv;
+
+	if (!chip->vendor.irq || priv->irq_tested)
+		return tpm_tis_send_main(chip, buf, len);
+
+	/* Verify receipt of the expected IRQ */
+	irq = chip->vendor.irq;
+	chip->vendor.irq = 0;
+	rc = tpm_tis_send_main(chip, buf, len);
+	chip->vendor.irq = irq;
+	if (!priv->irq_tested) {
+		disable_interrupts(chip);
+		dev_err(chip->dev,
+			FW_BUG "TPM interrupt not working, polling instead\n");
+	}
+	priv->irq_tested = true;
+	return rc;
+}
+
 struct tis_vendor_timeout_override {
 	u32 did_vid;
 	unsigned long timeout_us[4];
@@ -505,6 +546,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	if (interrupt == 0)
 		return IRQ_NONE;

+	((struct priv_data*)chip->vendor.priv)->irq_tested = true;
 	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
 		wake_up_interruptible(&chip->vendor.read_queue);
 	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
@@ -534,10 +576,14 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	u32 vendor, intfcaps, intmask;
 	int rc, i, irq_s, irq_e, probe;
 	struct tpm_chip *chip;
+	struct priv_data *priv;

 	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
 		return -ENODEV;

+	priv = devm_kzalloc(dev, sizeof(struct priv_data), GFP_KERNEL);
+	chip->vendor.priv = priv;
+
 	chip->vendor.iobase = ioremap(start, len);
 	if (!chip->vendor.iobase) {
 		rc = -EIO;
@@ -605,19 +651,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
 		dev_dbg(dev, "\tData Avail Int Support\n");

-	/* get the timeouts before testing for irqs */
-	if (tpm_get_timeouts(chip)) {
-		dev_err(dev, "Could not get TPM timeouts and durations\n");
-		rc = -ENODEV;
-		goto out_err;
-	}
-
-	if (tpm_do_selftest(chip)) {
-		dev_err(dev, "TPM self test failed\n");
-		rc = -ENODEV;
-		goto out_err;
-	}
-
 	/* INTERRUPT Setup */
 	init_waitqueue_head(&chip->vendor.read_queue);
 	init_waitqueue_head(&chip->vendor.int_queue);
@@ -719,6 +752,18 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		}
 	}

+	if (tpm_get_timeouts(chip)) {
+		dev_err(dev, "Could not get TPM timeouts and durations\n");
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+	if (tpm_do_selftest(chip)) {
+		dev_err(dev, "TPM self test failed\n");
+		rc = -ENODEV;
+		goto out_err;
+	}
+
 	INIT_LIST_HEAD(&chip->vendor.list);
 	mutex_lock(&tis_lock);
 	list_add(&chip->vendor.list, &tis_chips);
