Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaLRUFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 15:05:17 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:48592 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaLRUFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 15:05:15 -0500
Date: Thu, 18 Dec 2014 12:05:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arun KS <arunks.linux@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        josh@joshtriplett.org, rostedt@goodmis.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        laijs@cn.fujitsu.com, Arun KS <getarunks@gmail.com>
Subject: Re: [RCU] kernel hangs in wait_rcu_gp during suspend path
Message-ID: <20141218200506.GL11609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAKZGPAN6Ct_+FY1khP4AMSJ1RgP0zKdJ2pkczjhe-Q5HxTzsrw@mail.gmail.com>
 <CAKZGPAN7Vk2xpooZ2uFTiyWywT9yCCiW6bSAjRbT5fGs6fRYNw@mail.gmail.com>
 <CAKZGPAND7TPZKbTqG-zL_Vx=E_k3kio=onwppTJqVcVSmjOR6w@mail.gmail.com>
 <20141217192448.GR5310@linux.vnet.ibm.com>
 <CAKZGPAPNpci1UriB=vtT3OHcVQnMNtwi7qbT+d_Uqvp+A_xENw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKZGPAPNpci1UriB=vtT3OHcVQnMNtwi7qbT+d_Uqvp+A_xENw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121820-0017-0000-0000-0000073CBDBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 09:52:28PM +0530, Arun KS wrote:
> Hi Paul,
> 
> On Thu, Dec 18, 2014 at 12:54 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, Dec 16, 2014 at 11:00:20PM +0530, Arun KS wrote:
> >> Hello,
> >>
> >> Adding some more info.
> >>
> >> Below is the rcu_data data structure corresponding to cpu4.
> >
> > This shows that RCU is idle.  What was the state of the system at the
> > time you collected this data?
> 
> System initiated a suspend sequence and currently at disable_nonboot_cpus().
> It has hotplugged 0, 1 and 2 successfully.  And even successful in hot
> plugging cpu3.
> But while calling the CPU_POST_DEAD notifier for cpu3, another driver tried to
> unregister an atomic notifier. Which eventually calls syncronize_rcu()
> which hangs the suspend task.
> 
> bt as follows,
> PID: 202    TASK: edcd2a00  CPU: 4   COMMAND: "kworker/u16:4"
>  #0 [<c0a1f8c0>] (__schedule) from [<c0a1d054>]
>  #1 [<c0a1d054>] (schedule_timeout) from [<c0a1f018>]
>  #2 [<c0a1f018>] (wait_for_common) from [<c013c570>]
>  #3 [<c013c570>] (wait_rcu_gp) from [<c014407c>]
>  #4 [<c014407c>] (atomic_notifier_chain_unregister) from [<c06be62c>]
>  #5 [<c06be62c>] (cpufreq_interactive_disable_sched_input) from [<c06bee1c>]
>  #6 [<c06bee1c>] (cpufreq_governor_interactive) from [<c06b7724>]
>  #7 [<c06b7724>] (__cpufreq_governor) from [<c06b9f74>]
>  #8 [<c06b9f74>] (__cpufreq_remove_dev_finish) from [<c06ba3a4>]
>  #9 [<c06ba3a4>] (cpufreq_cpu_callback) from [<c0a22674>]
> #10 [<c0a22674>] (notifier_call_chain) from [<c012284c>]
> #11 [<c012284c>] (__cpu_notify) from [<c01229dc>]
> #12 [<c01229dc>] (cpu_notify_nofail) from [<c0a0dd1c>]
> #13 [<c0a0dd1c>] (_cpu_down) from [<c0122b48>]
> #14 [<c0122b48>] (disable_nonboot_cpus) from [<c0168cd8>]
> #15 [<c0168cd8>] (suspend_devices_and_enter) from [<c0169018>]
> #16 [<c0169018>] (pm_suspend) from [<c01691e0>]
> #17 [<c01691e0>] (try_to_suspend) from [<c01396f0>]
> #18 [<c01396f0>] (process_one_work) from [<c0139db0>]
> #19 [<c0139db0>] (worker_thread) from [<c013efa4>]
> #20 [<c013efa4>] (kthread) from [<c01061f8>]
> 
> But the other cores 4-7 are active. I can see them going to idle tasks
> coming out from idle because of interrupts, scheduling kworkers etc.
> So when I took the data, all the online cores(4-7) were in idle as
> shown below from runq data structures.
> 
> ------start--------------
> crash> runq
> CPU 0 [OFFLINE]
> 
> CPU 1 [OFFLINE]
> 
> CPU 2 [OFFLINE]
> 
> CPU 3 [OFFLINE]
> 
> CPU 4 RUNQUEUE: c5439040
>   CURRENT: PID: 0      TASK: f0c9d400  COMMAND: "swapper/4"
>   RT PRIO_ARRAY: c5439130
>      [no tasks queued]
>   CFS RB_ROOT: c54390c0
>      [no tasks queued]
> 
> CPU 5 RUNQUEUE: c5447040
>   CURRENT: PID: 0      TASK: f0c9aa00  COMMAND: "swapper/5"
>   RT PRIO_ARRAY: c5447130
>      [no tasks queued]
>   CFS RB_ROOT: c54470c0
>      [no tasks queued]
> 
> CPU 6 RUNQUEUE: c5455040
>   CURRENT: PID: 0      TASK: f0c9ce00  COMMAND: "swapper/6"
>   RT PRIO_ARRAY: c5455130
>      [no tasks queued]
>   CFS RB_ROOT: c54550c0
>      [no tasks queued]
> 
> CPU 7 RUNQUEUE: c5463040
>   CURRENT: PID: 0      TASK: f0c9b000  COMMAND: "swapper/7"
>   RT PRIO_ARRAY: c5463130
>      [no tasks queued]
>   CFS RB_ROOT: c54630c0
>      [no tasks queued]
> ------end--------------
> 
> but one strange thing i can see is that rcu_read_lock_nesting for idle
> tasks running on cpu 5 and cpu 6 are set to 1.
> 
> PID: 0      TASK: f0c9d400  CPU: 4   COMMAND: "swapper/4"
>   rcu_read_lock_nesting = 0,
> 
> PID: 0      TASK: f0c9aa00  CPU: 5   COMMAND: "swapper/5"
>   rcu_read_lock_nesting = 1,
> 
> PID: 0      TASK: f0c9ce00  CPU: 6   COMMAND: "swapper/6"
>   rcu_read_lock_nesting = 1,
> 
> PID: 0      TASK: f0c9b000  CPU: 7   COMMAND: "swapper/7"
>   rcu_read_lock_nesting = 0,
> 
> Does this means that the current grace period(suspend thread is
> waiting on) is getting extended infinitely?

Indeed it does, good catch!  Looks like someone entered an RCU read-side
critical section, then forgot to exit it, which would prevent grace
periods from ever completing.  CONFIG_PROVE_RCU=y might be
helpful in tracking this down.

> Also attaching the per_cpu rcu_data for online and offline cores.

But these still look like there is no grace period in progress.

Still, it would be good to try CONFIG_PROVE_RCU=y and see what it
shows you.

Also, I am not seeing similar complaints about 3.10, so it is quite
possible that a recent change in the ARM-specific idle-loop code is
doing this to you.  It might be well worth looking through recent
changes in this area, particularly if some older version works well
for you.

							Thanx, Paul

> Thanks,
> Arun
> 
> >
> >                                                         Thanx, Paul
> >
> >> struct rcu_data {
> >>   completed = 5877,
> >>   gpnum = 5877,
> >>   passed_quiesce = true,
> >>   qs_pending = false,
> >>   beenonline = true,
> >>   preemptible = true,
> >>   mynode = 0xc117f340 <rcu_preempt_state>,
> >>   grpmask = 16,
> >>   nxtlist = 0xedaaec00,
> >>   nxttail = {0xc54366c4, 0xe84d350c, 0xe84d350c, 0xe84d350c},
> >>   nxtcompleted = {4294967035, 5878, 5878, 5878},
> >>   qlen_lazy = 105,
> >>   qlen = 415,
> >>   qlen_last_fqs_check = 0,
> >>   n_cbs_invoked = 86323,
> >>   n_nocbs_invoked = 0,
> >>   n_cbs_orphaned = 0,
> >>   n_cbs_adopted = 139,
> >>   n_force_qs_snap = 0,
> >>   blimit = 10,
> >>   dynticks = 0xc5436758,
> >>   dynticks_snap = 7582140,
> >>   dynticks_fqs = 41,
> >>   offline_fqs = 0,
> >>   n_rcu_pending = 59404,
> >>   n_rp_qs_pending = 5,
> >>   n_rp_report_qs = 4633,
> >>   n_rp_cb_ready = 32,
> >>   n_rp_cpu_needs_gp = 41088,
> >>   n_rp_gp_completed = 2844,
> >>   n_rp_gp_started = 1150,
> >>   n_rp_need_nothing = 9657,
> >>   barrier_head = {
> >>     next = 0x0,
> >>     func = 0x0
> >>   },
> >>   oom_head = {
> >>     next = 0x0,
> >>     func = 0x0
> >>   },
> >>   cpu = 4,
> >>   rsp = 0xc117f340 <rcu_preempt_state>
> >> }
> >>
> >>
> >>
> >> Also pasting complete rcu_preempt_state.
> >>
> >>
> >>
> >> rcu_preempt_state = $9 = {
> >>   node = {{
> >>       lock = {
> >>         raw_lock = {
> >>           {
> >>             slock = 3129850509,
> >>             tickets = {
> >>               owner = 47757,
> >>               next = 47757
> >>             }
> >>           }
> >>         },
> >>         magic = 3735899821,
> >>         owner_cpu = 4294967295,
> >>         owner = 0xffffffff
> >>       },
> >>       gpnum = 5877,
> >>       completed = 5877,
> >>       qsmask = 0,
> >>       expmask = 0,
> >>       qsmaskinit = 240,
> >>       grpmask = 0,
> >>       grplo = 0,
> >>       grphi = 7,
> >>       grpnum = 0 '\000',
> >>       level = 0 '\000',
> >>       parent = 0x0,
> >>       blkd_tasks = {
> >>         next = 0xc117f378 <rcu_preempt_state+56>,
> >>         prev = 0xc117f378 <rcu_preempt_state+56>
> >>       },
> >>       gp_tasks = 0x0,
> >>       exp_tasks = 0x0,
> >>       need_future_gp = {1, 0},
> >>       fqslock = {
> >>         raw_lock = {
> >>           {
> >>             slock = 0,
> >>             tickets = {
> >>               owner = 0,
> >>               next = 0
> >>             }
> >>           }
> >>         },
> >>         magic = 3735899821,
> >>         owner_cpu = 4294967295,
> >>         owner = 0xffffffff
> >>       }
> >>     }},
> >>   level = {0xc117f340 <rcu_preempt_state>},
> >>   levelcnt = {1, 0, 0, 0, 0},
> >>   levelspread = "\b",
> >>   rda = 0xc115e6b0 <rcu_preempt_data>,
> >>   call = 0xc01975ac <call_rcu>,
> >>   fqs_state = 0 '\000',
> >>   boost = 0 '\000',
> >>   gpnum = 5877,
> >>   completed = 5877,
> >>   gp_kthread = 0xf0c9e600,
> >>   gp_wq = {
> >>     lock = {
> >>       {
> >>         rlock = {
> >>           raw_lock = {
> >>             {
> >>               slock = 2160230594,
> >>               tickets = {
> >>                 owner = 32962,
> >>                 next = 32962
> >>               }
> >>             }
> >>           },
> >>           magic = 3735899821,
> >>           owner_cpu = 4294967295,
> >>           owner = 0xffffffff
> >>         }
> >>       }
> >>     },
> >>     task_list = {
> >>       next = 0xf0cd1f20,
> >>       prev = 0xf0cd1f20
> >>     }
> >>   },
> >>   gp_flags = 1,
> >>   orphan_lock = {
> >>     raw_lock = {
> >>       {
> >>         slock = 327685,
> >>         tickets = {
> >>           owner = 5,
> >>           next = 5
> >>         }
> >>       }
> >>     },
> >>     magic = 3735899821,
> >>     owner_cpu = 4294967295,
> >>     owner = 0xffffffff
> >>   },
> >>   orphan_nxtlist = 0x0,
> >>   orphan_nxttail = 0xc117f490 <rcu_preempt_state+336>,
> >>   orphan_donelist = 0x0,
> >>   orphan_donetail = 0xc117f498 <rcu_preempt_state+344>,
> >>   qlen_lazy = 0,
> >>   qlen = 0,
> >>   onoff_mutex = {
> >>     count = {
> >>       counter = 1
> >>     },
> >>     wait_lock = {
> >>       {
> >>         rlock = {
> >>           raw_lock = {
> >>             {
> >>               slock = 811479134,
> >>               tickets = {
> >>                 owner = 12382,
> >>                 next = 12382
> >>               }
> >>             }
> >>           },
> >>           magic = 3735899821,
> >>           owner_cpu = 4294967295,
> >>           owner = 0xffffffff
> >>         }
> >>       }
> >>     },
> >>     wait_list = {
> >>       next = 0xc117f4bc <rcu_preempt_state+380>,
> >>       prev = 0xc117f4bc <rcu_preempt_state+380>
> >>     },
> >>     owner = 0x0,
> >>     name = 0x0,
> >>     magic = 0xc117f4a8 <rcu_preempt_state+360>
> >>   },
> >>   barrier_mutex = {
> >>     count = {
> >>       counter = 1
> >>     },
> >>     wait_lock = {
> >>       {
> >>         rlock = {
> >>           raw_lock = {
> >>             {
> >>               slock = 0,
> >>               tickets = {
> >>                 owner = 0,
> >>                 next = 0
> >>               }
> >>             }
> >>           },
> >>           magic = 3735899821,
> >>           owner_cpu = 4294967295,
> >>           owner = 0xffffffff
> >>         }
> >>       }
> >>     },
> >>     wait_list = {
> >>       next = 0xc117f4e4 <rcu_preempt_state+420>,
> >>       prev = 0xc117f4e4 <rcu_preempt_state+420>
> >>     },
> >>     owner = 0x0,
> >>     name = 0x0,
> >>     magic = 0xc117f4d0 <rcu_preempt_state+400>
> >>   },
> >>   barrier_cpu_count = {
> >>     counter = 0
> >>   },
> >>   barrier_completion = {
> >>     done = 0,
> >>     wait = {
> >>       lock = {
> >>         {
> >>           rlock = {
> >>             raw_lock = {
> >>               {
> >>                 slock = 0,
> >>                 tickets = {
> >>                   owner = 0,
> >>                   next = 0
> >>                 }
> >>               }
> >>             },
> >>             magic = 0,
> >>             owner_cpu = 0,
> >>             owner = 0x0
> >>           }
> >>         }
> >>       },
> >>       task_list = {
> >>         next = 0x0,
> >>         prev = 0x0
> >>       }
> >>     }
> >>   },
> >>   n_barrier_done = 0,
> >>   expedited_start = {
> >>     counter = 0
> >>   },
> >>   expedited_done = {
> >>     counter = 0
> >>   },
> >>   expedited_wrap = {
> >>     counter = 0
> >>   },
> >>   expedited_tryfail = {
> >>     counter = 0
> >>   },
> >>   expedited_workdone1 = {
> >>     counter = 0
> >>   },
> >>   expedited_workdone2 = {
> >>     counter = 0
> >>   },
> >>   expedited_normal = {
> >>     counter = 0
> >>   },
> >>   expedited_stoppedcpus = {
> >>     counter = 0
> >>   },
> >>   expedited_done_tries = {
> >>     counter = 0
> >>   },
> >>   expedited_done_lost = {
> >>     counter = 0
> >>   },
> >>   expedited_done_exit = {
> >>     counter = 0
> >>   },
> >>   jiffies_force_qs = 4294963917,
> >>   n_force_qs = 4028,
> >>   n_force_qs_lh = 0,
> >>   n_force_qs_ngp = 0,
> >>   gp_start = 4294963911,
> >>   jiffies_stall = 4294966011,
> >>   gp_max = 17,
> >>   name = 0xc0d833ab "rcu_preempt",
> >>   abbr = 112 'p',
> >>   flavors = {
> >>     next = 0xc117f2ec <rcu_bh_state+556>,
> >>     prev = 0xc117f300 <rcu_struct_flavors>
> >>   },
> >>   wakeup_work = {
> >>     flags = 3,
> >>     llnode = {
> >>       next = 0x0
> >>     },
> >>     func = 0xc0195aa8 <rsp_wakeup>
> >>   }
> >> }
> >>
> >> Hope this helps.
> >>
> >> Thanks,
> >> Arun
> >>
> >>
> >> On Tue, Dec 16, 2014 at 11:59 AM, Arun KS <arunks.linux@gmail.com> wrote:
> >> > Hello,
> >> >
> >> > I dig little deeper to understand the situation.
> >> > All other cpus are in idle thread already.
> >> > As per my understanding, for the grace period to end, at-least one of
> >> > the following should happen on all online cpus,
> >> >
> >> > 1. a context switch.
> >> > 2. user space switch.
> >> > 3. switch to idle thread.
> >> >
> >> > In this situation, since all the other cores are already in idle,  non
> >> > of the above are meet on all online cores.
> >> > So grace period is getting extended and never finishes. Below is the
> >> > state of runqueue when the hang happens.
> >> > --------------start------------------------------------
> >> > crash> runq
> >> > CPU 0 [OFFLINE]
> >> >
> >> > CPU 1 [OFFLINE]
> >> >
> >> > CPU 2 [OFFLINE]
> >> >
> >> > CPU 3 [OFFLINE]
> >> >
> >> > CPU 4 RUNQUEUE: c3192e40
> >> >   CURRENT: PID: 0      TASK: f0874440  COMMAND: "swapper/4"
> >> >   RT PRIO_ARRAY: c3192f20
> >> >      [no tasks queued]
> >> >   CFS RB_ROOT: c3192eb0
> >> >      [no tasks queued]
> >> >
> >> > CPU 5 RUNQUEUE: c31a0e40
> >> >   CURRENT: PID: 0      TASK: f0874980  COMMAND: "swapper/5"
> >> >   RT PRIO_ARRAY: c31a0f20
> >> >      [no tasks queued]
> >> >   CFS RB_ROOT: c31a0eb0
> >> >      [no tasks queued]
> >> >
> >> > CPU 6 RUNQUEUE: c31aee40
> >> >   CURRENT: PID: 0      TASK: f0874ec0  COMMAND: "swapper/6"
> >> >   RT PRIO_ARRAY: c31aef20
> >> >      [no tasks queued]
> >> >   CFS RB_ROOT: c31aeeb0
> >> >      [no tasks queued]
> >> >
> >> > CPU 7 RUNQUEUE: c31bce40
> >> >   CURRENT: PID: 0      TASK: f0875400  COMMAND: "swapper/7"
> >> >   RT PRIO_ARRAY: c31bcf20
> >> >      [no tasks queued]
> >> >   CFS RB_ROOT: c31bceb0
> >> >      [no tasks queued]
> >> > --------------end------------------------------------
> >> >
> >> > If my understanding is correct the below patch should help, because it
> >> > will expedite grace periods during suspend,
> >> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d1d74d14e98a6be740a6f12456c7d9ad47be9c9c
> >> >
> >> > But I wonder why it was not taken to stable trees. Can we take it?
> >> > Appreciate your help.
> >> >
> >> > Thanks,
> >> > Arun
> >> >
> >> > On Mon, Dec 15, 2014 at 10:34 PM, Arun KS <arunks.linux@gmail.com> wrote:
> >> >> Hi,
> >> >>
> >> >> Here is the backtrace of the process hanging in wait_rcu_gp,
> >> >>
> >> >> PID: 247    TASK: e16e7380  CPU: 4   COMMAND: "kworker/u16:5"
> >> >>  #0 [<c09fead0>] (__schedule) from [<c09fcab0>]
> >> >>  #1 [<c09fcab0>] (schedule_timeout) from [<c09fe050>]
> >> >>  #2 [<c09fe050>] (wait_for_common) from [<c013b2b4>]
> >> >>  #3 [<c013b2b4>] (wait_rcu_gp) from [<c0142f50>]
> >> >>  #4 [<c0142f50>] (atomic_notifier_chain_unregister) from [<c06b2ab8>]
> >> >>  #5 [<c06b2ab8>] (cpufreq_interactive_disable_sched_input) from [<c06b32a8>]
> >> >>  #6 [<c06b32a8>] (cpufreq_governor_interactive) from [<c06abbf8>]
> >> >>  #7 [<c06abbf8>] (__cpufreq_governor) from [<c06ae474>]
> >> >>  #8 [<c06ae474>] (__cpufreq_remove_dev_finish) from [<c06ae8c0>]
> >> >>  #9 [<c06ae8c0>] (cpufreq_cpu_callback) from [<c0a0185c>]
> >> >> #10 [<c0a0185c>] (notifier_call_chain) from [<c0121888>]
> >> >> #11 [<c0121888>] (__cpu_notify) from [<c0121a04>]
> >> >> #12 [<c0121a04>] (cpu_notify_nofail) from [<c09ee7f0>]
> >> >> #13 [<c09ee7f0>] (_cpu_down) from [<c0121b70>]
> >> >> #14 [<c0121b70>] (disable_nonboot_cpus) from [<c016788c>]
> >> >> #15 [<c016788c>] (suspend_devices_and_enter) from [<c0167bcc>]
> >> >> #16 [<c0167bcc>] (pm_suspend) from [<c0167d94>]
> >> >> #17 [<c0167d94>] (try_to_suspend) from [<c0138460>]
> >> >> #18 [<c0138460>] (process_one_work) from [<c0138b18>]
> >> >> #19 [<c0138b18>] (worker_thread) from [<c013dc58>]
> >> >> #20 [<c013dc58>] (kthread) from [<c01061b8>]
> >> >>
> >> >> Will this patch helps here,
> >> >> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d1d74d14e98a6be740a6f12456c7d9ad47be9c9c
> >> >>
> >> >> I couldn't really understand why it got struck in  synchronize_rcu().
> >> >> Please give some pointers to debug this further.
> >> >>
> >> >> Below are the configs enable related to RCU.
> >> >>
> >> >> CONFIG_TREE_PREEMPT_RCU=y
> >> >> CONFIG_PREEMPT_RCU=y
> >> >> CONFIG_RCU_STALL_COMMON=y
> >> >> CONFIG_RCU_FANOUT=32
> >> >> CONFIG_RCU_FANOUT_LEAF=16
> >> >> CONFIG_RCU_FAST_NO_HZ=y
> >> >> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> >> >> CONFIG_RCU_CPU_STALL_VERBOSE=y
> >> >>
> >> >> Kernel version is 3.10.28
> >> >> Architecture is ARM
> >> >>
> >> >> Thanks,
> >> >> Arun
> >>
> >

> crash> struct rcu_data C54286B0
> struct rcu_data {
>   completed = 2833,
>   gpnum = 2833,
>   passed_quiesce = false,
>   qs_pending = false,
>   beenonline = true,
>   preemptible = true,
>   mynode = 0xc117f340 <rcu_preempt_state>,
>   grpmask = 8,
>   nxtlist = 0x0,
>   nxttail = {0xc54286c4, 0xc54286c4, 0xc54286c4, 0x0},
>   nxtcompleted = {0, 4294967136, 4294967137, 4294967137},
>   qlen_lazy = 0,
>   qlen = 0,
>   qlen_last_fqs_check = 0,
>   n_cbs_invoked = 609,
>   n_nocbs_invoked = 0,
>   n_cbs_orphaned = 13,
>   n_cbs_adopted = 0,
>   n_force_qs_snap = 1428,
>   blimit = 10,
>   dynticks = 0xc5428758,
>   dynticks_snap = 13206053,
>   dynticks_fqs = 16,
>   offline_fqs = 0,
>   n_rcu_pending = 181,
>   n_rp_qs_pending = 1,
>   n_rp_report_qs = 21,
>   n_rp_cb_ready = 0,
>   n_rp_cpu_needs_gp = 0,
>   n_rp_gp_completed = 22,
>   n_rp_gp_started = 8,
>   n_rp_need_nothing = 130,
>   barrier_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   oom_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   cpu = 3,
>   rsp = 0xc117f340 <rcu_preempt_state>
> }
> 
> crash> struct rcu_data C541A6B0
> struct rcu_data {
>   completed = 5877,
>   gpnum = 5877,
>   passed_quiesce = true,
>   qs_pending = false,
>   beenonline = true,
>   preemptible = true,
>   mynode = 0xc117f340 <rcu_preempt_state>,
>   grpmask = 4,
>   nxtlist = 0x0,
>   nxttail = {0xc541a6c4, 0xc541a6c4, 0xc541a6c4, 0x0},
>   nxtcompleted = {0, 5877, 5878, 5878},
>   qlen_lazy = 0,
>   qlen = 0,
>   qlen_last_fqs_check = 0,
>   n_cbs_invoked = 61565,
>   n_nocbs_invoked = 0,
>   n_cbs_orphaned = 139,
>   n_cbs_adopted = 100,
>   n_force_qs_snap = 0,
>   blimit = 10,
>   dynticks = 0xc541a758,
>   dynticks_snap = 13901017,
>   dynticks_fqs = 75,
>   offline_fqs = 0,
>   n_rcu_pending = 16546,
>   n_rp_qs_pending = 3,
>   n_rp_report_qs = 4539,
>   n_rp_cb_ready = 69,
>   n_rp_cpu_needs_gp = 782,
>   n_rp_gp_completed = 4196,
>   n_rp_gp_started = 1739,
>   n_rp_need_nothing = 5221,
>   barrier_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   oom_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   cpu = 2,
>   rsp = 0xc117f340 <rcu_preempt_state>
> }
> 
> crash> struct rcu_data C540C6B0
> struct rcu_data {
>   completed = 5877,
>   gpnum = 5877,
>   passed_quiesce = true,
>   qs_pending = false,
>   beenonline = true,
>   preemptible = true,
>   mynode = 0xc117f340 <rcu_preempt_state>,
>   grpmask = 2,
>   nxtlist = 0x0,
>   nxttail = {0xc540c6c4, 0xc540c6c4, 0xc540c6c4, 0x0},
>   nxtcompleted = {4294967030, 5878, 5878, 5878},
>   qlen_lazy = 0,
>   qlen = 0,
>   qlen_last_fqs_check = 0,
>   n_cbs_invoked = 74292,
>   n_nocbs_invoked = 0,
>   n_cbs_orphaned = 100,
>   n_cbs_adopted = 65,
>   n_force_qs_snap = 0,
>   blimit = 10,
>   dynticks = 0xc540c758,
>   dynticks_snap = 10753433,
>   dynticks_fqs = 69,
>   offline_fqs = 0,
>   n_rcu_pending = 18350,
>   n_rp_qs_pending = 6,
>   n_rp_report_qs = 5009,
>   n_rp_cb_ready = 50,
>   n_rp_cpu_needs_gp = 915,
>   n_rp_gp_completed = 4423,
>   n_rp_gp_started = 1826,
>   n_rp_need_nothing = 6127,
>   barrier_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   oom_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   cpu = 1,
>   rsp = 0xc117f340 <rcu_preempt_state>
> }
> crash> struct rcu_data C53FE6B0
> struct rcu_data {
>   completed = 5877,
>   gpnum = 5877,
>   passed_quiesce = true,
>   qs_pending = false,
>   beenonline = true,
>   preemptible = true,
>   mynode = 0xc117f340 <rcu_preempt_state>,
>   grpmask = 1,
>   nxtlist = 0x0,
>   nxttail = {0xc53fe6c4, 0xc53fe6c4, 0xc53fe6c4, 0x0},
>   nxtcompleted = {4294966997, 5875, 5876, 5876},
>   qlen_lazy = 0,
>   qlen = 0,
>   qlen_last_fqs_check = 0,
>   n_cbs_invoked = 123175,
>   n_nocbs_invoked = 0,
>   n_cbs_orphaned = 52,
>   n_cbs_adopted = 0,
>   n_force_qs_snap = 0,
>   blimit = 10,
>   dynticks = 0xc53fe758,
>   dynticks_snap = 6330446,
>   dynticks_fqs = 46,
>   offline_fqs = 0,
>   n_rcu_pending = 22529,
>   n_rp_qs_pending = 3,
>   n_rp_report_qs = 5290,
>   n_rp_cb_ready = 279,
>   n_rp_cpu_needs_gp = 740,
>   n_rp_gp_completed = 2707,
>   n_rp_gp_started = 1208,
>   n_rp_need_nothing = 12305,
>   barrier_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   oom_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   cpu = 0,
>   rsp = 0xc117f340 <rcu_preempt_state>
> }
> 

> crash> struct rcu_data c54366b0
> struct rcu_data {
>   completed = 5877,
>   gpnum = 5877,
>   passed_quiesce = true,
>   qs_pending = false,
>   beenonline = true,
>   preemptible = true,
>   mynode = 0xc117f340 <rcu_preempt_state>,
>   grpmask = 16,
>   nxtlist = 0xedaaec00,
>   nxttail = {0xc54366c4, 0xe84d350c, 0xe84d350c, 0xe84d350c},
>   nxtcompleted = {4294967035, 5878, 5878, 5878},
>   qlen_lazy = 105,
>   qlen = 415,
>   qlen_last_fqs_check = 0,
>   n_cbs_invoked = 86323,
>   n_nocbs_invoked = 0,
>   n_cbs_orphaned = 0,
>   n_cbs_adopted = 139,
>   n_force_qs_snap = 0,
>   blimit = 10,
>   dynticks = 0xc5436758,
>   dynticks_snap = 7582140,
>   dynticks_fqs = 41,
>   offline_fqs = 0,
>   n_rcu_pending = 59404,
>   n_rp_qs_pending = 5,
>   n_rp_report_qs = 4633,
>   n_rp_cb_ready = 32,
>   n_rp_cpu_needs_gp = 41088,
>   n_rp_gp_completed = 2844,
>   n_rp_gp_started = 1150,
>   n_rp_need_nothing = 9657,
>   barrier_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   oom_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   cpu = 4,
>   rsp = 0xc117f340 <rcu_preempt_state>
> }
> 
> crash> struct rcu_data c54446b0
> struct rcu_data {
>   completed = 5877,
>   gpnum = 5877,
>   passed_quiesce = true,
>   qs_pending = false,
>   beenonline = true,
>   preemptible = true,
>   mynode = 0xc117f340 <rcu_preempt_state>,
>   grpmask = 32,
>   nxtlist = 0xcf9e856c,
>   nxttail = {0xc54446c4, 0xcfb3050c, 0xcfb3050c, 0xcfb3050c},
>   nxtcompleted = {0, 5878, 5878, 5878},
>   qlen_lazy = 0,
>   qlen = 117,
>   qlen_last_fqs_check = 0,
>   n_cbs_invoked = 36951,
>   n_nocbs_invoked = 0,
>   n_cbs_orphaned = 0,
>   n_cbs_adopted = 0,
>   n_force_qs_snap = 1428,
>   blimit = 10,
>   dynticks = 0xc5444758,
>   dynticks_snap = 86034,
>   dynticks_fqs = 46,
>   offline_fqs = 0,
>   n_rcu_pending = 49104,
>   n_rp_qs_pending = 3,
>   n_rp_report_qs = 2360,
>   n_rp_cb_ready = 18,
>   n_rp_cpu_needs_gp = 40106,
>   n_rp_gp_completed = 1334,
>   n_rp_gp_started = 791,
>   n_rp_need_nothing = 4495,
>   barrier_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   oom_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   cpu = 5,
>   rsp = 0xc117f340 <rcu_preempt_state>
> }
> 
> crash> struct rcu_data c54526b0
> struct rcu_data {
>   completed = 5877,
>   gpnum = 5877,
>   passed_quiesce = true,
>   qs_pending = false,
>   beenonline = true,
>   preemptible = true,
>   mynode = 0xc117f340 <rcu_preempt_state>,
>   grpmask = 64,
>   nxtlist = 0xe613d200,
>   nxttail = {0xc54526c4, 0xe6fc9d0c, 0xe6fc9d0c, 0xe6fc9d0c},
>   nxtcompleted = {0, 5878, 5878, 5878},
>   qlen_lazy = 2,
>   qlen = 35,
>   qlen_last_fqs_check = 0,
>   n_cbs_invoked = 34459,
>   n_nocbs_invoked = 0,
>   n_cbs_orphaned = 0,
>   n_cbs_adopted = 0,
>   n_force_qs_snap = 1428,
>   blimit = 10,
>   dynticks = 0xc5452758,
>   dynticks_snap = 116840,
>   dynticks_fqs = 47,
>   offline_fqs = 0,
>   n_rcu_pending = 48486,
>   n_rp_qs_pending = 3,
>   n_rp_report_qs = 2223,
>   n_rp_cb_ready = 24,
>   n_rp_cpu_needs_gp = 40101,
>   n_rp_gp_completed = 1226,
>   n_rp_gp_started = 789,
>   n_rp_need_nothing = 4123,
>   barrier_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   oom_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   cpu = 6,
>   rsp = 0xc117f340 <rcu_preempt_state>
> }
> 
> crash> struct rcu_data c54606b0
> struct rcu_data {
>   completed = 5877,
>   gpnum = 5877,
>   passed_quiesce = true,
>   qs_pending = false,
>   beenonline = true,
>   preemptible = true,
>   mynode = 0xc117f340 <rcu_preempt_state>,
>   grpmask = 128,
>   nxtlist = 0xdec32a6c,
>   nxttail = {0xc54606c4, 0xe6fcf10c, 0xe6fcf10c, 0xe6fcf10c},
>   nxtcompleted = {0, 5878, 5878, 5878},
>   qlen_lazy = 1,
>   qlen = 30,
>   qlen_last_fqs_check = 0,
>   n_cbs_invoked = 31998,
>   n_nocbs_invoked = 0,
>   n_cbs_orphaned = 0,
>   n_cbs_adopted = 0,
>   n_force_qs_snap = 1428,
>   blimit = 10,
>   dynticks = 0xc5460758,
>   dynticks_snap = 57846,
>   dynticks_fqs = 54,
>   offline_fqs = 0,
>   n_rcu_pending = 47502,
>   n_rp_qs_pending = 2,
>   n_rp_report_qs = 2142,
>   n_rp_cb_ready = 37,
>   n_rp_cpu_needs_gp = 40049,
>   n_rp_gp_completed = 1223,
>   n_rp_gp_started = 661,
>   n_rp_need_nothing = 3390,
>   barrier_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   oom_head = {
>     next = 0x0,
>     func = 0x0
>   },
>   cpu = 7,
>   rsp = 0xc117f340 <rcu_preempt_state>
> }

> 
> rcu_preempt_state = $9 = {
>   node = {{
>       lock = {
>         raw_lock = {
>           {
>             slock = 3129850509,
>             tickets = {
>               owner = 47757,
>               next = 47757
>             }
>           }
>         },
>         magic = 3735899821,
>         owner_cpu = 4294967295,
>         owner = 0xffffffff
>       },
>       gpnum = 5877,
>       completed = 5877,
>       qsmask = 0,
>       expmask = 0,
>       qsmaskinit = 240,
>       grpmask = 0,
>       grplo = 0,
>       grphi = 7,
>       grpnum = 0 '\000',
>       level = 0 '\000',
>       parent = 0x0,
>       blkd_tasks = {
>         next = 0xc117f378 <rcu_preempt_state+56>,
>         prev = 0xc117f378 <rcu_preempt_state+56>
>       },
>       gp_tasks = 0x0,
>       exp_tasks = 0x0,
>       need_future_gp = {1, 0},
>       fqslock = {
>         raw_lock = {
>           {
>             slock = 0,
>             tickets = {
>               owner = 0,
>               next = 0
>             }
>           }
>         },
>         magic = 3735899821,
>         owner_cpu = 4294967295,
>         owner = 0xffffffff
>       }
>     }},
>   level = {0xc117f340 <rcu_preempt_state>},
>   levelcnt = {1, 0, 0, 0, 0},
>   levelspread = "\b",
>   rda = 0xc115e6b0 <rcu_preempt_data>,
>   call = 0xc01975ac <call_rcu>,
>   fqs_state = 0 '\000',
>   boost = 0 '\000',
>   gpnum = 5877,
>   completed = 5877,
>   gp_kthread = 0xf0c9e600,
>   gp_wq = {
>     lock = {
>       {
>         rlock = {
>           raw_lock = {
>             {
>               slock = 2160230594,
>               tickets = {
>                 owner = 32962,
>                 next = 32962
>               }
>             }
>           },
>           magic = 3735899821,
>           owner_cpu = 4294967295,
>           owner = 0xffffffff
>         }
>       }
>     },
>     task_list = {
>       next = 0xf0cd1f20,
>       prev = 0xf0cd1f20
>     }
>   },
>   gp_flags = 1,
>   orphan_lock = {
>     raw_lock = {
>       {
>         slock = 327685,
>         tickets = {
>           owner = 5,
>           next = 5
>         }
>       }
>     },
>     magic = 3735899821,
>     owner_cpu = 4294967295,
>     owner = 0xffffffff
>   },
>   orphan_nxtlist = 0x0,
>   orphan_nxttail = 0xc117f490 <rcu_preempt_state+336>,
>   orphan_donelist = 0x0,
>   orphan_donetail = 0xc117f498 <rcu_preempt_state+344>,
>   qlen_lazy = 0,
>   qlen = 0,
>   onoff_mutex = {
>     count = {
>       counter = 1
>     },
>     wait_lock = {
>       {
>         rlock = {
>           raw_lock = {
>             {
>               slock = 811479134,
>               tickets = {
>                 owner = 12382,
>                 next = 12382
>               }
>             }
>           },
>           magic = 3735899821,
>           owner_cpu = 4294967295,
>           owner = 0xffffffff
>         }
>       }
>     },
>     wait_list = {
>       next = 0xc117f4bc <rcu_preempt_state+380>,
>       prev = 0xc117f4bc <rcu_preempt_state+380>
>     },
>     owner = 0x0,
>     name = 0x0,
>     magic = 0xc117f4a8 <rcu_preempt_state+360>
>   },
>   barrier_mutex = {
>     count = {
>       counter = 1
>     },
>     wait_lock = {
>       {
>         rlock = {
>           raw_lock = {
>             {
>               slock = 0,
>               tickets = {
>                 owner = 0,
>                 next = 0
>               }
>             }
>           },
>           magic = 3735899821,
>           owner_cpu = 4294967295,
>           owner = 0xffffffff
>         }
>       }
>     },
>     wait_list = {
>       next = 0xc117f4e4 <rcu_preempt_state+420>,
>       prev = 0xc117f4e4 <rcu_preempt_state+420>
>     },
>     owner = 0x0,
>     name = 0x0,
>     magic = 0xc117f4d0 <rcu_preempt_state+400>
>   },
>   barrier_cpu_count = {
>     counter = 0
>   },
>   barrier_completion = {
>     done = 0,
>     wait = {
>       lock = {
>         {
>           rlock = {
>             raw_lock = {
>               {
>                 slock = 0,
>                 tickets = {
>                   owner = 0,
>                   next = 0
>                 }
>               }
>             },
>             magic = 0,
>             owner_cpu = 0,
>             owner = 0x0
>           }
>         }
>       },
>       task_list = {
>         next = 0x0,
>         prev = 0x0
>       }
>     }
>   },
>   n_barrier_done = 0,
>   expedited_start = {
>     counter = 0
>   },
>   expedited_done = {
>     counter = 0
>   },
>   expedited_wrap = {
>     counter = 0
>   },
>   expedited_tryfail = {
>     counter = 0
>   },
>   expedited_workdone1 = {
>     counter = 0
>   },
>   expedited_workdone2 = {
>     counter = 0
>   },
>   expedited_normal = {
>     counter = 0
>   },
>   expedited_stoppedcpus = {
>     counter = 0
>   },
>   expedited_done_tries = {
>     counter = 0
>   },
>   expedited_done_lost = {
>     counter = 0
>   },
>   expedited_done_exit = {
>     counter = 0
>   },
>   jiffies_force_qs = 4294963917,
>   n_force_qs = 4028,
>   n_force_qs_lh = 0,
>   n_force_qs_ngp = 0,
>   gp_start = 4294963911,
>   jiffies_stall = 4294966011,
>   gp_max = 17,
>   name = 0xc0d833ab "rcu_preempt",
>   abbr = 112 'p',
>   flavors = {
>     next = 0xc117f2ec <rcu_bh_state+556>,
>     prev = 0xc117f300 <rcu_struct_flavors>
>   },
>   wakeup_work = {
>     flags = 3,
>     llnode = {
>       next = 0x0
>     },
>     func = 0xc0195aa8 <rsp_wakeup>
>   }
> 
> 

