Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaCLOCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:02:14 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:34207 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbaCLOBu (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 12 Mar 2014 10:01:50 -0400
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: joeyli <jlee@suse.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Julian Wollrath <jwollrath@web.de>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, Lee@linutronix.de,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
In-Reply-To: <1902317.cSAIh6fs84@vostro.rjw.lan>
References: <20140310110410.5b2218f6@ilfaris>
	 <20140311181513.0f73383c@ilfaris>
	 <1394596807.26565.135.camel@linux-s257.site>
	 <1902317.cSAIh6fs84@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Mar 2014 22:00:51 +0800
Message-ID: <1394632851.26565.160.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2014-03-12 於 12:20 +0100，Rafael J. Wysocki 提到：
> On Wednesday, March 12, 2014 12:00:07 PM joeyli wrote:
> > Hi Julian, 
[...]
> > 
> > 
> > >From 8ef4fff76dd2f50bef1e8eb9c96f3b0228a38401 Mon Sep 17 00:00:00 2001
> > From: Lee, Chun-Yi <jlee@suse.com>
> > Date: Wed, 12 Mar 2014 11:36:32 +0800
> > Subject: [PATCH] ACPI / init: Run acpi_early_init() before timekeeping_init() when CMOS RTC Not Present bit set
> > 
> > This is a variant patch from Rafael J. Wysocki's
> > ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
> > 
> > According to Matt Fleming, if acpi_early_init() was executed before
> > efi_enter_virtual_mode(), the EFI initialization could benefit from
> > it, so Rafael's patch makes that happen.
> > 
> > And, later we want accessing ACPI TAD device to set system clock, so
> > move acpi_early_init() before timekeeping_init() when "CMOS RTC Not
> > Present" bit set. This position is also before efi_enter_virtual_mode().
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  init/main.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/init/main.c b/init/main.c
> > index eb03090..e1b69d2 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -561,7 +561,9 @@ asmlinkage void __init start_kernel(void)
> >  	init_timers();
> >  	hrtimers_init();
> >  	softirq_init();
> > -	acpi_early_init();
> > +	if (acpi_gbl_FADT.header.revision >= 5 &&
> > +	    acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC)
> > +		acpi_early_init();
> 
> Sorry, this is not the right way to address that.
> 
> First of all, checking fields in acpi_gbl_FADT from anything in init/main.c
> is wrong.  If anything, please move that check to acpi_early_init().  And
> make it check it if it's been called already.
> 

I see, thanks for your suggestion.

> >  	timekeeping_init();
> >  	time_init();
> >  	sched_clock_postinit();
> > @@ -613,6 +615,9 @@ asmlinkage void __init start_kernel(void)
> >  	calibrate_delay();
> >  	pidmap_init();
> >  	anon_vma_init();
> > +	if (!(acpi_gbl_FADT.header.revision >= 5 &&
> > +	      acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC))
> > +		acpi_early_init();
> 
> And then you can call it here again.
> 
> >  #ifdef CONFIG_X86
> >  	if (efi_enabled(EFI_RUNTIME_SERVICES))
> >  		efi_enter_virtual_mode();
> > 
> 
> But I wonder: Can we simply enable SCI later?  In other words, can we
> split acpi_early_init() so that the part before acpi_enable_subsystem()
> is done before timekeeping_init() and the part including and after
> is done right after anon_vma_init()?  Would the TAD initialization work
> then?
> 

The machine that support ACPI TAD doesn't on my hand now, I need find a
time go to check it. Per DSDT, it trigger SMI in _GRT and _SRT to
get/set time. Looks no SCI involve.


Thanks a lot!
Joey Lee


