Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaKDQLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:11:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbaKDQLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:11:09 -0500
Date: Tue, 4 Nov 2014 08:09:20 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ff960a731788a7408b6f66ec4fd772ff18833211@git.kernel.org>
Cc: mingo@kernel.org, edumazet@google.com, david@gibson.dropbear.id.au,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        jhs@mojatatu.com, teg@jklm.no, nicolas.dichtel@6wind.com,
        cwang@twopensource.com, vyasevic@redhat.com, ebiederm@xmission.com,
        jiri@resnulli.us, vfalico@gmail.com, oleg@redhat.com,
        torvalds@linux-foundation.org, hkchu@google.com,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        therbert@google.com, fengguang.wu@intel.com,
        sfeldma@cumulusnetworks.com, davem@davemloft.net, hpa@zytor.com
Reply-To: davem@davemloft.net, hpa@zytor.com, sfeldma@cumulusnetworks.com,
        john.fastabend@gmail.com, therbert@google.com, fengguang.wu@intel.com,
        hkchu@google.com, torvalds@linux-foundation.org,
        stephen@networkplumber.org, ebiederm@xmission.com, vfalico@gmail.com,
        oleg@redhat.com, jiri@resnulli.us, cwang@twopensource.com,
        nicolas.dichtel@6wind.com, vyasevic@redhat.com, jhs@mojatatu.com,
        teg@jklm.no, tglx@linutronix.de, peterz@infradead.org,
        linux-kernel@vger.kernel.org, david@gibson.dropbear.id.au,
        mingo@kernel.org, edumazet@google.com
In-Reply-To: <20141029173110.GE15602@worktop.programming.kicks-ass.net>
References: <20141029173110.GE15602@worktop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] netdev, sched/wait:
  Fix sleeping inside wait event
Git-Commit-ID: ff960a731788a7408b6f66ec4fd772ff18833211
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff960a731788a7408b6f66ec4fd772ff18833211
Gitweb:     http://git.kernel.org/tip/ff960a731788a7408b6f66ec4fd772ff18833211
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 29 Oct 2014 17:04:56 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:48 +0100

netdev, sched/wait: Fix sleeping inside wait event

rtnl_lock_unregistering*() take rtnl_lock() -- a mutex -- inside a
wait loop. The wait loop relies on current->state to function, but so
does mutex_lock(), nesting them makes for the inner to destroy the
outer state.

Fix this using the new wait_woken() bits.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <cwang@twopensource.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jerry Chu <hkchu@google.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: sfeldma@cumulusnetworks.com <sfeldma@cumulusnetworks.com>
Cc: stephen hemminger <stephen@networkplumber.org>
Cc: Tom Gundersen <teg@jklm.no>
Cc: Tom Herbert <therbert@google.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Vlad Yasevich <vyasevic@redhat.com>
Cc: netdev@vger.kernel.org
Link: http://lkml.kernel.org/r/20141029173110.GE15602@worktop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 net/core/dev.c       | 10 +++++-----
 net/core/rtnetlink.c | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b793e35..c5a9d73 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7196,11 +7196,10 @@ static void __net_exit rtnl_lock_unregistering(struct list_head *net_list)
 	 */
 	struct net *net;
 	bool unregistering;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
+	add_wait_queue(&netdev_unregistering_wq, &wait);
 	for (;;) {
-		prepare_to_wait(&netdev_unregistering_wq, &wait,
-				TASK_UNINTERRUPTIBLE);
 		unregistering = false;
 		rtnl_lock();
 		list_for_each_entry(net, net_list, exit_list) {
@@ -7212,9 +7211,10 @@ static void __net_exit rtnl_lock_unregistering(struct list_head *net_list)
 		if (!unregistering)
 			break;
 		__rtnl_unlock();
-		schedule();
+
+		wait_woken(&wait, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
-	finish_wait(&netdev_unregistering_wq, &wait);
+	remove_wait_queue(&netdev_unregistering_wq, &wait);
 }
 
 static void __net_exit default_device_exit_batch(struct list_head *net_list)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a688268..b095296 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -365,11 +365,10 @@ static void rtnl_lock_unregistering_all(void)
 {
 	struct net *net;
 	bool unregistering;
-	DEFINE_WAIT(wait);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
+	add_wait_queue(&netdev_unregistering_wq, &wait);
 	for (;;) {
-		prepare_to_wait(&netdev_unregistering_wq, &wait,
-				TASK_UNINTERRUPTIBLE);
 		unregistering = false;
 		rtnl_lock();
 		for_each_net(net) {
@@ -381,9 +380,10 @@ static void rtnl_lock_unregistering_all(void)
 		if (!unregistering)
 			break;
 		__rtnl_unlock();
-		schedule();
+
+		wait_woken(&wait, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 	}
-	finish_wait(&netdev_unregistering_wq, &wait);
+	remove_wait_queue(&netdev_unregistering_wq, &wait);
 }
 
 /**
