Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3LPKkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:40:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44116 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab3LPKk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:40:27 -0500
Date: Mon, 16 Dec 2013 02:40:12 -0800
From: "tip-bot for Paul E. McKenney" <tipbot@zytor.com>
Message-ID: <tip-01352fb81658cbf78c55844de8e3d1d606bbf3f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-arch@vger.kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-arch@vger.kernel.org
In-Reply-To: <1386799151-2219-5-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1386799151-2219-5-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Add an smp_mb__after_unlock_lock()
  for UNLOCK+BLOCK barrier
Git-Commit-ID: 01352fb81658cbf78c55844de8e3d1d606bbf3f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 02:40:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01352fb81658cbf78c55844de8e3d1d606bbf3f8
Gitweb:     http://git.kernel.org/tip/01352fb81658cbf78c55844de8e3d1d606bbf3f8
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 11 Dec 2013 13:59:08 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 16 Dec 2013 11:36:13 +0100

locking: Add an smp_mb__after_unlock_lock() for UNLOCK+BLOCK barrier

The Linux kernel has traditionally required that an UNLOCK+LOCK
pair act as a full memory barrier when either (1) that
UNLOCK+LOCK pair was executed by the same CPU or task, or (2)
the same lock variable was used for the UNLOCK and LOCK.  It now
seems likely that very few places in the kernel rely on this
full-memory-barrier semantic, and with the advent of queued
locks, providing this semantic either requires complex
reasoning, or for some architectures, added overhead.

This commit therefore adds a smp_mb__after_unlock_lock(), which
may be placed after a LOCK primitive to restore the
full-memory-barrier semantic. All definitions are currently
no-ops, but will be upgraded for some architectures when queued
locks arrive.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <linux-arch@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1386799151-2219-5-git-send-email-paulmck@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/spinlock.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 75f3494..3f2867f 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -130,6 +130,16 @@ do {								\
 #define smp_mb__before_spinlock()	smp_wmb()
 #endif
 
+/*
+ * Place this after a lock-acquisition primitive to guarantee that
+ * an UNLOCK+LOCK pair act as a full barrier.  This guarantee applies
+ * if the UNLOCK and LOCK are executed by the same CPU or if the
+ * UNLOCK and LOCK operate on the same lock variable.
+ */
+#ifndef smp_mb__after_unlock_lock
+#define smp_mb__after_unlock_lock()	do { } while (0)
+#endif
+
 /**
  * raw_spin_unlock_wait - wait until the spinlock gets unlocked
  * @lock: the spinlock in question.
