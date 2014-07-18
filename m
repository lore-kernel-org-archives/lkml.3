Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbaGRMz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:55:26 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46265 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaGRMzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:55:24 -0400
Date: Fri, 18 Jul 2014 05:55:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Create rcuo kthreads only for
 onlined CPUs
Message-ID: <20140718125516.GH8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140714100604.GA9905@linux.vnet.ibm.com>
 <1405332404-10094-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1405332404-10094-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <53C9023D.3090007@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C9023D.3090007@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071812-9332-0000-0000-0000016D649F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 07:17:17AM -0400, Sasha Levin wrote:
> On 07/14/2014 06:06 AM, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > RCU currently uses for_each_possible_cpu() to spawn rcuo kthreads,
> > which can result in more rcuo kthreads than one would expect, for
> > example, derRichard reported 64 CPUs worth of rcuo kthreads on an
> > 8-CPU image.  This commit therefore creates rcuo kthreads only for
> > those CPUs that actually come online.
> > 
> > Reported-by: derRichard
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Hey Paul,
> 
> Me again. :)
> 
> It seems that this patch moved thread initialization to a point way
> too early during boot, before rest_init() which initializes kthreadd_task
> runs, so creating a new kthread triggers a NULL ptr deref:

This should be fixed by commit 918179699e4a in -rcu.  My guess is that
you are instead using commit c6e2955266d14, which, said to say, made it
into -next yesterday.  :-(

If my guess is wrong, please let me know!

							Thanx, Paul

> [    0.000000] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    0.000000] IP: wake_up_process (kernel/sched/core.c:1768)
> [    0.000000] PGD 0
> [    0.000000] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W      3.16.0-rc5-next-20140718-sasha-00046-g054cefc #898
> [    0.000000] task: ffffffff9fa2d580 ti: ffffffff9fa29580 task.ti: ffffffff9fa29580
> [    0.000000] RIP: wake_up_process (kernel/sched/core.c:1768)
> [    0.000000] RSP: 0000:ffffffff9fa2d238  EFLAGS: 00010046
> [    0.000000] RAX: ffffffff9fa2d580 RBX: 0000000000000000 RCX: 0000000000000000
> [    0.000000] RDX: 0000000000000000 RSI: ffffffff9f2f4567 RDI: ffffffff9f28c581
> [    0.000000] RBP: ffffffff9fa2d240 R08: 0000000000000001 R09: 0000000000000001
> [    0.000000] R10: 0000000000000000 R11: 3d3d3d3d3d3d3d3d R12: ffffffff9fab3000
> [    0.000000] R13: ffffffff99288bb0 R14: ffffffff9f18a72b R15: ffff8806f2050000
> [    0.000000] FS:  0000000000000000(0000) GS:ffff8805f3a00000(0000) knlGS:0000000000000000
> [    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    0.000000] CR2: 0000000000000000 CR3: 000000001fa22000 CR4: 00000000000006b0
> [    0.000000] Stack:
> [    0.000000]  00000000ffffffff ffffffff9fa2d388 ffffffff991fd3e7 0000000000000002
> [    0.000000]  ffffffff9fa2d580 ffffffffa13b04a0 ffffffff00000000 dead4ead00000000
> [    0.000000]  ffffffffffffffff ffffffffffffffff ffffffffa13ade38 0000000000000000
> [    0.000000] Call Trace:
> [    0.000000]  <UNK>
> [    0.000000] kthread_create_on_node (kernel/kthread.c:294)
> [    0.000000] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
> [    0.000000] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
> [    0.000000] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [    0.000000] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2639 (discriminator 8))
> [    0.000000] rcu_spawn_one_boost_kthread (kernel/rcu/tree_plugin.h:1348)
> [    0.000000] rcu_cpu_notify (kernel/rcu/tree.c:3454)
> [    0.000000] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [    0.000000] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2639 (discriminator 8))
> [    0.000000] rcu_init (kernel/rcu/tree.c:3753)
> [    0.000000] start_kernel (init/main.c:581)
> [    0.000000] ? early_idt_handlers (arch/x86/kernel/head_64.S:344)
> [    0.000000] x86_64_start_reservations (arch/x86/kernel/head64.c:194)
> [    0.000000] x86_64_start_kernel (arch/x86/kernel/head64.c:183)
> [ 0.000000] Code: 55 b0 8b 40 18 e9 2c fd ff ff 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 e8 1b 0b c9 04 55 48 89 e5 53 48 89 fb e8 ae 36 21 00 <48> 8b 03 a8 0c 75 17 48 89 df 31 d2 be 03 00 00 00 e8 98 f9 ff
> All code
> ========
>    0:   55                      push   %rbp
>    1:   b0 8b                   mov    $0x8b,%al
>    3:   40 18 e9                sbb    %bpl,%cl
>    6:   2c fd                   sub    $0xfd,%al
>    8:   ff                      (bad)
>    9:   ff 66 66                jmpq   *0x66(%rsi)
>    c:   66 66 66 66 2e 0f 1f    data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
>   13:   84 00 00 00 00 00
>   19:   e8 1b 0b c9 04          callq  0x4c90b39
>   1e:   55                      push   %rbp
>   1f:   48 89 e5                mov    %rsp,%rbp
>   22:   53                      push   %rbx
>   23:   48 89 fb                mov    %rdi,%rbx
>   26:   e8 ae 36 21 00          callq  0x2136d9
>   2b:*  48 8b 03                mov    (%rbx),%rax              <-- trapping instruction
>   2e:   a8 0c                   test   $0xc,%al
>   30:   75 17                   jne    0x49
>   32:   48 89 df                mov    %rbx,%rdi
>   35:   31 d2                   xor    %edx,%edx
>   37:   be 03 00 00 00          mov    $0x3,%esi
>   3c:   e8 98 f9 ff 00          callq  0xfff9d9
> 
> Code starting with the faulting instruction
> ===========================================
>    0:   48 8b 03                mov    (%rbx),%rax
>    3:   a8 0c                   test   $0xc,%al
>    5:   75 17                   jne    0x1e
>    7:   48 89 df                mov    %rbx,%rdi
>    a:   31 d2                   xor    %edx,%edx
>    c:   be 03 00 00 00          mov    $0x3,%esi
>   11:   e8 98 f9 ff 00          callq  0xfff9ae
> [    0.000000] RIP wake_up_process (kernel/sched/core.c:1768)
> [    0.000000]  RSP <ffffffff9fa2d238>
> [    0.000000] CR2: 0000000000000000
> 
> 
> Thanks,
> Sasha
> 

