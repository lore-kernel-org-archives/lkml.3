Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaI3Tiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:38:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:33084 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaI3Tip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:38:45 -0400
Date: Tue, 30 Sep 2014 21:38:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
cc: mingo@redhat.com, davej@redhat.com, hpa@zytor.com, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Quark: Update cache reporting, add Quark SoC
 X1000 string
In-Reply-To: <1412046710-2686-3-git-send-email-pure.logic@nexus-software.ie>
Message-ID: <alpine.DEB.2.11.1409302129550.4455@nanos>
References: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie> <1412046710-2686-3-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Bryan O'Donoghue wrote:

> Adds a path for legacy_cache_size to get a Quark SoC X1000 cache size
> Update init_intel to take account of PIII Tualatin and Quark X1000
> reporting cache size via legacy_cache_size

I don't see any reference to PIII Tualatin in the patch itself.

> Add string to family/model structure for completeness and better
> output of /proc/cpuinfo
> 
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
> ---
>  arch/x86/kernel/cpu/intel.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 50ce751..686eae7 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -396,7 +396,13 @@ static void init_intel(struct cpuinfo_x86 *c)
>  #endif
>  	}
>  
> -	l2 = init_intel_cacheinfo(c);
> +
> +	/* legacy_cache may have provided and cache_size already if not probe */

That comment took me some time to decode.

	/* 
	 * If cache_size has not been initialized via legacy_cache()
	 * probe it via init_intel_cacheinfo().
	 */

Perhaps?

> +	if (c->x86_cache_size == 0)
> +		l2 = init_intel_cacheinfo(c);
> +	else
> +		l2 = c->x86_cache_size;
> +
>  	if (c->cpuid_level > 9) {
>  		unsigned eax = cpuid_eax(10);
>  		/* Check for version and the number of counters */
> @@ -500,6 +506,15 @@ static unsigned int intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
>  	 */
>  	if ((c->x86 == 6) && (c->x86_model == 11) && (size == 0))
>  		size = 256;
> +

Stray extra newline

> +
> +	/*
> +	 * Intel Quark SoC X1000 contains a 4-way set associative
> +	 * 16K cache with a 16 byte cache line and 256 lines per tag
> +	 */
> +	if ((c->x86 == 5) && (c->x86_model == 9))
> +		size = 16;
> +
>  	return size;
>  }

Thanks,

	tglx
