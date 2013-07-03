Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566Ab3GCUVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:21:48 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:24485 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965545Ab3GCUVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:21:45 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Sasha Levin <sasha.levin@oracle.com>, Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 15/25] export-fs: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:21:32 -0400
Message-Id: <1372882892-23013-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that
use the d_lock field of the dentry structure need to be changed
accordingly. All the d_lock's spin_lock() and spin_unlock() calls
are replaced by the corresponding d_lock() and d_unlock() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/exportfs/expfs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 262fc99..9cf6a44 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -114,15 +114,15 @@ reconnect_path(struct vfsmount *mnt, struct dentry *target_dir, char *nbuf)
 
 		if (!IS_ROOT(pd)) {
 			/* must have found a connected parent - great */
-			spin_lock(&pd->d_lock);
+			d_lock(pd);
 			pd->d_flags &= ~DCACHE_DISCONNECTED;
-			spin_unlock(&pd->d_lock);
+			d_unlock(pd);
 			noprogress = 0;
 		} else if (pd == mnt->mnt_sb->s_root) {
 			printk(KERN_ERR "export: Eeek filesystem root is not connected, impossible\n");
-			spin_lock(&pd->d_lock);
+			d_lock(pd);
 			pd->d_flags &= ~DCACHE_DISCONNECTED;
-			spin_unlock(&pd->d_lock);
+			d_unlock(pd);
 			noprogress = 0;
 		} else {
 			/*
-- 
1.7.1

