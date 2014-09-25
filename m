Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaIYPMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:12:18 -0400
Received: from mail-bl2on0087.outbound.protection.outlook.com ([65.55.169.87]:39162
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753270AbaIYPMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:12:16 -0400
X-Greylist: delayed 76007 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 11:12:16 EDT
Date: Thu, 25 Sep 2014 10:06:10 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <dinguyen@opensource.altera.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 1/2] socfpga: hotplug: put cpu1 in wfi
In-Reply-To: <20140924212803.GD5182@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1409251002090.693@atx-linux-37>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <1411590449-9794-2-git-send-email-atull@opensource.altera.com> <20140924212803.GD5182@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0060.namprd08.prod.outlook.com (10.141.200.40) To
 DM2PR03MB317.namprd03.prod.outlook.com (10.141.54.15)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB317;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(51704005)(199003)(51914003)(86152002)(74502003)(97736003)(90102001)(85852003)(76176999)(46102003)(83072002)(66066001)(10300001)(92726001)(46406003)(120916001)(79102003)(81342003)(81542003)(77982003)(4396001)(80022003)(74662003)(83506001)(23726002)(106356001)(92566001)(50986999)(77096002)(102836001)(95666004)(42186005)(54356999)(47776003)(50466002)(83322001)(19580405001)(33716001)(20776003)(19580395003)(110136001)(69596002)(21056001)(105586002)(53416004)(31966008)(101416001)(85306004)(107046002)(81156004)(64706001)(76482002)(99396003)(87976001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB317;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Russell King - ARM Linux wrote:

Hi Russell,

> On Wed, Sep 24, 2014 at 03:27:28PM -0500, atull@opensource.altera.com wrote:
> > diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
> > index 5356a72..1d5f8ad 100644
> > --- a/arch/arm/mach-socfpga/platsmp.c
> > +++ b/arch/arm/mach-socfpga/platsmp.c
> > @@ -34,6 +34,10 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
> >  	int trampoline_size = &secondary_trampoline_end - &secondary_trampoline;
> >  
> >  	if (cpu1start_addr) {
> > +		/* This will put CPU #1 into reset.*/
> > +		__raw_writel(RSTMGR_MPUMODRST_CPU1,
> > +			     rst_manager_base_addr + 0x10);
> 
> If you can place CPU1 into reset, then why not place it into reset during
> hot unplug?

It's a chip weirdness.  We can reset CPU1 briefly, but if we leave it in
reset, it results in power consumption going up.

> 
> > @@ -86,10 +90,12 @@ static void __init socfpga_smp_prepare_cpus(unsigned int max_cpus)
> >   */
> >  static void socfpga_cpu_die(unsigned int cpu)
> >  {
> > -	cpu_do_idle();
> > +	/* Flush the L1 data cache. */
> > +	flush_cache_all();
> 
> Why do you think that's necessary?
> 
> This potentially flushes *all* levels of the cache, including L2, which
> is not a nice thing to do if you have another CPU running.  Secondly,
> the core code has already called flush_cache_louis() _twice_ for you
> immediately prior to calling your cpu_die() function explicitly to
> remove any L1 data.
> 
> The only data which should remain are speculative prefetches and stack
> data specific to _this_ CPU (which could include dirty cache lines
> associated with the stack frame to enter your cpu_die function.)
> None of these cache lines are of any interest to other CPUs in the
> system, so there's no need for them to be written back prior to the
> CPU being reset or powered down for hot unplug.
> 

Then it's clear we don't need that.  I'll take it out in v2.

Thanks for the review!

Alan
