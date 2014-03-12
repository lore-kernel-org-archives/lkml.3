Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaCLPmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:42:25 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:47208 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbaCLPmX (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 12 Mar 2014 11:42:23 -0400
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: joeyli <jlee@suse.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Julian Wollrath <jwollrath@web.de>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <53642014.xoKWERQIvL@vostro.rjw.lan>
References: <20140310110410.5b2218f6@ilfaris>
	 <1394596807.26565.135.camel@linux-s257.site>
	 <1902317.cSAIh6fs84@vostro.rjw.lan>  <53642014.xoKWERQIvL@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Mar 2014 23:41:39 +0800
Message-ID: <1394638899.26565.197.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael, 

於 三，2014-03-12 於 14:30 +0100，Rafael J. Wysocki 提到：
> > But I wonder: Can we simply enable SCI later?  In other words, can
> we
> > split acpi_early_init() so that the part before
> acpi_enable_subsystem()
> > is done before timekeeping_init() and the part including and after
> > is done right after anon_vma_init()?  Would the TAD initialization
> work
> > then?
> 
> Below is a patch implementing that idea.  Julian, can you please test
> this one too?
> 
> Rafael
> 
> ---
>  drivers/acpi/bus.c   |   20 +++++++++++++++-----
>  include/linux/acpi.h |    1 +
>  init/main.c          |    1 +
>  3 files changed, 17 insertions(+), 5 deletions(-)
> 
> Index: linux-pm/drivers/acpi/bus.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/bus.c
> +++ linux-pm/drivers/acpi/bus.c
> @@ -494,11 +494,21 @@ void __init acpi_early_init(void)
>         }
>  
>         status = acpi_load_tables();
> -       if (ACPI_FAILURE(status)) {
> -               printk(KERN_ERR PREFIX
> -                      "Unable to load the System Description Tables
> \n");
> -               goto error0;
> -       }
> +       if (ACPI_SUCCESS(status))
> +               return;
> +
> +       printk(KERN_ERR PREFIX "Unable to load the System Description
> Tables\n");
> +
> + error0:
> +       disable_acpi();
> +}
> +
> +void __init acpi_subsystem_init(void)
> +{
> +       acpi_status status;
> +
> +       if (acpi_disabled)
> +               return;
>  

After check the DSDT of target machine, I afraid the above patch is not
enough to use _GRT and _SRT because they need opregion support of
SystemMemory and SystemIO for trigger SMM to access RTC.

In my current semifinished patches, I add code to run the
acpi_ev_install_region_handlers() in acpi_enable_subsystem() when
acpi_early_init(), for install region handler to support opregion.

Before install region_handlers, it call acpi_enable() to enable acpi
mode and I think need setup SCI interrupt before run acpi_enable():

acpi_early_init(void)
	acpi_pic_sci_set_trigger(acpi_gbl_FADT.sci_interrupt,
	acpi_enable_subsystem(u32 flags)
		acpi_enable();		/* Enable ACPI mode */
		acpi_tb_initialize_facs();
		acpi_ev_install_region_handlers();  /* Need it! */


For developing ACPI TAD support, I used SystemIO to access CMOS port in
DSDT of Intel DQ57 for simulate ACPI TAD. It also need SystemIO opregion
support as the real machine. I just run your patch on this machine but
it failed.

I think maybe still using ACPI_FADT_NO_CMOS_RTC to check does
acpi_early_init() need run before timekeeping_init().
If there have any future machine that applied ACPI TAD but "Fast TSC
calibration" fail, at least the alternate TSC calibration can work
around issue.


Thanks a lot!
Joey Lee

