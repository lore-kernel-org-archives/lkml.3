Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090AbaD2SUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:20:04 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63280 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478AbaD2SUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:20:03 -0400
Message-ID: <535FED4D.5000703@amacapital.net>
Date: Tue, 29 Apr 2014 11:19:57 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org> <1398723161-21968-5-git-send-email-andi@firstfloor.org>
In-Reply-To: <1398723161-21968-5-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 03:12 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> IvyBridge added new instructions to directly write the fs and gs
> 64bit base registers. Previously this had to be done with a system
> call to write to MSRs. The main use case is fast user space threading
> and switching the fs/gs registers quickly there.
> 
> The instructions are opt-in and have to be explicitely enabled
> by the OS.
> 
> Previously Linux couldn't support this because the paranoid
> entry code relied on the gs base never being negative outside
> the kernel to decide when to use swaps. It would check the gs MSR
> value and assume it was already running in kernel if the value
> was already negative.
> 
> This patch changes the paranoid entry code to use rdgsbase
> if available.  Then we check the GS value against the expected GS value
> stored at the bottom of the IST stack. If the value is the expected
> value we skip swapgs.
> 
> This is also significantly faster than a MSR read, so will speed
> NMis (critical for profiling)
> 
> An alternative would have been to save/restore the GS value
> unconditionally, but this approach needs less changes.
> 
> Then after these changes we need to also use the new instructions
> to save/restore fs and gs, so that the new values set by the
> users won't disappear.  This is also significantly
> faster for the case when the 64bit base has to be switched
> (that is when GS is larger than 4GB), as we can replace
> the slow MSR write with a faster wr[fg]sbase execution.
> 
> The instructions do not context switch
> the segment index, so the old invariant that fs or gs index
> have to be 0 for a different 64bit value to stick is still
> true. Previously it was enforced by arch_prctl, now the user
> program has to make sure it keeps the segment indexes zero.
> If it doesn't the changes may not stick.
> 
> This is in term enables fast switching when there are
> enough threads that their TLS segment does not fit below 4GB,
> or alternatively programs that use fs as an additional base
> register will not get a sigificant context switch penalty.
> 
> It is all done in a single patch to avoid bisect crash
> holes.
> 


> +paranoid_save_gs:
> +	.byte 0xf3,0x48,0x0f,0xae,0xc9	# rdgsbaseq %rcx
> +	movq $-EXCEPTION_STKSZ,%rax	# non debug stack size
> +	cmpq $DEBUG_STACK,ORIG_RAX+8(%rsp)
> +	movq $-1,ORIG_RAX+8(%rsp)	# no syscall to restart
> +	jne  1f
> +	movq $-DEBUG_STKSZ,%rax		# debug stack size
> +1:
> +	andq %rsp,%rax			# bottom of stack
> +	movq (%rax),%rdi		# get expected GS
> +	cmpq %rdi,%rcx			# is it the kernel gs?

I don't like this part.  There are now three cases:

1. User gs, gsbase != kernel gs base.  This works the same as before

2. Kernel gs.  This also works the same as before.

3. User gs, but gsbase == kernel gs base.  This will cause C code to
execute on the *user* gs base.

Case 3 is annoying.  If nothing tries to change the user gs base, then
everything is okay because the user gs base and the kernel gs bases are
equal.  But if something does try to change the user gs base, then it
will accidentally change the kernel gs base instead.

For the IST entries, this should be fine -- cpu migration, scheduling,
and such are impossible anyway.  For the non-IST entries, I'm less
convinced.  The entry_64.S code suggests that the problematic entries are:

double_fault
stack_segment
machine_check

Of course, all of those entries really do use IST, so I wonder why they
are paranoid*entry instead of paranoid*entry_ist.  Is it because they're
supposedly non-recursive?

In any case, wouldn't this all be much simpler and less magical if the
paranoid entries just saved the old gsbase to the rbx and loaded the new
ones?  The exits could do the inverse.  This should be really fast:

rdgsbaseq %rbx
wrgsbaseq {the correct value}

...

wrgsbaseq %rbx

This still doesn't support changing the usergs value inside a paranoid
entry, but at least it will fail consistently instead of only failing if
the user gs has a particular special value.

I don't know the actual latencies, but I suspect that this would be
faster, too -- it removes some branches, and wrgsbase and rdgsbase
deserve to be faster than swapgs.  It's probably no good for
non-rd/wrgsbase-capable cpus, though, since I suspect that three MSR
accesses are much worse than one MSR access and two swapgs calls.

--Andy
