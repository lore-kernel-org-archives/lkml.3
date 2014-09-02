Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaIBU0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:26:11 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:35505 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaIBU0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:26:09 -0400
Date: Tue, 2 Sep 2014 20:22:58 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v6] tpm_tis: verify interrupt during init
In-Reply-To: <20140902172015.GD13956@obsidianresearch.com>
Message-ID: <alpine.LNX.2.11.1409021954110.1026@localhost.localdomain>
References: <20140825182414.GB1298@obsidianresearch.com> <alpine.LNX.2.11.1408270410190.701@localhost.localdomain> <20140827173142.GA11183@obsidianresearch.com> <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain> <20140827214743.GC11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain> <20140828165348.GE11183@obsidianresearch.com> <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain> <20140830174920.GA26218@obsidianresearch.com> <alpine.LNX.2.11.1408302229001.579@localhost.localdomain>
 <20140902172015.GD13956@obsidianresearch.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Jason Gunthorpe wrote:
> On Sat, Aug 30, 2014 at 11:23:56PM +0000, Scot Doyle wrote:
>> The output is now
>> [    1.526798] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
>> [    5.914732] tpm_tis 00:08: [Firmware Bug]: TPM interrupt not working, polling instead
>
> Cool, why did it take 4 seconds though?

It's spending that time (now 3 seconds) in tpm_tis_send_data.

Output is
[    2.928481] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
[    5.943468] tpm_tis 00:08: [Firmware Bug]: TPM interrupt not working, polling instead


> Looks really good to me, I can try and test the next version here this
> week.

Thanks!


---
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..6e42d60 100644
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

@@ -338,6 +342,21 @@ out_err:
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
@@ -345,8 +364,10 @@ out_err:
  */
 static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 {
-	int rc;
+	int rc, irq;
 	u32 ordinal;
+	bool test_irq;
+	struct priv_data *priv = chip->vendor.priv;

 	rc = tpm_tis_send_data(chip, buf, len);
 	if (rc < 0)
@@ -358,13 +379,30 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)

 	if (chip->vendor.irq) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
-		if (wait_for_tpm_stat
-		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-		     tpm_calc_ordinal_duration(chip, ordinal),
-		     &chip->vendor.read_queue, false) < 0) {
+		test_irq = !priv->irq_tested;
+		if (test_irq) {
+			irq = chip->vendor.irq;
+			chip->vendor.irq = 0;
+		}
+		rc = wait_for_tpm_stat
+		     (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+		      tpm_calc_ordinal_duration(chip, ordinal),
+		      &chip->vendor.read_queue, false);
+		if (test_irq)
+			chip->vendor.irq = irq;
+		if (rc < 0) {
 			rc = -ETIME;
 			goto out_err;
 		}
+		if (test_irq) {
+			msleep(1);
+			if (!priv->irq_tested) {
+				disable_interrupts(chip);
+				dev_err(chip->dev,
+					FW_BUG "TPM interrupt not working, polling instead\n");
+			}
+			priv->irq_tested = true;
+		}
 	}
 	return len;
 out_err:
@@ -505,6 +543,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	if (interrupt == 0)
 		return IRQ_NONE;

+	((struct priv_data*)chip->vendor.priv)->irq_tested = true;
 	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
 		wake_up_interruptible(&chip->vendor.read_queue);
 	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
@@ -534,10 +573,14 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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
@@ -605,19 +648,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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
@@ -719,6 +749,18 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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

