Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab3IWSQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:16:16 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:50987 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab3IWSQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:16:08 -0400
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 04/13] tpm: Store devname in the tpm_chip
Date: Mon, 23 Sep 2013 12:14:34 -0600
Message-Id: <1379960083-8942-5-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just put the memory directly in the chip structure, rather than
in a 2nd dedicated kmalloc.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm.c | 17 ++++++-----------
 drivers/char/tpm/tpm.h |  1 +
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index e3c974a..71eb8c7 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1463,7 +1463,6 @@ void tpm_dev_vendor_release(struct tpm_chip *chip)
 		chip->vendor.release(chip->dev);
 
 	clear_bit(chip->dev_num, dev_mask);
-	kfree(chip->vendor.miscdev.name);
 }
 EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
 
@@ -1496,17 +1495,13 @@ EXPORT_SYMBOL_GPL(tpm_dev_release);
 struct tpm_chip *tpm_register_hardware(struct device *dev,
 					const struct tpm_vendor_specific *entry)
 {
-#define DEVNAME_SIZE 7
-
-	char *devname;
 	struct tpm_chip *chip;
 
 	/* Driver specific per-device data */
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-	devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
 
-	if (chip == NULL || devname == NULL)
-		goto out_free;
+	if (chip == NULL)
+		return NULL;
 
 	mutex_init(&chip->buffer_mutex);
 	mutex_init(&chip->tpm_mutex);
@@ -1531,8 +1526,9 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 
 	set_bit(chip->dev_num, dev_mask);
 
-	scnprintf(devname, DEVNAME_SIZE, "%s%d", "tpm", chip->dev_num);
-	chip->vendor.miscdev.name = devname;
+	scnprintf(chip->devname, sizeof(chip->devname), "%s%d", "tpm",
+		  chip->dev_num);
+	chip->vendor.miscdev.name = chip->devname;
 
 	chip->vendor.miscdev.parent = dev;
 	chip->dev = get_device(dev);
@@ -1558,7 +1554,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 		goto put_device;
 	}
 
-	chip->bios_dir = tpm_bios_log_setup(devname);
+	chip->bios_dir = tpm_bios_log_setup(chip->devname);
 
 	/* Make chip available */
 	spin_lock(&driver_lock);
@@ -1571,7 +1567,6 @@ put_device:
 	put_device(chip->dev);
 out_free:
 	kfree(chip);
-	kfree(devname);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(tpm_register_hardware);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index a7bfc17..0df18b5 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -122,6 +122,7 @@ struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 
 	int dev_num;		/* /dev/tpm# */
+	char devname[7];
 	unsigned long is_open;	/* only one allowed */
 	int time_expired;
 
-- 
1.8.1.2

