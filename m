Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026Ab3HSPg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:36:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9345 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3HSPgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:36:21 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=zF0afzQVyTUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kaE1MqYwaDAA:10 a=VnNF1IyMAAAA:8 a=CCc9dfb0qLQ5uBn0lG0A:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130819153618.983248997@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 11:35:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RT 2/3] swait: Add memory barrier before checking list empty
References: <20130819153530.409041534@goodmis.org>
Content-Disposition: inline; filename=0002-swait-Add-memory-barrier-before-checking-list-empty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

There's a race condition with swait wakeups and adding to the list. The
__swait_wake() does a check for swait_head_has_waiters(), and if it is
empty it will exit without doing any wake ups. The problem is that the
check does not include any memory barriers before it makes a decision
to wake up or not.

	CPU0				CPU1
	----				----

  condition = 1

  load h->list (is empty)
				    raw_spin_lock(hlist->lock)
				    hlist_add();
				    __set_current_state();
				    raw_spin_unlock(hlist->lock)
  swait_wake()
   swait_head_has_waiters()
   (sees h->list as empty and returns)

				    check_condition (sees condition = 0)

   store condition = 1

				    schedule()

Now the task on CPU1 has just missed its wakeup. By adding a memory
barrier before the list empty check, we fix the problem of miss seeing
the list not empty as well as pushing out the condition for the other
task to see.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/wait-simple.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/wait-simple.c b/kernel/wait-simple.c
index 4b9a0b5..9725a11 100644
--- a/kernel/wait-simple.c
+++ b/kernel/wait-simple.c
@@ -27,6 +27,8 @@ static inline void __swait_dequeue(struct swaiter *w)
 /* Check whether a head has waiters enqueued */
 static inline bool swait_head_has_waiters(struct swait_head *h)
 {
+	/* Make sure the condition is visible before checking list_empty() */
+	smp_mb();
 	return !list_empty(&h->list);
 }
 
-- 
1.7.10.4


