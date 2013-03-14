Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843Ab3CNQKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:10:18 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:44630 "EHLO
	homiemail-a46.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964799Ab3CNQKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:10:14 -0400
From: Shea Levy <shea@shealevy.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Shea Levy <shea@shealevy.com>
Subject: [PATCH 1/2] vfs: mountinfo: A mnt is r/o if the superblock is
Date: Thu, 14 Mar 2013 12:09:19 -0400
Message-Id: <1363277360-1947-2-git-send-email-shea@shealevy.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363277360-1947-1-git-send-email-shea@shealevy.com>
References: <1363277360-1947-1-git-send-email-shea@shealevy.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By calling mount(2) with MS_REMOUNT | MS_BIND on a non-bind readonly
mountpoint, it is possible to have a readonly mount without MNT_READONLY
in its mnt_flags. Currently, /proc/<pid>/mountinfo will report such a
mount as r/w in the 4th column, even though for all intents and purposes
it is still readonly.

This patch makes show_mountinfo use __mnt_is_readonly to check if a
mount is readonly, which checks both for MNT_READONLY in mnt_flags and
for MS_RDONLY in mnt_sb->s_flags.

Signed-off-by: Shea Levy <shea@shealevy.com>
---
 fs/proc_namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 5fe34c3..cf8963c 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -143,7 +143,7 @@ static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
 	if (err)
 		goto out;
 
-	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? " ro" : " rw");
+	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
 	show_mnt_opts(m, mnt);
 
 	/* Tagged fields ("foo:X" or "bar") */
-- 
1.8.1.3

