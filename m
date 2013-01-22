Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3AVUfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:35:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50926 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab3AVUfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:35:08 -0500
Date: Tue, 22 Jan 2013 15:34:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Matt Sealey <matt@genesi-usa.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        devel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: Compilation problem with drivers/staging/zsmalloc when !SMP on
 ARM
Message-ID: <20130122203450.GD12371@phenom.dumpdata.com>
References: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com>
 <20130118210859.GH23505@n2100.arm.linux.org.uk>
 <CAKGA1bmJ6c4LC=NAD4MU_rBZ2hZjf6qH=C+dqMCf0eP+2vSFdA@mail.gmail.com>
 <20130119044602.GC5391@phenom.dumpdata.com>
 <20130121055541.GD3666@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121055541.GD3666@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The initial patch were done on x86. Then Seth did the work to make sure
> > it worked on PPC. Munchin looked on ARM and that is it.
> 
> s/Munchin/Minchan

Thank you. I am sorry for butchering your name.
> 
> > 
> > If you have an ARM server that you would be willing to part with I would
> > be thrilled to look at it.
> > 
> > > 
> > > diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c
> > > b/drivers/staging/zsmalloc/zsmalloc-main.c
> > > index 09a9d35..ecf75fb 100644
> > 	> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> > > +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> > > @@ -228,7 +228,7 @@ struct zs_pool {
> > >   * mapping rather than copying
> > >   * for object mapping.
> > >  */
> > > -#if defined(CONFIG_ARM)
> > > +#if defined(CONFIG_ARM) && defined(CONFIG_SMP)
> > >  #define USE_PGTABLE_MAPPING
> 
> I don't get it. How to prevent the problem Russel described?
> The problem is that other CPU can prefetch _speculatively_ under us.

<nods> Not sure either.
> 
> > >  #endif
> > > 
> > > .. such that it even compiles in both "guess" configurations, the
> > > slower Cortex-A8 600MHz single core system gets to use the slow copy
> > > path and the dual-core 1GHz+ Cortex-A9 (with twice the RAM..) gets to
> > > use the fast mapping path. Essentially all the patch does is "improve
> > > performance" on the fastest, best-configured, large-amounts-of-RAM,
> > > lots-of-CPU-performance ARM systems (OMAP4+, Snapdragon, Exynos4+,
> > > marvell armada, i.MX6..) while introducing the problems Russell
> > > describes, and leave performance exactly the same and potentially far
> > > more stable on the slower, memory-limited ARM machines.
> > 
> > Any ideas on how to detect that?
> > > 
> > > Given the purpose of zsmalloc, zram, zcache etc. this somewhat defies
> > > logic. If it's not making the memory-limited, slow ARM systems run
> > > better, what's the point?
> > > 
> > > So in summary I suggest "we" (Greg? or is it Seth's responsibility?)
> > > should just back out that whole USE_PGTABLE_MAPPING chunk of code
> > > introduced with f553646. Then Russell can carry on randconfiging and I
> > > can build for SMP and UP and get the same code.. with less bugs.
> > 
> > I get that you want to have this fixed right now. I think having it
> > fixed the right way is a better choice. Lets discuss that first
> > before we start tossing patches to disable parts of it.
> 
> If I don't miss something, we could have 2 choice.
> 
> 1) use flush_tlb_kernel_range instead of local_flush_tlb_kernel_range
> Or
> 2) use only memory copy
> 
> I guess everybody want 2 because it makes code very simple and maintainable.
> Even, rencently Joonsoo sent optimize patch.
> Look at https://lkml.org/lkml/2013/1/16/68 so zram/zcache effect caused by 2
> would be minimized.
> 
> But please give me the time and I will borrow quad-core embedded target board
> and test 1 on the phone with Seth's benchmark.
> 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Kind regards,
> Minchan Kim
