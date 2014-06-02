Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaFBSg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:36:57 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:47784 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723AbaFBSg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:36:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8OAGrDjFNbtAfK/2dsb2JhbABZgwerXQEBAQEBBQGYG4EVF3SCUy8jgRo3iEYBzyMXhVWIfR2EKgEDmgCLG4gSgXiBQjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 1/1] drivers/scsi/bfa/bfad_debugfs.c: replace 2 kzalloc/copy_from_user by memdup_user
Date: Mon,  2 Jun 2014 20:35:40 +0200
Message-Id: <1401734140-18987-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also removes unnecessary printk(KERN_INFO

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V4: remove blank line after memdup_user
V3: memdup_user first argument is already void __user * (thanks to Joe Perches)
    typo in title
V2: Remove printk(KERN_INFO (suggested by Alan)

 drivers/scsi/bfa/bfad_debugfs.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 8e83d04..74a307c 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -260,18 +260,9 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = kzalloc(nbytes, GFP_KERNEL);
-
-	if (!kern_buf) {
-		printk(KERN_INFO "bfad[%d]: Failed to allocate buffer\n",
-				bfad->inst_no);
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
-		kfree(kern_buf);
-		return -ENOMEM;
-	}
+	kern_buf = memdup_user(buf, nbytes);
+	if (IS_ERR(kern_buf))
+		return PTR_ERR(kern_buf);
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &len);
 	if (rc < 2) {
@@ -336,18 +327,9 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = kzalloc(nbytes, GFP_KERNEL);
-
-	if (!kern_buf) {
-		printk(KERN_INFO "bfad[%d]: Failed to allocate buffer\n",
-				bfad->inst_no);
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(kern_buf, (void  __user *)buf, nbytes)) {
-		kfree(kern_buf);
-		return -ENOMEM;
-	}
+	kern_buf = memdup_user(buf, nbytes);
+	if (IS_ERR(kern_buf))
+		return PTR_ERR(kern_buf);
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &val);
 	if (rc < 2) {
-- 
1.8.4.5

