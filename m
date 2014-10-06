Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaJFJzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:55:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:53479 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaJFJzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:55:54 -0400
Date: Mon, 6 Oct 2014 11:55:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
cc: mingo@redhat.com, hpa@zytor.com, davej@redhat.com, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86: Add cpu_detect_cache_sizes() to init_intel(),
 add Quark to legacy_cache()
In-Reply-To: <1412459037-26089-2-git-send-email-pure.logic@nexus-software.ie>
Message-ID: <alpine.DEB.2.11.1410061121470.4383@nanos>
References: <1412459037-26089-1-git-send-email-pure.logic@nexus-software.ie> <1412459037-26089-2-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2014, Bryan O'Donoghue wrote:
> @@ -381,7 +381,18 @@ static void init_intel(struct cpuinfo_x86 *c)
>  #endif
>  	}
>  
> -	l2 = init_intel_cacheinfo(c);
> +	/* Detect legacy cache sizes */
> +	cpu_detect_cache_sizes(c);
> +
> +	/*
> +	 * If cache_size has not been initialized via legacy_cache()
> +	 * probe it via init_intel_cacheinfo().
> +	 */
> +	if (c->x86_cache_size == 0)
> +		l2 = init_intel_cacheinfo(c);
> +	else
> +		l2 = c->x86_cache_size;

Looking a bit deeper. This wont work because cpu_detect_cache_sizes()
will set c->x86_cache_size for all cpus with extended_cpuid_level >=
0x80000005, which is the case for everything modern. So this results
in init_intel_cacheinfo() not being called anymore.

So we might need the following conditional:

	l2 = init_intel_cacheinfo(c);
+	if (!c->x86_cache_size) {
+		cpu_detect_cache_sizes(c);
+		l2 = c->x86_cache_size;
+	}

If that does not work because c->x86_cache_size is not 0 after
init_intel_cacheinfo() we really need to make it family/model
dependent.

Thanks,

	tglx
