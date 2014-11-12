Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaKLAke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:40:34 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:40533 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKLAkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:40:31 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141111213628.GP31490@pd.tnic> <CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
 <20141111223316.GQ31490@pd.tnic> <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
 <20141111230926.GR31490@pd.tnic> <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Nov 2014 16:40:09 -0800
Message-ID: <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 4:22 PM, Luck, Tony <tony.luck@intel.com> wrote:
> Andy said:
>> Yeah.  But if you haven't cleared MCIP, you go boom, which is the same
>> with pretty much any approach.
>
> The current code has an ugly hole at the moment.  End of do_machine_check()
> clears MCG_STATUS.  At that point we are still running on the magic stack for
> machine check exceptions ... if we take a machine check in the small window
> from there until we get off this stack (iret) ... then we will enter the handler
> back on the same stack that we haven't finished using yet. Bad things ensue.
>
> Andy's RFC patch removes this window.  We are already off on the normal stack
> when we clear MCG_STATUS.MCIP ...

Only if the first #MC came from user mode.

> so we enter the new machine check on the
> magic stack, but then (I hope) transition to the kernel stack (pushing a new frame
> below the other one).

We could, in theory, do this, but it seems really dangerous.  First,
there's a significant risk of overflowing the stack, since it makes
stack usage impossible to analyze.  Second, there are contexts in
which the kernel stack is unusable (the syscall prologue and epilogue
are major examples).

If the first #MC hits in user mode, then we'll transition to the
kernel stack.  If the second #MC hits in kernel mode, then we'll
handle it on the IST stack.

I think that the real nasty case is when there's a broadcast MCE that
hits a non-offending CPU that's running in kernel mode.  The best that
I can come up with is to find a way to schedule a work item from the
extremely atomic context that we're running in and defer clearing MCIP
to that work item.

I've thought about one sneaky option.  If we can reliably determine
that we're an innocent bystander of a broadcast #MC, can we send an
IPI-to-self and return without clearing MCIP?  Then we get another
interrupt as soon as interrupts are enabled, and we can clear MCIP at
a time when we're definitely not running on the IST stack.

>
> Boris said:
>> This is the key: if I enable irqs and the process gets scheduled on
>> another CPU, I lose. So I have to be able to say: before you run this
>> task on any CPU, kill it.
>
> I don't think it matters if sleep and schedule this task on another cpu. When
> we run there we'll keep running the memory_failure() code that we were
> in the middle of when we slept.  The task can move around - we just need to
> make sure it doesn't *return to the user-mode instruction* that hit the machine
> check before we find the pte and zero it and mark the page as POISON.

Yeah, this is the idea.

But, damnit, machine check broadcast is the worst idea ever.

--Andy
