Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935588Ab3DKMy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:54:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:42684 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3DKMy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:54:26 -0400
Date: Thu, 11 Apr 2013 14:54:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Dave Hansen <dave@sr71.net>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
In-Reply-To: <5166A1D0.1080102@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1304111452140.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos>
 <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <alpine.LFD.2.02.1304092036431.21884@ionos> <alpine.LFD.2.02.1304092126150.21884@ionos> <51647C30.3050109@sr71.net>
 <alpine.LFD.2.02.1304101024010.21884@ionos> <alpine.LFD.2.02.1304101250320.21884@ionos> <5165C087.4060404@sr71.net> <alpine.LFD.2.02.1304111020520.21884@ionos> <51669510.2040200@linux.vnet.ibm.com> <5166A1D0.1080102@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013, Srivatsa S. Bhat wrote:

> On 04/11/2013 04:18 PM, Srivatsa S. Bhat wrote:
> > On 04/11/2013 03:49 PM, Thomas Gleixner wrote:
> >> Dave,
> >>
> >> On Wed, 10 Apr 2013, Dave Hansen wrote:
> >>
> >>> I think I got a full trace this time:
> >>>
> >>> 	http://sr71.net/~dave/linux/bigbox-trace.1365621899.txt.gz
> >>>
> >>> The last timestamp is pretty close to the timestamp on the console:
> >>>
> >>> [ 2071.033434] smpboot_thread_fn():
> >>> [ 2071.033455] smpboot_thread_fn() cpu: 22 159
> >>> [ 2071.033470] td->cpu: 22
> >>> [ 2071.033475] smp_processor_id(): 21
> >>> [ 2071.033486] comm: migration/%u
> >>
> >> Yes, that's helpful. Though it makes my mind boggle:
> >>
> >>     migration/22-4335  [021] d.h.  2071.020530: sched_wakeup: comm=migration/21 pid=4323 prio=0 success=1 target_cpu=021^M
> >>     migration/22-4335  [021] d...  2071.020541: sched_switch: prev_comm=migration/22 prev_pid=4335 prev_prio=0 prev_state=0x200 ==> next_comm=migration/21 next_pid=4323 next_prio=0^M
> >>     migration/21-4323  [021] d...  2071.026110: sched_switch: prev_comm=migration/21 prev_pid=4323 prev_prio=0 prev_state=S ==> next_comm=migration/22 next_pid=4335 next_prio=0^M
> >>     migration/22-4335  [021] ....  2071.033422: smpboot_thread_fn <-kthread^M
> >>
> >> So the migration thread schedules out with state TASK_PARKED and gets
> >> scheduled back in right away without a wakeup. Srivatsa was about
> >> right, that this might be related to the sched_set_stop_task() call,
> >> but the changelog led completely down the wrong road.
> >>
> >> So the issue is:
> >>
> >> CPU14				CPU21
> >> create_thread(for CPU22)
> >>  park_thread()	
> >>    wait_for_completion()	park_me()
> >> 				 complete()
> >>    sched_set_stop_task()
> >> 				 schedule(TASK_PARKED)
> >>
> >> The sched_set_stop_task() call is issued while the task is on the
> >> runqueue of CPU21 and that confuses the hell out of the stop_task
> >> class on that cpu. So as we have to synchronize the state for the
> >> bind call (the issue observed by Borislav) we need to do the same
> >> before issuing sched_set_stop_task(). Delta patch below.
> >>
> > 
> > In that case, why not just apply this 2 line patch on mainline?
> > The patch I sent yesterday was more elaborate because I wrongly assumed
> > that kthread_bind() can cause a wakeup. But now, I feel the patch shown
> > below should work just fine too. Yeah, it binds the task during creation
> > as well as during unpark, but that should be ok (see below).
> > 
> > Somehow, I believe we can handle this issue without introducing that
> > whole TASK_PARKED thing..

We need it as Borislav showed.

Thread is created and parked. Now after online we unpark the thread,
but something else wakes it before we reach the unpark code and boom
it's on the wrong cpu. We want that PARKED thing for
robustness. Anything else is just voodoo programming.

Thanks,

	tglx
