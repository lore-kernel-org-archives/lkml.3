Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbaJVUO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:14:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932841AbaJVUOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:14:20 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] chardev: Increment cdev reference count when i_cdev references it
Date: Wed, 22 Oct 2014 22:14:11 +0200
Message-Id: <1414008853-13200-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1414008853-13200-1-git-send-email-jack@suse.cz>
References: <1414008853-13200-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently i_cdev reference to a character device isn't accounted in the
reference count of the character device. This then requires us to track
all references through a list of all inodes referencing a character
device which is somewhat clumsy and requires list_head in each inode in
the system.

So make i_cdev a reference like any other.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/char_dev.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index f77f7702fabe..21c210dbdba1 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -388,12 +388,13 @@ static int chrdev_open(struct inode *inode, struct file *filp)
 		   we dropped the lock. */
 		p = inode->i_cdev;
 		if (!p) {
+			/* Use reference from kobj_lookup for i_cdev ref */
 			inode->i_cdev = p = new;
 			list_add(&inode->i_devices, &p->list);
 			new = NULL;
-		} else if (!cdev_get(p))
-			ret = -ENXIO;
-	} else if (!cdev_get(p))
+		}
+	}
+	if (!cdev_get(p))
 		ret = -ENXIO;
 	spin_unlock(&cdev_lock);
 	cdev_put(new);
@@ -421,10 +422,15 @@ static int chrdev_open(struct inode *inode, struct file *filp)
 
 void cd_forget(struct inode *inode)
 {
+	struct cdev *cdev;
+
 	spin_lock(&cdev_lock);
 	list_del_init(&inode->i_devices);
+	cdev = inode->i_cdev;
 	inode->i_cdev = NULL;
 	spin_unlock(&cdev_lock);
+	if (cdev)
+		cdev_put(cdev);
 }
 
 static void cdev_purge(struct cdev *cdev)
-- 
1.8.1.4

