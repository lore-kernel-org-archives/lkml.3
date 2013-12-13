Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3LMSmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:42:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39104 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3LMSmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:42:32 -0500
From: "Chen.Yu" <chyyuu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: levex@linux.com, xiaoqixue_1@163.com, fanwlexca@gmail.com,
        "Chen.Yu" <chyyuu@gmail.com>
Subject: [PATCH] scsi: integer overflow in megadev_ioctl()
Date: Sat, 14 Dec 2013 02:41:32 +0800
Message-Id: <1386960092-32475-1-git-send-email-chyyuu@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chen.Yu" <chyyuu@gmail.com>

There is a potential integer overflow in megadev_ioctl() if
userspace passes in a large u32 variable uioc.adapno.
The int variable adapno would < 0, leading to an error
array access for hdb_soft_state[adapno], or an error
copy_to_user(uioc.uioc_uaddr, mcontroller+adapno,..)

Reported-by: Wenliang Fan <fanwlexca@gmail.com>
Suggested-by: Qixue Xiao <xiaoqixue_1@163.com>
Signed-off-by: Yu Chen <chyyuu@gmail.com>
Reviewed-by: Levente Kurusa <levex@linux.com>
---
 drivers/scsi/megaraid.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 816db12..0b90c54 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -3099,7 +3099,10 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		/*
 		 * Which adapter
 		 */
-		if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
+		adapno = GETADAP(uioc.adapno);
+		if( adapno < 0 )
+			return (-EINVAL);
+		if( adapno >= hba_count )
 			return (-ENODEV);
 
 		if( copy_to_user(uioc.uioc_uaddr, mcontroller+adapno,
@@ -3113,7 +3116,10 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		/*
 		 * Which adapter
 		 */
-		if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
+		adapno = GETADAP(uioc.adapno);
+		if( adapno < 0 )
+			return (-EINVAL);
+		if( adapno >= hba_count )
 			return (-ENODEV);
 
 		adapter = hba_soft_state[adapno];
@@ -3160,7 +3166,10 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		/*
 		 * Which adapter
 		 */
-		if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
+		adapno = GETADAP(uioc.adapno);
+		if( adapno < 0 )
+			return (-EINVAL);
+		if( adapno >= hba_count )
 			return (-ENODEV);
 
 		adapter = hba_soft_state[adapno];
-- 
1.8.3.2

