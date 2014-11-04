Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaKDQJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:09:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaKDQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:09:44 -0500
Date: Tue, 4 Nov 2014 08:08:47 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6b55fc63f46ba299f3d84013e9232be4bd259eab@git.kernel.org>
Cc: hpa@zytor.com, torvalds@linux-foundation.org, eparis@redhat.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        umgwanakikbuti@gmail.com, tglx@linutronix.de, peterz@infradead.org
Reply-To: tglx@linutronix.de, peterz@infradead.org, eparis@redhat.com,
        hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, umgwanakikbuti@gmail.com,
        mingo@kernel.org
In-Reply-To: <20141002102251.GA6324@worktop.programming.kicks-ass.net>
References: <20141002102251.GA6324@worktop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] audit, sched/wait: Fixup kauditd_thread()
  wait loop
Git-Commit-ID: 6b55fc63f46ba299f3d84013e9232be4bd259eab
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

Commit-ID:  6b55fc63f46ba299f3d84013e9232be4bd259eab
Gitweb:     http://git.kernel.org/tip/6b55fc63f46ba299f3d84013e9232be4bd259eab
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 2 Oct 2014 12:22:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:47 +0100

audit, sched/wait: Fixup kauditd_thread() wait loop

The kauditd_thread wait loop is a bit iffy; it has a number of problems:

 - calls try_to_freeze() before schedule(); you typically want the
   thread to re-evaluate the sleep condition when unfreezing, also
   freeze_task() issues a wakeup.

 - it unconditionally does the {add,remove}_wait_queue(), even when the
   sleep condition is false.

Use wait_event_freezable() that does the right thing.

Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: oleg@redhat.com
Cc: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141002102251.GA6324@worktop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/audit.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 80983df..32bfc43 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -499,7 +499,6 @@ static int kauditd_thread(void *dummy)
 	set_freezable();
 	while (!kthread_should_stop()) {
 		struct sk_buff *skb;
-		DECLARE_WAITQUEUE(wait, current);
 
 		flush_hold_queue();
 
@@ -514,16 +513,8 @@ static int kauditd_thread(void *dummy)
 				audit_printk_skb(skb);
 			continue;
 		}
-		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&kauditd_wait, &wait);
 
-		if (!skb_queue_len(&audit_skb_queue)) {
-			try_to_freeze();
-			schedule();
-		}
-
-		__set_current_state(TASK_RUNNING);
-		remove_wait_queue(&kauditd_wait, &wait);
+		wait_event_freezable(kauditd_wait, skb_queue_len(&audit_skb_queue));
 	}
 	return 0;
 }
