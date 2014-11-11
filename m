Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaKKWkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:40:35 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:48350 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaKKWke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:40:34 -0500
MIME-Version: 1.0
In-Reply-To: <20141111223316.GQ31490@pd.tnic>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141111213628.GP31490@pd.tnic> <CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
 <20141111223316.GQ31490@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Nov 2014 14:40:12 -0800
Message-ID: <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 2:33 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Nov 11, 2014 at 02:12:18PM -0800, Andy Lutomirski wrote:
>> I don't see why it would be any more likely for the normal kernel
>> stack to be corrupted due to a hardware issue that interrupted ring 3
>> code than that the IST stack is corrupted.
>
> The IST stack is, well, used solely be used for the vectors it is
> assigned for. Maybe the probabability of it getting bad is a bit
> lower..., who knows.
>
>> I don't know what, if anything, masks and unmasks #MC, but certainly
>> switching to process context like this patch does will not unmask it.
>
> Manuals say to clear MCG_STATUS[MCIP] before you return but you also
> have to IRET. Because not having cleared MCIP and returning would shut
> down the machine on another #MC.

I wonder what the IRET is for.  There had better not be another magic
IRET unmask thing.  I'm guessing that the actual semantics are that
nothing whatsoever can mask #MC, but that a second #MC when MCIP is
still set is a shutdown condition.

>
> But then what does it bring me to run on the kernel stack if I'm still
> in atomic context and I can't take locks? That doesn't help me with the
> memory_failure() thing.

Define "atomic".

You're still running with irqs off and MCIP set.  At some point,
you're presumably done with all of the machine check registers, and
you can clear MCIP.  Now, if current == victim, you can enable irqs
and do whatever you want.

In my mind, the benefit is that you don't need to think about how to
save your information and arrange to get called back the next time
that the victim task is a non-atomic context, since you *are* the
victim task and you're running in normal irqs-disabled kernel mode.

In contrast, with the current entry code, if you enable IRQs or so
anything that could sleep, you're on the wrong stack, so you'll crash.
That means that taking mutexes, even after clearing MCIP, is
impossible.

--Andy
