Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3IWSQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:16:13 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:51041 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab3IWSQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:16:08 -0400
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 05/13] tpm: Use container_of to locate the tpm_chip in tpm_open
Date: Mon, 23 Sep 2013 12:14:35 -0600
Message-Id: <1379960083-8942-6-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

misc_open sets the file->private_date to the misc_dev when calling
open. We can use container_of to go from the misc_dev back to the
tpm_chip.

Future clean ups will move tpm_open into a new file and this change
means we do not have to export the tpm_chip list.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 71eb8c7..c3ab508 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1170,38 +1170,25 @@ EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
  */
 int tpm_open(struct inode *inode, struct file *file)
 {
-	int minor = iminor(inode);
-	struct tpm_chip *chip = NULL, *pos;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
-		if (pos->vendor.miscdev.minor == minor) {
-			chip = pos;
-			get_device(chip->dev);
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	if (!chip)
-		return -ENODEV;
+	struct miscdevice *misc = file->private_data;
+	struct tpm_chip *chip = container_of(misc, struct tpm_chip,
+					     vendor.miscdev);
 
 	if (test_and_set_bit(0, &chip->is_open)) {
 		dev_dbg(chip->dev, "Another process owns this TPM\n");
-		put_device(chip->dev);
 		return -EBUSY;
 	}
 
 	chip->data_buffer = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
 	if (chip->data_buffer == NULL) {
 		clear_bit(0, &chip->is_open);
-		put_device(chip->dev);
 		return -ENOMEM;
 	}
 
 	atomic_set(&chip->data_pending, 0);
 
 	file->private_data = chip;
+	get_device(chip->dev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_open);
-- 
1.8.1.2

