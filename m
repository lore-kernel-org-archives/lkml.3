Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaIISmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:42:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:15624 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaIISkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:40:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,492,1406617200"; 
   d="scan'208";a="570725183"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, James Simmons <uja.ornl@gmail.com>,
        Liu Xuezhao <xuezhao.liu@emc.com>, Peng Tao <tao.peng@emc.com>,
        "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 3/7] staging/lustre: remove portals_compat25.h
Date: Tue, 9 Sep 2014 13:39:04 -0500
Message-ID: <1410287948-13168-4-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
References: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <uja.ornl@gmail.com>

Remove include/linux/libcfs/linux/portals_compat25.h.

. remove some unused/unnecessary macros such as smp_num_cpus /
  SIGNAL_MASK_ASSERT etc.

. replace some macros with direct kernel API calls such as
  RECALC_SIGPENDING/CLEAR_SIGPENDING/CURRENT_SECONDS,
  cfs_wait_event_interruptible/_exclusive etc.

Signed-off-by: Liu Xuezhao <xuezhao.liu@emc.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: James Simmons <uja.ornl@gmail.com>
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/4778
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
---
 .../lustre/include/linux/libcfs/libcfs_fail.h      |    4 +-
 .../lustre/include/linux/libcfs/linux/libcfs.h     |    1 -
 .../lustre/include/linux/libcfs/linux/linux-time.h |    2 -
 .../include/linux/libcfs/linux/portals_compat25.h  |   81 --------------------
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |    4 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.h  |    1 -
 .../lustre/lustre/include/linux/lustre_compat25.h  |    1 -
 drivers/staging/lustre/lustre/libcfs/hash.c        |    3 +-
 .../lustre/lustre/libcfs/linux/linux-debug.c       |    5 +-
 .../lustre/lustre/libcfs/linux/linux-prim.c        |   20 ++---
 drivers/staging/lustre/lustre/libcfs/workitem.c    |    4 +-
 .../staging/lustre/lustre/obdclass/obd_config.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |    2 -
 13 files changed, 20 insertions(+), 110 deletions(-)
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/portals_compat25.h

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_fail.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_fail.h
index 1934ec2..e5231d8 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_fail.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_fail.h
@@ -156,8 +156,8 @@ static inline void cfs_race(__u32 id)
 
 			cfs_race_state = 0;
 			CERROR("cfs_race id %x sleeping\n", id);
-			cfs_wait_event_interruptible(cfs_race_waitq,
-						     cfs_race_state != 0, rc);
+			rc = wait_event_interruptible(cfs_race_waitq,
+						      cfs_race_state != 0);
 			CERROR("cfs_fail_race id %x awake, rc=%d\n", id, rc);
 		} else {
 			CERROR("cfs_fail_race id %x waking\n", id);
diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/libcfs.h b/drivers/staging/lustre/include/linux/libcfs/linux/libcfs.h
index ccc55fc..7690229 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/libcfs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/libcfs.h
@@ -86,7 +86,6 @@
 #include "linux-cpu.h"
 #include "linux-time.h"
 #include "linux-mem.h"
-#include "portals_compat25.h"
 
 
 #define LUSTRE_TRACE_SIZE (THREAD_SIZE >> 5)
diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-time.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-time.h
index 1158a31..0709ee2 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-time.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-time.h
@@ -53,8 +53,6 @@
 #include <linux/time.h>
 #include <asm/div64.h>
 
-#include "portals_compat25.h"
-
 /*
  * post 2.5 kernels.
  */
diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/portals_compat25.h b/drivers/staging/lustre/include/linux/libcfs/linux/portals_compat25.h
deleted file mode 100644
index 442d61b..0000000
--- a/drivers/staging/lustre/include/linux/libcfs/linux/portals_compat25.h
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2008, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef __LIBCFS_LINUX_PORTALS_COMPAT_H__
-#define __LIBCFS_LINUX_PORTALS_COMPAT_H__
-
-/* XXX BUG 1511 -- remove this stanza and all callers when bug 1511 is resolved */
-#if defined(SPINLOCK_DEBUG) && SPINLOCK_DEBUG
-#  define SIGNAL_MASK_ASSERT() \
-   LASSERT(current->sighand->siglock.magic == SPINLOCK_MAGIC)
-#else
-# define SIGNAL_MASK_ASSERT()
-#endif
-/* XXX BUG 1511 -- remove this stanza and all callers when bug 1511 is resolved */
-
-#define SIGNAL_MASK_LOCK(task, flags)				  \
-	spin_lock_irqsave(&task->sighand->siglock, flags)
-#define SIGNAL_MASK_UNLOCK(task, flags)				\
-	spin_unlock_irqrestore(&task->sighand->siglock, flags)
-#define USERMODEHELPER(path, argv, envp)			       \
-	call_usermodehelper(path, argv, envp, 1)
-#define clear_tsk_thread_flag(current, TIF_SIGPENDING)	  clear_tsk_thread_flag(current,       \
-							TIF_SIGPENDING)
-# define smp_num_cpus	      num_online_cpus()
-
-#define cfs_wait_event_interruptible(wq, condition, ret)	       \
-	ret = wait_event_interruptible(wq, condition)
-#define cfs_wait_event_interruptible_exclusive(wq, condition, ret)     \
-	ret = wait_event_interruptible_exclusive(wq, condition)
-
-#define THREAD_NAME(comm, len, fmt, a...)			      \
-	snprintf(comm, len, fmt, ## a)
-
-/* 2.6 alloc_page users can use page->lru */
-#define PAGE_LIST_ENTRY lru
-#define PAGE_LIST(page) ((page)->lru)
-
-#ifndef __user
-#define __user
-#endif
-
-#ifndef __fls
-#define __cfs_fls fls
-#else
-#define __cfs_fls __fls
-#endif
-
-#endif /* _PORTALS_COMPAT_H */
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index 6c8b1e1..34c6abd 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -1537,9 +1537,9 @@ int ksocknal_scheduler(void *arg)
 			nloops = 0;
 
 			if (!did_something) {   /* wait for something to do */
-				cfs_wait_event_interruptible_exclusive(
+				rc = wait_event_interruptible_exclusive(
 					sched->kss_waitq,
-					!ksocknal_sched_cansleep(sched), rc);
+					!ksocknal_sched_cansleep(sched));
 				LASSERT (rc == 0);
 			} else {
 				cond_resched();
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.h b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.h
index f14a60c..7a793d2 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.h
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.h
@@ -63,7 +63,6 @@
 #include <linux/syscalls.h>
 
 #include "../../../include/linux/libcfs/libcfs.h"
-#include "../../../include/linux/libcfs/linux/portals_compat25.h"
 
 #include <linux/crc32.h>
 static inline __u32 ksocknal_csum(__u32 crc, unsigned char const *p, size_t len)
diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
index f9522de..e94ab34 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
@@ -39,7 +39,6 @@
 
 #include <linux/fs_struct.h>
 #include <linux/namei.h>
-#include "../../../include/linux/libcfs/linux/portals_compat25.h"
 
 #include "lustre_patchless_compat.h"
 
diff --git a/drivers/staging/lustre/lustre/libcfs/hash.c b/drivers/staging/lustre/lustre/libcfs/hash.c
index 3b1d24c..3b67b7b 100644
--- a/drivers/staging/lustre/lustre/libcfs/hash.c
+++ b/drivers/staging/lustre/lustre/libcfs/hash.c
@@ -2092,8 +2092,7 @@ int cfs_hash_debug_str(struct cfs_hash *hs, struct seq_file *m)
 			maxdepb = ffz(~maxdep);
 		}
 		total += bd.bd_bucket->hsb_count;
-		dist[min(__cfs_fls(bd.bd_bucket->hsb_count/max(theta,
-							       1)), 7)]++;
+		dist[min(fls(bd.bd_bucket->hsb_count / max(theta, 1)), 7)]++;
 		cfs_hash_bd_unlock(hs, &bd, 0);
 	}
 
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
index be6a144..3298ddf 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-debug.c
@@ -56,7 +56,6 @@
 # define DEBUG_SUBSYSTEM S_LNET
 
 #include "../../../include/linux/libcfs/libcfs.h"
-#include "../../../include/linux/libcfs/linux/portals_compat25.h"
 
 #include "../tracefile.h"
 
@@ -86,7 +85,7 @@ void libcfs_run_debug_log_upcall(char *file)
 
 	argv[2] = NULL;
 
-	rc = USERMODEHELPER(argv[0], argv, envp);
+	rc = call_usermodehelper(argv[0], argv, envp, 1);
 	if (rc < 0 && rc != -ENOENT) {
 		CERROR("Error %d invoking LNET debug log upcall %s %s; "
 		       "check /proc/sys/lnet/debug_log_upcall\n",
@@ -113,7 +112,7 @@ void libcfs_run_upcall(char **argv)
 
 	LASSERT(argc >= 2);
 
-	rc = USERMODEHELPER(argv[0], argv, envp);
+	rc = call_usermodehelper(argv[0], argv, envp, 1);
 	if (rc < 0 && rc != -ENOENT) {
 		CERROR("Error %d invoking LNET upcall %s %s%s%s%s%s%s%s%s; "
 		       "check /proc/sys/lnet/upcall\n",
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
index 871ba44..19f405e 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
@@ -130,11 +130,11 @@ cfs_block_allsigs(void)
 	unsigned long	  flags;
 	sigset_t	old;
 
-	SIGNAL_MASK_LOCK(current, flags);
+	spin_lock_irqsave(&current->sighand->siglock, flags);
 	old = current->blocked;
 	sigfillset(&current->blocked);
 	recalc_sigpending();
-	SIGNAL_MASK_UNLOCK(current, flags);
+	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 
 	return old;
 }
@@ -144,11 +144,11 @@ sigset_t cfs_block_sigs(unsigned long sigs)
 	unsigned long  flags;
 	sigset_t	old;
 
-	SIGNAL_MASK_LOCK(current, flags);
+	spin_lock_irqsave(&current->sighand->siglock, flags);
 	old = current->blocked;
 	sigaddsetmask(&current->blocked, sigs);
 	recalc_sigpending();
-	SIGNAL_MASK_UNLOCK(current, flags);
+	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 	return old;
 }
 
@@ -158,11 +158,11 @@ sigset_t cfs_block_sigsinv(unsigned long sigs)
 	unsigned long flags;
 	sigset_t old;
 
-	SIGNAL_MASK_LOCK(current, flags);
+	spin_lock_irqsave(&current->sighand->siglock, flags);
 	old = current->blocked;
 	sigaddsetmask(&current->blocked, ~sigs);
 	recalc_sigpending();
-	SIGNAL_MASK_UNLOCK(current, flags);
+	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 
 	return old;
 }
@@ -172,10 +172,10 @@ cfs_restore_sigs (sigset_t old)
 {
 	unsigned long  flags;
 
-	SIGNAL_MASK_LOCK(current, flags);
+	spin_lock_irqsave(&current->sighand->siglock, flags);
 	current->blocked = old;
 	recalc_sigpending();
-	SIGNAL_MASK_UNLOCK(current, flags);
+	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
 int
@@ -189,9 +189,9 @@ cfs_clear_sigpending(void)
 {
 	unsigned long flags;
 
-	SIGNAL_MASK_LOCK(current, flags);
+	spin_lock_irqsave(&current->sighand->siglock, flags);
 	clear_tsk_thread_flag(current, TIF_SIGPENDING);
-	SIGNAL_MASK_UNLOCK(current, flags);
+	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
 int
diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
index 03ab9e0..c4afaea 100644
--- a/drivers/staging/lustre/lustre/libcfs/workitem.c
+++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
@@ -288,8 +288,8 @@ cfs_wi_scheduler (void *arg)
 		}
 
 		cfs_wi_sched_unlock(sched);
-		cfs_wait_event_interruptible_exclusive(sched->ws_waitq,
-				!cfs_wi_sched_cansleep(sched), rc);
+		rc = wait_event_interruptible_exclusive(sched->ws_waitq,
+						!cfs_wi_sched_cansleep(sched));
 		cfs_wi_sched_lock(sched);
 	}
 
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index f741b07..5e7b3d7 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -1067,7 +1067,7 @@ static int process_param2_config(struct lustre_cfg *lcfg)
 	}
 
 	do_gettimeofday(&start);
-	rc = USERMODEHELPER(argv[0], argv, NULL);
+	rc = call_usermodehelper(argv[0], argv, NULL, 1);
 	do_gettimeofday(&end);
 
 	if (rc < 0) {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 4519aee..112e30b 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -2041,8 +2041,6 @@ int ptlrpc_set_next_timeout(struct ptlrpc_request_set *set)
 	struct ptlrpc_request *req;
 	int		    deadline;
 
-	SIGNAL_MASK_ASSERT(); /* XXX BUG 1511 */
-
 	list_for_each(tmp, &set->set_requests) {
 		req = list_entry(tmp, struct ptlrpc_request, rq_set_chain);
 
-- 
1.7.9.5

