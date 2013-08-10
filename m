Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3HJTTB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 15:19:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab3HJTS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 15:18:59 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFzhv1v9KatxQ3GUGBZf+zTb_hdx2fJZKT+m5tEcAkWsSQ@mail.gmail.com>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org> <5205C4BB.6020003@zytor.com> <1376114128.5332.17.camel@marge.simpson.net> <5206659F.9070705@zytor.com> <CA+55aFyB5E+Keupjz4trfMcNawUKVzQV8DF5aS_VsPiw3FaT_Q@mail.gmail.com> <520675D3.7030703@zytor.com> <CA+55aFzhv1v9KatxQ3GUGBZf+zTb_hdx2fJZKT+m5tEcAkWsSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 10 Aug 2013 12:18:21 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mike Galbraith <bitbucket@online.de>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Message-ID: <b3995a13-bb09-48a3-88e3-abecc6311e78@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right... I mentioned the need to move thread count into percpu and the other restructuring... all of that seems essential for this not to suck.

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>On Sat, Aug 10, 2013 at 10:18 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> We could then play a really ugly stunt by marking NEED_RESCHED by
>adding
>> 0x7fffffff to the counter.  Then the whole sequence becomes something
>like:
>>
>>         subl $1,%fs:preempt_count
>>         jno 1f
>>         call __naked_preempt_schedule   /* Or a trap */
>
>This is indeed one of the few cases where we probably *could* use
>trapv or something like that in theory, but those instructions tend to
>be slow enough that even if you don't take the trap, you'd be better
>off just testing by hand.
>
>However, it's worse than you think. Preempt count is per-thread, not
>per-cpu. So to access preempt-count, we currently have to look up
>thread_info (which is per-cpu or stack-based).
>
>I'd *like* to make preempt-count be per-cpu, and then copy it at
>thread switch time, and it's been discussed. But as things are now,
>preemption enable is quite expensive, and looks something like
>
>        movq %gs:kernel_stack,%rdx      #, pfo_ret__
>        subl    $1, -8124(%rdx) #, ti_22->preempt_count
>        movq %gs:kernel_stack,%rdx      #, pfo_ret__
>        movq    -8136(%rdx), %rdx       # MEM[(const long unsigned int
>*)ti_27 + 16B], D.
>        andl    $8, %edx        #, D.34545
>        jne     .L139   #,
>
>and that's actually the *good* case (ie not counting any extra costs
>of turning leaf functions into non-leaf ones).
>
>That "kernel_stack" thing is actually getting the thread_info pointer,
>and it doesn't get cached because gcc thinks the preempt_count value
>might alias. Sad, sad, sad. We actually used to do better back when we
>used actual tricks with the stack registers and used a const inline
>asm to let gcc know it could re-use the value etc.
>
>It would be *lovely* if we
> (a) made preempt-count per-cpu and just copied it at thread-switch
> (b) made the NEED_RESCHED bit be part of preempt-count (rather than
>thread flags) and just made it the high bit
>
>adn then maybe we could just do
>
>        subl    $1, %fs:preempt_count
>        js .L139
>
>with the actual schedule call being done as an
>
>        asm volatile("call user_schedule": : :"memory");
>
>that Andi introduced that doesn't pollute the register space. Note
>that you still want the *test* to be done in C code, because together
>with "unlikely()" you'd likely do pretty close to optimal code
>generation, and hiding the decrement and test and conditional jump in
>asm you wouldn't get the proper instruction scheduling and branch
>following that gcc does.
>
>I dunno. It looks like a fair amount of effort. But as things are now,
>the code generation difference between PREEMPT_NONE and PREEMPT is
>actually fairly noticeable. And PREEMPT_VOLUNTARY - which is supposed
>to be almost as cheap as PREEMPT_NONE - has lots of bad cases too, as
>Andi noticed.
>
>                   Linus

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
