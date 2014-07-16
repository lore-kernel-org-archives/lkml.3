Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaGPV7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:59:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46243 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaGPV7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:59:40 -0400
Message-ID: <53C6F5A9.80400@zytor.com>
Date: Wed, 16 Jul 2014 14:59:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, kvm@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
CC: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com
Subject: Re: [PATCH v3 2/5] random,x86: Add arch_get_slow_rng_u64
References: <cover.1405546879.git.luto@amacapital.net> <5778e65d5ca52bebbaa023e177d863e44f098e96.1405546879.git.luto@amacapital.net>
In-Reply-To: <5778e65d5ca52bebbaa023e177d863e44f098e96.1405546879.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 02:45 PM, Andy Lutomirski wrote:
> diff --git a/arch/x86/include/asm/archslowrng.h b/arch/x86/include/asm/archslowrng.h
> new file mode 100644
> index 0000000..c8e8d0d
> --- /dev/null
> +++ b/arch/x86/include/asm/archslowrng.h
> @@ -0,0 +1,30 @@
> +/*
> + * This file is part of the Linux kernel.
> + *
> + * Copyright (c) 2014 Andy Lutomirski
> + * Authors: Andy Lutomirski <luto@amacapital.net>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#ifndef ASM_X86_ARCHSLOWRANDOM_H
> +#define ASM_X86_ARCHSLOWRANDOM_H
> +
> +#ifndef CONFIG_ARCH_SLOW_RNG
> +# error archslowrng.h should not be included if !CONFIG_ARCH_SLOW_RNG
> +#endif
> +

I'm *seriously* questioning the wisdom of this.  A much saner thing
would be to do:

#ifndef CONFIG_ARCH_SLOW_RNG

/* Not supported */
static inline int arch_get_slow_rng_u64(u64 *v)
{
	(void)v;
	return 0;
}

#endif

... which is basically what we do for the archrandom stuff.

I'm also wondering if it makes sense to have a function which prefers
arch_get_random*() over this one as a preferred interface.  Something like:

int get_random_arch_u64_slow_ok(u64 *v)
{
	int i;
	u64 x = 0;
	unsigned long l;

	for (i = 0; i < 64/BITS_PER_LONG; i++) {
		if (!arch_get_random_long(&l))
			return arch_get_slow_rng_u64(v);

		x |=  l << (i*BITS_PER_LONG);
	}
	*v = l;
	return 0;
}

This still doesn't address the issue e.g. on x86 where RDRAND is
available but we haven't set up alternatives yet.  So it might be that
what we really want is to encapsulate this fallback in arch code and do
a more direct enumeration.

> +
> +static int kvm_get_slow_rng_u64(u64 *v)
> +{
> +	/*
> +	 * Allow migration from a hypervisor with the GET_RNG_SEED
> +	 * feature to a hypervisor without it.
> +	 */
> +	if (rdmsrl_safe(MSR_KVM_GET_RNG_SEED, v) == 0)
> +		return 1;
> +	else
> +		return 0;
> +}

How about:

return rdmsrl_safe(MSR_KVM_GET_RNG_SEED, v) == 0;

The naming also feels really inconsistent...
	
	-hpa

