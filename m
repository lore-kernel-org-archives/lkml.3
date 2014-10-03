Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaJCEvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 00:51:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50795 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaJCEvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 00:51:20 -0400
Message-ID: <542E2B05.5080607@oracle.com>
Date: Fri, 03 Oct 2014 00:50:13 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: oleg@redhat.com
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, dvlasenk@redhat.com, tglx@linutronix.de
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using THUNK
 helpers
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org>
In-Reply-To: <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 11:02 AM, tip-bot for Oleg Nesterov wrote:
> Commit-ID:  0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
> Gitweb:     http://git.kernel.org/tip/0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
> Author:     Oleg Nesterov <oleg@redhat.com>
> AuthorDate: Sun, 21 Sep 2014 20:41:53 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 24 Sep 2014 15:15:38 +0200
> 
> x86: Speed up ___preempt_schedule*() by using THUNK helpers
> 
> ___preempt_schedule() does SAVE_ALL/RESTORE_ALL but this is
> suboptimal, we do not need to save/restore the callee-saved
> register. And we already have arch/x86/lib/thunk_*.S which
> implements the similar asm wrappers, so it makes sense to
> redefine ___preempt_schedule() as "THUNK ..." and remove
> preempt.S altogether.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-by: Andy Lutomirski <luto@amacapital.net>
> Cc: Denys Vlasenko <dvlasenk@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Link: http://lkml.kernel.org/r/20140921184153.GA23727@redhat.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---

Hi Oleg,

I *think* that this patch is causing the following trace (arch/x86/lib/thunk_64.S:44
is new code introduced by this patch):


[  921.908530] kernel BUG at kernel/sched/core.c:2702!
[  921.909159] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  921.910084] Dumping ftrace buffer:
[  921.910626]    (ftrace buffer empty)
[  921.911178] Modules linked in:
[  921.915690] CPU: 18 PID: 9489 Comm: trinity-c195 Not tainted 3.17.0-rc7-next-20141002-sasha-00031-gbdb4244 #1273
[  921.917016] task: ffff8802bd748000 ti: ffff8802bda3c000 task.ti: ffff8802bda3c000
[  921.917752] RIP: __schedule (kernel/sched/core.c:2702 kernel/sched/core.c:2808)
[  921.917752] RSP: 0018:ffff8802bda3c360  EFLAGS: 00010297
[  921.917752] RAX: ffff8802bda3c000 RBX: ffff8808501e2a00 RCX: 0000000000000001
[  921.917752] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000286
[  921.917752] RBP: ffff8802bda3c3c0 R08: 000000000001aa50 R09: 0000000000000000
[  921.917752] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000012
[  921.917752] R13: ffff8808501e2a00 R14: 0000000000000002 R15: ffff8802bda3c428
[  921.917752] FS:  00007f5475cc2700(0000) GS:ffff880850000000(0000) knlGS:0000000000000000
[  921.917752] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  921.917752] CR2: 00007f5475abe60c CR3: 00000002bebab000 CR4: 00000000000006a0
[  921.917752] DR0: 00000000006f0000 DR1: 0000000000000000 DR2: 0000000000000000
[  921.917752] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  921.917752] Stack:
[  921.917752]  000000000001aa50 ffff8802bd748000 ffff8802bda3ffd8 00000000001e2a00
[  921.917752]  00000000001e2a00 ffff8802bd748000 ffff8802bda3c3a0 00000000001e2a00
[  921.917752]  ffff8802bd748000 000000000001a9ea 0000000000000002 ffff8802bda3c428
[  921.917752] Call Trace:
[  921.917752] schedule_user (kernel/sched/core.c:2894 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:20 kernel/sched/core.c:2909)
[  921.917752] int_careful (arch/x86/kernel/entry_64.S:560)
[  921.917752] ? retint_careful (arch/x86/kernel/entry_64.S:889)
[  921.917752] ? preempt_schedule (./arch/x86/include/asm/preempt.h:80 (discriminator 1) kernel/sched/core.c:2943 (discriminator 1))
[  921.917752] ? preempt_schedule_context (./arch/x86/include/asm/preempt.h:75 kernel/context_tracking.c:143)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  921.917752] ? __schedule (kernel/sched/core.c:2900)
[  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  921.917752] ? ftrace_ops_control_func (kernel/trace/ftrace.c:4780)
[  921.917752] ? ftrace_call (arch/x86/kernel/mcount_64.S:56)
[  921.917752] ? retint_careful (arch/x86/kernel/entry_64.S:886)
[  921.917752] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  921.917752] ? schedule_user (kernel/sched/core.c:2900)
[  921.917752] ? schedule_user (kernel/sched/core.c:2900)
[  921.917752] ? retint_careful (arch/x86/kernel/entry_64.S:889)
[ 921.917752] Code: 48 c7 c2 50 2d 72 97 be 72 00 00 00 48 c7 c7 eb 26 73 97 c6 05 37 b3 ac 02 01 e8 d4 06 c6 fc e9 0d fb ff ff 0f 1f 80 00 00 00 00 <0f> 0b 66 0f 1f 44 00 00 48 8b 45 c8 48 8b 00 48 83 f8 40 0f 84
All code
========
   0:	48 c7 c2 50 2d 72 97 	mov    $0xffffffff97722d50,%rdx
   7:	be 72 00 00 00       	mov    $0x72,%esi
   c:	48 c7 c7 eb 26 73 97 	mov    $0xffffffff977326eb,%rdi
  13:	c6 05 37 b3 ac 02 01 	movb   $0x1,0x2acb337(%rip)        # 0x2acb351
  1a:	e8 d4 06 c6 fc       	callq  0xfffffffffcc606f3
  1f:	e9 0d fb ff ff       	jmpq   0xfffffffffffffb31
  24:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  2b:*	0f 0b                	ud2    		<-- trapping instruction
  2d:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  33:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  37:	48 8b 00             	mov    (%rax),%rax
  3a:	48 83 f8 40          	cmp    $0x40,%rax
  3e:	0f                   	.byte 0xf
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   c:	48 8b 00             	mov    (%rax),%rax
   f:	48 83 f8 40          	cmp    $0x40,%rax
  13:	0f                   	.byte 0xf
  14:	84 00                	test   %al,(%rax)
[  921.917752] RIP __schedule (kernel/sched/core.c:2702 kernel/sched/core.c:2808)
[  921.917752]  RSP <ffff8802bda3c360>
[  922.457643] BUG: unable to handle kernel paging request at fffffffc310ead68
[  922.458855] IP: cpuacct_charge (kernel/sched/cpuacct.c:247)
[  922.467627] PGD 17e23067 PUD 0
[  922.467627] Thread overran stack, or stack corrupted
[  922.467627] Oops: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[  922.467627] Dumping ftrace buffer:
[  922.467627]    (ftrace buffer empty)
[  922.467627] Modules linked in:
[  922.467627] CPU: 18 PID: 9489 Comm: trinity-c195 Tainted: G      D        3.17.0-rc7-next-20141002-sasha-00031-gbdb4244 #1273
[  922.467627] task: ffff8802bd748000 ti: ffff8802bda3c000 task.ti: ffff8802bda3c000
[  922.467627] RIP: cpuacct_charge (kernel/sched/cpuacct.c:247)
[  922.467627] RSP: 0018:ffff880850003d28  EFLAGS: 00010046
[  922.467627] RAX: 000000000000f128 RBX: 00000000932539cd RCX: ffffffff932539cd
[  922.467627] RDX: ffffffff97ea5500 RSI: 0000000000000000 RDI: 0000000000000086
[  922.467627] RBP: ffff880850003d58 R08: 0000000000000000 R09: 0000000000000001
[  922.467627] R10: 0000000000000000 R11: 0000000000009a86 R12: 00000000128d0aa7
[  922.467627] R13: ffff8802bd748000 R14: ffffffff98afaa40 R15: 0000000000000400
[  922.467627] FS:  00007f5475cc2700(0000) GS:ffff880850000000(0000) knlGS:0000000000000000
[  922.467627] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  922.467627] CR2: fffffffc310ead68 CR3: 00000002bebab000 CR4: 00000000000006a0
[  922.467627] DR0: 00000000006f0000 DR1: 0000000000000000 DR2: 0000000000000000
[  922.467627] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  922.467627] Stack:
[  922.467627]  ffffffff931bdb35 ffffffff931bdb35 ffff8802bd748068 ffff88084f106f90
[  922.467627]  00000000128d0aa7 ffff8802bd748000 ffff880850003d98 ffffffff931a7b86
[  922.467627]  000000000001aa9a ffff8802bd748068 ffff88084f106f90 0000000000000000
[  922.467627] Call Trace:
[  922.467627]  <IRQ>
[  922.467627] ? cpuacct_charge (kernel/sched/cpuacct.c:236)
[  922.467627] ? cpuacct_charge (kernel/sched/cpuacct.c:236)
[  922.467627] update_curr (kernel/sched/stats.h:259 kernel/sched/fair.c:723)
[  922.467627] task_tick_fair (kernel/sched/fair.c:2526 (discriminator 2) kernel/sched/fair.c:7512 (discriminator 2))
[  922.467627] scheduler_tick (kernel/sched/core.c:2564)
[  922.467627] update_process_times (kernel/time/timer.c:1391)
[  922.467627] tick_sched_handle.isra.14 (kernel/time/tick-sched.c:152)
[  922.467627] tick_sched_timer (kernel/time/tick-sched.c:1117)
[  922.467627] __run_hrtimer (kernel/time/hrtimer.c:1218 (discriminator 3))
[  922.467627] ? tick_sched_do_timer (kernel/time/tick-sched.c:1101)
[  922.467627] hrtimer_interrupt (kernel/time/hrtimer.c:1307)
[  922.467627] local_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:921)
[  922.467627] smp_apic_timer_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/apic/apic.c:945)
[  922.467627] apic_timer_interrupt (arch/x86/kernel/entry_64.S:999)
[  922.467627]  <EOI>
[  922.467627] ? oops_end (./arch/x86/include/asm/paravirt.h:809 arch/x86/kernel/dumpstack.c:240)
[  922.467627] die (arch/x86/kernel/dumpstack.c:313)
[  922.467627] do_trap (arch/x86/kernel/traps.c:132 arch/x86/kernel/traps.c:178)
[  922.467627] do_error_trap (arch/x86/kernel/traps.c:216 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/kernel/traps.c:220)
[  922.467627] ? __schedule (kernel/sched/core.c:2702 kernel/sched/core.c:2808)
[  922.467627] ? error_sti (arch/x86/kernel/entry_64.S:1398)
[  922.467627] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  922.467627] do_invalid_op (arch/x86/kernel/traps.c:232)
[  922.467627] invalid_op (arch/x86/kernel/entry_64.S:1125)
[  922.467627] ? __schedule (kernel/sched/core.c:2702 kernel/sched/core.c:2808)
[  922.467627] schedule_user (kernel/sched/core.c:2894 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:20 kernel/sched/core.c:2909)
[  922.467627] int_careful (arch/x86/kernel/entry_64.S:560)
[  922.467627] ? retint_careful (arch/x86/kernel/entry_64.S:889)
[  922.467627] ? preempt_schedule (./arch/x86/include/asm/preempt.h:80 (discriminator 1) kernel/sched/core.c:2943 (discriminator 1))
[  922.467627] ? preempt_schedule_context (./arch/x86/include/asm/preempt.h:75 kernel/context_tracking.c:143)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? preempt_schedule_context (kernel/context_tracking.c:145)
[  922.467627] ? __schedule (kernel/sched/core.c:2900)
[  922.467627] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
[  922.467627] ? ftrace_ops_control_func (kernel/trace/ftrace.c:4780)
[  922.467627] ? ftrace_call (arch/x86/kernel/mcount_64.S:56)
[  922.467627] ? retint_careful (arch/x86/kernel/entry_64.S:886)
[  922.467627] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  922.467627] ? schedule_user (kernel/sched/core.c:2900)
[  922.467627] ? schedule_user (kernel/sched/core.c:2900)
[  922.467627] ? retint_careful (arch/x86/kernel/entry_64.S:889)
[ 922.467627] Code: 00 00 00 4d 8b b5 e8 18 00 00 e8 b5 55 02 00 85 c0 74 09 80 3d e4 1c e7 05 00 74 68 49 8b 56 60 48 63 cb 90 48 8b 82 e0 00 00 00 <48> 03 04 cd 00 df e4 97 4c 01 20 48 8b 52 48 48 85 d2 75 e5 e8
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 4d 8b             	add    %cl,-0x75(%rbp)
   5:	b5 e8                	mov    $0xe8,%ch
   7:	18 00                	sbb    %al,(%rax)
   9:	00 e8                	add    %ch,%al
   b:	b5 55                	mov    $0x55,%ch
   d:	02 00                	add    (%rax),%al
   f:	85 c0                	test   %eax,%eax
  11:	74 09                	je     0x1c
  13:	80 3d e4 1c e7 05 00 	cmpb   $0x0,0x5e71ce4(%rip)        # 0x5e71cfe
  1a:	74 68                	je     0x84
  1c:	49 8b 56 60          	mov    0x60(%r14),%rdx
  20:	48 63 cb             	movslq %ebx,%rcx
  23:	90                   	nop
  24:	48 8b 82 e0 00 00 00 	mov    0xe0(%rdx),%rax
  2b:*	48 03 04 cd 00 df e4 	add    -0x681b2100(,%rcx,8),%rax		<-- trapping instruction
  32:	97
  33:	4c 01 20             	add    %r12,(%rax)
  36:	48 8b 52 48          	mov    0x48(%rdx),%rdx
  3a:	48 85 d2             	test   %rdx,%rdx
  3d:	75 e5                	jne    0x24
  3f:	e8                   	.byte 0xe8
	...

Code starting with the faulting instruction
===========================================
   0:	48 03 04 cd 00 df e4 	add    -0x681b2100(,%rcx,8),%rax
   7:	97
   8:	4c 01 20             	add    %r12,(%rax)
   b:	48 8b 52 48          	mov    0x48(%rdx),%rdx
   f:	48 85 d2             	test   %rdx,%rdx
  12:	75 e5                	jne    0xfffffffffffffff9
  14:	e8                   	.byte 0xe8
	...
[  922.467627] RIP cpuacct_charge (kernel/sched/cpuacct.c:247)
[  922.467627]  RSP <ffff880850003d28>
[  922.467627] CR2: fffffffc310ead68


Thanks,
Sasha
