Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3LMOqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:46:15 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:53808 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3LMOqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:46:13 -0500
Date: Fri, 13 Dec 2013 11:46:03 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Fix next_pow2_l()
Message-ID: <20131213144603.GB29275@ghostprotocols.net>
References: <1386924816-24402-1-git-send-email-adrian.hunter@intel.com>
 <1386924816-24402-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386924816-24402-2-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 13, 2013 at 10:53:35AM +0200, Adrian Hunter escreveu:

> My implementation of next_pow2_l() was incorrect.  e.g.
 
>   perf record -m4296015872 uname
>   rounding mmap pages size to 17592186044416 bytes (4294967296 pages)
>   Invalid argument for --mmap_pages/-m
 
> Notice that the next power-of-2 value 4294967296 is less than the
> option value 4296015872.
 
> Change to using  __builtin_clzl() and prevent the shift being equal to
> the width of the operand.  Also __builtin_clzl(x) is undefined if x is
> 0, so adjust the condition to preclude that possibility.  Now:

Can we try to look first if there is an implementation for what we need
being used in the kernel sources, in include/ and then try to use, if
possible, exactly like done in kernel code?

For instance, include/linux/log2.h has roundup_pow_of_two() that seems
to be what you need, lemme check...

roundup_pow_of_two(4296015872)=8589934592

So, it yields what we need, I'll try to cook up a patch that makes us
use it, as I did in my dwarves tools in this changeset:

https://git.kernel.org/cgit/devel/pahole/pahole.git/commit/?id=e31fda3063e3c88ca0b93a9fb5e6d6e32478e36b

- Arnaldo
	 
>   perf record -m4296015872 uname
>   rounding mmap pages size to 35184372088832 bytes (8589934592 pages)
>   Invalid argument for --mmap_pages/-m
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/util.h | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index a1eea3e..ae609fe 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -284,13 +284,14 @@ static inline unsigned next_pow2(unsigned x)
>  
>  static inline unsigned long next_pow2_l(unsigned long x)
>  {
> -#if BITS_PER_LONG == 64
> -	if (x <= (1UL << 31))
> -		return next_pow2(x);
> -	return (unsigned long)next_pow2(x >> 32) << 32;
> -#else
> -	return next_pow2(x);
> -#endif
> +	int leading_zeros;
> +
> +	if (x < 2)
> +		return 1;
> +	leading_zeros = __builtin_clzl(x - 1);
> +	if (!leading_zeros)
> +		return 0;
> +	return 1UL << (BITS_PER_LONG - leading_zeros);
>  }
>  
>  size_t hex_width(u64 v);
> -- 
> 1.7.11.7
