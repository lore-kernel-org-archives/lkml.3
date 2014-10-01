Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaJAOSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:18:08 -0400
Received: from mail-by2on0089.outbound.protection.outlook.com ([207.46.100.89]:4145
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751575AbaJAOSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:18:07 -0400
Date: Wed, 1 Oct 2014 09:17:18 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@shineypoop
To: Pavel Machek <pavel@denx.de>
CC: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 1/2] socfpga: hotplug: put cpu1 in wfi
In-Reply-To: <20141001133527.GA12750@amd>
Message-ID: <alpine.DEB.2.10.1410010915440.2332@shineypoop>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <1411590449-9794-2-git-send-email-atull@opensource.altera.com> <20141001133527.GA12750@amd>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [24.206.110.125]
X-ClientProxiedBy: BLUPR07CA075.namprd07.prod.outlook.com (25.160.24.30) To
 BY2PR03MB315.namprd03.prod.outlook.com (10.141.139.25)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB315;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(24454002)(51914003)(189002)(51884002)(51704005)(77096002)(21056001)(107046002)(19580395003)(54356999)(76176999)(50986999)(87976001)(15202345003)(86362001)(105586002)(85306004)(66066001)(46102003)(92726001)(92566001)(64706001)(80022003)(85852003)(95666004)(42186005)(101416001)(19580405001)(20776003)(86152002)(106356001)(47776003)(110136001)(97736003)(4396001)(23726002)(33716001)(76482002)(120916001)(50466002)(99396003)(83506001)(46406003)(31966008)(10300001)(15975445006)(102836001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB315;H:shineypoop.local;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014, Pavel Machek wrote:

> Hi!
> 
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Use WFI when putting CPU1 to sleep.  Don't hold CPU1 in reset
> > since that results in increased power consumption.
> > 
> > Reset CPU1 briefly during CPU1 bootup.
> > 
> > This has been tested for hotplug and suspend/resume and results
> > in no increased power consumption.
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > ---
> >  arch/arm/mach-socfpga/core.h    |    2 ++
> >  arch/arm/mach-socfpga/platsmp.c |   12 +++++++++---
> >  2 files changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/mach-socfpga/core.h b/arch/arm/mach-socfpga/core.h
> > index 572b8f7..c4a0929 100644
> > --- a/arch/arm/mach-socfpga/core.h
> > +++ b/arch/arm/mach-socfpga/core.h
> > @@ -28,6 +28,8 @@
> >  #define RSTMGR_CTRL_SWCOLDRSTREQ	0x1	/* Cold Reset */
> >  #define RSTMGR_CTRL_SWWARMRSTREQ	0x2	/* Warm Reset */
> >  
> > +#define RSTMGR_MPUMODRST_CPU1		0x2     /*CPU1 Reset*/
> > +
> 
> It would be nice to have space after /* and before */.

Hi Pavel,

I will fix the comment space here and the other place you pointed out.

> 
> > diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
> > index 5356a72..1d5f8ad 100644
> > --- a/arch/arm/mach-socfpga/platsmp.c
> > +++ b/arch/arm/mach-socfpga/platsmp.c
> > @@ -34,6 +34,10 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
> >  	int trampoline_size = &secondary_trampoline_end - &secondary_trampoline;
> >  
> >  	if (cpu1start_addr) {
> > +		/* This will put CPU #1 into reset.*/
> 
> Same here.
> 
> > +		__raw_writel(RSTMGR_MPUMODRST_CPU1,
> > +			     rst_manager_base_addr + 0x10);
> 
> Would it be possible to copy reset manager description struct from
> u-boot and use it here, instead of raw offset?

I will replace this 0x10 with a macro that reflects how the register is 
named in the register map.

Thanks for the review!

Alan

> 								Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
