Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaEMSbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:31:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbaEMSbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:31:11 -0400
From: Mateusz Guzik <mguzik@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <esandeen@redhat.com>
Subject: [PATCH 2/2] fs: print a message when freezing/unfreezing filesystems
Date: Tue, 13 May 2014 20:31:02 +0200
Message-Id: <1400005862-3751-2-git-send-email-mguzik@redhat.com>
In-Reply-To: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps hang troubleshooting efforts when only dmesg is available.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Sandeen <esandeen@redhat.com>

---
 fs/super.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 017e10a..581c008 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1289,12 +1289,9 @@ int freeze_super(struct super_block *sb)
 		return 0;	/* sic - it's "nothing to do" */
 	}
 
-	if (sb->s_flags & MS_RDONLY) {
+	if (sb->s_flags & MS_RDONLY)
 		/* Nothing to do really... */
-		sb->s_writers.frozen = SB_FREEZE_COMPLETE;
-		up_write(&sb->s_umount);
-		return 0;
-	}
+		goto out;
 
 	/* From now on, no new normal writers can start */
 	sb->s_writers.frozen = SB_FREEZE_WRITE;
@@ -1335,8 +1332,10 @@ int freeze_super(struct super_block *sb)
 	 * This is just for debugging purposes so that fs can warn if it
 	 * sees write activity when frozen is set to SB_FREEZE_COMPLETE.
 	 */
+out:
 	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
 	up_write(&sb->s_umount);
+	pr_info("VFS:Filesystem %s thawed\n", sb->s_id);
 	return 0;
 }
 EXPORT_SYMBOL(freeze_super);
@@ -1374,7 +1373,7 @@ out:
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

