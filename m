Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaEMWFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:05:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbaEMWEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:04:55 -0400
From: Mateusz Guzik <mguzik@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <esandeen@redhat.com>, Joe Perches <joe@perches.com>
Subject: [PATCH V2 2/2] fs: print a message when freezing/unfreezing filesystems
Date: Wed, 14 May 2014 00:04:43 +0200
Message-Id: <1400018683-5565-2-git-send-email-mguzik@redhat.com>
In-Reply-To: <1400018683-5565-1-git-send-email-mguzik@redhat.com>
References: <1400018683-5565-1-git-send-email-mguzik@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps hang troubleshooting efforts when only dmesg is available.

While here remove code duplication with MS_RDONLY case and fix a whitespace nit.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Joe Perches <joe@perches.com>
---
since v1:
	fix copy-pasto which found its way into the patch
	restore curly brackets in MS_RDONLY case
 fs/super.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 017e10a..4dd7356 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1291,9 +1291,7 @@ int freeze_super(struct super_block *sb)
 
 	if (sb->s_flags & MS_RDONLY) {
 		/* Nothing to do really... */
-		sb->s_writers.frozen = SB_FREEZE_COMPLETE;
-		up_write(&sb->s_umount);
-		return 0;
+		goto out;
 	}
 
 	/* From now on, no new normal writers can start */
@@ -1335,8 +1333,10 @@ int freeze_super(struct super_block *sb)
 	 * This is just for debugging purposes so that fs can warn if it
 	 * sees write activity when frozen is set to SB_FREEZE_COMPLETE.
 	 */
+out:
 	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
 	up_write(&sb->s_umount);
+	pr_info("VFS:Filesystem %s frozen\n", sb->s_id);
 	return 0;
 }
 EXPORT_SYMBOL(freeze_super);
@@ -1374,7 +1374,7 @@ out:
 	smp_wmb();
 	wake_up(&sb->s_writers.wait_unfrozen);
 	deactivate_locked_super(sb);
-
+	pr_info("VFS:Filesystem %s thawed\n", sb->s_id);
 	return 0;
 }
 EXPORT_SYMBOL(thaw_super);
-- 
1.8.3.1

