Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbbAXBHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:07:21 -0500
Received: from smtp2.ore.mailhop.org ([54.186.57.195]:51731 "EHLO
	smtp2.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbAXBHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:07:17 -0500
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX1/zQPUPf8TLRwjR9js/J8gS
Date: Fri, 23 Jan 2015 17:03:41 -0800
From: Tony Lindgren <tony@atomide.com>
To: NeilBrown <neilb@suse.de>
Cc: Marek Belisko <marek@goldelico.com>, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, NeilBrown <neil@brown.name>
Subject: Re: [PATCH 12/13] ARM: dts: omap3-gta04: uart4 is not connected, so
 mark it "disabled"
Message-ID: <20150124010340.GB28663@atomide.com>
References: <1421959099-28319-1-git-send-email-marek@goldelico.com>
 <1421959099-28319-13-git-send-email-marek@goldelico.com>
 <20150122214052.GY7718@atomide.com>
 <20150124092842.2441d3c6@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150124092842.2441d3c6@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* NeilBrown <neilb@suse.de> [150123 14:31]:
> On Thu, 22 Jan 2015 13:40:53 -0800 Tony Lindgren <tony@atomide.com> wrote:
> > >  
> > > +&uart4 {
> > > +	status = "disabled";
> > > +};
> > > +
> > 
> > This you probably want to avoid from PM point of view. Depending on
> > bootloader state of uart4, Linux may or may not be able to hit any
> > deeper power states.
> > 
> > Marking something with status = "disabled" in dts causes the device
> > entry not even to be created. That means hwmod won't be able to reset
> > and idle this device during boot.
> > 
> > The uart4 device is there for sure even if not muxed and in incomplete
> > state. You may want to also check other places where you're using
> > status = "disabled" for the same reasons.
> 
> That's ... unfortunate.  Would that apply to the MCBSPs too?  They are
> disabled by default so you would need to explicitly enable them all for
> sensible behaviour....

Yeah that applies to all the SoC integrated devices that the bus code
(hwmod) is supposed to reset and idle if unused. Basically anything
that depends on the dev entry being created.
 
> Hopefully there is some way to mark as device as "this is not used, make sure
> it is turned off and stays off" ???

Not currently that I know of :) To do that, we should add something
like status = "incomplete" where the dev entry gets created but the
driver is never probed. And incomplete here meaning that the device
is missing some parts like pins that would make it work properly.
 
> Thanks for the heads-up.  I'll have a look and see exactly what is happening.

OK
 
> BTW, on the topic of OMAP UARTs and power saving...
>  I note that there are now two drivers for the OMAP3 UART - omap-serial and
>  8250_omap.
>  I also note that your commit:
> 
> commit a2fc36613ac1af2e92cbed7af80bc72d8114dd50
>     ARM: OMAP3: Use manual idle for UARTs because of DMA errata
> 
>  is incompatible with omap-serial.  In particular, if I enable runtime
>  suspend of the serial port by setting the autosuspend_timeout, then incoming
>  characters will no longer wake the port (if I revert your patch incoming
>  chars do wake the port).
>  This could (I think) be fixed by enabling the RX/CTS interrupt.  However if
>  omap-serial is being deprecated, then there probably isn't any point.
> 
>  So: what is the longer term expectation for these drivers?  Should we be
>  switching over to 8250?

Yeah you should alredy be able to do it. Hopefully we'll have some
translation layer and the old omap-serial.c can be mostly removed
now that we have 8250 support with runtime PM :)

Regards,

Tony
