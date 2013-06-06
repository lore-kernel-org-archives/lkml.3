Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3FFIdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:33:51 -0400
Received: from 10.mo5.mail-out.ovh.net ([46.105.52.148]:56509 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932130Ab3FFIds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:33:48 -0400
Date: Thu, 6 Jun 2013 10:29:41 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] of: Export of_irq_count for using in modules
Message-ID: <20130606082941.GH19834@game.jcrosoft.org>
References: <6aa29b1d109a46278a7f37b598defe07d6edfe60.1369921774.git.michal.simek@xilinx.com>
 <20130530201714.GE19834@game.jcrosoft.org>
 <51A85BEE.4000009@monstr.eu>
 <20130531110045.GF19834@game.jcrosoft.org>
 <51A8AC4B.906@monstr.eu>
 <20130531151601.GG19834@game.jcrosoft.org>
 <51A8D3A3.5030200@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A8D3A3.5030200@monstr.eu>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5289196289508682703
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:45 Fri 31 May     , Michal Simek wrote:
> On 05/31/2013 05:16 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 15:57 Fri 31 May     , Michal Simek wrote:
> >> On 05/31/2013 01:00 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>> On 10:14 Fri 31 May     , Michal Simek wrote:
> >>>> Hi Jean-Christophe,
> >>>>
> >>>> On 05/30/2013 10:17 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>>>> On 15:49 Thu 30 May     , Michal Simek wrote:
> >>>>>> Export of_irq_count for modules.
> >>>>>
> >>>>> can you explain why do you need to call of_irq_count
> >>>>
> >>>> I need to count number of irq written in the DTS node.
> >>>> It is not fixed size that's why I need to proper way how to
> >>>> find it out.
> >>>>
> >>>> I am using this loop.
> >>>> 	count = of_irq_count(pdev->dev.of_node);
> >>>> 	/* Alloc IRQ based on DTS to be sure that no other driver will use it */
> >>>> 	while (count--) {
> >>>> 		tmp->irq = irq_of_parse_and_map(pdev->dev.of_node, count);
> >>>> 		dev_info(&pdev->dev, "%d: Alloc irq: %d\n", count, tmp->irq);
> >>>> 		ret = request_irq(tmp->irq, zynq_remoteproc_interrupt, 0,
> >>>> 					dev_name(&pdev->dev), &pdev->dev);
> >>>> 		if (ret) {
> >>>> 			...
> >>>> 		}
> >>>> 	}
> >>>>
> >>>> But of course if you think that this is incorrect to export it
> >>>> I can use what it is in of_irq_count body
> >>>> 368 int of_irq_count(struct device_node *dev)
> >>>> 369 {
> >>>> 370         int nr = 0;
> >>>> 371
> >>>> 372         while (of_irq_to_resource(dev, nr, NULL))
> >>>> 373                 nr++;
> >>>> 374
> >>>> 375         return nr;
> >>>> 376 }
> >>>>
> >>>> Because of_irq_to_resource is exported for modules.
> >>>> Or is there any better way how to loop over all interrupts in DT node?
> >>>
> >>> can just explain me why you need to call irq_of_parse_and_map in your driver?
> >>>
> >>> as the irq will be provided in the resources normally
> >>
> >> It is quite a long time I have written this driver on v3.1 or 3.3.
> >> But is this better?
> >>
> >> 	struct resource *res;
> >> 	int i = 0;
> >> 	do {
> >> 		res = platform_get_resource(pdev, IORESOURCE_IRQ, i++);
> >> 		if (res)
> >> 			do something
> >> 	} while(res);
> >>
> >> Also what about of_irq_to_resource()? Is it deprecated and all drivers
> >> shouldn't use it?
> >>
> >> I have no problem to rewrite the driver to use platform_get_resource.
> > yeah it's better but be aware there is a but in DT that I'm working on to fix
> > if you use irq that are registered by a pdev this will not work
> > 
> > I hope to fix it for 3.11
> > and already send an RFC that fix it
> 
> ok. good to know. Btw: Let's return to my origin point why not to
> export of_irq_count for modules?
> Or opposite question if platform_get_resource is correct way
> why to export of_irq_to_resource for modules?

for old ppc drivers that are not converted yet to pdev

if you can do so just use pdev resource I should have fix the pb or irq_domain
hopefully for 3.11

Best Regards,
J.

> 
> Thanks,
> Michal
> 
> -- 
> Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
> Maintainer of Linux kernel - Xilinx Zynq ARM architecture
> Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
> 
> 


