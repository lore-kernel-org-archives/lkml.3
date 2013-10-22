Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3JVRya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:54:30 -0400
Received: from mout.gmx.net ([212.227.17.22]:58847 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab3JVRy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:54:28 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 04/15] tpm: Store devname in the tpm_chip
Date: Tue, 22 Oct 2013 19:53:49 +0200
Message-Id: <1382464440-7579-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382464440-7579-1-git-send-email-peterhuewe@gmx.de>
References: <1382464440-7579-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:BoFjQf/5rS0cNVZ85+tatlZ4w+C5eDjk8v21C9Rsro8ouzwL0D8
 TkWAaH3Zr8qbHKCpIfQpD5HNwbWRqNTuqf27UaGUO6cC2YJTmStrP/ZTVQBUdijssdk1Uz+
 8Bny4WiSO0Z+TP3A2Ku0cwhPb0Te81k3/VxgfLzCZB7DlDF4N5oPQTymQwOmNDKM/FTGMxh
 6i4Ug/0x1yViin800Wx7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Just put the memory directly in the chip structure, rather than
in a 2nd dedicated kmalloc.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c |   17 ++++++-----------
 drivers/char/tpm/tpm.h |    1 +
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
1.7.5.4

