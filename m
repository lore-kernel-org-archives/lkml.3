Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbaH3ACi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 20:02:38 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:51054 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaH3ACg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 20:02:36 -0400
Date: Fri, 29 Aug 2014 23:59:32 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4] tpm_tis: verify interrupt during init
In-Reply-To: <20140828165348.GE11183@obsidianresearch.com>
Message-ID: <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain>
References: <20140822160626.GA8477@obsidianresearch.com> <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain> <20140822203241.GB1733@obsidianresearch.com> <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain> <20140825182414.GB1298@obsidianresearch.com>
 <alpine.LNX.2.11.1408270410190.701@localhost.localdomain> <20140827173142.GA11183@obsidianresearch.com> <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain> <20140827214743.GC11183@obsidianresearch.com> <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain>
 <20140828165348.GE11183@obsidianresearch.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Jason Gunthorpe wrote:

> On Thu, Aug 28, 2014 at 12:35:16AM +0000, Scot Doyle wrote:
>
>>> To move it means we have to understand why you are getting timeouts:
>>>
>>> [   33.247720] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
>>> [   33.247731] tpm_tis 00:08: [Hardware Error]: TPM command timed out during continue self test
>>>
>>> I had thought based on your other patch that these should not happen
>>> since the raw register is polled after the timer expires?
>>
>> It is polled after the timer expires in tpm_tis_send_data, but not in
>> tpm_tis_send, and the return value is used in tpm_tis_send...
>
> tpm_tis_send does:
>
>             wait_for_tpm_stat
> 		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> 		     tpm_calc_ordinal_duration(chip, ordinal),
> 		     &chip->vendor.read_queue, false)
>
> Which is:
> 		rc = wait_event_interruptible_timeout(*queue,
> 			wait_for_tpm_stat_cond(chip, mask, check_cancel,
> 					       &canceled),
>
> And we know that wait_event_interruptible_timeout returns 1 if
> the condition is true when the timeout expires.
>
> So, all calls to wait_for_tpm_stat should succeed if the register has
> the requested bits set at the end of the timer - thus if interrupts
> are broken we should never see ETIME from wait_for_tpm_stat as the
> chip does actually complete its work. (and this is the correct,
> desired, behavior)
>
> Is this analysis wrong somehow?

Something (systemd-udevd?) is interrupting the selftest with a signal 
(current->pending.signal.sig[0] == 0x00000100 == SIGKILL?) about 30 
seconds after module load begins. wait_for_tpm_stat sees that the return 
value from wait_event_interruptible_timeout is positive and returns 0. 
tpm_tis_send thinks everything is fine and continues. However, since a 
signal was received, but not cleared, then the next time 
wait_event_interruptible_timeout is used within wait_for_tpm_stat it 
returns with -ERESTARTSYS, and continues doing so until tpm_send_data 
returns -ETIME.

So I think that mystery is finally solved :-)

The attached patch results in the following output:
[    1.536850] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
[    7.650172] tpm_tis 00:08: [Firmware Bug]: TPM interrupt not working, polling instead

I tried calling tpm_get_timeouts only during the interrupt test, but again 
was timed out after 30 seconds. The interrupt wait in tis_send calls 
tpm_calc_ordinal_duration, which uses a default timeout of two minutes 
when chip->vendor.duration[duration_idx] hasn't been set. Thus the second 
call to tpm_get_timeouts in tpm_tis_init.

What do you think about the guard logic? My intent is to prevent a signal 
received after the test period from causing a fallback to polling mode. 
Plus, it seems good to preserve the current logic where practical.

Thanks so much for the help!

---
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..92f4ab5 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -75,6 +75,11 @@ enum tis_defaults {
 #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))

+struct priv_data {
+	bool testing_int;
+	bool int_received;
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
@@ -366,6 +387,15 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 			goto out_err;
 		}
 	}
+	if (priv->testing_int) {
+		priv->testing_int = false;
+		msleep(1);
+		if (!priv->int_received) {
+			disable_interrupts(chip);
+			dev_err(chip->dev,
+				FW_BUG "TPM interrupt not working, polling instead\n");
+		}
+	}
 	return len;
 out_err:
 	tpm_tis_ready(chip);
@@ -496,6 +526,7 @@ static irqreturn_t tis_int_probe(int irq, void *dev_id)
 static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
+	struct priv_data *priv = chip->vendor.priv;
 	u32 interrupt;
 	int i;

@@ -505,6 +536,8 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	if (interrupt == 0)
 		return IRQ_NONE;

+	if (priv->testing_int)
+		priv->int_received = true;
 	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
 		wake_up_interruptible(&chip->vendor.read_queue);
 	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
@@ -534,10 +567,14 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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
@@ -612,12 +649,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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
@@ -719,6 +750,22 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		}
 	}

+	/* Test interrupt */
+	if (chip->vendor.irq) {
+		priv->testing_int = true;
+		if (tpm_get_timeouts(chip)) {
+			dev_err(dev, "Could not get TPM timeouts\n");
+			rc = -ENODEV;
+			goto out_err;
+		}
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

