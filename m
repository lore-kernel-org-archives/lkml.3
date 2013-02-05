Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3BERO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:14:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35898 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3BERO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:14:27 -0500
Date: Tue, 5 Feb 2013 17:06:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Cyril Chemparathy <cyril@ti.com>,
        balbi@ti.com, Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        "Nair, Sandeep" <sandeep_n@ti.com>, Chris Ball <cjb@laptop.org>,
        Matt Porter <mporter@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
	arm/common
Message-ID: <20130205170628.GD17852@n2100.arm.linux.org.uk>
References: <20130204154153.GA18237@arwen.pp.htv.fi> <510FF1A6.403@mvista.com> <20130204164712.GB4269@arwen.pp.htv.fi> <510FF5C9.3030600@mvista.com> <20130204170216.GC4269@arwen.pp.htv.fi> <51100A72.6030909@ti.com> <CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com> <5110369B.9060901@ti.com> <CACRpkda8xBB35CwuBH76xXcC341TeRs1ZuwzDD0LtuXc4ifQTw@mail.gmail.com> <20130205164705.GG4720@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205164705.GG4720@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:47:05PM +0000, Mark Brown wrote:
> On Tue, Feb 05, 2013 at 05:21:48PM +0100, Linus Walleij wrote:
> 
> > For IRQ mode, use the completion callback to push each cookie
> > to NAPI, and thus let the IRQ drive the traffic.
> 
> The whole purpose of NAPI is to avoid taking interrupts for completion
> of transfers.  Anything that generates interrupts when NAPI is in
> polling mode is defeating the point.

Yes, but you're missing one very important point.  If your DMA engine
is decoupled from the network device, and the DMA engine relies upon
interrupts to queue further transfers to move data into RAM, then you
have two options:

1. Receive these interrupts so you can update the DMA engine for
   further data transfer.
2. Don't receive these interrupts, and cause the network device to
   error out with a FIFO overrun because its DMA requests have not
   been serviced. (which may raise an interrupt.)
