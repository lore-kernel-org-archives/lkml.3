Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946121AbaD3WaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:30:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21016 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946081AbaD3WaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:30:14 -0400
Message-ID: <5361795C.2040205@oracle.com>
Date: Wed, 30 Apr 2014 18:29:48 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4 v2] rcu: Have the RCU tracepoints use the tracepoint_string
 infrastructure
References: <20130802023933.677590002@goodmis.org> <20130802024222.969067017@goodmis.org>
In-Reply-To: <20130802024222.969067017@goodmis.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 10:39 PM, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Currently, RCU tracepoints save only a pointer to strings in the
> ring buffer. When displayed via the /sys/kernel/debug/tracing/trace file
> they are referenced like the printf "%s" that looks at the address
> in the ring buffer and prints out the string it points too. This requires
> that the strings are constant and persistent in the kernel.
> 
> The problem with this is for tools like trace-cmd and perf that read the
> binary data from the buffers but have no access to the kernel memory to
> find out what string is represented by the address in the buffer.
> 
> By using the tracepoint_string infrastructure, the RCU tracepoint strings
> can be exported such that userspace tools can map the addresses to
> the strings.
> 
>  # cat /sys/kernel/debug/tracing/printk_formats
> 0xffffffff81a4a0e8 : "rcu_preempt"
> 0xffffffff81a4a0f4 : "rcu_bh"
> 0xffffffff81a4a100 : "rcu_sched"
> 0xffffffff818437a0 : "cpuqs"
> 0xffffffff818437a6 : "rcu_sched"
> 0xffffffff818437a0 : "cpuqs"
> 0xffffffff818437b0 : "rcu_bh"
> 0xffffffff818437b7 : "Start context switch"
> 0xffffffff818437cc : "End context switch"
> 0xffffffff818437a0 : "cpuqs"
> [...]
> 
> Now userspaces tools can display:
> 
>  rcu_utilization:      Start context switch
>  rcu_dyntick:          Start 1 0
>  rcu_utilization:      End context switch
>  rcu_batch_start:      rcu_preempt CBs=0/5 bl=10
>  rcu_dyntick:          End 0 140000000000000
>  rcu_invoke_callback:  rcu_preempt rhp=0xffff880071c0d600 func=proc_i_callback
>  rcu_invoke_callback:  rcu_preempt rhp=0xffff880077b5b230 func=__d_free
>  rcu_dyntick:          Start 140000000000000 0
>  rcu_invoke_callback:  rcu_preempt rhp=0xffff880077563980 func=file_free_rcu
>  rcu_batch_end:        rcu_preempt CBs-invoked=3 idle=>c<>c<>c<>c<
>  rcu_utilization:      End RCU core
>  rcu_grace_period:     rcu_preempt 9741 start
>  rcu_dyntick:          Start 1 0
>  rcu_dyntick:          End 0 140000000000000
>  rcu_dyntick:          Start 140000000000000 0
> 
> Instead of:
> 
>  rcu_utilization:      ffffffff81843110
>  rcu_future_grace_period: ffffffff81842f1d 9939 9939 9940 0 0 3 ffffffff81842f32
>  rcu_batch_start:      ffffffff81842f1d CBs=0/4 bl=10
>  rcu_future_grace_period: ffffffff81842f1d 9939 9939 9940 0 0 3 ffffffff81842f3c
>  rcu_grace_period:     ffffffff81842f1d 9939 ffffffff81842f80
>  rcu_invoke_callback:  ffffffff81842f1d rhp=0xffff88007888aac0 func=file_free_rcu
>  rcu_grace_period:     ffffffff81842f1d 9939 ffffffff81842f95
>  rcu_invoke_callback:  ffffffff81842f1d rhp=0xffff88006aeb4600 func=proc_i_callback
>  rcu_future_grace_period: ffffffff81842f1d 9939 9939 9940 0 0 3 ffffffff81842f32
>  rcu_future_grace_period: ffffffff81842f1d 9939 9939 9940 0 0 3 ffffffff81842f3c
>  rcu_invoke_callback:  ffffffff81842f1d rhp=0xffff880071cb9fc0 func=__d_free
>  rcu_grace_period:     ffffffff81842f1d 9939 ffffffff81842f80
>  rcu_invoke_callback:  ffffffff81842f1d rhp=0xffff88007888ae80 func=file_free_rcu
>  rcu_batch_end:        ffffffff81842f1d CBs-invoked=4 idle=>c<>c<>c<>c<
>  rcu_utilization:      ffffffff8184311f
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Hi Steven,

It seems that this patch is causing the following for me on -next kernel:

[ 1202.780629] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1202.782056] Dumping ftrace buffer:
[ 1202.783243]    (ftrace buffer empty)
[ 1202.784253] Modules linked in:
[ 1202.784778] CPU: 7 PID: 65 Comm: rcuos/0 Tainted: G        W     3.15.0-rc3-next-201
40429-sasha-00015-g7c7e0a7-dirty #427
[ 1202.787872] task: ffff880035c63000 ti: ffff880035c5c000 task.ti: ffff880035c5c000
[ 1202.788722] RIP: rcu_note_context_switch (include/trace/events/rcu.h:20 kernel/rcu/tree.c:216)
[ 1202.790083] RSP: 0018:ffff880035c5dcc8  EFLAGS: 00010286
[ 1202.790468] RAX: 6b6b6b6b6b6b6b6b RBX: ffff880034608de8 RCX: 0000000000000001
[ 1202.790468] RDX: 0000000000000000 RSI: ffffffffa56dd9ef RDI: 6b6b6b6b6b6b6b6b
[ 1202.790468] RBP: ffff880035c5dce8 R08: 0000000000000000 R09: 0000000000000000
[ 1202.790468] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffa56dd9ef
[ 1202.790468] R13: 0000000000000007 R14: ffffffffa6aca2c3 R15: ffff880036dd0080
[ 1202.790468] FS:  0000000000000000(0000) GS:ffff8801ecc00000(0000) knlGS:0000000000000000
[ 1202.790468] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1202.790468] CR2: 0000000000000004 CR3: 0000000025e2d000 CR4: 00000000000006a0
[ 1202.790468] DR0: 00000000006de000 DR1: 00000000006de000 DR2: 0000000000000000
[ 1202.790468] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 1202.790468] Stack:
[ 1202.790468]  0000000000000000 ffff880036dd01f0 ffff8801ecdd7840 0000000000000007
[ 1202.790468]  ffff880035c5dd68 ffffffffa4571dee ffff880035c5dd08 ffff880036dd01f0
[ 1202.790468]  ffff880035c5dfd8 00000000001d7840 00000000001d7840 00000000001d7840
[ 1202.790468] Call Trace:
[ 1202.790468] __schedule (arch/x86/include/asm/preempt.h:22 kernel/sched/core.c:2585 kernel/sched/core.c:2678)
[ 1202.790468] ? prepare_to_wait_event (kernel/sched/wait.c:218 kernel/sched/wait.c:216)
[ 1202.790468] schedule (kernel/sched/core.c:2765)
[ 1202.790468] rcu_nocb_kthread (kernel/rcu/tree_plugin.h:2234 (discriminator 9))
[ 1202.790468] ? rcu_nocb_kthread (kernel/rcu/rcu.h:84 kernel/rcu/tree_plugin.h:2280)
[ 1202.790468] ? preempt_count_sub (kernel/sched/core.c:2541)
[ 1202.790468] ? bit_waitqueue (kernel/sched/wait.c:291)
[ 1202.790468] ? rcu_cpu_notify (kernel/rcu/tree_plugin.h:2220)
[ 1202.790468] kthread (kernel/kthread.c:210)
[ 1202.790468] ? kthread_create_on_node (kernel/kthread.c:176)
[ 1202.790468] ret_from_fork (arch/x86/kernel/entry_64.S:552)
[ 1202.790468] ? kthread_create_on_node (kernel/kthread.c:176)
[ 1202.790468] Code: 65 ff 0c 25 a0 da 00 00 0f 84 fa 00 00 00 eb 28 0f 1f 84 00 00 00 00 00 48 8b 03 0f 1f 44 00 00 48 8b 7b 08 4c 89 e6 48 83 c3 10 <ff> d0 48 8b 03 48 85 c0 75 eb eb c9 90 44 89 ef e8 e8 71 ff ff
[ 1202.790468] RIP rcu_note_context_switch (include/trace/events/rcu.h:20 kernel/rcu/tree.c:216)
[ 1202.790468]  RSP <ffff880035c5dcc8>


Thanks,
Sasha
