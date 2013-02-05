Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3BEA4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:56:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:20615 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755566Ab3BEA4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:56:50 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6688653"
Subject: Re: [PATCH 1/5] numa: avoid export acpi_numa variable
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
In-Reply-To: <alpine.DEB.2.02.1302041127540.10378@chino.kir.corp.google.com>
References: <1359967426-32629-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1359967426-32629-2-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302041127540.10378@chino.kir.corp.google.com>
Date: Tue, 05 Feb 2013 08:56:33 +0800
Message-ID: <1360025793.4449.6.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 08:55:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 08:55:31,
	Serialize complete at 2013/02/05 08:55:31
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-04一的 11:31 -0800，David Rientjes写道：
> On Mon, 4 Feb 2013, liguang wrote:
> 
> > diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
> > index 0c44630..c4e0875 100644
> > --- a/arch/x86/include/asm/acpi.h
> > +++ b/arch/x86/include/asm/acpi.h
> > @@ -181,7 +181,8 @@ static inline void disable_acpi(void) { }
> >  #define ARCH_HAS_POWER_INIT	1
> >  
> >  #ifdef CONFIG_ACPI_NUMA
> > -extern int acpi_numa;
> > +extern void bad_srat(void);
> > +extern bool srat_disabled(void);
> 
> So anything that wants to disable acpi_numa, such as xen, must call a 
> function named bad_srat()?  That seems a little misnamed itself.

I would assume every caller have the sense of what SRAT is.
(may be a little bold assumption)

> 
> >  extern int x86_acpi_numa_init(void);
> >  #endif /* CONFIG_ACPI_NUMA */
> >  
> > diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> > index 2d125be..92986d8 100644
> > --- a/arch/x86/mm/numa.c
> > +++ b/arch/x86/mm/numa.c
> > @@ -47,7 +47,7 @@ static __init int numa_setup(char *opt)
> >  #endif
> >  #ifdef CONFIG_ACPI_NUMA
> >  	if (!strncmp(opt, "noacpi", 6))
> > -		acpi_numa = -1;
> > +		bad_srat();
> 
> This will print an error line saying "SRAT: SRAT not used." which wasn't 
> emitted before.  I don't think that's the desire.

yes, you're right.

> 
> >  #endif
> >  	return 0;
> >  }
> > diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> > index 4ddf497..a837c95 100644
> > --- a/arch/x86/mm/srat.c
> > +++ b/arch/x86/mm/srat.c
> > @@ -24,22 +24,22 @@
> >  #include <asm/apic.h>
> >  #include <asm/uv/uv.h>
> >  
> > -int acpi_numa __initdata;
> > +static bool acpi_numa __initdata;
> >  
> 
> You've changed this to be type bool but didn't update the existing code 
> that still does "acpi_numa = 1".

good catch!

> 
> >  static __init int setup_node(int pxm)
> >  {
> >  	return acpi_map_pxm_to_node(pxm);
> >  }
> >  
> > -static __init void bad_srat(void)
> > +void __init bad_srat(void)
> >  {
> >  	printk(KERN_ERR "SRAT: SRAT not used.\n");
> > -	acpi_numa = -1;
> > +	acpi_numa = false;
> >  }
> >  
> > -static __init inline int srat_disabled(void)
> > +bool __init srat_disabled(void)
> >  {
> > -	return acpi_numa < 0;
> > +	return acpi_numa;
> >  }
> >  
> >  /* Callback for SLIT parsing */
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 138e566..94c8c70 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -1415,7 +1415,7 @@ asmlinkage void __init xen_start_kernel(void)
> >  	 * any NUMA information the kernel tries to get from ACPI will
> >  	 * be meaningless.  Prevent it from trying.
> >  	 */
> > -	acpi_numa = -1;
> > +	bad_srat();
> 
> Same as before.  It seems like you want to introduce a new function 
> specifically to disable it:
> 
> 	void acpi_numa_disable(void)
> 	{
> 		acpi_numa = false;
> 	}
> 
> and then bad_srat() should call into it?

good idea, Thanks!




