Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbaBDTls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:41:48 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:34775 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbaBDTlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:41:46 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402042011400.24986@ionos.tec.linutronix.de>
References: <d348afdb2f6acc41dde0381396226b69a0358f8b.1391210357.git.luto@amacapital.net>
 <alpine.DEB.2.02.1402042011400.24986@ionos.tec.linutronix.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Feb 2014 11:41:25 -0800
Message-ID: <CALCETrUwdS9c1RgWLN4Wvimejh56N0tnCmgsSgPKGv5bVCn8ZQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Remove hpet vclock support
To: Thomas Gleixner <tglx@linutronix.de>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 11:31 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 31 Jan 2014, Andy Lutomirski wrote:
>
>> The HPET is so amazingly slow that this is barely a win.  It adds
>
> That's nonsense. It's definitely a win to access HPET directly
> especially on older systems with TSC wreckage. Why do you want to
> enforce a syscall if we can read out the data straight from user
> space. The systems which are forced to use HPET have slower syscalls
> than those which have a proper TSC.
>

I'm actually curious whether anyone cares about this particular
performance difference.  On all my HPET systems, the actual HPET read
takes ~500ns, whereas the overhead from a syscall is ~50ns.  (This is
ignoring the CONFIG_AUDIT_SYSCALL wreckage, which I'm trying to fix.)
I certainly care about 10% performance changes in clock_gettime, but
that's only because it's already fast enough to call very frequently.
If it took anywhere near 500ns, I would just stop using it, so the
50ns difference wouldn't matter for my application.

It's certainly true that, on older hardware, syscalls are slower, but
I suspect that the HPET is at least as slow, and old enough hardware
won't even have a usable HPET.

On newish things (probably Nehalem and up that have non-buggy BIOS),
HPET is AFAIK completely pointless.

>> complexity, and it scares me a tiny bit to map a piece of crappy
>> hardware where every userspace program can poke at it (even if said
>> poking is read-only).  Let's just remove it.
>
> What's scary about granting user space access to a read only resource?

I only said it was a tiny bit scary, not that it was meaningfully scary :)

>
>> This is probably a tiny speedup on kvmclock systems.
>
> Oh, now you are coming to the real point of your change:
>
>     You want to save a few cycles in a guest system.
>
> So you justify that by completely unbacked assumptions and a pointless
> blurb about scariness.
>
> We are not removing existing functionality which is useful for parts
> of our userbase just to make financial online gambling faster.

For the record, while I could be accused of financial online gambling,
I do not use kvmclock.  In fact, I couldn't even get kvmclock to work
on my box (to test this patch) without manually patching out a bunch
of apparently buggy TSC stability checks.  I'm not at all convinced
that this thing is actually functional on any normal system.

(My interest in clock_gettime performance is to keep the overhead of
userspace profiling low.  I do this on bare metal.)

That being said, lots of people probably do care about kvmclock
performance.  It's probably quite popular in the cloud, and the cloud
seems to be all the rage these days.

>
>>  #ifdef CONFIG_PARAVIRT_CLOCK
>>
>>  static notrace const struct pvclock_vsyscall_time_info *get_pvti(int cpu)
>> @@ -157,8 +151,6 @@ notrace static inline u64 vgetsns(int *mode)
>>       cycles_t cycles;
>>       if (gtod->clock.vclock_mode == VCLOCK_TSC)
>>               cycles = vread_tsc();
>> -     else if (gtod->clock.vclock_mode == VCLOCK_HPET)
>> -             cycles = vread_hpet();
>>  #ifdef CONFIG_PARAVIRT_CLOCK
>>       else if (gtod->clock.vclock_mode == VCLOCK_PVCLOCK)
>>               cycles = vread_pvclock(mode);
>
> I really doubt, that your tiny speedup is even measurable simply
> because the branch prediction wont fail and the cache foot print is
> not that excitingly smaller. I could be wrong as usual, but its up to
> you to provide proper numbers which prove that:
>
>     - there is no impact for the actual forced to use HPET systems
>
>     - there is a measurable improvement for the PV clock case
>
> and not before you tried to revert the evaluation order of VCLOCK_HPET
> and VCLOCK_PVCLOCK.

Heh.  If I actually cared about speeding up VCLOCK_PVCLOCK, I think
I'd be aiming for much bigger fish.

That being said, you're the maintainer.  If you don't like this patch,
feel free to drop it.  (But please don't drop my other vDSO patch --
that one fixes a real bug.  It was kind of alarming to see English
text in my vvar page.)

--Andy
