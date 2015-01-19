Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbbASUrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:47:33 -0500
Received: from mailrelay115.isp.belgacom.be ([195.238.20.142]:37061 "EHLO
	mailrelay115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbbASUrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:47:32 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=wcGNbXEvJ1+lRvjKRe8ww5ZIB0ZoB9oB8wjQofnwvDA= c=1 sm=2
 a=iBTyMBLzZVNNl2LLs9kA:9
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEPAC1svVTD7gaz/2dsb2JhbABbgwaBKrNuBQEBAQEBAQUBd5dCgSZDAQEBAQF9hDpSgVGIMAHAA44zLIYFiRBkHYQTBZdwihqIECKBRYIqboEDgUABAQE
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [RFC 1/2] FS: mount_bdev from vfs instead of filesystem specific mount function.
Date: Mon, 19 Jan 2015 21:47:20 +0100
Message-Id: <1421700440-15128-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a lot of filesystem mounting functions feature in
file_system_type only to be called from vfs mount_fs and call mount_bdev.

This patch adds fill_super function to that structure and lets vfs
call mount_bdev when no mount function is declared.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/super.c         | 6 +++++-
 include/linux/fs.h | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index a89d625..7c37355 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1112,7 +1112,11 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 			goto out_free_secdata;
 	}
 
-	root = type->mount(type, flags, name, data);
+	if (type->mount)
+		root = type->mount(type, flags, name, data);
+	else
+		root = mount_bdev(type, flags, name, data, type->fill_super);
+
 	if (IS_ERR(root)) {
 		error = PTR_ERR(root);
 		goto out_free_secdata;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0bd9669..3e19349 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1846,8 +1846,10 @@ struct file_system_type {
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_USERNS_DEV_MOUNT	16 /* A userns mount does not imply MNT_NODEV */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
+	int (*fill_super)(struct super_block *, void *, int);
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
+
 	void (*kill_sb) (struct super_block *);
 	struct module *owner;
 	struct file_system_type * next;
-- 
1.9.3

