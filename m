Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaCLEAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:00:55 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:36332 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaCLEAy (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 12 Mar 2014 00:00:54 -0400
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: joeyli <jlee@suse.com>
To: Julian Wollrath <jwollrath@web.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Lee@linutronix.de,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
In-Reply-To: <20140311181513.0f73383c@ilfaris>
References: <20140310110410.5b2218f6@ilfaris>
	 <alpine.DEB.2.02.1403101123470.18573@ionos.tec.linutronix.de>
	 <20140311142910.27594027@ilfaris>
	 <alpine.DEB.2.02.1403111454140.18573@ionos.tec.linutronix.de>
	 <20140311181513.0f73383c@ilfaris>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Mar 2014 12:00:07 +0800
Message-ID: <1394596807.26565.135.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julian, 

於 二，2014-03-11 於 18:15 +0100，Julian Wollrath 提到：
> Am Tue, 11 Mar 2014 14:56:41 +0100 (CET)
> schrieb Thomas Gleixner <tglx@linutronix.de>:
> > > Ok, via bisecting I found commit
> > > 73f7d1ca32638028e3271f54616773727e2f9f26 (see below) to be the one
> > > that introduced this regression.
> > 
> > Interesting. I have no idea what's going on. But maybe can the ACPI
> > folks shed some light on it.
> 

My patch moved acpi_early_init() to before timekeeping_init() is for
prepare the later using ACPI TAD to set system clock. I think that
because acpi_early_init() setup SCI interrupt and enable acpi subsystem,
it causes fast TSC calibration fail.

> I have absolutely no idea, if it is the right thing to do and why it
> works, but the patch below fixes the problem. Thank you for your help.
> 
> 
> Cheers,
> Julian Wollrath
> 
> From 7664f495039d93adfce073e58840a46549904f04 Mon Sep 17 00:00:00 2001
> From: Julian Wollrath <jwollrath@web.de>
> Date: Tue, 11 Mar 2014 18:05:43 +0100
> Subject: [PATCH] Fix fast TSC calibration
> 
> Since commit 73f7d1ca32638028e3271f54616773727e2f9f26 the fast TSC calibration
> failed on a Thinkpad X121e with an AMD E450 APU. Moving acpi_early_init() after
> late_time_init() fixes this.
> 
> Signed-off-by: Julian Wollrath <jwollrath@web.de>
> ---
>  init/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/main.c b/init/main.c
> index eb03090cdced..bf9d99148bd6 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -561,7 +561,6 @@ asmlinkage void __init start_kernel(void)
>  	init_timers();
>  	hrtimers_init();
>  	softirq_init();
> -	acpi_early_init();
>  	timekeeping_init();
>  	time_init();
>  	sched_clock_postinit();
> @@ -609,6 +608,7 @@ asmlinkage void __init start_kernel(void)
>  	numa_policy_init();
>  	if (late_time_init)
>  		late_time_init();
> +	acpi_early_init();
>  	sched_clock_init();
>  	calibrate_delay();
>  	pidmap_init();

The late_time_init() dependent on timekeeping_init(), if we don't want
move acpi_early_init() before timekeeping_init() then just direct put it
before efi_enter_virtual_mode() because we tested this changed.

This patch restricts the position to run acpi_early_init() before
timekeeping_init() when only "CMOS RTC Not Present" bit set in FADT.

Could you please help to test it on your machine?


Thanks a lot!
Joey Lee


>From 8ef4fff76dd2f50bef1e8eb9c96f3b0228a38401 Mon Sep 17 00:00:00 2001
From: Lee, Chun-Yi <jlee@suse.com>
Date: Wed, 12 Mar 2014 11:36:32 +0800
Subject: [PATCH] ACPI / init: Run acpi_early_init() before timekeeping_init() when CMOS RTC Not Present bit set

This is a variant patch from Rafael J. Wysocki's
ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()

According to Matt Fleming, if acpi_early_init() was executed before
efi_enter_virtual_mode(), the EFI initialization could benefit from
it, so Rafael's patch makes that happen.

And, later we want accessing ACPI TAD device to set system clock, so
move acpi_early_init() before timekeeping_init() when "CMOS RTC Not
Present" bit set. This position is also before efi_enter_virtual_mode().

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 init/main.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index eb03090..e1b69d2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -561,7 +561,9 @@ asmlinkage void __init start_kernel(void)
 	init_timers();
 	hrtimers_init();
 	softirq_init();
-	acpi_early_init();
+	if (acpi_gbl_FADT.header.revision >= 5 &&
+	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC)
+		acpi_early_init();
 	timekeeping_init();
 	time_init();
 	sched_clock_postinit();
@@ -613,6 +615,9 @@ asmlinkage void __init start_kernel(void)
 	calibrate_delay();
 	pidmap_init();
 	anon_vma_init();
+	if (!(acpi_gbl_FADT.header.revision >= 5 &&
+	      acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC))
+		acpi_early_init();
 #ifdef CONFIG_X86
 	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();
-- 
1.6.4.2



