Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaEFVe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:34:28 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:60451 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaEFVe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:34:27 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwix8dSDQ1N1Qu2-9rzGxWeeGAv4fSPVQWGo1YNzJoCoA@mail.gmail.com>
References: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
 <CA+55aFy6NzQOfyne4xLqQQCvuhpi-KSXnJNLjXTRc7+4ChPAnQ@mail.gmail.com>
 <CA+55aFw_Dj7Lx_bE0B3mDxMUNz_K1yc=saziC9dmA_dKSkFWiw@mail.gmail.com> <CA+55aFwix8dSDQ1N1Qu2-9rzGxWeeGAv4fSPVQWGo1YNzJoCoA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 6 May 2014 14:34:06 -0700
Message-ID: <CALCETrVHj1rd=ma-dW8C9RNyQNj3smRAyevWJSQXmvgshbQb6w@mail.gmail.com>
Subject: Re: [ABOMINATION] x86: Fast interrupt return to userspace
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 2:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, May 6, 2014 at 2:00 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I'll do profiles and test the kernel compile too, but the raw timings
>> are certainly promising. The "sysret" hack is pretty disgusting, and
>> it's broken too. sysret doesn't do some things iret does (like TF flag
>> etc), so it's not complete, but it's clearly good enough to run tests
>> on. It will definitely break ptrace() and friends.
>
> It clearly breaks other things too, and there seems to be bugs in
> there. I got this, for example:
>
> WARNING: CPU: 2 PID: 1174 at kernel/smp.c:230
> smp_call_function_single+0x81/0xa0()
> CPU: 2 PID: 1174 Comm: gdbus Tainted: G        W
> 3.15.0-rc4-00260-g38583f095c5a-dirty #2
> Call Trace:
>   dump_stack+0x45/0x56
>   warn_slowpath_common+0x73/0x90
>   warn_slowpath_null+0x15/0x20
>   smp_call_function_single+0x81/0xa0
>   smp_call_function_many+0x21c/0x260
>   flush_tlb_page+0x6d/0xb0
>   ptep_clear_flush+0x2c/0x40
>   do_wp_page+0x208/0x6e0
>   handle_mm_fault+0x79c/0x1060
>   __do_page_fault+0x15e/0x510
>   do_page_fault+0xc/0x10
>   page_fault+0x22/0x30
>   retint_swapgs+0x6/0x10
>
> which is because interrupts are disabled in that
> install_sysret_trampoline() path that touches user space. It's
> possibly sufficient to just move the "cli" to below the call to it. I
> eventually ended up with a hung machine, possibly related to this,
> possibly something else.

I don't think that's enough to fix this -- interrupts may not have
been on in the first place, I think.  I wonder if __put_user_inatomic
would work here.

Also, sysexit might be better than sysret.  And I categorically refuse
to add any new feature that requires vsyscall=native, so this would
have to use the vdso instead.  Plus it's awful.

>
> Whatever. I got enough profile data to say that it seems to have cut
> 'iret' overhead by at least two thirds. So it may not *work*, but from
> a "hey look, some random numbers" standpoint it is worth playing with.
>

:)

Is there actual interest in turning something like this into a real
patch?  It would almost certainly have to default off and no one sane
would ever use it except for special-purpose machines.

--Andy
