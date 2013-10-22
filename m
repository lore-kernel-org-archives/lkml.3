Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3JVRyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:54:37 -0400
Received: from mout.gmx.net ([212.227.17.22]:59132 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab3JVRyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:54:36 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 05/15] tpm: Use container_of to locate the tpm_chip in tpm_open
Date: Tue, 22 Oct 2013 19:53:50 +0200
Message-Id: <1382464440-7579-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382464440-7579-1-git-send-email-peterhuewe@gmx.de>
References: <1382464440-7579-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:x1tejRjRlQDe+L/5L4kGxntR+YIZEnMFQoj5jfcvgQPTJ6T9JNu
 eRvnJQrQQAw7QqP/7rjfurymyKOxLkTZAUteNUlqnsCKNVZ/5BRgw+uI1Orr3/3QNlkRP+d
 L8kXf0wpg525rabT/v8OEaX4i630Zbx6F0fyGQ2meNZ28XUzhiuAitAmDyGJM1PwJoMsKQi
 MbODC1uRoEVJGCYtcRqtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

misc_open sets the file->private_date to the misc_dev when calling
open. We can use container_of to go from the misc_dev back to the
tpm_chip.

Future clean ups will move tpm_open into a new file and this change
means we do not have to export the tpm_chip list.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

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
1.7.5.4

