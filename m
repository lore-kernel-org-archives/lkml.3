Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaJPImh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:42:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:50381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaJPIme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:42:34 -0400
Date: Thu, 16 Oct 2014 10:42:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
Message-ID: <20141016084227.GI7369@worktop.fdxtended.com>
References: <cover.1413323611.git.luto@amacapital.net>
 <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 03:57:39PM -0700, Andy Lutomirski wrote:
> We currently allow any process to use rdpmc.  This significantly
> weakens the protection offered by PR_TSC_DISABLED, and it could be
> helpful to users attempting to exploit timing attacks.
> 
> Since we can't enable access to individual counters, use a very
> coarse heuristic to limit access to rdpmc: allow access only when
> a perf_event is mmapped.  This protects seccomp sandboxes.
> 
> There is plenty of room to further tighen these restrictions.  For
> example, on x86, *all* perf_event mappings set cap_user_rdpmc.  This
> should probably be changed to only apply to perf_events that are
> accessible using rdpmc.

So I suppose this patch is a little over engineered,

> @@ -1852,10 +1865,26 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
>  	if (x86_pmu.attr_rdpmc_broken)
>  		return -ENOTSUPP;
>  
> +	mutex_lock(&rdpmc_enable_mutex);
>  	if (!!val != !!x86_pmu.attr_rdpmc) {
> -		x86_pmu.attr_rdpmc = !!val;
> -		on_each_cpu(change_rdpmc, (void *)val, 1);
> +		if (val) {
> +			static_key_slow_inc(&rdpmc_enabled);
> +			on_each_cpu(refresh_pce, NULL, 1);
> +			smp_wmb();
> +			x86_pmu.attr_rdpmc = 1;
> +		} else {
> +			/*
> +			 * This direction can race against existing
> +			 * rdpmc-capable mappings.  Try our best regardless.
> +			 */
> +			x86_pmu.attr_rdpmc = 0;
> +			smp_wmb();
> +			static_key_slow_dec(&rdpmc_enabled);
> +			WARN_ON(static_key_true(&rdpmc_enabled));
> +			on_each_cpu(refresh_pce, NULL, 1);
> +		}
>  	}
> +	mutex_unlock(&rdpmc_enable_mutex);
>  
>  	return count;
>  }

why do you care about that rdpmc_enabled static key thing? Also you
should not expose static key control to userspace like this, they can
totally wreck the system. At the very least it should be
static_key_slow_dec_deferred() -- gawd I hate the static_key API.
