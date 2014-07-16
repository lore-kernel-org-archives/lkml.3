Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaGPWNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:13:52 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:55995 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbaGPWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <53C6F5A9.80400@zytor.com>
References: <cover.1405546879.git.luto@amacapital.net> <5778e65d5ca52bebbaa023e177d863e44f098e96.1405546879.git.luto@amacapital.net>
 <53C6F5A9.80400@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 16 Jul 2014 15:13:28 -0700
Message-ID: <CALCETrVwT1g-S1hLyyB_uAVwffYCnFacTfUhJeD8Bb5j3X0mkg@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] random,x86: Add arch_get_slow_rng_u64
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm list <kvm@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 2:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/16/2014 02:45 PM, Andy Lutomirski wrote:
>> diff --git a/arch/x86/include/asm/archslowrng.h b/arch/x86/include/asm/archslowrng.h
>> new file mode 100644
>> index 0000000..c8e8d0d
>> --- /dev/null
>> +++ b/arch/x86/include/asm/archslowrng.h
>> @@ -0,0 +1,30 @@
>> +/*
>> + * This file is part of the Linux kernel.
>> + *
>> + * Copyright (c) 2014 Andy Lutomirski
>> + * Authors: Andy Lutomirski <luto@amacapital.net>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + */
>> +
>> +#ifndef ASM_X86_ARCHSLOWRANDOM_H
>> +#define ASM_X86_ARCHSLOWRANDOM_H
>> +
>> +#ifndef CONFIG_ARCH_SLOW_RNG
>> +# error archslowrng.h should not be included if !CONFIG_ARCH_SLOW_RNG
>> +#endif
>> +
>
> I'm *seriously* questioning the wisdom of this.  A much saner thing
> would be to do:
>
> #ifndef CONFIG_ARCH_SLOW_RNG
>
> /* Not supported */
> static inline int arch_get_slow_rng_u64(u64 *v)
> {
>         (void)v;
>         return 0;
> }
>
> #endif
>
> ... which is basically what we do for the archrandom stuff.

The archrandom stuff defines the "not supported" variant in the
generic header, which is what I'm doing here.  I could wrap all of
asm/archslowrng.h in #ifdef CONFIG_ARCH_SLOW_RNG instead of putting
the #error in there, but I have no strong preference.

>
> I'm also wondering if it makes sense to have a function which prefers
> arch_get_random*() over this one as a preferred interface.  Something like:
>
> int get_random_arch_u64_slow_ok(u64 *v)
> {
>         int i;
>         u64 x = 0;
>         unsigned long l;
>
>         for (i = 0; i < 64/BITS_PER_LONG; i++) {
>                 if (!arch_get_random_long(&l))
>                         return arch_get_slow_rng_u64(v);
>
>                 x |=  l << (i*BITS_PER_LONG);
>         }
>         *v = l;
>         return 0;
> }

I played with something like this earlier, but I dropped it when it
ended up having exactly one user.  I suspect that the highly paranoid
will actually prefer seeding with both sources in init_std_data even
if RDRAND is available -- it costs very little and it provides a bit
of extra assurance.

>
> This still doesn't address the issue e.g. on x86 where RDRAND is
> available but we haven't set up alternatives yet.  So it might be that
> what we really want is to encapsulate this fallback in arch code and do
> a more direct enumeration.

My personal preference is to defer this until some user shows up.  I
think that even this would be too complicated for KASLR, which is the
only extremely early-boot user that I found.

Hmm.  Does the prandom stuff want to use this?

>
>> +
>> +static int kvm_get_slow_rng_u64(u64 *v)
>> +{
>> +     /*
>> +      * Allow migration from a hypervisor with the GET_RNG_SEED
>> +      * feature to a hypervisor without it.
>> +      */
>> +     if (rdmsrl_safe(MSR_KVM_GET_RNG_SEED, v) == 0)
>> +             return 1;
>> +     else
>> +             return 0;
>> +}
>
> How about:
>
> return rdmsrl_safe(MSR_KVM_GET_RNG_SEED, v) == 0;
>
> The naming also feels really inconsistent...

Better ideas welcome.  I could call the generic function
arch_get_pv_random_seed, but maybe someone will come up with a
non-paravirt implementation.

--Andy

>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
