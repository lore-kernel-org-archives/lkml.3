Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbaH0EfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:35:04 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:50815 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430AbaH0Ee7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:34:59 -0400
Date: Wed, 27 Aug 2014 04:31:56 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2] tpm_tis: verify interrupt during init
In-Reply-To: <20140825182414.GB1298@obsidianresearch.com>
Message-ID: <alpine.LNX.2.11.1408270410190.701@localhost.localdomain>
References: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain> <20140822160626.GA8477@obsidianresearch.com> <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain> <20140822203241.GB1733@obsidianresearch.com> <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain>
 <20140825182414.GB1298@obsidianresearch.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014, Jason Gunthorpe wrote:
> On Mon, Aug 25, 2014, Scot Doyle wrote:
>> 3. Custom SeaBIOS. Blacklist the tpm_tis module so that it doesn't load
>>    and therefore doesn't issue startup(clear) to the TPM chip.
>
> It seems to me at least in this case you should be able to get rid of
> the IRQ entry, people are going to be flashing the custom SeaBIOS
> anyhow.

The person building many of these custom SeaBIOS packages has removed the
TPM section from the DSDT, so this may be addressed.


On Mon, 25 Aug 2014, Jason Gunthorpe wrote:
> I think you'll have to directly test in the tis driver if the
> interrupt is working.
>
> The ordering in the TIS driver is wrong, interrupts should be turned
> on before any TPM commands are issued. This is what other drivers are
> doing.
>
> If you fix this, tis can then just count interrupts recieved and check
> if that is 0 to detect failure and then turn them off.

How about something like this?

It doesn't enable stock SeaBIOS machines to suspend/resume before the 30 
second interrupt timeout, unless using interrupts=0 or force=1.

---

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..ae701d8 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -493,6 +493,8 @@ static irqreturn_t tis_int_probe(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }

+static bool interrupted = false;
+
 static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
@@ -511,6 +513,8 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 		for (i = 0; i < 5; i++)
 			if (check_locality(chip, i) >= 0)
 				break;
+	if (interrupt & TPM_INTF_CMD_READY_INT)
+		interrupted = true;
 	if (interrupt &
 	    (TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_STS_VALID_INT |
 	     TPM_INTF_CMD_READY_INT))
@@ -612,12 +616,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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
@@ -693,7 +691,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 			free_irq(i, chip);
 		}
 	}
-	if (chip->vendor.irq) {
+	if (interrupts && chip->vendor.irq) {
 		iowrite8(chip->vendor.irq,
 			 chip->vendor.iobase +
 			 TPM_INT_VECTOR(chip->vendor.locality));
@@ -719,6 +717,32 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		}
 	}

+	/* Test interrupt and/or prepare for later save state */
+	interrupted = false;
+	if (tpm_do_selftest(chip)) {
+		if (!interrupts || interrupted) {
+			dev_err(dev, "TPM self test failed\n");
+			rc = -ENODEV;
+			goto out_err;
+		} else {
+			/* Turn off interrupt */
+			iowrite32(intmask,
+				  chip->vendor.iobase +
+				  TPM_INT_ENABLE(chip->vendor.locality));
+			free_irq(chip->vendor.irq, chip);
+
+			/* Retry in polling mode */
+			chip->vendor.irq = 0;
+			if (tpm_do_selftest(chip)) {
+				dev_err(dev, "TPM self test failed\n");
+				rc = -ENODEV;
+				goto out_err;
+			} else {
+				dev_err(dev, "ACPI DSDT entry incorrect, polling instead\n");
+			}
+		}
+	}
+
 	INIT_LIST_HEAD(&chip->vendor.list);
 	mutex_lock(&tis_lock);
 	list_add(&chip->vendor.list, &tis_chips);

