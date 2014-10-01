Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaJATaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:30:25 -0400
Received: from mail-by2on0098.outbound.protection.outlook.com ([207.46.100.98]:48352
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751207AbaJATaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:30:21 -0400
Date: Wed, 1 Oct 2014 14:24:07 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Pavel Machek <pavel@denx.de>
CC: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 2/2] socfpga: support suspend to ram
In-Reply-To: <20141001134917.GB12750@amd>
Message-ID: <alpine.DEB.2.02.1410011420580.31476@atx-linux-37>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <1411590449-9794-3-git-send-email-atull@opensource.altera.com> <20141001134917.GB12750@amd>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR08CA0025.namprd08.prod.outlook.com (10.242.217.153) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB314;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(51704005)(54534003)(189002)(199003)(54356999)(86362001)(76176999)(120916001)(31966008)(4396001)(50986999)(21056001)(92566001)(86152002)(92726001)(15202345003)(46406003)(80022003)(46102003)(101416001)(87976001)(85852003)(33716001)(19580395003)(76482002)(66066001)(69596002)(83506001)(15975445006)(110136001)(102836001)(107046002)(77096002)(105586002)(81156004)(85306004)(106356001)(23726002)(97736003)(20776003)(47776003)(64706001)(53416004)(50466002)(10300001)(99396003)(95666004)(42186005)(3556765001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014, Pavel Machek wrote:

> Hi!
> 
> > Add code that requests that the sdr controller go into
> > self-refresh mode.  This code is run from ocram.
> > 
> > This patch assumes that u-boot has already configured sdr:
> >   sdr.ctrlcfg.lowpwreq.selfrfshmask = 3
> >   sdr.ctrlcfg.lowpwrtiming.clkdisablecycles = 8
> >   sdr.ctrlcfg.dramtiming4.selfrfshexit = 512
> 
> I'm not sure if we should make assumptions like that. u-boot is not
> the only bootloader.

Yes, that's why I wanted to document it.

> 
> At the very least, it should go to comment in the code, not to changelog.
> 

I agree.  I'm about to post the next version.  I will add this in
the code.

> > +u32 socfpga_sdram_self_refresh(u32 sdr_base, u32 scu_base);
> > +extern unsigned int socfpga_sdram_self_refresh_sz;
> 
> _sz -> size.
> 
> Is it ok to just copy code around?
> 

You have to use fncpy to do it.

> > +/* Round up a pointer address to fix aligment for fncpy() */
> > +static void *fncpy_align(void *ptr)
> > +{
> > +	u32 value = (u32)ptr;
> > +
> > +	if ((value & (FNCPY_ALIGN - 1)) != 0)
> > +		value = ((value & ~(FNCPY_ALIGN - 1)) + FNCPY_ALIGN);
> > +
> > +	return (void *)value;
> > +}
> 
> Don't we have a nice macro doing aligning?

Actually the next version is going to fix some of these other comments by 
using the ocram sram driver to allocate ocram space.  

> 
> I guess the if() is not neccessary.
> 
> > +static int socfpga_pm_suspend(unsigned long arg)
> > +{
> > +	u32 ret;
> > +
> > +	ret = socfpga_sdram_self_refresh_in_ocram((u32)sdr_ctl_base_addr,
> > +						  (u32)socfpga_scu_base_addr);
> > +
> > +	pr_debug("%s self-refresh loops request=%d exit=%d\n", __func__,
> > +		 ret & 0xffff, (ret >> 16) & 0xffff);
> > +
> > +	return 0;
> > +}
> 
> return ret?
> 
> 
> > +	.arch   armv7-a
> > +	.text
> > +	.align 3
> > +
> > +	/*
> > +	 * socfpga_sdram_self_refresh
> > +	 *
> > +	 *  r0 : sdr_ctl_base_addr
> > +	 *  r1 : socfpga_scu_base_addr
> > +	 *  r2 : temp storage of register values
> > +	 *  r3 : loop counter
> > +	 *  r4 : temp storage of return value
> > +	 *
> > +	 *  return value: lower 16 bits: loop count going into self refresh
> > +	 *                upper 16 bits: loop count exiting self refresh
> > +	 */
> > +ENTRY(socfpga_sdram_self_refresh)
> 
> r0, r1 are the parameters?
> 
> > @@ -77,6 +78,15 @@ void __init socfpga_sysmgr_init(void)
> >  
> >  	np = of_find_compatible_node(NULL, NULL, "altr,rst-mgr");
> >  	rst_manager_base_addr = of_iomap(np, 0);
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "altr,sdr-ctl");
> > +	if (!np) {
> > +		pr_err("SOCFPGA: Unable to find sdr-ctl\n");
> > +		return;
> > +	}
> > +
> > +	sdr_ctl_base_addr = of_iomap(np, 0);
> > +	WARN_ON(!sdr_ctl_base_addr);
> >  }
> >  
> >  static void __init socfpga_init_irq(void)
> 
> Actually, "sdr-ctl" is quite hard to understand. I guess it means
> "sdram-control"? Should we do something like altr,sdram-ctrl-1.0, so
> that we have way forward if hardware changes in future?
> 
> 									Pavel
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
