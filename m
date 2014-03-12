Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaCLN4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:56:12 -0400
Received: from mout.web.de ([212.227.17.12]:57434 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbaCLN4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:56:09 -0400
Date: Wed, 12 Mar 2014 14:55:54 +0100
From: Julian Wollrath <jwollrath@web.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: joeyli <jlee@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
Message-ID: <20140312145554.65eafc6c@ilfaris>
In-Reply-To: <53642014.xoKWERQIvL@vostro.rjw.lan>
References: <20140310110410.5b2218f6@ilfaris>
	<1394596807.26565.135.camel@linux-s257.site>
	<1902317.cSAIh6fs84@vostro.rjw.lan>
	<53642014.xoKWERQIvL@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:0ebghvxOZ4YgA/ZAHj6OgqF20EIwN3bB2qHHxjyxs48hSRkjtxM
 9HusMGN53JzhGBPo0rw1qUg73biFSodzodSntYn5GA2r59bEYiESooYRL1MatfLDHffXeuO
 zTmtdWZ5GbdCahIQfWylWzshKf2t87ZO3OsTKBVR38dXk2Hr8yIYbDkMsCtb4dq9w2PeNFv
 8vSTFYmCydpkrM5F3Uayw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But I wonder: Can we simply enable SCI later?  In other words, can
> > we split acpi_early_init() so that the part before
> > acpi_enable_subsystem() is done before timekeeping_init() and the
> > part including and after is done right after anon_vma_init()?
> > Would the TAD initialization work then?
> 
> Below is a patch implementing that idea.  Julian, can you please test
> this one too?
That patch also fixes the problem, thank you.

Cheers,
Julian

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
>  	}
>  
>  	status = acpi_load_tables();
> -	if (ACPI_FAILURE(status)) {
> -		printk(KERN_ERR PREFIX
> -		       "Unable to load the System Description
> Tables\n");
> -		goto error0;
> -	}
> +	if (ACPI_SUCCESS(status))
> +		return;
> +
> +	printk(KERN_ERR PREFIX "Unable to load the System
> Description Tables\n"); +
> + error0:
> +	disable_acpi();
> +}
> +
> +void __init acpi_subsystem_init(void)
> +{
> +	acpi_status status;
> +
> +	if (acpi_disabled)
> +		return;
>  
>  #ifdef CONFIG_X86
>  	if (!acpi_ioapic) {
> Index: linux-pm/include/linux/acpi.h
> ===================================================================
> --- linux-pm.orig/include/linux/acpi.h
> +++ linux-pm/include/linux/acpi.h
> @@ -401,6 +401,7 @@ extern acpi_status acpi_pci_osc_control_
>  #define ACPI_OST_SC_INSERT_NOT_SUPPORTED	0x82
>  
>  extern void acpi_early_init(void);
> +extern void acpi_subsystem_init(void);
>  
>  extern int acpi_nvs_register(__u64 start, __u64 size);
>  
> Index: linux-pm/init/main.c
> ===================================================================
> --- linux-pm.orig/init/main.c
> +++ linux-pm/init/main.c
> @@ -613,6 +613,7 @@ asmlinkage void __init start_kernel(void
>  	calibrate_delay();
>  	pidmap_init();
>  	anon_vma_init();
> +	acpi_subsystem_init();
>  #ifdef CONFIG_X86
>  	if (efi_enabled(EFI_RUNTIME_SERVICES))
>  		efi_enter_virtual_mode();
> 

