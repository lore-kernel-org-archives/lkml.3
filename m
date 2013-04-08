Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935556Ab3DHMSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:18:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:35449 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935057Ab3DHMR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:17:59 -0400
Date: Mon, 8 Apr 2013 14:17:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, dhillf@gmail.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel BUG at kernel/smpboot.c:134!
In-Reply-To: <20130408115553.GA4395@pd.tnic>
Message-ID: <alpine.LFD.2.02.1304081415570.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos>
 <20130408115553.GA4395@pd.tnic>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Apr 2013, Borislav Petkov wrote:
> On Mon, Apr 08, 2013 at 11:24:14AM +0200, Thomas Gleixner wrote:
> > +	/* Rebind ourself to the target cpu */
> > +	if (test_bit(KTHREAD_IS_PER_CPU, &self->flags)) {
> > +		set_cpus_allowed_ptr(currrent, cpumask_of(self->cpu));
> 
> "currrent" is a typo, I fixed it up to the obvious "current" so that it
> builds.

Bah.
 
> [    1.640000] WARNING: at kernel/sched/core.c:963 set_task_cpu+0x12c/0x280()
> [    1.640000] Hardware name: Bochs
> [    1.640000] Modules linked in:
> [    1.640000] Pid: 8, comm: migration/0 Not tainted 3.9.0-rc5+ #5

Hmm, crap migration thread trying to migrate itself via stomp
machine. Not really a brilliant idea.

/me goes back to drawing board.

> [    1.640000] Call Trace:
> [    1.640000]  [<c1035633>] warn_slowpath_common+0x73/0xb0
> [    1.640000]  [<c106a6cc>] ? set_task_cpu+0x12c/0x280
> [    1.640000]  [<c106a6cc>] ? set_task_cpu+0x12c/0x280
> [    1.640000]  [<c1035693>] warn_slowpath_null+0x23/0x30
> [    1.640000]  [<c106a6cc>] set_task_cpu+0x12c/0x280
> [    1.640000]  [<c1068e2b>] ? update_rq_clock+0x3b/0x70
> [    1.640000]  [<c1068ee1>] ? dequeue_task+0x81/0xc0
> [    1.640000]  [<c106a922>] __migrate_task+0x102/0x140
> [    1.640000]  [<c106a960>] ? __migrate_task+0x140/0x140
> [    1.640000]  [<c106a982>] migration_cpu_stop+0x22/0x30
> [    1.640000]  [<c10a0a88>] cpu_stopper_thread+0x68/0x130
> [    1.640000]  [<c106ea11>] ? sched_clock_cpu+0xf1/0x180
> [    1.640000]  [<c106a20d>] ? sub_preempt_count+0x4d/0xb0
> [    1.640000]  [<c106eaee>] ? local_clock+0x4e/0x60
> [    1.640000]  [<c108cf4a>] ? trace_hardirqs_off_caller+0x1a/0x110
> [    1.640000]  [<c108d22d>] ? put_lock_stats.isra.17+0xd/0x30
> [    1.640000]  [<c1512b25>] ? _raw_spin_unlock_irqrestore+0x55/0x70
> [    1.640000]  [<c1512b0b>] ? _raw_spin_unlock_irqrestore+0x3b/0x70
> [    1.640000]  [<c1063f06>] smpboot_thread_fn+0x176/0x260
> [    1.640000]  [<c1063d90>] ? lg_lock_init+0x20/0x20
> [    1.640000]  [<c105b305>] kthread+0x95/0xa0
> [    1.640000]  [<c1510303>] ? schedule_hrtimeout_range_clock+0x163/0x170
> [    1.640000]  [<c151077f>] ? wait_for_common+0xcf/0x110
> [    1.640000]  [<c1060000>] ? hrtimer_run_pending+0x110/0x110
> [    1.640000]  [<c15137b7>] ret_from_kernel_thread+0x1b/0x28
> [    1.640000]  [<c105b270>] ? __kthread_parkme+0xa0/0xa0
