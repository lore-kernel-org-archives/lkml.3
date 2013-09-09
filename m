Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3IINaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:30:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12599 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3IIN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:26:54 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=C6u6bv4baTcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Qus6zTA8wZAA:10 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=xt1Mke5GkH6e2Q2BLK4A:9 a=2e6ZYRoF4I4A:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130909124556.478659945@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 09 Sep 2013 08:45:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 04/16] list_bl.h: make list head locking RT safe
References: <20130909124531.445392664@goodmis.org>
Content-Disposition: inline; filename=0004-list_bl.h-make-list-head-locking-RT-safe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

As per changes in include/linux/jbd_common.h for avoiding the
bit_spin_locks on RT ("fs: jbd/jbd2: Make state lock and journal
head lock rt safe") we do the same thing here.

We use the non atomic __set_bit and __clear_bit inside the scope of
the lock to preserve the ability of the existing LIST_DEBUG code to
use the zero'th bit in the sanity checks.

As a bit spinlock, we had no lockdep visibility into the usage
of the list head locking.  Now, if we were to implement it as a
standard non-raw spinlock, we would see:

BUG: sleeping function called from invalid context at kernel/rtmutex.c:658
in_atomic(): 1, irqs_disabled(): 0, pid: 122, name: udevd
5 locks held by udevd/122:
 #0:  (&sb->s_type->i_mutex_key#7/1){+.+.+.}, at: [<ffffffff811967e8>] lock_rename+0xe8/0xf0
 #1:  (rename_lock){+.+...}, at: [<ffffffff811a277c>] d_move+0x2c/0x60
 #2:  (&dentry->d_lock){+.+...}, at: [<ffffffff811a0763>] dentry_lock_for_move+0xf3/0x130
 #3:  (&dentry->d_lock/2){+.+...}, at: [<ffffffff811a0734>] dentry_lock_for_move+0xc4/0x130
 #4:  (&dentry->d_lock/3){+.+...}, at: [<ffffffff811a0747>] dentry_lock_for_move+0xd7/0x130
Pid: 122, comm: udevd Not tainted 3.4.47-rt62 #7
Call Trace:
 [<ffffffff810b9624>] __might_sleep+0x134/0x1f0
 [<ffffffff817a24d4>] rt_spin_lock+0x24/0x60
 [<ffffffff811a0c4c>] __d_shrink+0x5c/0xa0
 [<ffffffff811a1b2d>] __d_drop+0x1d/0x40
 [<ffffffff811a24be>] __d_move+0x8e/0x320
 [<ffffffff811a278e>] d_move+0x3e/0x60
 [<ffffffff81199598>] vfs_rename+0x198/0x4c0
 [<ffffffff8119b093>] sys_renameat+0x213/0x240
 [<ffffffff817a2de5>] ? _raw_spin_unlock+0x35/0x60
 [<ffffffff8107781c>] ? do_page_fault+0x1ec/0x4b0
 [<ffffffff817a32ca>] ? retint_swapgs+0xe/0x13
 [<ffffffff813eb0e6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8119b0db>] sys_rename+0x1b/0x20
 [<ffffffff817a3b96>] system_call_fastpath+0x1a/0x1f

Since we are only taking the lock during short lived list operations,
lets assume for now that it being raw won't be a significant latency
concern.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/list_bl.h |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 31f9d75..ddfd46a 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -2,6 +2,7 @@
 #define _LINUX_LIST_BL_H
 
 #include <linux/list.h>
+#include <linux/spinlock.h>
 #include <linux/bit_spinlock.h>
 
 /*
@@ -32,13 +33,22 @@
 
 struct hlist_bl_head {
 	struct hlist_bl_node *first;
+#ifdef CONFIG_PREEMPT_RT_BASE
+	raw_spinlock_t lock;
+#endif
 };
 
 struct hlist_bl_node {
 	struct hlist_bl_node *next, **pprev;
 };
-#define INIT_HLIST_BL_HEAD(ptr) \
-	((ptr)->first = NULL)
+
+static inline void INIT_HLIST_BL_HEAD(struct hlist_bl_head *h)
+{
+	h->first = NULL;
+#ifdef CONFIG_PREEMPT_RT_BASE
+	raw_spin_lock_init(&h->lock);
+#endif
+}
 
 static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
 {
@@ -117,12 +127,22 @@ static inline void hlist_bl_del_init(struct hlist_bl_node *n)
 
 static inline void hlist_bl_lock(struct hlist_bl_head *b)
 {
+#ifndef CONFIG_PREEMPT_RT_BASE
 	bit_spin_lock(0, (unsigned long *)b);
+#else
+	raw_spin_lock(&b->lock);
+	__set_bit(0, (unsigned long *)b);
+#endif
 }
 
 static inline void hlist_bl_unlock(struct hlist_bl_head *b)
 {
+#ifndef CONFIG_PREEMPT_RT_BASE
 	__bit_spin_unlock(0, (unsigned long *)b);
+#else
+	__clear_bit(0, (unsigned long *)b);
+	raw_spin_unlock(&b->lock);
+#endif
 }
 
 /**
-- 
1.7.10.4


