Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3BSB03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:26:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14562 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3BSB01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:26:27 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Tns0NbjpAz8A:10 a=3cUUKT4QoJCtVsZvzEwA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361237185.23152.174.camel@gandalf.local.home>
Subject: Re: sched: BUG in load_balance
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Feb 2013 20:26:25 -0500
In-Reply-To: <5122CD9C.9070702@oracle.com>
References: <5122CD9C.9070702@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 19:55 -0500, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest, running today's -next,
> I've stumbled on the following spew.
> 
> I've cc'ed Steven Rostedt since the culprit looks like "sched: Enable
> interrupts in idle_balance()".

You're correct. Interrupts are ok but softirqs must still be disabled.

The following patch should work.

-- Steve

Only compiled tested:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0fcdbff..a31174c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5222,9 +5222,9 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	update_rq_runnable_avg(this_rq, 1);
 
 	/*
-	 * Drop the rq->lock, but keep preempt disabled.
+	 * Drop the rq->lock, but keep softirqs disabled.
 	 */
-	preempt_disable();
+	local_bh_disable();
 	raw_spin_unlock_irq(&this_rq->lock);
 
 	update_blocked_averages(this_cpu);
@@ -5253,7 +5253,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	rcu_read_unlock();
 
 	raw_spin_lock_irq(&this_rq->lock);
-	preempt_enable();
+	local_bh_enable();
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*


