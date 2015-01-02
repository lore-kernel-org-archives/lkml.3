Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbbABR1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:27:01 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56693 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbbABR1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:27:00 -0500
From: Seunghun Lee <waydi1@gmail.com>
To: miklos@szeredi.hu
Cc: sedat.dilek@gmail.com, richard.weinberger@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] ovl: Prevent rw remount when it should be ro mount
Date: Sat,  3 Jan 2015 02:26:49 +0900
Message-Id: <1420219609-2568-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overlayfs should be mounted read-only when upper-fs is read-only or nonexistent.
But now it can be remounted read-write and this can cause kernel panic.
So we should prevent read-write remount when the above situation happens.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/overlayfs/super.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 84f3144..8944651 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -522,10 +522,21 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	return 0;
 }
 
+static int ovl_remount(struct super_block *sb, int *flags, char *data)
+{
+	struct ovl_fs *ufs = sb->s_fs_info;
+
+	if (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
+		*flags |= MS_RDONLY;
+
+	return 0;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
 	.statfs		= ovl_statfs,
 	.show_options	= ovl_show_options,
+	.remount_fs	= ovl_remount,
 };
 
 enum {
-- 
2.1.3

