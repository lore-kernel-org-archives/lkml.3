Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3BEF5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:57:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44015 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab3BEF5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:57:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6690302"
Subject: Re: [PATCH v2 2/4] numa: avoid export acpi_numa variable
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
In-Reply-To: <alpine.DEB.2.02.1302042135590.31498@chino.kir.corp.google.com>
References: <1360031838-26898-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1360031838-26898-3-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302042135590.31498@chino.kir.corp.google.com>
Date: Tue, 05 Feb 2013 13:44:30 +0800
Message-ID: <1360043070.4449.11.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 13:43:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 13:56:24,
	Serialize complete at 2013/02/05 13:56:24
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-04一的 21:39 -0800，David Rientjes写道：
> On Tue, 5 Feb 2013, liguang wrote:
> 
> > acpi_numa is used to prevent srat table
> > being parsed, seems a little miss-named,
> > if 'noacpi' was specified by cmdline and
> > CONFIG_ACPI_NUMA was enabled, acpi_numa
> > will be operated directly from everywhere
> > it needed to disable/enable numa in acpi
> > mode which was a bad thing, so, try to
> > export a fuction to get srat table
> > enable/disable info.
> > 
> > Reviewed-by: David Rientjes <rientjes@google.com>
> 
> Again, this was never reviewed by me, please learn how to use these tags 
> appropriately by reading Documentation/SubmittingPatches.

OK.

> 
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> > ---
> >  arch/x86/include/asm/acpi.h |    2 +-
> >  arch/x86/kernel/acpi/srat.c |   15 ++++++++++-----
> >  arch/x86/mm/numa.c          |    2 +-
> >  arch/x86/xen/enlighten.c    |    2 +-
> >  4 files changed, 13 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
> > index 0c44630..6b9c861 100644
> > --- a/arch/x86/include/asm/acpi.h
> > +++ b/arch/x86/include/asm/acpi.h
> > @@ -181,7 +181,7 @@ static inline void disable_acpi(void) { }
> >  #define ARCH_HAS_POWER_INIT	1
> >  
> >  #ifdef CONFIG_ACPI_NUMA
> > -extern int acpi_numa;
> > +extern void disable_acpi_numa(void);
> >  extern int x86_acpi_numa_init(void);
> >  #endif /* CONFIG_ACPI_NUMA */
> >  
> > diff --git a/arch/x86/kernel/acpi/srat.c b/arch/x86/kernel/acpi/srat.c
> > index 4ddf497..0a4d7ee 100644
> > --- a/arch/x86/kernel/acpi/srat.c
> > +++ b/arch/x86/kernel/acpi/srat.c
> > @@ -24,22 +24,27 @@
> >  #include <asm/apic.h>
> >  #include <asm/uv/uv.h>
> >  
> > -int acpi_numa __initdata;
> > +static bool acpi_numa __initdata;
> >  
> >  static __init int setup_node(int pxm)
> >  {
> >  	return acpi_map_pxm_to_node(pxm);
> >  }
> >  
> > -static __init void bad_srat(void)
> > +void __init disable_acpi_numa(void)
> > +{
> > +	acpi_numa = false;
> > +}
> > +
> > +static void __init bad_srat(void)
> >  {
> > -	printk(KERN_ERR "SRAT: SRAT not used.\n");
> >  	acpi_numa = -1;
> > +	printk(KERN_ERR "SRAT: SRAT will not be used.\n");
> >  }
> >  
> > -static __init inline int srat_disabled(void)
> > +static bool __init srat_disabled(void)
> >  {
> > -	return acpi_numa < 0;
> > +	return acpi_numa;
> >  }
> >  
> >  /* Callback for SLIT parsing */
> > diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> > index 2d125be..870ca6b 100644
> > --- a/arch/x86/mm/numa.c
> > +++ b/arch/x86/mm/numa.c
> > @@ -47,7 +47,7 @@ static __init int numa_setup(char *opt)
> >  #endif
> >  #ifdef CONFIG_ACPI_NUMA
> >  	if (!strncmp(opt, "noacpi", 6))
> > -		acpi_numa = -1;
> > +		disable_acpi_numa();
> >  #endif
> >  	return 0;
> >  }
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 138e566..a5f6353 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -1415,7 +1415,7 @@ asmlinkage void __init xen_start_kernel(void)
> >  	 * any NUMA information the kernel tries to get from ACPI will
> >  	 * be meaningless.  Prevent it from trying.
> >  	 */
> > -	acpi_numa = -1;
> > +	disable_acpi_numa();
> >  #endif
> >  
> >  	/* Don't do the full vcpu_info placement stuff until we have a
> 
> You've declared disable_acpi_numa() but never defined it so this will 
> fail at link time.  Please compile and test all of your changes with care 
> before posting them or people will start to ignore your contributions.

It did pass build.



