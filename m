Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935931AbaH0VfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:35:16 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:51973 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933809AbaH0VfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:35:14 -0400
Date: Wed, 27 Aug 2014 21:32:10 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3] tpm_tis: verify interrupt during init
In-Reply-To: <20140827173142.GA11183@obsidianresearch.com>
Message-ID: <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain>
References: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain> <20140822160626.GA8477@obsidianresearch.com> <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain> <20140822203241.GB1733@obsidianresearch.com> <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain>
 <20140825182414.GB1298@obsidianresearch.com> <alpine.LNX.2.11.1408270410190.701@localhost.localdomain> <20140827173142.GA11183@obsidianresearch.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 27 Aug 2014, Jason Gunthorpe wrote:

> On Wed, Aug 27, 2014 at 04:31:56AM +0000, Scot Doyle wrote:
>> It doesn't enable stock SeaBIOS machines to suspend/resume before the 30
>> second interrupt timeout, unless using interrupts=0 or force=1.
>
> ? Can you explain that a bit more? interrupts should be detected off
> by suspend/resume time, surely?

Yes, here's dmesg:

[    1.491629] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
[   33.247720] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[   33.247731] tpm_tis 00:08: [Hardware Error]: TPM command timed out during continue self test
[   33.349888] tpm_tis 00:08: tpm_transmit: tpm_send: error -5
[   33.459911] tpm_tis 00:08: [Firmware Bug]: TPM interrupt not working, polling instead

At module load, the misconfigured DSDT is causing the interrupt to be used 
during selftest. The interrupt wait times out after 30 seconds, and the 
irq is freed, with the module falling back to polling mode.

If suspend/resume occur before falling back to polling mode (within 30 
seconds after module load), then the machine freezes on resume because 
the module is waiting on the interrupts.

So, this should only affect machines with incorrect ACPI, that are not 
using a module parameter, and that are suspended within 30 seconds after 
module load. Considering that we are enabling such machines to 
automatically work otherwise, I think this is fair.


>> -    if (tpm_do_selftest(chip)) {
>> -            dev_err(dev, "TPM self test failed\n");
>> -            rc = -ENODEV;
>> -            goto out_err;
>> -    }
>
> Move gettimeout too

Can it be moved? It sends startup(clear) if the TPM isn't yet operational.


>> -    if (chip->vendor.irq) {
>> +    if (interrupts && chip->vendor.irq) {
>
> Unrelated? Looks unnecessary:
>
>        if (!interrupts) {
>                irq = 0;
>
>        chip->vendor.irq = irq;
>
>        if (chip->vendor.irq) {

Setting chip->vendor.irq would erase any we just found in probing?


>> +	/* Test interrupt and/or prepare for later save state */
>> +	interrupted = false;
>> +	if (tpm_do_selftest(chip)) {
>
> As you pointed out before, the commands don't actually fail if
> interrupts are not enabled, they just take a longer time to complete.

Right, the TPM commands don't fail, but tpm_get_timeouts does. I've 
simplified the section in this version.

And I've incorporated the other suggestions, thanks!

---
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index e4d0888..6747a47 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -69,6 +69,7 @@ struct tpm_vendor_specific {

 	int irq;
 	int probed_irq;
+	bool int_received;

 	int region_size;
 	int have_region;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..ad63027 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -505,6 +505,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	if (interrupt == 0)
 		return IRQ_NONE;

+	chip->vendor.int_received = true;
 	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
 		wake_up_interruptible(&chip->vendor.read_queue);
 	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
@@ -612,12 +613,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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
@@ -693,7 +688,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 			free_irq(i, chip);
 		}
 	}
-	if (chip->vendor.irq) {
+	if (interrupts && chip->vendor.irq) {
 		iowrite8(chip->vendor.irq,
 			 chip->vendor.iobase +
 			 TPM_INT_VECTOR(chip->vendor.locality));
@@ -719,6 +714,29 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		}
 	}

+	/* Test interrupt and/or prepare for later save state */
+	chip->vendor.int_received = false;
+	if (tpm_do_selftest(chip)) {
+		if (interrupts && !chip->vendor.int_received) {
+			/* Turn off interrupt */
+			iowrite32(intmask,
+				  chip->vendor.iobase +
+				  TPM_INT_ENABLE(chip->vendor.locality));
+			free_irq(chip->vendor.irq, chip);
+
+			/* Retry in polling mode */
+			chip->vendor.irq = 0;
+			if (!tpm_do_selftest(chip)) {
+			    dev_err(dev, FW_BUG "TPM interrupt not working, polling instead\n");
+			    goto cont;
+			}
+		}
+		dev_err(dev, "TPM self test failed\n");
+		rc = -ENODEV;
+		goto out_err;
+	}
+
+cont:
 	INIT_LIST_HEAD(&chip->vendor.list);
 	mutex_lock(&tis_lock);
 	list_add(&chip->vendor.list, &tis_chips);

