Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbaGLCHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:07:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44183 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaGLCHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:07:35 -0400
Date: Fri, 11 Jul 2014 19:07:31 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Marek Vasut <marex@denx.de>
Cc: Huang Shijie <shijie8@gmail.com>, Huang Shijie <b32955@freescale.com>,
        Graham Moore <grmoore@altera.com>, ggrahammoore@gmail.com,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        linux-mtd@lists.infradead.org, Insop Song <insop.song@gainspeed.com>,
        Alan Tull <atull@altera.com>, Sourav Poddar <sourav.poddar@ti.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
Message-ID: <20140712020731.GL7537@ld-irv-0074>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com>
 <201404260012.24311.marex@denx.de>
 <20140426031011.GA4811@localhost.localdomain>
 <201404280706.18068.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404280706.18068.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Sorry to revisit this way late, and sorry for not paying as much
attention initially. I'm prepped to merge v4, but some of the
conversation matches what I was just thinking.

On Mon, Apr 28, 2014 at 07:06:17AM +0200, Marek Vasut wrote:
> On Saturday, April 26, 2014 at 05:10:13 AM, Huang Shijie wrote:
> > On Sat, Apr 26, 2014 at 12:12:24AM +0200, Marek Vasut wrote:
> > > > > > the drivers may fills this hook itself, so the code should like this:
> > > > > >    --------------------------------------------------
> > > > > > 	
> > > > > > 	if ((info->flags & USE_FSR) &&
> > > > > > 	
> > > > > > 	       	nor->wait_till_ready == spi_nor_wait_till_fsr_ready)
> > > > > > 		
> > > > > > 		nor->wait_till_ready = spi_nor_wait_till_fsr_ready;
> > > > > > 		
> > > > > >    --------------------------------------------------
> > > > > 
> > > > > I sense a misdesign of the SPI NOR subsystem here. The subsystem and
> > > > > the driver compete for a function pointer here ? I guess one should
> > > > > have precedence in some way then ... and also, they should be two
> > > > > different pointers, where the subsystem decides which to use.
> > > > 
> > > > the subsystem do not decides which one to use, the driver decides which
> > > > one to use.
> > > > 
> > > > If driver has its own @wait_till_ready , it means the driver knows the
> > > > feature, and has implemented it in its own @wait_till_ready.
> > > > 
> > > > If the driver does not fill any wait_till_ready, it means the driver
> > > > will use the default @wait_till_ready. We can treat the
> > > > spi_nor_wait_till_fsr_ready as a default hook too.
> > > 
> > > I see the driver overwriting a hook previously set by the subsystem. This
> > 
> > not sure ;)
> > 
> > The driver set the hooks before the subsystem set these hooks.
> > 
> > If the driver has already set the @wait_till_ready hook before it calls
> > the spi_nor_scan, the subsystem will not set the hook anymore.
> > 
> > Please see the spi_nor_check().
> 
> Two things competing over the same pointer looks misdesigned to me. I will need 
> to dig into this one more time ...

Yes, that is misdesigned. And looking at nand_base for examples is not
foolproof; it has quite a bit of legacy and workarounds. It'd be best to
get the design right for spi-nor.

The subsystem code should not require a function pointer for FSR vs.
non-FSR -- all devices should be able to use the same function. We just
need to stash some flash-ID-related data (i.e., a flags field) in the
spi_nor struct. On the plus side, we can avoid the code duplication
between spi_nor_wait_till_fsr_ready() and spi_nor_wait_till_ready().

I think the wait_till_ready pointer should be reserved for the driver,
as a hardware-specific "wait" function.

This still leaves the question of whether the SPI NOR core should assume
that any driver's 'wait_till_ready' function (if present) actually
implements all necessary waits (FSR vs. non-FSR, for instance). I'd
argue that's a maintenance burden, and that the subsystem should still
do a sanity check that the status register is correct. After all, that's
what the ->{read,write}_reg() functions are useful for. But perhaps
there is some performance argument for avoiding the (potentially
redundant) register checks?

Anyway, I've tested v4, and I plan to merge it soon. Patches can be sent
on top. (I may even cook up my own.)

Regards,
Brian
