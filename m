Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3GXWG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3GXWGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 21/36] cuse: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:24 -0700
Message-Id: <1374703539-9705-22-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the cuse class code to use the
correct field.

Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Miklos, feel free to take this through your tree, or ACK it and I can
take it through mine.

 fs/fuse/cuse.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index aef34b1e..adbfd66b 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -568,6 +568,7 @@ static ssize_t cuse_class_waiting_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", atomic_read(&cc->fc.num_waiting));
 }
+static DEVICE_ATTR(waiting, S_IFREG | 0400, cuse_class_waiting_show, NULL);
 
 static ssize_t cuse_class_abort_store(struct device *dev,
 				      struct device_attribute *attr,
@@ -578,12 +579,14 @@ static ssize_t cuse_class_abort_store(struct device *dev,
 	fuse_abort_conn(&cc->fc);
 	return count;
 }
+static DEVICE_ATTR(abort, S_IFREG | 0200, NULL, cuse_class_abort_store);
 
-static struct device_attribute cuse_class_dev_attrs[] = {
-	__ATTR(waiting, S_IFREG | 0400, cuse_class_waiting_show, NULL),
-	__ATTR(abort, S_IFREG | 0200, NULL, cuse_class_abort_store),
-	{ }
+static struct attribute *cuse_class_dev_attrs[] = {
+	&dev_attr_waiting.attr,
+	&dev_attr_abort.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(cuse_class_dev);
 
 static struct miscdevice cuse_miscdev = {
 	.minor		= MISC_DYNAMIC_MINOR,
@@ -609,7 +612,7 @@ static int __init cuse_init(void)
 	if (IS_ERR(cuse_class))
 		return PTR_ERR(cuse_class);
 
-	cuse_class->dev_attrs = cuse_class_dev_attrs;
+	cuse_class->dev_groups = cuse_class_dev_groups;
 
 	rc = misc_register(&cuse_miscdev);
 	if (rc) {
-- 
1.8.3.rc0.20.gb99dd2e

