Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497Ab3JPOAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:00:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:29634 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760584Ab3JPOA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:00:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,507,1378882800"; 
   d="scan'208";a="420027128"
Message-ID: <525E9BF7.7020706@linux.intel.com>
Date: Wed, 16 Oct 2013 07:00:23 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: unify copy_from_user() checking
References: <525E964402000078000FB70C@nat28.tlf.novell.com>
In-Reply-To: <525E964402000078000FB70C@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> It also puzzles me that similar checking isn't done for copy_to_user():
> While not resulting in (kernel) buffer overflows, size mistakes there
> would still lead to information leaks.

at the time I went for the highest payoff only; e.g. the mistake of copying
to a fixed size kernel buffer.

Adding the other direction is a good idea of course.


>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Guenter Roeck <linux@roeck-us.net>


> +static inline unsigned long __must_check copy_from_user(void *to,
> +					  const void __user *from,
> +					  unsigned long n)
> +{
> +	int sz = __compiletime_object_size(to);
> +
> +	might_fault();
> +	if (likely(sz == -1 || sz >= n))
> +		n = _copy_from_user(to, from, n);
> +	else if(__builtin_constant_p(n))
> +		copy_from_user_overflow();


this part I am not so sure about.
the original intent was that even if n is not constant, the compiler must still be able
to prove that it is smaller than sz using the range tracking feature in gcc!
In fact, that was the whole point.
The code (at the time, they're all fixed) found cases where the checks done to "n" were off by one
etc...

by requiring "n" to be constant for these checks you remove that layer of checking.

if you have found cases where this matters... maybe you found a new security issue...


so while I like the cleanup part of your patch.... not convinced on this part yet

