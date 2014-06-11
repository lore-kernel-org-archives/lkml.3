Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaFKUps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:45:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:34855 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaFKUpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:45:42 -0400
Message-Id: <20140611204237.271300614@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 20:45:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Subject: [patch 4/5] futex: Split out the first waiter attachment from
 lookup_pi_state()
References: <20140611202744.676528190@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=futex-split-out-attach-to-owner.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to be a bit more clever in futex_lock_pi_atomic() and separate
the possible states. Split out the code which attaches the first
waiter to the owner into a separate function. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

Index: linux/kernel/futex.c
===================================================================
--- linux.orig/kernel/futex.c
+++ linux/kernel/futex.c
@@ -865,21 +865,16 @@ out_state:
 	return 0;
 }
 
-static int
-lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
-		union futex_key *key, struct futex_pi_state **ps)
+/*
+ * Lookup the task for the TID provided from user space and attach to
+ * it after doing proper sanity checks.
+ */
+static int attach_to_pi_owner(u32 uval, union futex_key *key,
+			      struct futex_pi_state **ps)
 {
-	struct futex_q *match = futex_top_waiter(hb, key);
-	struct futex_pi_state *pi_state = NULL;
-	struct task_struct *p;
 	pid_t pid = uval & FUTEX_TID_MASK;
-
-	/*
-	 * If there is a waiter on that futex, validate it and
-	 * attach to the pi_state when the validation succeeds.
-	 */
-	if (match)
-		return attach_to_pi_state(uval, match->pi_state, ps);
+	struct futex_pi_state *pi_state;
+	struct task_struct *p;
 
 	/*
 	 * We are the first waiter - try to look up the real owner and attach
@@ -922,7 +917,7 @@ lookup_pi_state(u32 uval, struct futex_h
 	pi_state = alloc_pi_state();
 
 	/*
-	 * Initialize the pi_mutex in locked state and make 'p'
+	 * Initialize the pi_mutex in locked state and make @p
 	 * the owner of it:
 	 */
 	rt_mutex_init_proxy_locked(&pi_state->pi_mutex, p);
@@ -942,6 +937,25 @@ lookup_pi_state(u32 uval, struct futex_h
 	return 0;
 }
 
+static int lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
+			   union futex_key *key, struct futex_pi_state **ps)
+{
+	struct futex_q *match = futex_top_waiter(hb, key);
+
+	/*
+	 * If there is a waiter on that futex, validate it and
+	 * attach to the pi_state when the validation succeeds.
+	 */
+	if (match)
+		return attach_to_pi_state(uval, match->pi_state, ps);
+
+	/*
+	 * We are the first waiter - try to look up the owner based on
+	 * @uval and attach to it.
+	 */
+	return attach_to_pi_owner(uval, key, ps);
+}
+
 /**
  * futex_lock_pi_atomic() - Atomic work required to acquire a pi aware futex
  * @uaddr:		the pi futex user address


