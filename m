Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaATSUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:20:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbaATSUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:20:17 -0500
Date: Mon, 20 Jan 2014 19:20:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] lockdep: don't create the wrong dependency on
	hlock->check == 0
Message-ID: <20140120182010.GA26498@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120181942.GA20783@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test-case:

	DEFINE_MUTEX(m1);
	DEFINE_MUTEX(m2);
	DEFINE_MUTEX(mx);

	void lockdep_should_complain(void)
	{
		lockdep_set_novalidate_class(&mx);

		// m1 -> mx -> m2
		mutex_lock(&m1);
		mutex_lock(&mx);
		mutex_lock(&m2);
		mutex_unlock(&m2);
		mutex_unlock(&mx);
		mutex_unlock(&m1);

		// m2 -> m1 ; should trigger the warning
		mutex_lock(&m2);
		mutex_lock(&m1);
		mutex_unlock(&m1);
		mutex_unlock(&m2);
	}

this doesn't trigger any warning, lockdep can't detect the trivial
deadlock.

This is because lock(&mx) correctly avoids m1 -> mx dependency, it
skips validate_chain() due to mx->check == 0. But lock(&m2) wrongly
adds mx -> m2 and thus m1 -> m2 is not created.

rcu_lock_acquire()->lock_acquire(check => 0) is fine due to read == 2,
so currently only __lockdep_no_validate__ can trigger this problem.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/locking/lockdep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c6a7d9d..543e120 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1934,12 +1934,12 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 
 	for (;;) {
 		int distance = curr->lockdep_depth - depth + 1;
-		hlock = curr->held_locks + depth-1;
+		hlock = curr->held_locks + depth - 1;
 		/*
 		 * Only non-recursive-read entries get new dependencies
 		 * added:
 		 */
-		if (hlock->read != 2) {
+		if (hlock->read != 2 && hlock->check) {
 			if (!check_prev_add(curr, hlock, next,
 						distance, trylock_loop))
 				return 0;
-- 
1.5.5.1

