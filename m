Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaJCNkC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:40:02 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46916 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJCNj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:39:59 -0400
Date: Fri, 3 Oct 2014 08:39:54 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: oleg@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, luto@amacapital.net, dvlasenk@redhat.com,
        tglx@linutronix.de
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using
 THUNK helpers
Message-ID: <20141003083954.10a13a24@as>
In-Reply-To: <542E2B05.5080607@oracle.com>
References: <20140921184153.GA23727@redhat.com>
	<tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org>
	<542E2B05.5080607@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Oct 2014 00:50:13 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> On 09/24/2014 11:02 AM, tip-bot for Oleg Nesterov wrote:
> > Commit-ID:  0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
> > Gitweb:     http://git.kernel.org/tip/0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
> > Author:     Oleg Nesterov <oleg@redhat.com>
> > AuthorDate: Sun, 21 Sep 2014 20:41:53 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 24 Sep 2014 15:15:38 +0200
> > 
> > x86: Speed up ___preempt_schedule*() by using THUNK helpers
> > 
> > ___preempt_schedule() does SAVE_ALL/RESTORE_ALL but this is
> > suboptimal, we do not need to save/restore the callee-saved
> > register. And we already have arch/x86/lib/thunk_*.S which
> > implements the similar asm wrappers, so it makes sense to
> > redefine ___preempt_schedule() as "THUNK ..." and remove
> > preempt.S altogether.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Reviewed-by: Andy Lutomirski <luto@amacapital.net>
> > Cc: Denys Vlasenko <dvlasenk@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Link: http://lkml.kernel.org/r/20140921184153.GA23727@redhat.com
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > ---
> 
> Hi Oleg,
> 
> I *think* that this patch is causing the following trace (arch/x86/lib/thunk_64.S:44
> is new code introduced by this patch):
> 
> 
> [  921.908530] kernel BUG at kernel/sched/core.c:2702!
> [  921.909159] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  921.910084] Dumping ftrace buffer:
> [  921.910626]    (ftrace buffer empty)
> [  921.911178] Modules linked in:
> [  921.915690] CPU: 18 PID: 9489 Comm: trinity-c195 Not tainted 3.17.0-rc7-next-20141002-sasha-00031-gbdb4244 #1273
> [  921.917016] task: ffff8802bd748000 ti: ffff8802bda3c000 task.ti: ffff8802bda3c000
> [  921.917752] RIP: __schedule (kernel/sched/core.c:2702 kernel/sched/core.c:2808)
> [  921.917752] RSP: 0018:ffff8802bda3c360  EFLAGS: 00010297
> [  921.917752] RAX: ffff8802bda3c000 RBX: ffff8808501e2a00 RCX: 0000000000000001
> [  921.917752] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000286
> [  921.917752] RBP: ffff8802bda3c3c0 R08: 000000000001aa50 R09: 0000000000000000
> [  921.917752] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000012
> [  921.917752] R13: ffff8808501e2a00 R14: 0000000000000002 R15: ffff8802bda3c428
> [  921.917752] FS:  00007f5475cc2700(0000) GS:ffff880850000000(0000) knlGS:0000000000000000
> [  921.917752] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  921.917752] CR2: 00007f5475abe60c CR3: 00000002bebab000 CR4: 00000000000006a0
> [  921.917752] DR0: 00000000006f0000 DR1: 0000000000000000 DR2: 0000000000000000
> [  921.917752] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [  921.917752] Stack:
> [  921.917752]  000000000001aa50 ffff8802bd748000 ffff8802bda3ffd8 00000000001e2a00
> [  921.917752]  00000000001e2a00 ffff8802bd748000 ffff8802bda3c3a0 00000000001e2a00
> [  921.917752]  ffff8802bd748000 000000000001a9ea 0000000000000002 ffff8802bda3c428
> [  921.917752] Call Trace:
> [  921.917752] schedule_user (kernel/sched/core.c:2894 include/linux/jump_label.h:114 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:20 kernel/sched/core.c:2909)
> [  921.917752] int_careful (arch/x86/kernel/entry_64.S:560)
> [  921.917752] ? retint_careful (arch/x86/kernel/entry_64.S:889)
> [  921.917752] ? preempt_schedule (./arch/x86/include/asm/preempt.h:80 (discriminator 1) kernel/sched/core.c:2943 (discriminator 1))
> [  921.917752] ? preempt_schedule_context (./arch/x86/include/asm/preempt.h:75 kernel/context_tracking.c:143)
> [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)
> [  921.917752] ? ___preempt_schedule_context (arch/x86/lib/thunk_64.S:44)
> [  921.917752] ? preempt_schedule_context (kernel/context_tracking.c:145)

<snip lots of repeats of this>

I *think* this is because RBP isn't being saved across task switch
anymore?

Without CONFIG_FRAME_POINTERS that night not be a problem...
