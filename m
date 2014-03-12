Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaCLLEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:04:45 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56905 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753565AbaCLLEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:04:43 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: joeyli <jlee@suse.com>
Cc: Julian Wollrath <jwollrath@web.de>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, Lee@linutronix.de,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
Date: Wed, 12 Mar 2014 12:20:02 +0100
Message-ID: <1902317.cSAIh6fs84@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394596807.26565.135.camel@linux-s257.site>
References: <20140310110410.5b2218f6@ilfaris> <20140311181513.0f73383c@ilfaris> <1394596807.26565.135.camel@linux-s257.site>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 12, 2014 12:00:07 PM joeyli wrote:
> Hi Julian, 
> 
> 於 二，2014-03-11 於 18:15 +0100，Julian Wollrath 提到：
> > Am Tue, 11 Mar 2014 14:56:41 +0100 (CET)
> > schrieb Thomas Gleixner <tglx@linutronix.de>:
> > > > Ok, via bisecting I found commit
> > > > 73f7d1ca32638028e3271f54616773727e2f9f26 (see below) to be the one
> > > > that introduced this regression.
> > > 
> > > Interesting. I have no idea what's going on. But maybe can the ACPI
> > > folks shed some light on it.
> > 
> 
> My patch moved acpi_early_init() to before timekeeping_init() is for
> prepare the later using ACPI TAD to set system clock. I think that
> because acpi_early_init() setup SCI interrupt and enable acpi subsystem,
> it causes fast TSC calibration fail.
> 
> > I have absolutely no idea, if it is the right thing to do and why it
> > works, but the patch below fixes the problem. Thank you for your help.
> > 
> > 
> > Cheers,
> > Julian Wollrath
> > 
> > From 7664f495039d93adfce073e58840a46549904f04 Mon Sep 17 00:00:00 2001
> > From: Julian Wollrath <jwollrath@web.de>
> > Date: Tue, 11 Mar 2014 18:05:43 +0100
> > Subject: [PATCH] Fix fast TSC calibration
> > 
> > Since commit 73f7d1ca32638028e3271f54616773727e2f9f26 the fast TSC calibration
> > failed on a Thinkpad X121e with an AMD E450 APU. Moving acpi_early_init() after
> > late_time_init() fixes this.
> > 
> > Signed-off-by: Julian Wollrath <jwollrath@web.de>
> > ---
> >  init/main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/init/main.c b/init/main.c
> > index eb03090cdced..bf9d99148bd6 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -561,7 +561,6 @@ asmlinkage void __init start_kernel(void)
> >  	init_timers();
> >  	hrtimers_init();
> >  	softirq_init();
> > -	acpi_early_init();
> >  	timekeeping_init();
> >  	time_init();
> >  	sched_clock_postinit();
> > @@ -609,6 +608,7 @@ asmlinkage void __init start_kernel(void)
> >  	numa_policy_init();
> >  	if (late_time_init)
> >  		late_time_init();
> > +	acpi_early_init();
> >  	sched_clock_init();
> >  	calibrate_delay();
> >  	pidmap_init();
> 
> The late_time_init() dependent on timekeeping_init(), if we don't want
> move acpi_early_init() before timekeeping_init() then just direct put it
> before efi_enter_virtual_mode() because we tested this changed.
> 
> This patch restricts the position to run acpi_early_init() before
> timekeeping_init() when only "CMOS RTC Not Present" bit set in FADT.
> 
> Could you please help to test it on your machine?
> 
> 
> Thanks a lot!
> Joey Lee
> 
> 
> >From 8ef4fff76dd2f50bef1e8eb9c96f3b0228a38401 Mon Sep 17 00:00:00 2001
> From: Lee, Chun-Yi <jlee@suse.com>
> Date: Wed, 12 Mar 2014 11:36:32 +0800
> Subject: [PATCH] ACPI / init: Run acpi_early_init() before timekeeping_init() when CMOS RTC Not Present bit set
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
> Present" bit set. This position is also before efi_enter_virtual_mode().
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

Sorry, this is not the right way to address that.

First of all, checking fields in acpi_gbl_FADT from anything in init/main.c
is wrong.  If anything, please move that check to acpi_early_init().  And
make it check it if it's been called already.

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

And then you can call it here again.

>  #ifdef CONFIG_X86
>  	if (efi_enabled(EFI_RUNTIME_SERVICES))
>  		efi_enter_virtual_mode();
> 

But I wonder: Can we simply enable SCI later?  In other words, can we
split acpi_early_init() so that the part before acpi_enable_subsystem()
is done before timekeeping_init() and the part including and after
is done right after anon_vma_init()?  Would the TAD initialization work
then?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
