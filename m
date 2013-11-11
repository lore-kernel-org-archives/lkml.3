Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3KKTdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:33:05 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:49891 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab3KKTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:32:55 -0500
MIME-Version: 1.0
In-Reply-To: <20131111183101.GA16051@gmail.com>
References: <1381450698-28710-4-git-send-email-keescook@chromium.org>
	<tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>
	<20131111182046.GA14961@gmail.com>
	<20131111183101.GA16051@gmail.com>
Date: Mon, 11 Nov 2013 11:32:53 -0800
X-Google-Sender-Auth: mD4Dg5NQMgCauiofJOCg4xUoF2c
Message-ID: <CAGXu5jL96B4+McO=K9dptu81m+bdKWOZ8YS9x7+SZxkjfUsg9Q@mail.gmail.com>
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 10:31 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Ingo Molnar <mingo@kernel.org> wrote:
>
>>
>> * tip-bot for Kees Cook <tipbot@zytor.com> wrote:
>>
>> > Commit-ID:  5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3
>> > Gitweb:     http://git.kernel.org/tip/5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3
>> > Author:     Kees Cook <keescook@chromium.org>
>> > AuthorDate: Thu, 10 Oct 2013 17:18:15 -0700
>> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> > CommitDate: Sun, 13 Oct 2013 03:12:12 -0700
>> >
>> > x86, kaslr: Provide randomness functions
>> >
>> > Adds potential sources of randomness: RDRAND, RDTSC, or the i8254.
>> >
>> > This moves the pre-alternatives inline rdrand function into the header so
>> > both pieces of code can use it. Availability of RDRAND is then controlled
>> > by CONFIG_ARCH_RANDOM, if someone wants to disable it even for kASLR.
>>
>> While reviewing this as a pre-pull-request, I noticed the following
>> detail:
>>
>> > +static unsigned long get_random_long(void)
>> > +{
>> > +   unsigned long random;
>> > +
>> > +   if (has_cpuflag(X86_FEATURE_RDRAND)) {
>> > +           debug_putstr("KASLR using RDRAND...\n");
>> > +           if (rdrand_long(&random))
>> > +                   return random;
>> > +   }
>> > +
>> > +   if (has_cpuflag(X86_FEATURE_TSC)) {
>> > +           uint32_t raw;
>> > +
>> > +           debug_putstr("KASLR using RDTSC...\n");
>> > +           rdtscl(raw);
>> > +
>> > +           /* Only use the low bits of rdtsc. */
>> > +           random = raw & 0xffff;
>> > +   } else {
>> > +           debug_putstr("KASLR using i8254...\n");
>> > +           random = i8254();
>> > +   }
>> > +
>> > +   /* Extend timer bits poorly... */
>> > +   random |= (random << 16);
>> > +#ifdef CONFIG_X86_64
>> > +   random |= (random << 32);
>> > +#endif
>> > +   return random;
>> > +}
>>
>> Why aren't the 3 sources of entropy XOR-ed together?

Ah, excellent suggestion. There's no reason they couldn't be. I can
rework that function to do that.

>> Also, we talked about also adding system dependent entropy sources, such
>> as memory layout or the DMI table - none of that seems to have happened.

It seemed like those things didn't contribute as much entropy as the 3
already in use, but I could investigate how to distill those things
down into entropy. Perhaps just XORing the start and length of every
e820 area? DMI I'll need to dig into...

>> It's not like this function should be performance critical, it's run once
>> per bootup, right? There's just no excuse for not maximizing available
>> entropy in such a situation ...

Fair point. Is memory layout and DMI used for system entropy later in boot?

> Another problem I noticed is that the RANDOMIZE_BASE Kconfig text does not
> match the actual sources of entropy:
>
>            Entropy is generated using the RDRAND instruction if it
>            is supported.  If not, then RDTSC is used, if supported. If
>            neither RDRAND nor RDTSC are supported, then no randomness
>            is introduced.
>
> (i8254 is missing.)

Ah! Yes, thanks for catching that. I will fix that.

> Nor does the help text explain an important detail: what granularity does
> the randomization have and roughly how many bits of the address are
> randomized if people use the default values?

Yeah, true -- that seems like a good place to describe the limits.

Would you like the series updated, or patches on top?

-- 
Kees Cook
Chrome OS Security
