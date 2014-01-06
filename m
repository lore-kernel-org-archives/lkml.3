Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaAFBiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:38:54 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:38388 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaAFBix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:38:53 -0500
Message-ID: <1388972316.4918.5.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 5/4] futex: silence uninitialized warnings
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com
Date: Sun, 05 Jan 2014 17:38:36 -0800
In-Reply-To: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

Callers of cmpxchg_futex_value_locked() can trigger the following:

kernel/futex.c: In function ‘futex_lock_pi_atomic’:
kernel/futex.c:725: warning: ‘curval’ may be used uninitialized in this function

This was initially addressed by commit 7cfdaf38, but others still remain. Silence
these messages once and for all as the variables really aren't uninitialized.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/futex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 5b4d09e..65ade8a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -838,7 +838,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 				struct task_struct *task, int set_waiters)
 {
 	int lock_taken, ret, force_take = 0;
-	u32 uval, newval, curval, vpid = task_pid_vnr(task);
+	u32 uval, newval, uninitialized_var(curval), vpid = task_pid_vnr(task);
 
 retry:
 	ret = lock_taken = 0;
@@ -2227,7 +2227,7 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
 	union futex_key key = FUTEX_KEY_INIT;
-	u32 uval, vpid = task_pid_vnr(current);
+	u32 uninitialized_var(uval), vpid = task_pid_vnr(current);
 	int ret;
 
 retry:
@@ -2843,7 +2843,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 
 static int __init futex_init(void)
 {
-	u32 curval;
+	u32 uninitialized_var(curval);
 	unsigned long i;
 
 #if CONFIG_BASE_SMALL
-- 
1.8.1.4



