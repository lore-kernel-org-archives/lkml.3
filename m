Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaCKN4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:56:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:60408 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbaCKN4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:56:35 -0400
Date: Tue, 11 Mar 2014 14:56:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Julian Wollrath <jwollrath@web.de>
cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, Lee@linutronix.de,
        Chun-Yi <jlee@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <20140311142910.27594027@ilfaris>
Message-ID: <alpine.DEB.2.02.1403111454140.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris> <alpine.DEB.2.02.1403101123470.18573@ionos.tec.linutronix.de> <20140311142910.27594027@ilfaris>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014, Julian Wollrath wrote:

> Am Mon, 10 Mar 2014 11:39:44 +0100 (CET)
> schrieb Thomas Gleixner <tglx@linutronix.de>:
> > And that definitely does not affect the quick calibration. No idea,
> > except bisecting.
> Ok, via bisecting I found commit
> 73f7d1ca32638028e3271f54616773727e2f9f26 (see below) to be the one that
> introduced this regression.

Interesting. I have no idea what's going on. But maybe can the ACPI
folks shed some light on it.

Thanks,

	tglx
> 
> Cheers,
> Julian Wollrath
> 
> From 73f7d1ca32638028e3271f54616773727e2f9f26 Mon Sep 17 00:00:00 2001
> From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
> Date: Wed, 15 Jan 2014 15:25:48 +0800
> Subject: [PATCH] ACPI / init: Run acpi_early_init() before timekeeping_init()
> 
> This is a variant patch from Rafael J. Wysocki's
> ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
> 
> According to Matt Fleming, if acpi_early_init() was executed before
> efi_enter_virtual_mode(), the EFI initialization could benefit from
> it, so Rafael's patch makes that happen.
> 
> And, we want accessing ACPI TAD device to set system clock, so move
> acpi_early_init() before timekeeping_init(). This final position is
> also before efi_enter_virtual_mode().
> 
> Tested-by: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  init/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/main.c b/init/main.c
> index febc511e078a..b6d93c840154 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
>  	init_timers();
>  	hrtimers_init();
>  	softirq_init();
> +	acpi_early_init();
>  	timekeeping_init();
>  	time_init();
>  	sched_clock_postinit();
> @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
>  
>  	check_bugs();
>  
> -	acpi_early_init(); /* before LAPIC and SMP init */
>  	sfi_init_late();
>  
>  	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> -- 
> 1.9.0
> 
> 
