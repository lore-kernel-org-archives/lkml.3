Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaHNAKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:10:05 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:38128 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaHNAKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:10:01 -0400
Message-ID: <53EBFE6E.1060400@gmail.com>
Date: Wed, 13 Aug 2014 20:10:22 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding "Control Dependencies" in memory-barriers.txt
References: <CAJhHMCADiEsUC7GsYF7=qMNEyRJerfhC5zh7WQPgkQ0gJn5=5A@mail.gmail.com> <20140804185226.GQ8101@linux.vnet.ibm.com> <CAJhHMCBEprK9hp786cwguJR=JW7Xxgt4GKX5=E0vikO-D4qmZg@mail.gmail.com> <20140805073237.GX3935@laptop> <CAJhHMCBjub+_Gg_wC2EoR5OgzwT7JTHr-wzoGp_dePUBVwEG8g@mail.gmail.com> <20140813224436.GA4752@linux.vnet.ibm.com>
In-Reply-To: <20140813224436.GA4752@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, Aug 13, 2014 at 6:44 PM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

>         .LFB0:
>                 .cfi_startproc
>                 movl    a, %ecx
>                 movl    $1717986919, %edx
>                 movl    %ecx, %eax
>                 imull   %edx
>                 movl    %ecx, %eax
>                 sarl    $31, %eax
>                 movl    %ecx, b
>                 sarl    $2, %edx
>                 subl    %eax, %edx
>                 leal    (%edx,%edx,4), %eax
>                 addl    %eax, %eax
>                 cmpl    %eax, %ecx
>                 jne     .L4
>                 jmp     do_something_else
>                 .p2align 4,,7
>                 .p2align 3
>         .L4:
>                 jmp     do_something
>                 .cfi_endproc
>         .LFE0:
>                 .size   foo, .-foo
>                 .comm   b,4,4
>                 .comm   a,4,4
>                 .ident  "GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
>                 .section        .note.GNU-stack,"",@progbits
>
> As you can see, the assignment to "b" has been hoisted above the "if".
> And adding barrier() to each leg of the "if" statement doesn't help,
> the store to "b" still gets hoisted.

That does not match to what I am seeing. I added barrier() to both the
legs and this is the outcome with the same options you used:

0000000000000000 <foo>:
   0:	mov    0x0(%rip),%ecx        # 6 <foo+0x6>
   6:	mov    $0x66666667,%edx
   b:	mov    %ecx,%eax
   d:	imul   %edx
   f:	mov    %ecx,%eax
  11:	sar    $0x1f,%eax
  14:	sar    $0x2,%edx
  17:	sub    %eax,%edx
  19:	lea    (%rdx,%rdx,4),%eax
  1c:	add    %eax,%eax
  1e:	cmp    %eax,%ecx
  20:	jne    30 <foo+0x30>
  22:	mov    %ecx,0x0(%rip)        # 28 <foo+0x28> ACCESS_ONCE(b) = q
  28:	jmpq   2d <foo+0x2d>
  2d:	nopl   (%rax)
  30:	mov    %ecx,0x0(%rip)        # 36 <foo+0x36> ACCESS_ONCE(b) = q
  36:	jmpq   3b <foo+0x3b>

My gcc version is 4.9.1. 

Trying it out with 4.6.4 and 4.7.3 I see what you are seeing! So must be a bug
in older compiler versions.

>
> So this whole "q % MAX" example is bogus...
>
> In fact, if you have the same store on both legs of the "if" statement,
> your ordering appears to be toast, at least at high optimization levels.
>
> You would think that I would have tested with -O3 initially.  :-(

Looks like it is even happening at -O2 with 4.6/4.7 version of gcc. 
Btw, how are you generating the pretty output for assembly? I am using objdump
and it is not as pretty.

> ------------------------------------------------------------------------
>
> memory-barriers: Fix description of 2-legged-if-based control dependencies
>
> Sad to say, current compilers really will hoist identical stores from both
> branches of an "if" statement to precede the conditional.  This commit
> therefore updates the description of control dependencies to reflect this
> ugly reality.
>
> Reported-by: Pranith Kumar <bobby.prani@gmail.com>
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Please see one question below:

>
> +Given this transformation, the CPU is not required to respect the ordering
> +between the load from variable 'a' and the store to variable 'b'.  It is
> +tempting to add a barrier(), but this does not help.  The conditional
> +is gone, and the barrier won't bring it back.  Therefore, if you are
> +relying on this ordering, you should make sure that MAX is greater than
> +one, perhaps as follows:
>
>         q = ACCESS_ONCE(a);
>         BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
> @@ -695,10 +675,14 @@ do something like the following:
>                 ACCESS_ONCE(b) = p;
>                 do_something();
>         } else {
> -               ACCESS_ONCE(b) = p;
> +               ACCESS_ONCE(b) = r;
>                 do_something_else();
>         }
>
> +Please note once again that the stores to 'b' differ.  If they were
> +identical, as noted earlier, the compiler could pull this store outside
> +of the 'if' statement.

If the stores to 'b' differ, then there is no issue. Why not document how to
avoid re-ordering in the case where both the stores are the same? In that case
using a stronger barrier like mb() should be sufficient for both the compiler
and the CPU to avoid re-ordering, right?

-- 
Pranith
