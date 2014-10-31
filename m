Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaJaLXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:23:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaJaLVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:21:44 -0400
Message-Id: <20141031111549.668783222@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 31 Oct 2014 12:10:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: peter@hurleysoftware.com, oleg@redhat.com, rjw@rjwysocki.net,
        torvalds@linux-foundation.org, tglx@linutronix.de, eparis@redhat.com,
        umgwanakikbuti@gmail.com, marcel@holtmann.org, ebiederm@xmission.com,
        davem@davemloft.net, fengguang.wu@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/7] audit,wait: Fixup kauditd_thread wait loop
References: <20141031111037.936236584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peter_zijlstra-nested_sleeps_fixes_and_debug_infrastructure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kauditd_thread wait loop is a bit iffy; it has a number of problems:

 - calls try_to_freeze() before schedule(); you typically want the
   thread to re-evaluate the sleep condition when unfreezing, also
   freeze_task() issues a wakeup.

 - it unconditionally does the {add,remove}_wait_queue(), even when the
   sleep condition is false.

Use wait_event_freezable() that does the right thing.

Cc: mingo@kernel.org
Cc: oleg@redhat.com
Cc: torvalds@linux-foundation.org
Cc: tglx@linutronix.de
Cc: Eric Paris <eparis@redhat.com>
Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20141002102251.GA6324@worktop.programming.kicks-ass.net
---
 kernel/audit.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

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


