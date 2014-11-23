Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaKWVFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 16:05:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:35190 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaKWVFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 16:05:49 -0500
Date: Sun, 23 Nov 2014 22:05:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Mason <clm@fb.com>
cc: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: New crashes walking proc with Saturday's git
In-Reply-To: <1416761342.24312.15@mail.thefacebook.com>
Message-ID: <alpine.DEB.2.11.1411232141590.6439@nanos>
References: <20141123010239.GA12691@ret.masoncoding.com> <1416758187.24312.12@mail.thefacebook.com> <20141123161120.GB7070@pd.tnic> <1416759411.24312.13@mail.thefacebook.com> <20141123163258.GB6436@pd.tnic> <1416761342.24312.15@mail.thefacebook.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2014, Chris Mason wrote:
> On Sun, Nov 23, 2014 at 11:32 AM, Borislav Petkov <bp@alien8.de> wrote:
> > On Sun, Nov 23, 2014 at 11:16:51AM -0500, Chris Mason wrote:
> > >  It must be:
> > > 
> > >  commit 6e998916dfe327e785e7c2447959b2c1a3ea4930
> > >  Author: Stanislaw Gruszka <sgruszka@redhat.com>
> > >  Date:   Wed Nov 12 16:58:44 2014 +0100
> > > 
> > >     sched/cputime: Fix clock_nanosleep()/clock_gettime() inconsistency
> > > 
> > >  I'll do two runs to confirm, but it's the only related patch between rc5
> > > and
> > >  now.
> 
> I've adding Ingo and Stanislaw to the cc.  With
> 6e998916dfe327e785e7c2447959b2c1a3ea4930 reverted, I'm no longer crashing.
> 
> Repeating the stack trace for the new cc list.  I see the crash with atop or
> similar walkers of /proc racing against exiting programs.  Given the NULL rip,
> this line from the patch is probably broken, but it really feels like we
> should be falling over on p->sched_class and not on the update_curr func.
> 
> +               p->sched_class->update_curr(rq);
> 
> I'm leaving my fork bomb running on two machines with the patch reverted to
> make sure.

The sched_class instances which do not have update_curr are stop_task
and idle. Patch below.

I'm sure nobody thought about the stats read code path here.

[ 1053.759741]  [<ffffffff81208348>] do_task_stat+0x8b8/0xb00

do_task_stat(()
 thread_group_cputime_adjusted()
   thread_group_cputime()
     task_cputime()
       task_sched_runtime()
	if (task_current(rq, p) && task_on_rq_queued(p)) {
                update_rq_clock(rq);
                p->sched_class->update_curr(rq);
        }

Now if the stats are read for a stomp machine task, aka 'migration/N'
and that task is current on its cpu. Ooops.

I added the callback for idle tasks as well for completeness sake.

Thanks,

	tglx
---
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 67ad4e7f506a..c65dac8c97cd 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -75,6 +75,10 @@ static unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task
 	return 0;
 }
 
+static void update_curr_idle(struct rq *rq)
+{
+}
+
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
@@ -101,4 +105,5 @@ const struct sched_class idle_sched_class = {
 
 	.prio_changed		= prio_changed_idle,
 	.switched_to		= switched_to_idle,
+	.update_curr		= update_curr_idle,
 };
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 67426e529f59..79ffec45a6ac 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -102,6 +102,10 @@ get_rr_interval_stop(struct rq *rq, struct task_struct *task)
 	return 0;
 }
 
+static void update_curr_stop(struct rq *rq)
+{
+}
+
 /*
  * Simple, special scheduling class for the per-CPU stop tasks:
  */
@@ -128,4 +132,5 @@ const struct sched_class stop_sched_class = {
 
 	.prio_changed		= prio_changed_stop,
 	.switched_to		= switched_to_stop,
+	.update_curr		= update_curr_stop,
 };

