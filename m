Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaBJNeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:34:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33387 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaBJNeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:34:00 -0500
Date: Mon, 10 Feb 2014 05:33:08 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-1b5ff816cab708ba44c7d7b56b613516269eb577@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, peterz@infradead.org, davej@redhat.com,
        gregkh@linuxfoundation.org, paulmck@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, peterz@infradead.org, davej@redhat.com,
        paulmck@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        rostedt@goodmis.org, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20140120182010.GA26498@redhat.com>
References: <20140120182010.GA26498@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Don'
 t create the wrong dependency on hlock->check == 0
Git-Commit-ID: 1b5ff816cab708ba44c7d7b56b613516269eb577
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:33:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b5ff816cab708ba44c7d7b56b613516269eb577
Gitweb:     http://git.kernel.org/tip/1b5ff816cab708ba44c7d7b56b613516269eb577
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 20 Jan 2014 19:20:10 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 21:18:57 +0100

lockdep: Don't create the wrong dependency on hlock->check == 0

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
Cc: Dave Jones <davej@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140120182010.GA26498@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/lockdep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 8c85a0d..f7eba92 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1936,12 +1936,12 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 
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
