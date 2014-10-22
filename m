Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaJVUO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:14:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932836AbaJVUOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:14:20 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] chardev: Don't use i_devices inode field
Date: Wed, 22 Oct 2014 22:14:12 +0200
Message-Id: <1414008853-13200-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1414008853-13200-1-git-send-email-jack@suse.cz>
References: <1414008853-13200-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that character device can be freed only after all inodes referencing
it through i_cdev are gone, we can remove all the tracking of inodes
pointing to a character device.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/char_dev.c        | 22 +---------------------
 include/linux/cdev.h |  1 -
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 21c210dbdba1..08a1404f590b 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -390,7 +390,6 @@ static int chrdev_open(struct inode *inode, struct file *filp)
 		if (!p) {
 			/* Use reference from kobj_lookup for i_cdev ref */
 			inode->i_cdev = p = new;
-			list_add(&inode->i_devices, &p->list);
 			new = NULL;
 		}
 	}
@@ -425,7 +424,6 @@ void cd_forget(struct inode *inode)
 	struct cdev *cdev;
 
 	spin_lock(&cdev_lock);
-	list_del_init(&inode->i_devices);
 	cdev = inode->i_cdev;
 	inode->i_cdev = NULL;
 	spin_unlock(&cdev_lock);
@@ -433,18 +431,6 @@ void cd_forget(struct inode *inode)
 		cdev_put(cdev);
 }
 
-static void cdev_purge(struct cdev *cdev)
-{
-	spin_lock(&cdev_lock);
-	while (!list_empty(&cdev->list)) {
-		struct inode *inode;
-		inode = container_of(cdev->list.next, struct inode, i_devices);
-		list_del_init(&inode->i_devices);
-		inode->i_cdev = NULL;
-	}
-	spin_unlock(&cdev_lock);
-}
-
 /*
  * Dummy default file-operations: the only thing this does
  * is contain the open that then fills in the correct operations
@@ -515,10 +501,8 @@ void cdev_del(struct cdev *p)
 
 static void cdev_default_release(struct kobject *kobj)
 {
-	struct cdev *p = container_of(kobj, struct cdev, kobj);
 	struct kobject *parent = kobj->parent;
 
-	cdev_purge(p);
 	kobject_put(parent);
 }
 
@@ -527,7 +511,6 @@ static void cdev_dynamic_release(struct kobject *kobj)
 	struct cdev *p = container_of(kobj, struct cdev, kobj);
 	struct kobject *parent = kobj->parent;
 
-	cdev_purge(p);
 	kfree(p);
 	kobject_put(parent);
 }
@@ -548,10 +531,8 @@ static struct kobj_type ktype_cdev_dynamic = {
 struct cdev *cdev_alloc(void)
 {
 	struct cdev *p = kzalloc(sizeof(struct cdev), GFP_KERNEL);
-	if (p) {
-		INIT_LIST_HEAD(&p->list);
+	if (p)
 		kobject_init(&p->kobj, &ktype_cdev_dynamic);
-	}
 	return p;
 }
 
@@ -566,7 +547,6 @@ struct cdev *cdev_alloc(void)
 void cdev_init(struct cdev *cdev, const struct file_operations *fops)
 {
 	memset(cdev, 0, sizeof *cdev);
-	INIT_LIST_HEAD(&cdev->list);
 	kobject_init(&cdev->kobj, &ktype_cdev_default);
 	cdev->ops = fops;
 }
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index fb4591977b03..fe00138b5106 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -13,7 +13,6 @@ struct cdev {
 	struct kobject kobj;
 	struct module *owner;
 	const struct file_operations *ops;
-	struct list_head list;
 	dev_t dev;
 	unsigned int count;
 };
-- 
1.8.1.4

