Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3BES36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:29:58 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33559 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3BES3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:29:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130205164705.GG4720@opensource.wolfsonmicro.com>
References: <20130201213003.GW2637@n2100.arm.linux.org.uk>
	<20130204154153.GA18237@arwen.pp.htv.fi>
	<510FF1A6.403@mvista.com>
	<20130204164712.GB4269@arwen.pp.htv.fi>
	<510FF5C9.3030600@mvista.com>
	<20130204170216.GC4269@arwen.pp.htv.fi>
	<51100A72.6030909@ti.com>
	<CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com>
	<5110369B.9060901@ti.com>
	<CACRpkda8xBB35CwuBH76xXcC341TeRs1ZuwzDD0LtuXc4ifQTw@mail.gmail.com>
	<20130205164705.GG4720@opensource.wolfsonmicro.com>
Date: Tue, 5 Feb 2013 19:29:53 +0100
Message-ID: <CACRpkdbeoMO1rjPiWDAuVL0uYwMGF+9-vCxqoMiMd1uAgZm=RQ@mail.gmail.com>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Cyril Chemparathy <cyril@ti.com>, balbi@ti.com,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, "Nair, Sandeep" <sandeep_n@ti.com>,
        Chris Ball <cjb@laptop.org>, Matt Porter <mporter@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 5:47 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Feb 05, 2013 at 05:21:48PM +0100, Linus Walleij wrote:
>
>> For IRQ mode, use the completion callback to push each cookie
>> to NAPI, and thus let the IRQ drive the traffic.
>
> The whole purpose of NAPI is to avoid taking interrupts for completion
> of transfers.  Anything that generates interrupts when NAPI is in
> polling mode is defeating the point.

So what I was trying to get across is that when you're in polling
mode you do not set DMA_PREP_INTERRUPT on your transfers,
just throw the obtained struct dma_async_tx_descriptor on some
list and then when polling use dma_async_is_tx_complete()
on the channel and the cookie inside the descriptor.

I was trying to describe that you can move from
IRQ mode to polling mode and back again by selectively
choosing to set/not set the DMA_PREP_INTERRUPT flag.

If polling is all you want you never set it.

Then there is the fact that the transfer needs to have
been flagged complete and it is indeed something that needs
to be set in some bytes somewhere. By something. But it
doesn't have to be an interrupt from the DMA controller.

In such cases we use dma_async_is_tx_complete() with
channel and cookies as parameter. This will call down into the
driver chan->device->device_tx_status() and there we can
actually poll the hardware to see if the transfer happens to
be complete, and if it is flag it complete.

Which is likely what we want.

No interrupts, only function calls as far as I can see.

(I bet Russell will poke a hole in my reasoning, but it's worth
a try.)

Yours,
Linus Walleij
