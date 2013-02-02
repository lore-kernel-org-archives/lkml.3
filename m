Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab3BBVDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 16:03:05 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:31480 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751095Ab3BBVC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 16:02:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/250n+wTGdI8gsROit8ALb
Date: Sat, 2 Feb 2013 13:02:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130202210251.GE577@atomide.com>
References: <1359742975-10421-1-git-send-email-mporter@ti.com>
 <1359742975-10421-2-git-send-email-mporter@ti.com>
 <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com>
 <20130201184915.GP2244@beef>
 <2077c13e12314dc3adc8e5b653855da0@DFLE72.ent.ti.com>
 <20130201185959.GQ2244@beef>
 <e9be6668da8b4372a04687847daa1d8c@DFLE72.ent.ti.com>
 <20130202180747.GS2244@beef>
 <20130202181643.GD577@atomide.com>
 <20130202194853.GT2244@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202194853.GT2244@beef>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [130202 11:51]:
> On Sat, Feb 02, 2013 at 10:16:43AM -0800, Tony Lindgren wrote:
> > * Matt Porter <mporter@ti.com> [130202 10:10]:
> > > If it doesn't work, work with Vinod to fix the api. It's expected,
> > > I'm working on dmaengine API changes right now to deal with a
> > > limitation of EDMA that needs to be abstracted.
> > 
> > Regarding the DMA API limitations, I'm only aware of lack of capability
> > to configure autoincrement at the device end. And that keeps us from
> > converting all GPMC related devices using omap SDMA to use the DMA API.
> > 
> > Are there other limitations currently known with the DMA API?
> 
> Yes, I called one out when this was first posted as an RFC and was
> working it in parallel with this support. This one blocks AM33XX support
> in mmc and is the reason I split all of the mmc support out of the base
> edma dmaengine for am33xx series. Independent of the blockage, whatever
> we finally settle on to address this API need will also cleanup the use
> of magic values in the davinci mmc driver (that's part of the second
> thread below).
> 
> RFC posting:
> https://patchwork.kernel.org/patch/1583531/
> Posting with initial attempt at a caps api:
> http://www.spinics.net/lists/linux-mmc/msg18351.html

OK thanks for the links, good to hear at least some work is happening
on it.

> Also, I haven't fully vetted the situation with cyclic transfers and
> EDMA, however, I'm pretty sure that we'll need some API changes there.
> The reason is that some Davinci platforms have no FIFO on their McASP
> implementation (that was a new feature added on DA8xx and also AM33xx).
> As such they have audio support implemented using ping-pong buffering
> via an SRAM buffer. There's been a number of patches ahead of all this
> that myself and others have worked upstream to get the SRAM stuff to be
> Davinci-independent (genalloc). But, at the end of all of this, there's
> no notion in a cyclic transfer of doing synchronized ping-pong buffering
> using two chain channels. This is how it is implemented (and documented
> in EDMA docs going back to the DSPs this IP first showed up on) using
> the private API. I'll be looking at this soon, but, I'm more interested
> in 1) getting the base support in 2) then the mmc stuff blocking DT
> populated platforms using omap_hsmmc (split out and posted) 3) v3 of the
> caps api w/ vinod's concerns address (working it not)
> 
> Normally, I'm not going to bring up the cyclic transfer issue until I
> have some code to show or reference for discussion...but it's worth
> being aware. But, in any case, I'm confident that will gate having the
> mcasp driver that am33xx also uses converted to dmaengine.  Except for
> the gpmc limitation you menationed, that's the last in kernel user of
> the privat edma api needed to be converted such that we can kill off
> arch/arm/common/edma.c once it's taken in.

And then there's the case of device-to-device DMA that we're not
currently doing luckily. And I don't think I've even seen that being
used so we probably don't need to worry about that one right now.

Regards,

Tony
