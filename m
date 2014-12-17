Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaLQT2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:28:03 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56732 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaLQT2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:28:00 -0500
Date: Wed, 17 Dec 2014 11:27:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arun KS <arunks.linux@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        josh@joshtriplett.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, laijs@cn.fujitsu.com
Subject: Re: [RCU] kernel hangs in wait_rcu_gp during suspend path
Message-ID: <20141217192753.GS5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAKZGPAN6Ct_+FY1khP4AMSJ1RgP0zKdJ2pkczjhe-Q5HxTzsrw@mail.gmail.com>
 <CAKZGPAN7Vk2xpooZ2uFTiyWywT9yCCiW6bSAjRbT5fGs6fRYNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKZGPAN7Vk2xpooZ2uFTiyWywT9yCCiW6bSAjRbT5fGs6fRYNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121719-0013-0000-0000-00000727B25C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 11:59:07AM +0530, Arun KS wrote:
> Hello,
> 
> I dig little deeper to understand the situation.
> All other cpus are in idle thread already.
> As per my understanding, for the grace period to end, at-least one of
> the following should happen on all online cpus,
> 
> 1. a context switch.
> 2. user space switch.
> 3. switch to idle thread.

This is the case for rcu_sched, and the other flavors vary a bit.

> In this situation, since all the other cores are already in idle,  non
> of the above are meet on all online cores.
> So grace period is getting extended and never finishes. Below is the
> state of runqueue when the hang happens.
> --------------start------------------------------------
> crash> runq
> CPU 0 [OFFLINE]
> 
> CPU 1 [OFFLINE]
> 
> CPU 2 [OFFLINE]
> 
> CPU 3 [OFFLINE]
> 
> CPU 4 RUNQUEUE: c3192e40
>   CURRENT: PID: 0      TASK: f0874440  COMMAND: "swapper/4"
>   RT PRIO_ARRAY: c3192f20
>      [no tasks queued]
>   CFS RB_ROOT: c3192eb0
>      [no tasks queued]
> 
> CPU 5 RUNQUEUE: c31a0e40
>   CURRENT: PID: 0      TASK: f0874980  COMMAND: "swapper/5"
>   RT PRIO_ARRAY: c31a0f20
>      [no tasks queued]
>   CFS RB_ROOT: c31a0eb0
>      [no tasks queued]
> 
> CPU 6 RUNQUEUE: c31aee40
>   CURRENT: PID: 0      TASK: f0874ec0  COMMAND: "swapper/6"
>   RT PRIO_ARRAY: c31aef20
>      [no tasks queued]
>   CFS RB_ROOT: c31aeeb0
>      [no tasks queued]
> 
> CPU 7 RUNQUEUE: c31bce40
>   CURRENT: PID: 0      TASK: f0875400  COMMAND: "swapper/7"
>   RT PRIO_ARRAY: c31bcf20
>      [no tasks queued]
>   CFS RB_ROOT: c31bceb0
>      [no tasks queued]
> --------------end------------------------------------
> 
> If my understanding is correct the below patch should help, because it
> will expedite grace periods during suspend,
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d1d74d14e98a6be740a6f12456c7d9ad47be9c9c

I believe that we already covered this, but I do suggest that you give
it a try.

> But I wonder why it was not taken to stable trees. Can we take it?
> Appreciate your help.

I have no objection to your taking it, but have you tried it yet?

							Thanx, Paul

> Thanks,
> Arun
> 
> On Mon, Dec 15, 2014 at 10:34 PM, Arun KS <arunks.linux@gmail.com> wrote:
> > Hi,
> >
> > Here is the backtrace of the process hanging in wait_rcu_gp,
> >
> > PID: 247    TASK: e16e7380  CPU: 4   COMMAND: "kworker/u16:5"
> >  #0 [<c09fead0>] (__schedule) from [<c09fcab0>]
> >  #1 [<c09fcab0>] (schedule_timeout) from [<c09fe050>]
> >  #2 [<c09fe050>] (wait_for_common) from [<c013b2b4>]
> >  #3 [<c013b2b4>] (wait_rcu_gp) from [<c0142f50>]
> >  #4 [<c0142f50>] (atomic_notifier_chain_unregister) from [<c06b2ab8>]
> >  #5 [<c06b2ab8>] (cpufreq_interactive_disable_sched_input) from [<c06b32a8>]
> >  #6 [<c06b32a8>] (cpufreq_governor_interactive) from [<c06abbf8>]
> >  #7 [<c06abbf8>] (__cpufreq_governor) from [<c06ae474>]
> >  #8 [<c06ae474>] (__cpufreq_remove_dev_finish) from [<c06ae8c0>]
> >  #9 [<c06ae8c0>] (cpufreq_cpu_callback) from [<c0a0185c>]
> > #10 [<c0a0185c>] (notifier_call_chain) from [<c0121888>]
> > #11 [<c0121888>] (__cpu_notify) from [<c0121a04>]
> > #12 [<c0121a04>] (cpu_notify_nofail) from [<c09ee7f0>]
> > #13 [<c09ee7f0>] (_cpu_down) from [<c0121b70>]
> > #14 [<c0121b70>] (disable_nonboot_cpus) from [<c016788c>]
> > #15 [<c016788c>] (suspend_devices_and_enter) from [<c0167bcc>]
> > #16 [<c0167bcc>] (pm_suspend) from [<c0167d94>]
> > #17 [<c0167d94>] (try_to_suspend) from [<c0138460>]
> > #18 [<c0138460>] (process_one_work) from [<c0138b18>]
> > #19 [<c0138b18>] (worker_thread) from [<c013dc58>]
> > #20 [<c013dc58>] (kthread) from [<c01061b8>]
> >
> > Will this patch helps here,
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d1d74d14e98a6be740a6f12456c7d9ad47be9c9c
> >
> > I couldn't really understand why it got struck in  synchronize_rcu().
> > Please give some pointers to debug this further.
> >
> > Below are the configs enable related to RCU.
> >
> > CONFIG_TREE_PREEMPT_RCU=y
> > CONFIG_PREEMPT_RCU=y
> > CONFIG_RCU_STALL_COMMON=y
> > CONFIG_RCU_FANOUT=32
> > CONFIG_RCU_FANOUT_LEAF=16
> > CONFIG_RCU_FAST_NO_HZ=y
> > CONFIG_RCU_CPU_STALL_TIMEOUT=21
> > CONFIG_RCU_CPU_STALL_VERBOSE=y
> >
> > Kernel version is 3.10.28
> > Architecture is ARM
> >
> > Thanks,
> > Arun
> 

