Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaKBHb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 02:31:27 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:46540 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaKBHbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 02:31:22 -0500
Message-ID: <1414913478.5380.114.camel@marge.simpson.net>
Subject: 3.14.23-rt20 - fs,btrfs: fix rt deadlock on extent_buffer->lock
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Sun, 02 Nov 2014 08:31:18 +0100
In-Reply-To: <1414910967.5380.81.camel@marge.simpson.net>
References: <20141031170326.1491a63f@gandalf.local.home>
	 <1414910967.5380.81.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: fs,btrfs: fix rt deadlock on extent_buffer->lock
From: Mike Galbraith <mgalbraith@suse.de>
Sat Jul 14 12:30:41 CEST 2012

Trivially repeatable deadlock is cured by enabling lockdep code in
btrfs_clear_path_blocking() as suggested by Chris Mason.  He also
suggested restricting blocking reader count to one, and not allowing
a spinning reader while blocking reader exists.  This has proven to
be unnecessary, the strict lock order enforcement is enough.. or
rather that's my box's opinion after long hours of hard pounding.

Note: extent-tree.c bit is additional recommendation from Chris
      Mason, split into a separate patch after discussion.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Chris Mason <chris.mason@fusionio.com>
---
 fs/btrfs/ctree.c       |    4 ++--
 fs/btrfs/extent-tree.c |    8 --------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -80,7 +80,7 @@ noinline void btrfs_clear_path_blocking(
 {
 	int i;
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if (defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PREEMPT_RT_BASE))
 	/* lockdep really cares that we take all of these spinlocks
 	 * in the right order.  If any of the locks in the path are not
 	 * currently blocking, it is going to complain.  So, make really
@@ -107,7 +107,7 @@ noinline void btrfs_clear_path_blocking(
 		}
 	}
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if (defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PREEMPT_RT_BASE))
 	if (held)
 		btrfs_clear_lock_blocking_rw(held, held_rw);
 #endif
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6938,14 +6938,6 @@ use_block_rsv(struct btrfs_trans_handle
 		goto again;
 	}
 
-	if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
-		static DEFINE_RATELIMIT_STATE(_rs,
-				DEFAULT_RATELIMIT_INTERVAL * 10,
-				/*DEFAULT_RATELIMIT_BURST*/ 1);
-		if (__ratelimit(&_rs))
-			WARN(1, KERN_DEBUG
-				"BTRFS: block rsv returned %d\n", ret);
-	}
 try_reserve:
 	ret = reserve_metadata_bytes(root, block_rsv, blocksize,
 				     BTRFS_RESERVE_NO_FLUSH);





