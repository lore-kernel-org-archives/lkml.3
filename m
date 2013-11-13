Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab3KMSQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:16:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49456 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab3KMSQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:16:02 -0500
Date: Wed, 13 Nov 2013 19:16:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, keescook@chromium.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
Message-ID: <20131113181600.GA6160@amd.pavel.ucw.cz>
References: <1381450698-28710-4-git-send-email-keescook@chromium.org>
 <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>
 <20131111182046.GA14961@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111182046.GA14961@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > x86, kaslr: Provide randomness functions
> > 
> > Adds potential sources of randomness: RDRAND, RDTSC, or the i8254.
> > 
> > This moves the pre-alternatives inline rdrand function into the header so
> > both pieces of code can use it. Availability of RDRAND is then controlled
> > by CONFIG_ARCH_RANDOM, if someone wants to disable it even for kASLR.
> 
> While reviewing this as a pre-pull-request, I noticed the following 
> detail:
> 
> > +static unsigned long get_random_long(void)
> > +{
> > +	unsigned long random;
> > +
> > +	if (has_cpuflag(X86_FEATURE_RDRAND)) {
> > +		debug_putstr("KASLR using RDRAND...\n");
> > +		if (rdrand_long(&random))
> > +			return random;
> > +	}
> > +
> > +	if (has_cpuflag(X86_FEATURE_TSC)) {
> > +		uint32_t raw;
> > +
> > +		debug_putstr("KASLR using RDTSC...\n");
> > +		rdtscl(raw);
> > +
> > +		/* Only use the low bits of rdtsc. */
> > +		random = raw & 0xffff;
> > +	} else {
> > +		debug_putstr("KASLR using i8254...\n");
> > +		random = i8254();
> > +	}
> > +
> > +	/* Extend timer bits poorly... */
> > +	random |= (random << 16);
> > +#ifdef CONFIG_X86_64
> > +	random |= (random << 32);
> > +#endif
> > +	return random;
> > +}
> 
> Why aren't the 3 sources of entropy XOR-ed together?
> 
> Also, we talked about also adding system dependent entropy sources, such 
> as memory layout or the DMI table - none of that seems to have
> happened.

> It's not like this function should be performance critical, it's run once 
> per bootup, right? There's just no excuse for not maximizing available 
> entropy in such a situation ...

If it is not performance critical, why not use "/dev/random"
infrastructure?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
