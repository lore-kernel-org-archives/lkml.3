Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaH3X1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 19:27:16 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:42708 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaH3X1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 19:27:15 -0400
Date: Sat, 30 Aug 2014 23:23:56 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v5] tpm_tis: verify interrupt during init
In-Reply-To: <20140830174920.GA26218@obsidianresearch.com>
Message-ID: <alpine.LNX.2.11.1408302229001.579@localhost.localdomain>
References: <20140822203241.GB1733@obsidianresearch.com> <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain> <20140825182414.GB1298@obsidianresearch.com> <alpine.LNX.2.11.1408270410190.701@localhost.localdomain> <20140827173142.GA11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain> <20140827214743.GC11183@obsidianresearch.com> <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain> <20140828165348.GE11183@obsidianresearch.com> <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain>
 <20140830174920.GA26218@obsidianresearch.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2014, Jason Gunthorpe wrote:

> On Fri, Aug 29, 2014 at 11:59:32PM +0000, Scot Doyle wrote:
>
>> I tried calling tpm_get_timeouts only during the interrupt test, but again
>> was timed out after 30 seconds. The interrupt wait in tis_send calls
>> tpm_calc_ordinal_duration, which uses a default timeout of two minutes
>> when chip->vendor.duration[duration_idx] hasn't been set. Thus the second
>> call to tpm_get_timeouts in tpm_tis_init.
>
> So the strategy is to read the timeouts and hope that the chip reports
> something small and reasonable, then do a second read?
>
> Seems reasonable, but with this new arrangement we could also use an
> alternate polling logic for 'testing_int' that did the normal polling
> loop unconditionally and then checked if the interrupt was
> delivered. This would give a minimal dealy.

I like the idea. And then tpm_do_selftest could be used for the interrupt 
verification instead of a second tpm_get_timeouts?

The output is now
[    1.526798] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
[    5.914732] tpm_tis 00:08: [Firmware Bug]: TPM interrupt not working, polling instead

Enjoy the weekend!

---
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..7a5f5b2 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -75,6 +75,11 @@ enum tis_defaults {
 #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))

+struct priv_data {
+	int test_irq;
+	int int_count;
+};
+
 static LIST_HEAD(tis_chips);
 static DEFINE_MUTEX(tis_lock);

@@ -338,6 +343,21 @@ out_err:
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
@@ -347,6 +367,7 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	int rc;
 	u32 ordinal;
+	struct priv_data *priv = chip->vendor.priv;

 	rc = tpm_tis_send_data(chip, buf, len);
 	if (rc < 0)
@@ -358,13 +379,27 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)

 	if (chip->vendor.irq) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
-		if (wait_for_tpm_stat
-		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-		     tpm_calc_ordinal_duration(chip, ordinal),
-		     &chip->vendor.read_queue, false) < 0) {
+		if (priv->test_irq)
+			chip->vendor.irq = 0;
+		rc = wait_for_tpm_stat
+		     (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+		      tpm_calc_ordinal_duration(chip, ordinal),
+		      &chip->vendor.read_queue, false);
+		if (priv->test_irq)
+			chip->vendor.irq = priv->test_irq;
+		if (rc < 0) {
 			rc = -ETIME;
 			goto out_err;
 		}
+		if (priv->test_irq) {
+			priv->test_irq = 0;
+			msleep(1);
+			if (!priv->int_count) {
+				disable_interrupts(chip);
+				dev_err(chip->dev,
+					FW_BUG "TPM interrupt not working, polling instead\n");
+			}
+		}
 	}
 	return len;
 out_err:
@@ -505,6 +540,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	if (interrupt == 0)
 		return IRQ_NONE;

+	((struct priv_data*)chip->vendor.priv)->int_count++;
 	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
 		wake_up_interruptible(&chip->vendor.read_queue);
 	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
@@ -534,10 +570,14 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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
@@ -612,12 +652,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		goto out_err;
 	}

-	if (tpm_do_selftest(chip)) {
-		dev_err(dev, "TPM self test failed\n");
-		rc = -ENODEV;
-		goto out_err;
-	}
-
 	/* INTERRUPT Setup */
 	init_waitqueue_head(&chip->vendor.read_queue);
 	init_waitqueue_head(&chip->vendor.int_queue);
@@ -719,6 +753,14 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		}
 	}

+	/* Test interrupt and prepare for later save state */
+	priv->test_irq = chip->vendor.irq;
+	if (tpm_do_selftest(chip)) {
+		dev_err(dev, "TPM self test failed\n");
+		rc = -ENODEV;
+		goto out_err;
+	}
+
 	INIT_LIST_HEAD(&chip->vendor.list);
 	mutex_lock(&tis_lock);
 	list_add(&chip->vendor.list, &tis_chips);

