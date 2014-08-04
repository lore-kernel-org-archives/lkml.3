Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaHDVDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:03:47 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:54379 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaHDVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:03:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAK1hOcOwD0cpVWZEV8FP40y9149feUdaxoszQC+wWQfAwU4MNQ@mail.gmail.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <CALCETrWA6SL52SOM3yifvc0Pjz-HTOvs8G8fXo9TqF5v=0eTzw@mail.gmail.com>
 <CAK1hOcOwD0cpVWZEV8FP40y9149feUdaxoszQC+wWQfAwU4MNQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 5 Aug 2014 06:03:24 +0900
Message-ID: <CALCETrV6rap+rZirLsMmdzML9rSKnWEmq-ACNLLGYgKtT-K6uA@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 11:28 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> On Fri, Aug 1, 2014 at 7:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Fri, Aug 1, 2014 at 7:48 AM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
>>> 64-bit code was using six stack slots fewer by not saving/restoring
>>> registers which a callee-preserved according to C ABI,
>>> and not allocating space for them
>>
>> This is great.
>>
>> Next up: remove FIXUP/RESTORE_TOP_OF_STACK? :)  Maybe I'll give that a shot.
>
> I'm yet at the stage "what that stuff does anyway?" and at
> "why do we need percpu old_rsp thingy?" in particular.

On x86_64, the syscall instruction has no effect on rsp.  That means
that the entry point starts out with no stack.  There are no free
registers whatsoever at the entry point.

That means that the entry code needs to do swapgs, stash rsp somewhere
relative to gs, and then load the kernel's rsp.  old_rsp is the spot
used for this.

Now the kernel does an optimization that is, I think, very much not
worth it.  The kernel doesn't bother sticking the old rsp value into
pt_regs (saving two instructions on fast path entries) and doesn't
initialize the SS, CS, RCX, and EFLAGS fields in pt_regs, saving four
more instructions.

To make this optimization work, the whole FIXUP/RESTORE_TOP_OF_STACK
dance is needed, and there's the usersp crap in the context switch
code, and current_user_stack_pointer(), and probably even more crap
that I haven't noticed.  And I sure hope that nothing in the *compat*
syscall path touches current_user_stack_pointer(), because the compat
code doesn't seem to use old_rsp.

I think this should all be ripped out.  The only real difficulty will
be that the sysret code needs to restore rsp itself, so the sysret
path will end up needing two more instructions.  Removing all of the
TOP_OF_STACK stuff will add ten instructions to fast path syscalls,
and I wouldn't be surprised if this adds considerably fewer than ten
cycles on any modern chip.

(It's too bad that there's no unlocked xchg; this could be faster if
we had one.  It's also too bad that the syscall ABI didn't choose some
register to unconditionally set to zero, which would have given us the
single scratch register we'd need to avoid this whole mess in the
first place.)

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
