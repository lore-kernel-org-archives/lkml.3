Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3KKSUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:20:55 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49649 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3KKSUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:20:50 -0500
Date: Mon, 11 Nov 2013 19:20:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, keescook@chromium.org,
        tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
Message-ID: <20131111182046.GA14961@gmail.com>
References: <1381450698-28710-4-git-send-email-keescook@chromium.org>
 <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Kees Cook <tipbot@zytor.com> wrote:

> Commit-ID:  5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3
> Gitweb:     http://git.kernel.org/tip/5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Thu, 10 Oct 2013 17:18:15 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Sun, 13 Oct 2013 03:12:12 -0700
> 
> x86, kaslr: Provide randomness functions
> 
> Adds potential sources of randomness: RDRAND, RDTSC, or the i8254.
> 
> This moves the pre-alternatives inline rdrand function into the header so
> both pieces of code can use it. Availability of RDRAND is then controlled
> by CONFIG_ARCH_RANDOM, if someone wants to disable it even for kASLR.

While reviewing this as a pre-pull-request, I noticed the following 
detail:

> +static unsigned long get_random_long(void)
> +{
> +	unsigned long random;
> +
> +	if (has_cpuflag(X86_FEATURE_RDRAND)) {
> +		debug_putstr("KASLR using RDRAND...\n");
> +		if (rdrand_long(&random))
> +			return random;
> +	}
> +
> +	if (has_cpuflag(X86_FEATURE_TSC)) {
> +		uint32_t raw;
> +
> +		debug_putstr("KASLR using RDTSC...\n");
> +		rdtscl(raw);
> +
> +		/* Only use the low bits of rdtsc. */
> +		random = raw & 0xffff;
> +	} else {
> +		debug_putstr("KASLR using i8254...\n");
> +		random = i8254();
> +	}
> +
> +	/* Extend timer bits poorly... */
> +	random |= (random << 16);
> +#ifdef CONFIG_X86_64
> +	random |= (random << 32);
> +#endif
> +	return random;
> +}

Why aren't the 3 sources of entropy XOR-ed together?

Also, we talked about also adding system dependent entropy sources, such 
as memory layout or the DMI table - none of that seems to have happened.

It's not like this function should be performance critical, it's run once 
per bootup, right? There's just no excuse for not maximizing available 
entropy in such a situation ...

Thanks,

	Ingo
