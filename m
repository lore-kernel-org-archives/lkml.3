Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbaEFCGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 22:06:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:25704 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933564AbaEFCGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 22:06:32 -0400
Date: Mon, 5 May 2014 22:06:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: <peterz@infradead.org>, <bsegall@google.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Move the wakeup tracepoint from ttwu_do_wakeup()
 to ttwu_activate().
Message-ID: <20140505220628.5d62fdec@gandalf.local.home>
In-Reply-To: <53682AA7.9060401@cn.fujitsu.com>
References: <53673074.1040406@cn.fujitsu.com>
	<1399271647-25696-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140505100014.19b46560@gandalf.local.home>
	<53682AA7.9060401@cn.fujitsu.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 09:19:51 +0900
Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:

> > tldr;
> 
> Yes, it is really loooong, sorry for my terrible expression in english. :(

No problem. I can imagine the trouble of having to write change logs in
a language that is not your mother tongue.

> >
> > ttwu_do_wakeup() is called when the task's state is switched back to
> > TASK_RUNNING, whether or not the task actually scheduled out. Tracing
> > the wakeup event when the task never scheduled out is quite confusing.
> > It should only trace the task wake up if the task actually did go to
> > sleep. Move the tracepoint from ttwu_do_wakeup() to ttwu_activate()
> > where it is called only if the task is really woken up and not just
> > have its state changed.
> 
> Thanx for your kind comment here, it looks shorter and more clear to me.
> I will update my commit message with your suggestion.
> 
> Thank you very much! :)

I wonder if we should have the event, or way to distinguish the
difference. Hmm, there's that "success" parameter in the tracepoint.
Could we possible be able to trace events where the success is true
only if it was actually waking the event, and false otherwise?

Having the sched_wakeup trace event show you when something woke the
task up may still be useful information. For example, you add yourself
to a wait queue and want to see the "wakeup". If we only show it for
tasks that really woke up then we wont see it for those that added
itself to a waitqueue but was "woken" before it could schedule out.

The original sched_wakeup did this, but with the ttwu rewrite, it was
lost.

Something like below?

-- Steve

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..e583989 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1404,6 +1404,7 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 {
 	activate_task(rq, p, en_flags);
 	p->on_rq = 1;
+	trace_sched_wakeup(p, true);
 
 	/* if a worker is waking up, notify workqueue */
 	if (p->flags & PF_WQ_WORKER)
@@ -1417,7 +1418,6 @@ static void
 ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
 	check_preempt_curr(rq, p, wake_flags);
-	trace_sched_wakeup(p, true);
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
@@ -1662,6 +1662,8 @@ static void try_to_wake_up_local(struct task_struct *p)
 
 	if (!p->on_rq)
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
+	else
+		trace_sched_wakeup(p, false);
 
 	ttwu_do_wakeup(rq, p, 0);
 	ttwu_stat(p, smp_processor_id(), 0);
