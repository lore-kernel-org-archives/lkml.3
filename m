Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3CSN2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:28:20 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:35512 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3CSN2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:28:18 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: message: fusion: Use memdup_user function
Date: Tue, 19 Mar 2013 06:22:38 +0200
Message-Id: <1363666958-31991-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used memdup_user function instead of kmalloc and copy_from_user.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/message/fusion/mptctl.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index b383b69..2669e83 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1268,19 +1268,12 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
 	else
 		return -EFAULT;
 
-	karg = kmalloc(data_size, GFP_KERNEL);
-	if (karg == NULL) {
-		printk(KERN_ERR MYNAM "%s::mpt_ioctl_iocinfo() @%d - no memory available!\n",
-				__FILE__, __LINE__);
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(karg, uarg, data_size)) {
+	karg = memdup_user(uarg, data_size);
+	if (IS_ERR(karg)) {
 		printk(KERN_ERR MYNAM "%s@%d::mptctl_getiocinfo - "
 			"Unable to read in mpt_ioctl_iocinfo struct @ %p\n",
 				__FILE__, __LINE__, uarg);
-		kfree(karg);
-		return -EFAULT;
+		return PTR_ERR(karg);
 	}
 
 	if (((iocnum = mpt_verify_adapter(karg->hdr.iocnum, &ioc)) < 0) ||
-- 
1.7.9.5

