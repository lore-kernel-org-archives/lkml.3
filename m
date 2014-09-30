Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaI3U3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:29:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:33297 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaI3U3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:29:07 -0400
Date: Tue, 30 Sep 2014 22:28:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
cc: mingo@redhat.com, davej@redhat.com, hpa@zytor.com, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: Bugfix bit-rot in the calling of
 legacy_cache_size
In-Reply-To: <1412046710-2686-2-git-send-email-pure.logic@nexus-software.ie>
Message-ID: <alpine.DEB.2.11.1409302211560.4455@nanos>
References: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie> <1412046710-2686-2-git-send-email-pure.logic@nexus-software.ie>
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
>  static void default_init(struct cpuinfo_x86 *c)
>  {
> -#ifdef CONFIG_X86_64
>  	cpu_detect_cache_sizes(c);
> -#else
> +
>  	/* Not much we can do here... */
>  	/* Check if at least it has cpuid */
>  	if (c->cpuid_level == -1) {
> @@ -79,7 +78,6 @@ static void default_init(struct cpuinfo_x86 *c)
>  		else if (c->x86 == 3)
>  			strcpy(c->x86_model_id, "386");
>  	}
> -#endif

What's the exact point of this? This is the default init function
which is for X86_VENDOR_UNKNOWN, right?

>  }
>  
>  static const struct cpu_dev default_cpu = {
> @@ -874,6 +872,15 @@ static void identify_cpu(struct cpuinfo_x86 *c)
>  #endif
>  
>  	/*
> +	 * If c_x86_vendor != X86_VENDOR_UNKNOWN i.e. a known vendor then
> +	 * there's a vendor specific c_init()
> +	 *
> +	 * Even still Intel, AMD and VIA make use of legacy_cache_size which
> +	 * is reachable only through default_init right now

That's nonsense. It's called from cpu_detect_cache_sizes() and that is
called from:

arch/x86/kernel/cpu/amd.c:      cpu_detect_cache_sizes(c);
arch/x86/kernel/cpu/centaur.c:  cpu_detect_cache_sizes(c);
arch/x86/kernel/cpu/common.c:   cpu_detect_cache_sizes(c);
arch/x86/kernel/cpu/cyrix.c:            cpu_detect_cache_sizes(c);
arch/x86/kernel/cpu/transmeta.c:        cpu_detect_cache_sizes(c);

So we have 4 callsites outside of default_init() already. Now you're
adding another one into identify_cpu()

> +	 */
> +	if (this_cpu->c_x86_vendor != X86_VENDOR_UNKNOWN)
> +		default_init(c);

With the consequence that for amd/centaur/cyrix/transmeta
cpu_detect_cache_sizes() is invoked twice for nothing.

So the only CPU vendor c_init() callback which does not call
cpu_detect_cache_sizes() is the Intel one. And therefor we inflict
that call on all others twice. Brilliant solution!

So the proper solution is to add the call to identify_cpu()
unconditionally and remove it from _all_ other call sites, make it
static and be done with it.

Sigh,

	tglx


