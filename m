Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670AbaKLCCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:02:17 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:32888 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917AbaKLCCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:02:12 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141111213628.GP31490@pd.tnic> <CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
 <20141111223316.GQ31490@pd.tnic> <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
 <20141111230926.GR31490@pd.tnic> <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
 <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Nov 2014 18:01:50 -0800
Message-ID: <CALCETrUkeB8cV5TWDsrOX=BPw+=+P2cTurb20jK9XfZ3ybEZ8Q@mail.gmail.com>
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

On Tue, Nov 11, 2014 at 5:06 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> I've thought about one sneaky option.  If we can reliably determine
>> that we're an innocent bystander of a broadcast #MC, can we send an
>> IPI-to-self and return without clearing MCIP?  Then we get another
>> interrupt as soon as interrupts are enabled, and we can clear MCIP at
>> a time when we're definitely not running on the IST stack.
>
> Innocent bystanders have RIPV=1, EIPV=0 in MCG_STATUS ... so they
> are quite easy to spot.  Perhaps we might look at subverting the silly
> broadcast by just having them immediately clear MCG_STATUS and iret
> (i.e. not go to do_machine_check() at all).  That would require lots of
> surgery to do_machine_check() and friends - now it wouldn't be sure
> how many processors to expect to show up.  It also opens a different
> window - once they are back running normal code they might trip another
> machine check while the victims of the first are still processing - so
> another "boom, you're dead".  The advantage of hitting everyone
> with the machine check is that it lessens the chance that another will
> happen as everyone is running looking at a few pages of kernel code
> & data.
>
> The worrying part in that is "as soon as interrupts are enabled". Until
> we do clear MCIP we're sitting in a mode where another machine check
> means instant death no saving throw.  Nominally better than the "we'll
> mess the stack up for you" that we are trying to avoid - but the old window
> is quite short and known to be bounded. The new one might be a lot bigger.

Yeah, fair enough.

The annoying thing is that there's no way to atomically return from
interrupt and clear MCIP.

Here's a different idea.  In do_machine_check, check if (regs->sp
points at the machine check IST stack && !user_mode(regs)) and, if so,
declare the machine check to be unrecoverable.  There are a couple
ways this can happen:

 - This is a second #MC that hit after clearing MCIP and before
returning.  It's genuinely unrecoverable (we're well and truly screwed
at this point), but we probably won't actually crash unless we try to
return.

 - This is a normal #MC that hit in kernel mode during a time when sp
was bogus and coincidentally pointed at the #MC IST stack.

This isn't perfect.  A malicious user can do dummy syscalls in a loop
on one CPU with rsp pointing at the IST stack and try to cause a
machine check on a different CPU, causing the system to panic when it
thinks that the first CPU had a recursive IST usage.  I think that we
probably have bigger problems if a malicious user can cause machine
checks, though.

--Andy
