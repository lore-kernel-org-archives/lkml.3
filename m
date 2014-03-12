Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaCLKUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:20:22 -0400
Received: from mout.web.de ([212.227.15.4]:52031 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbaCLKUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:20:20 -0400
Date: Wed, 12 Mar 2014 11:20:10 +0100
From: Julian Wollrath <jwollrath@web.de>
To: joeyli <jlee@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Lee@linutronix.de,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
Message-ID: <20140312112010.48e46749@ilfaris>
In-Reply-To: <1394596807.26565.135.camel@linux-s257.site>
References: <20140310110410.5b2218f6@ilfaris>
	<alpine.DEB.2.02.1403101123470.18573@ionos.tec.linutronix.de>
	<20140311142910.27594027@ilfaris>
	<alpine.DEB.2.02.1403111454140.18573@ionos.tec.linutronix.de>
	<20140311181513.0f73383c@ilfaris>
	<1394596807.26565.135.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:z/6LTgaJcFs3iq9wzb8hfiMlfcerpsPPafUCfP4xYk2q5x9iVMu
 hEwBQlsg5w9BXlWgS4IyTKQhbSyPjhurB0hgub/riJJTBX/80YpfnjPHU97Zzni/Y2z8yZN
 iL6OH7qtZ17YtP88oXfXRrGLzI9DVY8oFuwuy9HEMA98YTpD9VpE+b92N8eq3lABNeZ7K94
 MJYLnGxFwVMCtuydGVEnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch restricts the position to run acpi_early_init() before
> timekeeping_init() when only "CMOS RTC Not Present" bit set in FADT.
> 
> Could you please help to test it on your machine?
That patch fixes the problem, thank you.

Cheers,
Julian Wollrath
> 
> 
> Thanks a lot!
> Joey Lee
> 
> 
> >From 8ef4fff76dd2f50bef1e8eb9c96f3b0228a38401 Mon Sep 17 00:00:00
> >2001
> From: Lee, Chun-Yi <jlee@suse.com>
> Date: Wed, 12 Mar 2014 11:36:32 +0800
> Subject: [PATCH] ACPI / init: Run acpi_early_init() before
> timekeeping_init() when CMOS RTC Not Present bit set
> 
> This is a variant patch from Rafael J. Wysocki's
> ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
> 
> According to Matt Fleming, if acpi_early_init() was executed before
> efi_enter_virtual_mode(), the EFI initialization could benefit from
> it, so Rafael's patch makes that happen.
> 
> And, later we want accessing ACPI TAD device to set system clock, so
> move acpi_early_init() before timekeeping_init() when "CMOS RTC Not
> Present" bit set. This position is also before
> efi_enter_virtual_mode().
> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  init/main.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index eb03090..e1b69d2 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -561,7 +561,9 @@ asmlinkage void __init start_kernel(void)
>  	init_timers();
>  	hrtimers_init();
>  	softirq_init();
> -	acpi_early_init();
> +	if (acpi_gbl_FADT.header.revision >= 5 &&
> +	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC)
> +		acpi_early_init();
>  	timekeeping_init();
>  	time_init();
>  	sched_clock_postinit();
> @@ -613,6 +615,9 @@ asmlinkage void __init start_kernel(void)
>  	calibrate_delay();
>  	pidmap_init();
>  	anon_vma_init();
> +	if (!(acpi_gbl_FADT.header.revision >= 5 &&
> +	      acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC))
> +		acpi_early_init();
>  #ifdef CONFIG_X86
>  	if (efi_enabled(EFI_RUNTIME_SERVICES))
>  		efi_enter_virtual_mode();

