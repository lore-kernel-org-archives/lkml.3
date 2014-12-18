Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaLRQWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:22:31 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:52870 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaLRQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:22:29 -0500
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
In-Reply-To: <20141217192448.GR5310@linux.vnet.ibm.com>
References: <CAKZGPAN6Ct_+FY1khP4AMSJ1RgP0zKdJ2pkczjhe-Q5HxTzsrw@mail.gmail.com>
	<CAKZGPAN7Vk2xpooZ2uFTiyWywT9yCCiW6bSAjRbT5fGs6fRYNw@mail.gmail.com>
	<CAKZGPAND7TPZKbTqG-zL_Vx=E_k3kio=onwppTJqVcVSmjOR6w@mail.gmail.com>
	<20141217192448.GR5310@linux.vnet.ibm.com>
Date: Thu, 18 Dec 2014 21:52:28 +0530
X-Google-Sender-Auth: ZbgxaXvyLub4HosHGTgSbDQjCMs
Message-ID: <CAKZGPAPNpci1UriB=vtT3OHcVQnMNtwi7qbT+d_Uqvp+A_xENw@mail.gmail.com>
Subject: Re: [RCU] kernel hangs in wait_rcu_gp during suspend path
From: Arun KS <arunks.linux@gmail.com>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        josh@joshtriplett.org, rostedt@goodmis.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        laijs@cn.fujitsu.com, Arun KS <getarunks@gmail.com>
Content-Type: multipart/mixed; boundary=089e0118401096f66b050a7fffa1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0118401096f66b050a7fffa1
Content-Type: text/plain; charset=UTF-8

Hi Paul,

On Thu, Dec 18, 2014 at 12:54 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Dec 16, 2014 at 11:00:20PM +0530, Arun KS wrote:
>> Hello,
>>
>> Adding some more info.
>>
>> Below is the rcu_data data structure corresponding to cpu4.
>
> This shows that RCU is idle.  What was the state of the system at the
> time you collected this data?

System initiated a suspend sequence and currently at disable_nonboot_cpus().
It has hotplugged 0, 1 and 2 successfully.  And even successful in hot
plugging cpu3.
But while calling the CPU_POST_DEAD notifier for cpu3, another driver tried to
unregister an atomic notifier. Which eventually calls syncronize_rcu()
which hangs the suspend task.

bt as follows,
PID: 202    TASK: edcd2a00  CPU: 4   COMMAND: "kworker/u16:4"
 #0 [<c0a1f8c0>] (__schedule) from [<c0a1d054>]
 #1 [<c0a1d054>] (schedule_timeout) from [<c0a1f018>]
 #2 [<c0a1f018>] (wait_for_common) from [<c013c570>]
 #3 [<c013c570>] (wait_rcu_gp) from [<c014407c>]
 #4 [<c014407c>] (atomic_notifier_chain_unregister) from [<c06be62c>]
 #5 [<c06be62c>] (cpufreq_interactive_disable_sched_input) from [<c06bee1c>]
 #6 [<c06bee1c>] (cpufreq_governor_interactive) from [<c06b7724>]
 #7 [<c06b7724>] (__cpufreq_governor) from [<c06b9f74>]
 #8 [<c06b9f74>] (__cpufreq_remove_dev_finish) from [<c06ba3a4>]
 #9 [<c06ba3a4>] (cpufreq_cpu_callback) from [<c0a22674>]
#10 [<c0a22674>] (notifier_call_chain) from [<c012284c>]
#11 [<c012284c>] (__cpu_notify) from [<c01229dc>]
#12 [<c01229dc>] (cpu_notify_nofail) from [<c0a0dd1c>]
#13 [<c0a0dd1c>] (_cpu_down) from [<c0122b48>]
#14 [<c0122b48>] (disable_nonboot_cpus) from [<c0168cd8>]
#15 [<c0168cd8>] (suspend_devices_and_enter) from [<c0169018>]
#16 [<c0169018>] (pm_suspend) from [<c01691e0>]
#17 [<c01691e0>] (try_to_suspend) from [<c01396f0>]
#18 [<c01396f0>] (process_one_work) from [<c0139db0>]
#19 [<c0139db0>] (worker_thread) from [<c013efa4>]
#20 [<c013efa4>] (kthread) from [<c01061f8>]

But the other cores 4-7 are active. I can see them going to idle tasks
coming out from idle because of interrupts, scheduling kworkers etc.
So when I took the data, all the online cores(4-7) were in idle as
shown below from runq data structures.

------start--------------
crash> runq
CPU 0 [OFFLINE]

CPU 1 [OFFLINE]

CPU 2 [OFFLINE]

CPU 3 [OFFLINE]

CPU 4 RUNQUEUE: c5439040
  CURRENT: PID: 0      TASK: f0c9d400  COMMAND: "swapper/4"
  RT PRIO_ARRAY: c5439130
     [no tasks queued]
  CFS RB_ROOT: c54390c0
     [no tasks queued]

CPU 5 RUNQUEUE: c5447040
  CURRENT: PID: 0      TASK: f0c9aa00  COMMAND: "swapper/5"
  RT PRIO_ARRAY: c5447130
     [no tasks queued]
  CFS RB_ROOT: c54470c0
     [no tasks queued]

CPU 6 RUNQUEUE: c5455040
  CURRENT: PID: 0      TASK: f0c9ce00  COMMAND: "swapper/6"
  RT PRIO_ARRAY: c5455130
     [no tasks queued]
  CFS RB_ROOT: c54550c0
     [no tasks queued]

CPU 7 RUNQUEUE: c5463040
  CURRENT: PID: 0      TASK: f0c9b000  COMMAND: "swapper/7"
  RT PRIO_ARRAY: c5463130
     [no tasks queued]
  CFS RB_ROOT: c54630c0
     [no tasks queued]
------end--------------

but one strange thing i can see is that rcu_read_lock_nesting for idle
tasks running on cpu 5 and cpu 6 are set to 1.

PID: 0      TASK: f0c9d400  CPU: 4   COMMAND: "swapper/4"
  rcu_read_lock_nesting = 0,

PID: 0      TASK: f0c9aa00  CPU: 5   COMMAND: "swapper/5"
  rcu_read_lock_nesting = 1,

PID: 0      TASK: f0c9ce00  CPU: 6   COMMAND: "swapper/6"
  rcu_read_lock_nesting = 1,

PID: 0      TASK: f0c9b000  CPU: 7   COMMAND: "swapper/7"
  rcu_read_lock_nesting = 0,

Does this means that the current grace period(suspend thread is
waiting on) is getting extended infinitely?
Also attaching the per_cpu rcu_data for online and offline cores.

Thanks,
Arun

>
>                                                         Thanx, Paul
>
>> struct rcu_data {
>>   completed = 5877,
>>   gpnum = 5877,
>>   passed_quiesce = true,
>>   qs_pending = false,
>>   beenonline = true,
>>   preemptible = true,
>>   mynode = 0xc117f340 <rcu_preempt_state>,
>>   grpmask = 16,
>>   nxtlist = 0xedaaec00,
>>   nxttail = {0xc54366c4, 0xe84d350c, 0xe84d350c, 0xe84d350c},
>>   nxtcompleted = {4294967035, 5878, 5878, 5878},
>>   qlen_lazy = 105,
>>   qlen = 415,
>>   qlen_last_fqs_check = 0,
>>   n_cbs_invoked = 86323,
>>   n_nocbs_invoked = 0,
>>   n_cbs_orphaned = 0,
>>   n_cbs_adopted = 139,
>>   n_force_qs_snap = 0,
>>   blimit = 10,
>>   dynticks = 0xc5436758,
>>   dynticks_snap = 7582140,
>>   dynticks_fqs = 41,
>>   offline_fqs = 0,
>>   n_rcu_pending = 59404,
>>   n_rp_qs_pending = 5,
>>   n_rp_report_qs = 4633,
>>   n_rp_cb_ready = 32,
>>   n_rp_cpu_needs_gp = 41088,
>>   n_rp_gp_completed = 2844,
>>   n_rp_gp_started = 1150,
>>   n_rp_need_nothing = 9657,
>>   barrier_head = {
>>     next = 0x0,
>>     func = 0x0
>>   },
>>   oom_head = {
>>     next = 0x0,
>>     func = 0x0
>>   },
>>   cpu = 4,
>>   rsp = 0xc117f340 <rcu_preempt_state>
>> }
>>
>>
>>
>> Also pasting complete rcu_preempt_state.
>>
>>
>>
>> rcu_preempt_state = $9 = {
>>   node = {{
>>       lock = {
>>         raw_lock = {
>>           {
>>             slock = 3129850509,
>>             tickets = {
>>               owner = 47757,
>>               next = 47757
>>             }
>>           }
>>         },
>>         magic = 3735899821,
>>         owner_cpu = 4294967295,
>>         owner = 0xffffffff
>>       },
>>       gpnum = 5877,
>>       completed = 5877,
>>       qsmask = 0,
>>       expmask = 0,
>>       qsmaskinit = 240,
>>       grpmask = 0,
>>       grplo = 0,
>>       grphi = 7,
>>       grpnum = 0 '\000',
>>       level = 0 '\000',
>>       parent = 0x0,
>>       blkd_tasks = {
>>         next = 0xc117f378 <rcu_preempt_state+56>,
>>         prev = 0xc117f378 <rcu_preempt_state+56>
>>       },
>>       gp_tasks = 0x0,
>>       exp_tasks = 0x0,
>>       need_future_gp = {1, 0},
>>       fqslock = {
>>         raw_lock = {
>>           {
>>             slock = 0,
>>             tickets = {
>>               owner = 0,
>>               next = 0
>>             }
>>           }
>>         },
>>         magic = 3735899821,
>>         owner_cpu = 4294967295,
>>         owner = 0xffffffff
>>       }
>>     }},
>>   level = {0xc117f340 <rcu_preempt_state>},
>>   levelcnt = {1, 0, 0, 0, 0},
>>   levelspread = "\b",
>>   rda = 0xc115e6b0 <rcu_preempt_data>,
>>   call = 0xc01975ac <call_rcu>,
>>   fqs_state = 0 '\000',
>>   boost = 0 '\000',
>>   gpnum = 5877,
>>   completed = 5877,
>>   gp_kthread = 0xf0c9e600,
>>   gp_wq = {
>>     lock = {
>>       {
>>         rlock = {
>>           raw_lock = {
>>             {
>>               slock = 2160230594,
>>               tickets = {
>>                 owner = 32962,
>>                 next = 32962
>>               }
>>             }
>>           },
>>           magic = 3735899821,
>>           owner_cpu = 4294967295,
>>           owner = 0xffffffff
>>         }
>>       }
>>     },
>>     task_list = {
>>       next = 0xf0cd1f20,
>>       prev = 0xf0cd1f20
>>     }
>>   },
>>   gp_flags = 1,
>>   orphan_lock = {
>>     raw_lock = {
>>       {
>>         slock = 327685,
>>         tickets = {
>>           owner = 5,
>>           next = 5
>>         }
>>       }
>>     },
>>     magic = 3735899821,
>>     owner_cpu = 4294967295,
>>     owner = 0xffffffff
>>   },
>>   orphan_nxtlist = 0x0,
>>   orphan_nxttail = 0xc117f490 <rcu_preempt_state+336>,
>>   orphan_donelist = 0x0,
>>   orphan_donetail = 0xc117f498 <rcu_preempt_state+344>,
>>   qlen_lazy = 0,
>>   qlen = 0,
>>   onoff_mutex = {
>>     count = {
>>       counter = 1
>>     },
>>     wait_lock = {
>>       {
>>         rlock = {
>>           raw_lock = {
>>             {
>>               slock = 811479134,
>>               tickets = {
>>                 owner = 12382,
>>                 next = 12382
>>               }
>>             }
>>           },
>>           magic = 3735899821,
>>           owner_cpu = 4294967295,
>>           owner = 0xffffffff
>>         }
>>       }
>>     },
>>     wait_list = {
>>       next = 0xc117f4bc <rcu_preempt_state+380>,
>>       prev = 0xc117f4bc <rcu_preempt_state+380>
>>     },
>>     owner = 0x0,
>>     name = 0x0,
>>     magic = 0xc117f4a8 <rcu_preempt_state+360>
>>   },
>>   barrier_mutex = {
>>     count = {
>>       counter = 1
>>     },
>>     wait_lock = {
>>       {
>>         rlock = {
>>           raw_lock = {
>>             {
>>               slock = 0,
>>               tickets = {
>>                 owner = 0,
>>                 next = 0
>>               }
>>             }
>>           },
>>           magic = 3735899821,
>>           owner_cpu = 4294967295,
>>           owner = 0xffffffff
>>         }
>>       }
>>     },
>>     wait_list = {
>>       next = 0xc117f4e4 <rcu_preempt_state+420>,
>>       prev = 0xc117f4e4 <rcu_preempt_state+420>
>>     },
>>     owner = 0x0,
>>     name = 0x0,
>>     magic = 0xc117f4d0 <rcu_preempt_state+400>
>>   },
>>   barrier_cpu_count = {
>>     counter = 0
>>   },
>>   barrier_completion = {
>>     done = 0,
>>     wait = {
>>       lock = {
>>         {
>>           rlock = {
>>             raw_lock = {
>>               {
>>                 slock = 0,
>>                 tickets = {
>>                   owner = 0,
>>                   next = 0
>>                 }
>>               }
>>             },
>>             magic = 0,
>>             owner_cpu = 0,
>>             owner = 0x0
>>           }
>>         }
>>       },
>>       task_list = {
>>         next = 0x0,
>>         prev = 0x0
>>       }
>>     }
>>   },
>>   n_barrier_done = 0,
>>   expedited_start = {
>>     counter = 0
>>   },
>>   expedited_done = {
>>     counter = 0
>>   },
>>   expedited_wrap = {
>>     counter = 0
>>   },
>>   expedited_tryfail = {
>>     counter = 0
>>   },
>>   expedited_workdone1 = {
>>     counter = 0
>>   },
>>   expedited_workdone2 = {
>>     counter = 0
>>   },
>>   expedited_normal = {
>>     counter = 0
>>   },
>>   expedited_stoppedcpus = {
>>     counter = 0
>>   },
>>   expedited_done_tries = {
>>     counter = 0
>>   },
>>   expedited_done_lost = {
>>     counter = 0
>>   },
>>   expedited_done_exit = {
>>     counter = 0
>>   },
>>   jiffies_force_qs = 4294963917,
>>   n_force_qs = 4028,
>>   n_force_qs_lh = 0,
>>   n_force_qs_ngp = 0,
>>   gp_start = 4294963911,
>>   jiffies_stall = 4294966011,
>>   gp_max = 17,
>>   name = 0xc0d833ab "rcu_preempt",
>>   abbr = 112 'p',
>>   flavors = {
>>     next = 0xc117f2ec <rcu_bh_state+556>,
>>     prev = 0xc117f300 <rcu_struct_flavors>
>>   },
>>   wakeup_work = {
>>     flags = 3,
>>     llnode = {
>>       next = 0x0
>>     },
>>     func = 0xc0195aa8 <rsp_wakeup>
>>   }
>> }
>>
>> Hope this helps.
>>
>> Thanks,
>> Arun
>>
>>
>> On Tue, Dec 16, 2014 at 11:59 AM, Arun KS <arunks.linux@gmail.com> wrote:
>> > Hello,
>> >
>> > I dig little deeper to understand the situation.
>> > All other cpus are in idle thread already.
>> > As per my understanding, for the grace period to end, at-least one of
>> > the following should happen on all online cpus,
>> >
>> > 1. a context switch.
>> > 2. user space switch.
>> > 3. switch to idle thread.
>> >
>> > In this situation, since all the other cores are already in idle,  non
>> > of the above are meet on all online cores.
>> > So grace period is getting extended and never finishes. Below is the
>> > state of runqueue when the hang happens.
>> > --------------start------------------------------------
>> > crash> runq
>> > CPU 0 [OFFLINE]
>> >
>> > CPU 1 [OFFLINE]
>> >
>> > CPU 2 [OFFLINE]
>> >
>> > CPU 3 [OFFLINE]
>> >
>> > CPU 4 RUNQUEUE: c3192e40
>> >   CURRENT: PID: 0      TASK: f0874440  COMMAND: "swapper/4"
>> >   RT PRIO_ARRAY: c3192f20
>> >      [no tasks queued]
>> >   CFS RB_ROOT: c3192eb0
>> >      [no tasks queued]
>> >
>> > CPU 5 RUNQUEUE: c31a0e40
>> >   CURRENT: PID: 0      TASK: f0874980  COMMAND: "swapper/5"
>> >   RT PRIO_ARRAY: c31a0f20
>> >      [no tasks queued]
>> >   CFS RB_ROOT: c31a0eb0
>> >      [no tasks queued]
>> >
>> > CPU 6 RUNQUEUE: c31aee40
>> >   CURRENT: PID: 0      TASK: f0874ec0  COMMAND: "swapper/6"
>> >   RT PRIO_ARRAY: c31aef20
>> >      [no tasks queued]
>> >   CFS RB_ROOT: c31aeeb0
>> >      [no tasks queued]
>> >
>> > CPU 7 RUNQUEUE: c31bce40
>> >   CURRENT: PID: 0      TASK: f0875400  COMMAND: "swapper/7"
>> >   RT PRIO_ARRAY: c31bcf20
>> >      [no tasks queued]
>> >   CFS RB_ROOT: c31bceb0
>> >      [no tasks queued]
>> > --------------end------------------------------------
>> >
>> > If my understanding is correct the below patch should help, because it
>> > will expedite grace periods during suspend,
>> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d1d74d14e98a6be740a6f12456c7d9ad47be9c9c
>> >
>> > But I wonder why it was not taken to stable trees. Can we take it?
>> > Appreciate your help.
>> >
>> > Thanks,
>> > Arun
>> >
>> > On Mon, Dec 15, 2014 at 10:34 PM, Arun KS <arunks.linux@gmail.com> wrote:
>> >> Hi,
>> >>
>> >> Here is the backtrace of the process hanging in wait_rcu_gp,
>> >>
>> >> PID: 247    TASK: e16e7380  CPU: 4   COMMAND: "kworker/u16:5"
>> >>  #0 [<c09fead0>] (__schedule) from [<c09fcab0>]
>> >>  #1 [<c09fcab0>] (schedule_timeout) from [<c09fe050>]
>> >>  #2 [<c09fe050>] (wait_for_common) from [<c013b2b4>]
>> >>  #3 [<c013b2b4>] (wait_rcu_gp) from [<c0142f50>]
>> >>  #4 [<c0142f50>] (atomic_notifier_chain_unregister) from [<c06b2ab8>]
>> >>  #5 [<c06b2ab8>] (cpufreq_interactive_disable_sched_input) from [<c06b32a8>]
>> >>  #6 [<c06b32a8>] (cpufreq_governor_interactive) from [<c06abbf8>]
>> >>  #7 [<c06abbf8>] (__cpufreq_governor) from [<c06ae474>]
>> >>  #8 [<c06ae474>] (__cpufreq_remove_dev_finish) from [<c06ae8c0>]
>> >>  #9 [<c06ae8c0>] (cpufreq_cpu_callback) from [<c0a0185c>]
>> >> #10 [<c0a0185c>] (notifier_call_chain) from [<c0121888>]
>> >> #11 [<c0121888>] (__cpu_notify) from [<c0121a04>]
>> >> #12 [<c0121a04>] (cpu_notify_nofail) from [<c09ee7f0>]
>> >> #13 [<c09ee7f0>] (_cpu_down) from [<c0121b70>]
>> >> #14 [<c0121b70>] (disable_nonboot_cpus) from [<c016788c>]
>> >> #15 [<c016788c>] (suspend_devices_and_enter) from [<c0167bcc>]
>> >> #16 [<c0167bcc>] (pm_suspend) from [<c0167d94>]
>> >> #17 [<c0167d94>] (try_to_suspend) from [<c0138460>]
>> >> #18 [<c0138460>] (process_one_work) from [<c0138b18>]
>> >> #19 [<c0138b18>] (worker_thread) from [<c013dc58>]
>> >> #20 [<c013dc58>] (kthread) from [<c01061b8>]
>> >>
>> >> Will this patch helps here,
>> >> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d1d74d14e98a6be740a6f12456c7d9ad47be9c9c
>> >>
>> >> I couldn't really understand why it got struck in  synchronize_rcu().
>> >> Please give some pointers to debug this further.
>> >>
>> >> Below are the configs enable related to RCU.
>> >>
>> >> CONFIG_TREE_PREEMPT_RCU=y
>> >> CONFIG_PREEMPT_RCU=y
>> >> CONFIG_RCU_STALL_COMMON=y
>> >> CONFIG_RCU_FANOUT=32
>> >> CONFIG_RCU_FANOUT_LEAF=16
>> >> CONFIG_RCU_FAST_NO_HZ=y
>> >> CONFIG_RCU_CPU_STALL_TIMEOUT=21
>> >> CONFIG_RCU_CPU_STALL_VERBOSE=y
>> >>
>> >> Kernel version is 3.10.28
>> >> Architecture is ARM
>> >>
>> >> Thanks,
>> >> Arun
>>
>

--089e0118401096f66b050a7fffa1
Content-Type: text/plain; charset=US-ASCII; name="rcu_data_offline_cpus_0_3.txt"
Content-Disposition: attachment; filename="rcu_data_offline_cpus_0_3.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3uc5wrp0

Y3Jhc2g+IHN0cnVjdCByY3VfZGF0YSBDNTQyODZCMA0Kc3RydWN0IHJjdV9kYXRhIHsNCiAgY29t
cGxldGVkID0gMjgzMywNCiAgZ3BudW0gPSAyODMzLA0KICBwYXNzZWRfcXVpZXNjZSA9IGZhbHNl
LA0KICBxc19wZW5kaW5nID0gZmFsc2UsDQogIGJlZW5vbmxpbmUgPSB0cnVlLA0KICBwcmVlbXB0
aWJsZSA9IHRydWUsDQogIG15bm9kZSA9IDB4YzExN2YzNDAgPHJjdV9wcmVlbXB0X3N0YXRlPiwN
CiAgZ3JwbWFzayA9IDgsDQogIG54dGxpc3QgPSAweDAsDQogIG54dHRhaWwgPSB7MHhjNTQyODZj
NCwgMHhjNTQyODZjNCwgMHhjNTQyODZjNCwgMHgwfSwNCiAgbnh0Y29tcGxldGVkID0gezAsIDQy
OTQ5NjcxMzYsIDQyOTQ5NjcxMzcsIDQyOTQ5NjcxMzd9LA0KICBxbGVuX2xhenkgPSAwLA0KICBx
bGVuID0gMCwNCiAgcWxlbl9sYXN0X2Zxc19jaGVjayA9IDAsDQogIG5fY2JzX2ludm9rZWQgPSA2
MDksDQogIG5fbm9jYnNfaW52b2tlZCA9IDAsDQogIG5fY2JzX29ycGhhbmVkID0gMTMsDQogIG5f
Y2JzX2Fkb3B0ZWQgPSAwLA0KICBuX2ZvcmNlX3FzX3NuYXAgPSAxNDI4LA0KICBibGltaXQgPSAx
MCwNCiAgZHludGlja3MgPSAweGM1NDI4NzU4LA0KICBkeW50aWNrc19zbmFwID0gMTMyMDYwNTMs
DQogIGR5bnRpY2tzX2ZxcyA9IDE2LA0KICBvZmZsaW5lX2ZxcyA9IDAsDQogIG5fcmN1X3BlbmRp
bmcgPSAxODEsDQogIG5fcnBfcXNfcGVuZGluZyA9IDEsDQogIG5fcnBfcmVwb3J0X3FzID0gMjEs
DQogIG5fcnBfY2JfcmVhZHkgPSAwLA0KICBuX3JwX2NwdV9uZWVkc19ncCA9IDAsDQogIG5fcnBf
Z3BfY29tcGxldGVkID0gMjIsDQogIG5fcnBfZ3Bfc3RhcnRlZCA9IDgsDQogIG5fcnBfbmVlZF9u
b3RoaW5nID0gMTMwLA0KICBiYXJyaWVyX2hlYWQgPSB7DQogICAgbmV4dCA9IDB4MCwNCiAgICBm
dW5jID0gMHgwDQogIH0sDQogIG9vbV9oZWFkID0gew0KICAgIG5leHQgPSAweDAsDQogICAgZnVu
YyA9IDB4MA0KICB9LA0KICBjcHUgPSAzLA0KICByc3AgPSAweGMxMTdmMzQwIDxyY3VfcHJlZW1w
dF9zdGF0ZT4NCn0NCg0KY3Jhc2g+IHN0cnVjdCByY3VfZGF0YSBDNTQxQTZCMA0Kc3RydWN0IHJj
dV9kYXRhIHsNCiAgY29tcGxldGVkID0gNTg3NywNCiAgZ3BudW0gPSA1ODc3LA0KICBwYXNzZWRf
cXVpZXNjZSA9IHRydWUsDQogIHFzX3BlbmRpbmcgPSBmYWxzZSwNCiAgYmVlbm9ubGluZSA9IHRy
dWUsDQogIHByZWVtcHRpYmxlID0gdHJ1ZSwNCiAgbXlub2RlID0gMHhjMTE3ZjM0MCA8cmN1X3By
ZWVtcHRfc3RhdGU+LA0KICBncnBtYXNrID0gNCwNCiAgbnh0bGlzdCA9IDB4MCwNCiAgbnh0dGFp
bCA9IHsweGM1NDFhNmM0LCAweGM1NDFhNmM0LCAweGM1NDFhNmM0LCAweDB9LA0KICBueHRjb21w
bGV0ZWQgPSB7MCwgNTg3NywgNTg3OCwgNTg3OH0sDQogIHFsZW5fbGF6eSA9IDAsDQogIHFsZW4g
PSAwLA0KICBxbGVuX2xhc3RfZnFzX2NoZWNrID0gMCwNCiAgbl9jYnNfaW52b2tlZCA9IDYxNTY1
LA0KICBuX25vY2JzX2ludm9rZWQgPSAwLA0KICBuX2Nic19vcnBoYW5lZCA9IDEzOSwNCiAgbl9j
YnNfYWRvcHRlZCA9IDEwMCwNCiAgbl9mb3JjZV9xc19zbmFwID0gMCwNCiAgYmxpbWl0ID0gMTAs
DQogIGR5bnRpY2tzID0gMHhjNTQxYTc1OCwNCiAgZHludGlja3Nfc25hcCA9IDEzOTAxMDE3LA0K
ICBkeW50aWNrc19mcXMgPSA3NSwNCiAgb2ZmbGluZV9mcXMgPSAwLA0KICBuX3JjdV9wZW5kaW5n
ID0gMTY1NDYsDQogIG5fcnBfcXNfcGVuZGluZyA9IDMsDQogIG5fcnBfcmVwb3J0X3FzID0gNDUz
OSwNCiAgbl9ycF9jYl9yZWFkeSA9IDY5LA0KICBuX3JwX2NwdV9uZWVkc19ncCA9IDc4MiwNCiAg
bl9ycF9ncF9jb21wbGV0ZWQgPSA0MTk2LA0KICBuX3JwX2dwX3N0YXJ0ZWQgPSAxNzM5LA0KICBu
X3JwX25lZWRfbm90aGluZyA9IDUyMjEsDQogIGJhcnJpZXJfaGVhZCA9IHsNCiAgICBuZXh0ID0g
MHgwLA0KICAgIGZ1bmMgPSAweDANCiAgfSwNCiAgb29tX2hlYWQgPSB7DQogICAgbmV4dCA9IDB4
MCwNCiAgICBmdW5jID0gMHgwDQogIH0sDQogIGNwdSA9IDIsDQogIHJzcCA9IDB4YzExN2YzNDAg
PHJjdV9wcmVlbXB0X3N0YXRlPg0KfQ0KDQpjcmFzaD4gc3RydWN0IHJjdV9kYXRhIEM1NDBDNkIw
DQpzdHJ1Y3QgcmN1X2RhdGEgew0KICBjb21wbGV0ZWQgPSA1ODc3LA0KICBncG51bSA9IDU4Nzcs
DQogIHBhc3NlZF9xdWllc2NlID0gdHJ1ZSwNCiAgcXNfcGVuZGluZyA9IGZhbHNlLA0KICBiZWVu
b25saW5lID0gdHJ1ZSwNCiAgcHJlZW1wdGlibGUgPSB0cnVlLA0KICBteW5vZGUgPSAweGMxMTdm
MzQwIDxyY3VfcHJlZW1wdF9zdGF0ZT4sDQogIGdycG1hc2sgPSAyLA0KICBueHRsaXN0ID0gMHgw
LA0KICBueHR0YWlsID0gezB4YzU0MGM2YzQsIDB4YzU0MGM2YzQsIDB4YzU0MGM2YzQsIDB4MH0s
DQogIG54dGNvbXBsZXRlZCA9IHs0Mjk0OTY3MDMwLCA1ODc4LCA1ODc4LCA1ODc4fSwNCiAgcWxl
bl9sYXp5ID0gMCwNCiAgcWxlbiA9IDAsDQogIHFsZW5fbGFzdF9mcXNfY2hlY2sgPSAwLA0KICBu
X2Nic19pbnZva2VkID0gNzQyOTIsDQogIG5fbm9jYnNfaW52b2tlZCA9IDAsDQogIG5fY2JzX29y
cGhhbmVkID0gMTAwLA0KICBuX2Nic19hZG9wdGVkID0gNjUsDQogIG5fZm9yY2VfcXNfc25hcCA9
IDAsDQogIGJsaW1pdCA9IDEwLA0KICBkeW50aWNrcyA9IDB4YzU0MGM3NTgsDQogIGR5bnRpY2tz
X3NuYXAgPSAxMDc1MzQzMywNCiAgZHludGlja3NfZnFzID0gNjksDQogIG9mZmxpbmVfZnFzID0g
MCwNCiAgbl9yY3VfcGVuZGluZyA9IDE4MzUwLA0KICBuX3JwX3FzX3BlbmRpbmcgPSA2LA0KICBu
X3JwX3JlcG9ydF9xcyA9IDUwMDksDQogIG5fcnBfY2JfcmVhZHkgPSA1MCwNCiAgbl9ycF9jcHVf
bmVlZHNfZ3AgPSA5MTUsDQogIG5fcnBfZ3BfY29tcGxldGVkID0gNDQyMywNCiAgbl9ycF9ncF9z
dGFydGVkID0gMTgyNiwNCiAgbl9ycF9uZWVkX25vdGhpbmcgPSA2MTI3LA0KICBiYXJyaWVyX2hl
YWQgPSB7DQogICAgbmV4dCA9IDB4MCwNCiAgICBmdW5jID0gMHgwDQogIH0sDQogIG9vbV9oZWFk
ID0gew0KICAgIG5leHQgPSAweDAsDQogICAgZnVuYyA9IDB4MA0KICB9LA0KICBjcHUgPSAxLA0K
ICByc3AgPSAweGMxMTdmMzQwIDxyY3VfcHJlZW1wdF9zdGF0ZT4NCn0NCmNyYXNoPiBzdHJ1Y3Qg
cmN1X2RhdGEgQzUzRkU2QjANCnN0cnVjdCByY3VfZGF0YSB7DQogIGNvbXBsZXRlZCA9IDU4Nzcs
DQogIGdwbnVtID0gNTg3NywNCiAgcGFzc2VkX3F1aWVzY2UgPSB0cnVlLA0KICBxc19wZW5kaW5n
ID0gZmFsc2UsDQogIGJlZW5vbmxpbmUgPSB0cnVlLA0KICBwcmVlbXB0aWJsZSA9IHRydWUsDQog
IG15bm9kZSA9IDB4YzExN2YzNDAgPHJjdV9wcmVlbXB0X3N0YXRlPiwNCiAgZ3JwbWFzayA9IDEs
DQogIG54dGxpc3QgPSAweDAsDQogIG54dHRhaWwgPSB7MHhjNTNmZTZjNCwgMHhjNTNmZTZjNCwg
MHhjNTNmZTZjNCwgMHgwfSwNCiAgbnh0Y29tcGxldGVkID0gezQyOTQ5NjY5OTcsIDU4NzUsIDU4
NzYsIDU4NzZ9LA0KICBxbGVuX2xhenkgPSAwLA0KICBxbGVuID0gMCwNCiAgcWxlbl9sYXN0X2Zx
c19jaGVjayA9IDAsDQogIG5fY2JzX2ludm9rZWQgPSAxMjMxNzUsDQogIG5fbm9jYnNfaW52b2tl
ZCA9IDAsDQogIG5fY2JzX29ycGhhbmVkID0gNTIsDQogIG5fY2JzX2Fkb3B0ZWQgPSAwLA0KICBu
X2ZvcmNlX3FzX3NuYXAgPSAwLA0KICBibGltaXQgPSAxMCwNCiAgZHludGlja3MgPSAweGM1M2Zl
NzU4LA0KICBkeW50aWNrc19zbmFwID0gNjMzMDQ0NiwNCiAgZHludGlja3NfZnFzID0gNDYsDQog
IG9mZmxpbmVfZnFzID0gMCwNCiAgbl9yY3VfcGVuZGluZyA9IDIyNTI5LA0KICBuX3JwX3FzX3Bl
bmRpbmcgPSAzLA0KICBuX3JwX3JlcG9ydF9xcyA9IDUyOTAsDQogIG5fcnBfY2JfcmVhZHkgPSAy
NzksDQogIG5fcnBfY3B1X25lZWRzX2dwID0gNzQwLA0KICBuX3JwX2dwX2NvbXBsZXRlZCA9IDI3
MDcsDQogIG5fcnBfZ3Bfc3RhcnRlZCA9IDEyMDgsDQogIG5fcnBfbmVlZF9ub3RoaW5nID0gMTIz
MDUsDQogIGJhcnJpZXJfaGVhZCA9IHsNCiAgICBuZXh0ID0gMHgwLA0KICAgIGZ1bmMgPSAweDAN
CiAgfSwNCiAgb29tX2hlYWQgPSB7DQogICAgbmV4dCA9IDB4MCwNCiAgICBmdW5jID0gMHgwDQog
IH0sDQogIGNwdSA9IDAsDQogIHJzcCA9IDB4YzExN2YzNDAgPHJjdV9wcmVlbXB0X3N0YXRlPg0K
fQ0KDQo=
--089e0118401096f66b050a7fffa1
Content-Type: text/plain; charset=US-ASCII; name="rcu_data_online_cpus_4_7.txt"
Content-Disposition: attachment; filename="rcu_data_online_cpus_4_7.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3uc5wse1

Y3Jhc2g+IHN0cnVjdCByY3VfZGF0YSBjNTQzNjZiMA0Kc3RydWN0IHJjdV9kYXRhIHsNCiAgY29t
cGxldGVkID0gNTg3NywNCiAgZ3BudW0gPSA1ODc3LA0KICBwYXNzZWRfcXVpZXNjZSA9IHRydWUs
DQogIHFzX3BlbmRpbmcgPSBmYWxzZSwNCiAgYmVlbm9ubGluZSA9IHRydWUsDQogIHByZWVtcHRp
YmxlID0gdHJ1ZSwNCiAgbXlub2RlID0gMHhjMTE3ZjM0MCA8cmN1X3ByZWVtcHRfc3RhdGU+LA0K
ICBncnBtYXNrID0gMTYsDQogIG54dGxpc3QgPSAweGVkYWFlYzAwLA0KICBueHR0YWlsID0gezB4
YzU0MzY2YzQsIDB4ZTg0ZDM1MGMsIDB4ZTg0ZDM1MGMsIDB4ZTg0ZDM1MGN9LA0KICBueHRjb21w
bGV0ZWQgPSB7NDI5NDk2NzAzNSwgNTg3OCwgNTg3OCwgNTg3OH0sDQogIHFsZW5fbGF6eSA9IDEw
NSwNCiAgcWxlbiA9IDQxNSwNCiAgcWxlbl9sYXN0X2Zxc19jaGVjayA9IDAsDQogIG5fY2JzX2lu
dm9rZWQgPSA4NjMyMywNCiAgbl9ub2Nic19pbnZva2VkID0gMCwNCiAgbl9jYnNfb3JwaGFuZWQg
PSAwLA0KICBuX2Nic19hZG9wdGVkID0gMTM5LA0KICBuX2ZvcmNlX3FzX3NuYXAgPSAwLA0KICBi
bGltaXQgPSAxMCwNCiAgZHludGlja3MgPSAweGM1NDM2NzU4LA0KICBkeW50aWNrc19zbmFwID0g
NzU4MjE0MCwNCiAgZHludGlja3NfZnFzID0gNDEsDQogIG9mZmxpbmVfZnFzID0gMCwNCiAgbl9y
Y3VfcGVuZGluZyA9IDU5NDA0LA0KICBuX3JwX3FzX3BlbmRpbmcgPSA1LA0KICBuX3JwX3JlcG9y
dF9xcyA9IDQ2MzMsDQogIG5fcnBfY2JfcmVhZHkgPSAzMiwNCiAgbl9ycF9jcHVfbmVlZHNfZ3Ag
PSA0MTA4OCwNCiAgbl9ycF9ncF9jb21wbGV0ZWQgPSAyODQ0LA0KICBuX3JwX2dwX3N0YXJ0ZWQg
PSAxMTUwLA0KICBuX3JwX25lZWRfbm90aGluZyA9IDk2NTcsDQogIGJhcnJpZXJfaGVhZCA9IHsN
CiAgICBuZXh0ID0gMHgwLA0KICAgIGZ1bmMgPSAweDANCiAgfSwNCiAgb29tX2hlYWQgPSB7DQog
ICAgbmV4dCA9IDB4MCwNCiAgICBmdW5jID0gMHgwDQogIH0sDQogIGNwdSA9IDQsDQogIHJzcCA9
IDB4YzExN2YzNDAgPHJjdV9wcmVlbXB0X3N0YXRlPg0KfQ0KDQpjcmFzaD4gc3RydWN0IHJjdV9k
YXRhIGM1NDQ0NmIwDQpzdHJ1Y3QgcmN1X2RhdGEgew0KICBjb21wbGV0ZWQgPSA1ODc3LA0KICBn
cG51bSA9IDU4NzcsDQogIHBhc3NlZF9xdWllc2NlID0gdHJ1ZSwNCiAgcXNfcGVuZGluZyA9IGZh
bHNlLA0KICBiZWVub25saW5lID0gdHJ1ZSwNCiAgcHJlZW1wdGlibGUgPSB0cnVlLA0KICBteW5v
ZGUgPSAweGMxMTdmMzQwIDxyY3VfcHJlZW1wdF9zdGF0ZT4sDQogIGdycG1hc2sgPSAzMiwNCiAg
bnh0bGlzdCA9IDB4Y2Y5ZTg1NmMsDQogIG54dHRhaWwgPSB7MHhjNTQ0NDZjNCwgMHhjZmIzMDUw
YywgMHhjZmIzMDUwYywgMHhjZmIzMDUwY30sDQogIG54dGNvbXBsZXRlZCA9IHswLCA1ODc4LCA1
ODc4LCA1ODc4fSwNCiAgcWxlbl9sYXp5ID0gMCwNCiAgcWxlbiA9IDExNywNCiAgcWxlbl9sYXN0
X2Zxc19jaGVjayA9IDAsDQogIG5fY2JzX2ludm9rZWQgPSAzNjk1MSwNCiAgbl9ub2Nic19pbnZv
a2VkID0gMCwNCiAgbl9jYnNfb3JwaGFuZWQgPSAwLA0KICBuX2Nic19hZG9wdGVkID0gMCwNCiAg
bl9mb3JjZV9xc19zbmFwID0gMTQyOCwNCiAgYmxpbWl0ID0gMTAsDQogIGR5bnRpY2tzID0gMHhj
NTQ0NDc1OCwNCiAgZHludGlja3Nfc25hcCA9IDg2MDM0LA0KICBkeW50aWNrc19mcXMgPSA0NiwN
CiAgb2ZmbGluZV9mcXMgPSAwLA0KICBuX3JjdV9wZW5kaW5nID0gNDkxMDQsDQogIG5fcnBfcXNf
cGVuZGluZyA9IDMsDQogIG5fcnBfcmVwb3J0X3FzID0gMjM2MCwNCiAgbl9ycF9jYl9yZWFkeSA9
IDE4LA0KICBuX3JwX2NwdV9uZWVkc19ncCA9IDQwMTA2LA0KICBuX3JwX2dwX2NvbXBsZXRlZCA9
IDEzMzQsDQogIG5fcnBfZ3Bfc3RhcnRlZCA9IDc5MSwNCiAgbl9ycF9uZWVkX25vdGhpbmcgPSA0
NDk1LA0KICBiYXJyaWVyX2hlYWQgPSB7DQogICAgbmV4dCA9IDB4MCwNCiAgICBmdW5jID0gMHgw
DQogIH0sDQogIG9vbV9oZWFkID0gew0KICAgIG5leHQgPSAweDAsDQogICAgZnVuYyA9IDB4MA0K
ICB9LA0KICBjcHUgPSA1LA0KICByc3AgPSAweGMxMTdmMzQwIDxyY3VfcHJlZW1wdF9zdGF0ZT4N
Cn0NCg0KY3Jhc2g+IHN0cnVjdCByY3VfZGF0YSBjNTQ1MjZiMA0Kc3RydWN0IHJjdV9kYXRhIHsN
CiAgY29tcGxldGVkID0gNTg3NywNCiAgZ3BudW0gPSA1ODc3LA0KICBwYXNzZWRfcXVpZXNjZSA9
IHRydWUsDQogIHFzX3BlbmRpbmcgPSBmYWxzZSwNCiAgYmVlbm9ubGluZSA9IHRydWUsDQogIHBy
ZWVtcHRpYmxlID0gdHJ1ZSwNCiAgbXlub2RlID0gMHhjMTE3ZjM0MCA8cmN1X3ByZWVtcHRfc3Rh
dGU+LA0KICBncnBtYXNrID0gNjQsDQogIG54dGxpc3QgPSAweGU2MTNkMjAwLA0KICBueHR0YWls
ID0gezB4YzU0NTI2YzQsIDB4ZTZmYzlkMGMsIDB4ZTZmYzlkMGMsIDB4ZTZmYzlkMGN9LA0KICBu
eHRjb21wbGV0ZWQgPSB7MCwgNTg3OCwgNTg3OCwgNTg3OH0sDQogIHFsZW5fbGF6eSA9IDIsDQog
IHFsZW4gPSAzNSwNCiAgcWxlbl9sYXN0X2Zxc19jaGVjayA9IDAsDQogIG5fY2JzX2ludm9rZWQg
PSAzNDQ1OSwNCiAgbl9ub2Nic19pbnZva2VkID0gMCwNCiAgbl9jYnNfb3JwaGFuZWQgPSAwLA0K
ICBuX2Nic19hZG9wdGVkID0gMCwNCiAgbl9mb3JjZV9xc19zbmFwID0gMTQyOCwNCiAgYmxpbWl0
ID0gMTAsDQogIGR5bnRpY2tzID0gMHhjNTQ1Mjc1OCwNCiAgZHludGlja3Nfc25hcCA9IDExNjg0
MCwNCiAgZHludGlja3NfZnFzID0gNDcsDQogIG9mZmxpbmVfZnFzID0gMCwNCiAgbl9yY3VfcGVu
ZGluZyA9IDQ4NDg2LA0KICBuX3JwX3FzX3BlbmRpbmcgPSAzLA0KICBuX3JwX3JlcG9ydF9xcyA9
IDIyMjMsDQogIG5fcnBfY2JfcmVhZHkgPSAyNCwNCiAgbl9ycF9jcHVfbmVlZHNfZ3AgPSA0MDEw
MSwNCiAgbl9ycF9ncF9jb21wbGV0ZWQgPSAxMjI2LA0KICBuX3JwX2dwX3N0YXJ0ZWQgPSA3ODks
DQogIG5fcnBfbmVlZF9ub3RoaW5nID0gNDEyMywNCiAgYmFycmllcl9oZWFkID0gew0KICAgIG5l
eHQgPSAweDAsDQogICAgZnVuYyA9IDB4MA0KICB9LA0KICBvb21faGVhZCA9IHsNCiAgICBuZXh0
ID0gMHgwLA0KICAgIGZ1bmMgPSAweDANCiAgfSwNCiAgY3B1ID0gNiwNCiAgcnNwID0gMHhjMTE3
ZjM0MCA8cmN1X3ByZWVtcHRfc3RhdGU+DQp9DQoNCmNyYXNoPiBzdHJ1Y3QgcmN1X2RhdGEgYzU0
NjA2YjANCnN0cnVjdCByY3VfZGF0YSB7DQogIGNvbXBsZXRlZCA9IDU4NzcsDQogIGdwbnVtID0g
NTg3NywNCiAgcGFzc2VkX3F1aWVzY2UgPSB0cnVlLA0KICBxc19wZW5kaW5nID0gZmFsc2UsDQog
IGJlZW5vbmxpbmUgPSB0cnVlLA0KICBwcmVlbXB0aWJsZSA9IHRydWUsDQogIG15bm9kZSA9IDB4
YzExN2YzNDAgPHJjdV9wcmVlbXB0X3N0YXRlPiwNCiAgZ3JwbWFzayA9IDEyOCwNCiAgbnh0bGlz
dCA9IDB4ZGVjMzJhNmMsDQogIG54dHRhaWwgPSB7MHhjNTQ2MDZjNCwgMHhlNmZjZjEwYywgMHhl
NmZjZjEwYywgMHhlNmZjZjEwY30sDQogIG54dGNvbXBsZXRlZCA9IHswLCA1ODc4LCA1ODc4LCA1
ODc4fSwNCiAgcWxlbl9sYXp5ID0gMSwNCiAgcWxlbiA9IDMwLA0KICBxbGVuX2xhc3RfZnFzX2No
ZWNrID0gMCwNCiAgbl9jYnNfaW52b2tlZCA9IDMxOTk4LA0KICBuX25vY2JzX2ludm9rZWQgPSAw
LA0KICBuX2Nic19vcnBoYW5lZCA9IDAsDQogIG5fY2JzX2Fkb3B0ZWQgPSAwLA0KICBuX2ZvcmNl
X3FzX3NuYXAgPSAxNDI4LA0KICBibGltaXQgPSAxMCwNCiAgZHludGlja3MgPSAweGM1NDYwNzU4
LA0KICBkeW50aWNrc19zbmFwID0gNTc4NDYsDQogIGR5bnRpY2tzX2ZxcyA9IDU0LA0KICBvZmZs
aW5lX2ZxcyA9IDAsDQogIG5fcmN1X3BlbmRpbmcgPSA0NzUwMiwNCiAgbl9ycF9xc19wZW5kaW5n
ID0gMiwNCiAgbl9ycF9yZXBvcnRfcXMgPSAyMTQyLA0KICBuX3JwX2NiX3JlYWR5ID0gMzcsDQog
IG5fcnBfY3B1X25lZWRzX2dwID0gNDAwNDksDQogIG5fcnBfZ3BfY29tcGxldGVkID0gMTIyMywN
CiAgbl9ycF9ncF9zdGFydGVkID0gNjYxLA0KICBuX3JwX25lZWRfbm90aGluZyA9IDMzOTAsDQog
IGJhcnJpZXJfaGVhZCA9IHsNCiAgICBuZXh0ID0gMHgwLA0KICAgIGZ1bmMgPSAweDANCiAgfSwN
CiAgb29tX2hlYWQgPSB7DQogICAgbmV4dCA9IDB4MCwNCiAgICBmdW5jID0gMHgwDQogIH0sDQog
IGNwdSA9IDcsDQogIHJzcCA9IDB4YzExN2YzNDAgPHJjdV9wcmVlbXB0X3N0YXRlPg0KfQ0K
--089e0118401096f66b050a7fffa1
Content-Type: text/plain; charset=US-ASCII; name="rcu_preept_state.txt"
Content-Disposition: attachment; filename="rcu_preept_state.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3uc5wsh2

DQpyY3VfcHJlZW1wdF9zdGF0ZSA9ICQ5ID0gew0KICBub2RlID0ge3sNCiAgICAgIGxvY2sgPSB7
DQogICAgICAgIHJhd19sb2NrID0gew0KICAgICAgICAgIHsNCiAgICAgICAgICAgIHNsb2NrID0g
MzEyOTg1MDUwOSwNCiAgICAgICAgICAgIHRpY2tldHMgPSB7DQogICAgICAgICAgICAgIG93bmVy
ID0gNDc3NTcsDQogICAgICAgICAgICAgIG5leHQgPSA0Nzc1Nw0KICAgICAgICAgICAgfQ0KICAg
ICAgICAgIH0NCiAgICAgICAgfSwNCiAgICAgICAgbWFnaWMgPSAzNzM1ODk5ODIxLA0KICAgICAg
ICBvd25lcl9jcHUgPSA0Mjk0OTY3Mjk1LA0KICAgICAgICBvd25lciA9IDB4ZmZmZmZmZmYNCiAg
ICAgIH0sDQogICAgICBncG51bSA9IDU4NzcsDQogICAgICBjb21wbGV0ZWQgPSA1ODc3LA0KICAg
ICAgcXNtYXNrID0gMCwNCiAgICAgIGV4cG1hc2sgPSAwLA0KICAgICAgcXNtYXNraW5pdCA9IDI0
MCwNCiAgICAgIGdycG1hc2sgPSAwLA0KICAgICAgZ3JwbG8gPSAwLA0KICAgICAgZ3JwaGkgPSA3
LA0KICAgICAgZ3JwbnVtID0gMCAnXDAwMCcsDQogICAgICBsZXZlbCA9IDAgJ1wwMDAnLA0KICAg
ICAgcGFyZW50ID0gMHgwLA0KICAgICAgYmxrZF90YXNrcyA9IHsNCiAgICAgICAgbmV4dCA9IDB4
YzExN2YzNzggPHJjdV9wcmVlbXB0X3N0YXRlKzU2PiwNCiAgICAgICAgcHJldiA9IDB4YzExN2Yz
NzggPHJjdV9wcmVlbXB0X3N0YXRlKzU2Pg0KICAgICAgfSwNCiAgICAgIGdwX3Rhc2tzID0gMHgw
LA0KICAgICAgZXhwX3Rhc2tzID0gMHgwLA0KICAgICAgbmVlZF9mdXR1cmVfZ3AgPSB7MSwgMH0s
DQogICAgICBmcXNsb2NrID0gew0KICAgICAgICByYXdfbG9jayA9IHsNCiAgICAgICAgICB7DQog
ICAgICAgICAgICBzbG9jayA9IDAsDQogICAgICAgICAgICB0aWNrZXRzID0gew0KICAgICAgICAg
ICAgICBvd25lciA9IDAsDQogICAgICAgICAgICAgIG5leHQgPSAwDQogICAgICAgICAgICB9DQog
ICAgICAgICAgfQ0KICAgICAgICB9LA0KICAgICAgICBtYWdpYyA9IDM3MzU4OTk4MjEsDQogICAg
ICAgIG93bmVyX2NwdSA9IDQyOTQ5NjcyOTUsDQogICAgICAgIG93bmVyID0gMHhmZmZmZmZmZg0K
ICAgICAgfQ0KICAgIH19LA0KICBsZXZlbCA9IHsweGMxMTdmMzQwIDxyY3VfcHJlZW1wdF9zdGF0
ZT59LA0KICBsZXZlbGNudCA9IHsxLCAwLCAwLCAwLCAwfSwNCiAgbGV2ZWxzcHJlYWQgPSAiXGIi
LA0KICByZGEgPSAweGMxMTVlNmIwIDxyY3VfcHJlZW1wdF9kYXRhPiwNCiAgY2FsbCA9IDB4YzAx
OTc1YWMgPGNhbGxfcmN1PiwNCiAgZnFzX3N0YXRlID0gMCAnXDAwMCcsDQogIGJvb3N0ID0gMCAn
XDAwMCcsDQogIGdwbnVtID0gNTg3NywNCiAgY29tcGxldGVkID0gNTg3NywNCiAgZ3Bfa3RocmVh
ZCA9IDB4ZjBjOWU2MDAsDQogIGdwX3dxID0gew0KICAgIGxvY2sgPSB7DQogICAgICB7DQogICAg
ICAgIHJsb2NrID0gew0KICAgICAgICAgIHJhd19sb2NrID0gew0KICAgICAgICAgICAgew0KICAg
ICAgICAgICAgICBzbG9jayA9IDIxNjAyMzA1OTQsDQogICAgICAgICAgICAgIHRpY2tldHMgPSB7
DQogICAgICAgICAgICAgICAgb3duZXIgPSAzMjk2MiwNCiAgICAgICAgICAgICAgICBuZXh0ID0g
MzI5NjINCiAgICAgICAgICAgICAgfQ0KICAgICAgICAgICAgfQ0KICAgICAgICAgIH0sDQogICAg
ICAgICAgbWFnaWMgPSAzNzM1ODk5ODIxLA0KICAgICAgICAgIG93bmVyX2NwdSA9IDQyOTQ5Njcy
OTUsDQogICAgICAgICAgb3duZXIgPSAweGZmZmZmZmZmDQogICAgICAgIH0NCiAgICAgIH0NCiAg
ICB9LA0KICAgIHRhc2tfbGlzdCA9IHsNCiAgICAgIG5leHQgPSAweGYwY2QxZjIwLA0KICAgICAg
cHJldiA9IDB4ZjBjZDFmMjANCiAgICB9DQogIH0sDQogIGdwX2ZsYWdzID0gMSwNCiAgb3JwaGFu
X2xvY2sgPSB7DQogICAgcmF3X2xvY2sgPSB7DQogICAgICB7DQogICAgICAgIHNsb2NrID0gMzI3
Njg1LA0KICAgICAgICB0aWNrZXRzID0gew0KICAgICAgICAgIG93bmVyID0gNSwNCiAgICAgICAg
ICBuZXh0ID0gNQ0KICAgICAgICB9DQogICAgICB9DQogICAgfSwNCiAgICBtYWdpYyA9IDM3MzU4
OTk4MjEsDQogICAgb3duZXJfY3B1ID0gNDI5NDk2NzI5NSwNCiAgICBvd25lciA9IDB4ZmZmZmZm
ZmYNCiAgfSwNCiAgb3JwaGFuX254dGxpc3QgPSAweDAsDQogIG9ycGhhbl9ueHR0YWlsID0gMHhj
MTE3ZjQ5MCA8cmN1X3ByZWVtcHRfc3RhdGUrMzM2PiwNCiAgb3JwaGFuX2RvbmVsaXN0ID0gMHgw
LA0KICBvcnBoYW5fZG9uZXRhaWwgPSAweGMxMTdmNDk4IDxyY3VfcHJlZW1wdF9zdGF0ZSszNDQ+
LA0KICBxbGVuX2xhenkgPSAwLA0KICBxbGVuID0gMCwNCiAgb25vZmZfbXV0ZXggPSB7DQogICAg
Y291bnQgPSB7DQogICAgICBjb3VudGVyID0gMQ0KICAgIH0sDQogICAgd2FpdF9sb2NrID0gew0K
ICAgICAgew0KICAgICAgICBybG9jayA9IHsNCiAgICAgICAgICByYXdfbG9jayA9IHsNCiAgICAg
ICAgICAgIHsNCiAgICAgICAgICAgICAgc2xvY2sgPSA4MTE0NzkxMzQsDQogICAgICAgICAgICAg
IHRpY2tldHMgPSB7DQogICAgICAgICAgICAgICAgb3duZXIgPSAxMjM4MiwNCiAgICAgICAgICAg
ICAgICBuZXh0ID0gMTIzODINCiAgICAgICAgICAgICAgfQ0KICAgICAgICAgICAgfQ0KICAgICAg
ICAgIH0sDQogICAgICAgICAgbWFnaWMgPSAzNzM1ODk5ODIxLA0KICAgICAgICAgIG93bmVyX2Nw
dSA9IDQyOTQ5NjcyOTUsDQogICAgICAgICAgb3duZXIgPSAweGZmZmZmZmZmDQogICAgICAgIH0N
CiAgICAgIH0NCiAgICB9LA0KICAgIHdhaXRfbGlzdCA9IHsNCiAgICAgIG5leHQgPSAweGMxMTdm
NGJjIDxyY3VfcHJlZW1wdF9zdGF0ZSszODA+LA0KICAgICAgcHJldiA9IDB4YzExN2Y0YmMgPHJj
dV9wcmVlbXB0X3N0YXRlKzM4MD4NCiAgICB9LA0KICAgIG93bmVyID0gMHgwLA0KICAgIG5hbWUg
PSAweDAsDQogICAgbWFnaWMgPSAweGMxMTdmNGE4IDxyY3VfcHJlZW1wdF9zdGF0ZSszNjA+DQog
IH0sDQogIGJhcnJpZXJfbXV0ZXggPSB7DQogICAgY291bnQgPSB7DQogICAgICBjb3VudGVyID0g
MQ0KICAgIH0sDQogICAgd2FpdF9sb2NrID0gew0KICAgICAgew0KICAgICAgICBybG9jayA9IHsN
CiAgICAgICAgICByYXdfbG9jayA9IHsNCiAgICAgICAgICAgIHsNCiAgICAgICAgICAgICAgc2xv
Y2sgPSAwLA0KICAgICAgICAgICAgICB0aWNrZXRzID0gew0KICAgICAgICAgICAgICAgIG93bmVy
ID0gMCwNCiAgICAgICAgICAgICAgICBuZXh0ID0gMA0KICAgICAgICAgICAgICB9DQogICAgICAg
ICAgICB9DQogICAgICAgICAgfSwNCiAgICAgICAgICBtYWdpYyA9IDM3MzU4OTk4MjEsDQogICAg
ICAgICAgb3duZXJfY3B1ID0gNDI5NDk2NzI5NSwNCiAgICAgICAgICBvd25lciA9IDB4ZmZmZmZm
ZmYNCiAgICAgICAgfQ0KICAgICAgfQ0KICAgIH0sDQogICAgd2FpdF9saXN0ID0gew0KICAgICAg
bmV4dCA9IDB4YzExN2Y0ZTQgPHJjdV9wcmVlbXB0X3N0YXRlKzQyMD4sDQogICAgICBwcmV2ID0g
MHhjMTE3ZjRlNCA8cmN1X3ByZWVtcHRfc3RhdGUrNDIwPg0KICAgIH0sDQogICAgb3duZXIgPSAw
eDAsDQogICAgbmFtZSA9IDB4MCwNCiAgICBtYWdpYyA9IDB4YzExN2Y0ZDAgPHJjdV9wcmVlbXB0
X3N0YXRlKzQwMD4NCiAgfSwNCiAgYmFycmllcl9jcHVfY291bnQgPSB7DQogICAgY291bnRlciA9
IDANCiAgfSwNCiAgYmFycmllcl9jb21wbGV0aW9uID0gew0KICAgIGRvbmUgPSAwLA0KICAgIHdh
aXQgPSB7DQogICAgICBsb2NrID0gew0KICAgICAgICB7DQogICAgICAgICAgcmxvY2sgPSB7DQog
ICAgICAgICAgICByYXdfbG9jayA9IHsNCiAgICAgICAgICAgICAgew0KICAgICAgICAgICAgICAg
IHNsb2NrID0gMCwNCiAgICAgICAgICAgICAgICB0aWNrZXRzID0gew0KICAgICAgICAgICAgICAg
ICAgb3duZXIgPSAwLA0KICAgICAgICAgICAgICAgICAgbmV4dCA9IDANCiAgICAgICAgICAgICAg
ICB9DQogICAgICAgICAgICAgIH0NCiAgICAgICAgICAgIH0sDQogICAgICAgICAgICBtYWdpYyA9
IDAsDQogICAgICAgICAgICBvd25lcl9jcHUgPSAwLA0KICAgICAgICAgICAgb3duZXIgPSAweDAN
CiAgICAgICAgICB9DQogICAgICAgIH0NCiAgICAgIH0sDQogICAgICB0YXNrX2xpc3QgPSB7DQog
ICAgICAgIG5leHQgPSAweDAsDQogICAgICAgIHByZXYgPSAweDANCiAgICAgIH0NCiAgICB9DQog
IH0sDQogIG5fYmFycmllcl9kb25lID0gMCwNCiAgZXhwZWRpdGVkX3N0YXJ0ID0gew0KICAgIGNv
dW50ZXIgPSAwDQogIH0sDQogIGV4cGVkaXRlZF9kb25lID0gew0KICAgIGNvdW50ZXIgPSAwDQog
IH0sDQogIGV4cGVkaXRlZF93cmFwID0gew0KICAgIGNvdW50ZXIgPSAwDQogIH0sDQogIGV4cGVk
aXRlZF90cnlmYWlsID0gew0KICAgIGNvdW50ZXIgPSAwDQogIH0sDQogIGV4cGVkaXRlZF93b3Jr
ZG9uZTEgPSB7DQogICAgY291bnRlciA9IDANCiAgfSwNCiAgZXhwZWRpdGVkX3dvcmtkb25lMiA9
IHsNCiAgICBjb3VudGVyID0gMA0KICB9LA0KICBleHBlZGl0ZWRfbm9ybWFsID0gew0KICAgIGNv
dW50ZXIgPSAwDQogIH0sDQogIGV4cGVkaXRlZF9zdG9wcGVkY3B1cyA9IHsNCiAgICBjb3VudGVy
ID0gMA0KICB9LA0KICBleHBlZGl0ZWRfZG9uZV90cmllcyA9IHsNCiAgICBjb3VudGVyID0gMA0K
ICB9LA0KICBleHBlZGl0ZWRfZG9uZV9sb3N0ID0gew0KICAgIGNvdW50ZXIgPSAwDQogIH0sDQog
IGV4cGVkaXRlZF9kb25lX2V4aXQgPSB7DQogICAgY291bnRlciA9IDANCiAgfSwNCiAgamlmZmll
c19mb3JjZV9xcyA9IDQyOTQ5NjM5MTcsDQogIG5fZm9yY2VfcXMgPSA0MDI4LA0KICBuX2ZvcmNl
X3FzX2xoID0gMCwNCiAgbl9mb3JjZV9xc19uZ3AgPSAwLA0KICBncF9zdGFydCA9IDQyOTQ5NjM5
MTEsDQogIGppZmZpZXNfc3RhbGwgPSA0Mjk0OTY2MDExLA0KICBncF9tYXggPSAxNywNCiAgbmFt
ZSA9IDB4YzBkODMzYWIgInJjdV9wcmVlbXB0IiwNCiAgYWJiciA9IDExMiAncCcsDQogIGZsYXZv
cnMgPSB7DQogICAgbmV4dCA9IDB4YzExN2YyZWMgPHJjdV9iaF9zdGF0ZSs1NTY+LA0KICAgIHBy
ZXYgPSAweGMxMTdmMzAwIDxyY3Vfc3RydWN0X2ZsYXZvcnM+DQogIH0sDQogIHdha2V1cF93b3Jr
ID0gew0KICAgIGZsYWdzID0gMywNCiAgICBsbG5vZGUgPSB7DQogICAgICBuZXh0ID0gMHgwDQog
ICAgfSwNCiAgICBmdW5jID0gMHhjMDE5NWFhOCA8cnNwX3dha2V1cD4NCiAgfQ0KDQoNCg==
--089e0118401096f66b050a7fffa1--
