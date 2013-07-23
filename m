Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3GWHrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:47:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3GWHrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:47:09 -0400
Date: Tue, 23 Jul 2013 00:46:20 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-1e40c2edef2537f87f94d0baf80aeaeb7d51cc23@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davidlohr.bueso@hp.com, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, riel@redhat.com,
        dhowells@redhat.com, Waiman.Long@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davidlohr.bueso@hp.com, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, riel@redhat.com,
        Waiman.Long@hp.com, dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <20130719183101.GA20909@twins.programming.kicks-ass.net>
References: <20130719183101.GA20909@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] mutex: Fix/
 document access-once assumption in mutex_can_spin_on_owner()
Git-Commit-ID: 1e40c2edef2537f87f94d0baf80aeaeb7d51cc23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:46:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e40c2edef2537f87f94d0baf80aeaeb7d51cc23
Gitweb:     http://git.kernel.org/tip/1e40c2edef2537f87f94d0baf80aeaeb7d51cc23
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 19 Jul 2013 20:31:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 22 Jul 2013 10:33:39 +0200

mutex: Fix/document access-once assumption in mutex_can_spin_on_owner()

mutex_can_spin_on_owner() is technically broken in that it would
in theory allow the compiler to load lock->owner twice, seeing a
pointer first time and a NULL pointer the second time.

Linus pointed out that a compiler has to be seriously broken to
not compile this correctly - but nevertheless this change
is correct as it will better document the implementation.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Acked-by: Waiman Long <Waiman.Long@hp.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20130719183101.GA20909@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/mutex.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index ff05f4b..7ff48c5 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -209,11 +209,13 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
  */
 static inline int mutex_can_spin_on_owner(struct mutex *lock)
 {
+	struct task_struct *owner;
 	int retval = 1;
 
 	rcu_read_lock();
-	if (lock->owner)
-		retval = lock->owner->on_cpu;
+	owner = ACCESS_ONCE(lock->owner);
+	if (owner)
+		retval = owner->on_cpu;
 	rcu_read_unlock();
 	/*
 	 * if lock->owner is not set, the mutex owner may have just acquired
