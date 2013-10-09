Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3JIOeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:34:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41646 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3JIOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:34:13 -0400
Date: Wed, 9 Oct 2013 16:33:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009143359.GU26785@twins.programming.kicks-ass.net>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
 <20131008143400.GA14721@redhat.com>
 <20131009080459.GA2298@localhost>
 <20131009124310.GA11769@redhat.com>
 <20131009140734.GH3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009140734.GH3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 04:07:34PM +0200, Peter Zijlstra wrote:
> Once I force a x86_64 build using the 'same' config it goes away and
> generates 'sensible' code again (although I don't see why L9 isn't
> merged with L2):

i386-SMP also generates correct code afaict; a tad stupid but not wrong.

If I remove ftrace from the .config its still broken..
If I also remove the likely/unlikely tracer its still broken and lots
smaller:

        .p2align 4,,15
        .globl  task_work_add
        .type   task_work_add, @function
task_work_add:
        pushl   %ebp    #
        movl    %esp, %ebp      #,
        pushl   %edi    #
        pushl   %esi    #
        pushl   %ebx    #
        movl    %eax, %esi      # task, task
        .p2align 4,,15
.L4:
        movl    904(%esi), %ebx # task_5(D)->task_works, __old
        cmpl    $work_exited, %ebx      #, __old
        je      .L5     #,
        movl    %ebx, (%edx)    # __old, work_10(D)->next
        movl    %ebx, %eax      # __old, __ret
#APP
# 34 "/usr/src/linux-2.6/kernel/task_work.c" 1
        cmpxchgl %edx,904(%esi) # work, *__ptr_12
# 0 "" 2
#NO_APP
        cmpl    %eax, %ebx      # __ret, __old
        jne     .L4     #,
        testb   %cl, %cl        # notify
        je      .L6     #,
        movl    4(%esi), %eax   # task_5(D)->stack, task_5(D)->stack
#APP
# 208 "/usr/src/linux-2.6/arch/x86/include/asm/bitops.h" 1
        bts $1, 8(%eax); jc .L2 #, MEM[(volatile long unsigned int *)_18],
# 0 "" 2
#NO_APP
.L6:
        xorl    %edi, %edi      # D.14172
.L2:
        movl    %edi, %eax      # D.14172,
        popl    %ebx    #
        popl    %esi    #
        popl    %edi    #
        popl    %ebp    #
        ret
.L5:
        movl    $-3, %edi       #, D.14172
        jmp     .L2     #
        .size   task_work_add, .-task_work_add

That "jc .L2" needs to be .L6 ! It looks like it fails to deal with the
empty branch.

Why this thing needs to use EDI is anybodies guess I suppose. Would've
made much more sense to have:

.L6:
	xorl %eax, %eax
.L2:
	popl %ebx
	popl %esi
	popl %ebp
	ret
.L5:
	movl, $-3, %eax
	jmp .L2

At least its not duplicating the popl+ret bits 3 times anymore.
