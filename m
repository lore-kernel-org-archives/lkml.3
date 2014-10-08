Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaJHKEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:04:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8894 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbaJHKEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:04:51 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-65-54350c421985
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Joel Becker <jlbec@evilplan.org>, linux-usb@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] fs: configfs: add allow_drop() to configfs_item_operations
Date: Wed, 08 Oct 2014 12:04:31 +0200
Message-id: <1412762671-2940-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xq7pOPKYhBu/bhS1mvWxnsTh4v95i
	2sVJzBbNi9ezWZw8943F4vKuOWwWi5a1MlusPXKX3YHD4+nFII93586xe+yfu4bdo2/LKkaP
	4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAlXFnzX22gkUiFScn3GJvYPwp0MXIySEhYCJxcdZL
	FghbTOLCvfVsXYxcHEICSxkldh67yAiSEBLoZ5JYdrAYxGYTMJbYe7ADLC4ioCCxufcZK0gD
	s8ASJokXn/rBEsIC3hLzV75kB7FZBFQlLm7aygZi8wq4SKycMglqm6JE97MJbBMYuRcwMqxi
	FE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAmbLzsYFx+zOsQowMGoxMNr0GwSIsSaWFZcmXuI
	UYKDWUmEt/oXUIg3JbGyKrUoP76oNCe1+BAjEwenVAOjVYKbtcOELbGLtzaFKE6SiPijGHy2
	3tJGccr+mOBTxxdx5lyPtdnfv0TuxUoXc+GTvwx2O//x2HyLJeJshKGIjP6VxM0GyfN+Zrq9
	OiC0Ne3a+mlt7J9Svy+PeBTs9kZh7/6N9l0PxGRWP/l8Ydlt9j7jWXeZmLPPRi74UDDLZsmW
	vJn/Tk6xUWIpzkg01GIuKk4EAHZh6WD5AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it might be desirable to prohibit removing a symbolic link
in configfs. One example is USB gadget: when a gadget is already bound,
if USB function symlink (used to associate USB functions with USB
configurations) is removed, the gadget must be thrown away, too.
A better solution would be to fail with e.g. -EBUSY.

Why add a new method? Even though (*drop_link)() does have a return value,
it is ignored in fs/configfs/symlink.c:configfs_unlink(). It could be
tempting to just check the return value, but some users of configfs might
already depend on the fact that (*drop_link)() is called _after_
corresponding filesystem entities are torn down. In other words, the
semantics of (*drop_link)() is "the final, unconditional cleanup". In order
not to break this semantics, a new method is added and its value is checked
in fs/configfs/symlink.c:configfs_unlink().

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 fs/configfs/symlink.c    | 11 +++++++++--
 include/linux/configfs.h |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index cc9f254..52851dc 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -198,6 +198,13 @@ int configfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	parent_item = configfs_get_config_item(dentry->d_parent);
 	type = parent_item->ci_type;
+	if (type && type->ct_item_ops &&
+	    type->ct_item_ops->allow_drop) {
+		ret = type->ct_item_ops->allow_drop(parent_item,
+							sl->sl_target);
+		if (ret)
+			goto out_put;
+	}
 
 	spin_lock(&configfs_dirent_lock);
 	list_del_init(&sd->s_sibling);
@@ -224,10 +231,10 @@ int configfs_unlink(struct inode *dir, struct dentry *dentry)
 	config_item_put(sl->sl_target);
 	kfree(sl);
 
-	config_item_put(parent_item);
-
 	ret = 0;
 
+out_put:
+	config_item_put(parent_item);
 out:
 	return ret;
 }
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 34025df..29df5e1 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -226,6 +226,7 @@ struct configfs_item_operations {
 	ssize_t	(*show_attribute)(struct config_item *, struct configfs_attribute *,char *);
 	ssize_t	(*store_attribute)(struct config_item *,struct configfs_attribute *,const char *, size_t);
 	int (*allow_link)(struct config_item *src, struct config_item *target);
+	int (*allow_drop)(struct config_item *src, struct config_item *target);
 	int (*drop_link)(struct config_item *src, struct config_item *target);
 };
 
-- 
1.9.1

