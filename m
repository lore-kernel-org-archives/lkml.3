Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaIJPbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:31:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38540 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751344AbaIJPbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:31:18 -0400
Date: Wed, 10 Sep 2014 17:31:14 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Johan Hovold <johan@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] rtc: at91sam9: add DT bindings documentation
Message-ID: <20140910173114.593dd132@bbrezillon>
In-Reply-To: <20140910150702.GK2974@localhost>
References: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com>
	<1409733934-14465-6-git-send-email-boris.brezillon@free-electrons.com>
	<20140910121424.GG2974@localhost>
	<20140910152019.111c4c01@bbrezillon>
	<20140910150702.GK2974@localhost>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 17:07:02 +0200
Johan Hovold <johan@kernel.org> wrote:

> On Wed, Sep 10, 2014 at 03:20:19PM +0200, Boris BREZILLON wrote:
> > On Wed, 10 Sep 2014 14:14:24 +0200
> > Johan Hovold <johan@kernel.org> wrote:
> 
> > > This does not describe the hardware, but rather a specific software
> > > configuration.
> > > 
> > > The RTT is first of all not an RTC (although it can be used as one in a
> > > specific software configuration). And the second register resource above
> > > is not an RTT register, but a general-purpose backup register could be
> > > used for other purposes (which register to use is currently configurable
> > > for legacy booting using CONFIG_RTC_DRV_AT91SAM9_GPBR).
> > 
> > We could use a syscon device (which exposes a regmap) for the GPBR
> > block.
> > 
> > rtc@ffffff20 {
> 
> rtt
> 
> > 	compatible = "atmel,at91sam9260-rtt";
> > 	reg = <0xfffffd20 0x10>;
> > 	interrupts = <1 4 7>;
> > 	clocks = <&clk32k>;
> > 	atmel,time-reg = <&gpbr 0x0>;
> > };
> > 
> > gpbr: syscon@fffffd50 {
> > 	compatible = "atmel,at91sam9260-gpbr", "syscon";
> > 	reg = <0xfffffd50 0x10>;
> > 	
> > };
> 
> Yes, this essentially what I suggested in the thread (and my last reply)
> and relying on syscon rather than a custom driver seems like a good
> idea. It would allow early access to the registers too with the recently
> proposed changes. It would not guarantee any kind of exclusivity,
> though, but I guess that's tolerable?

Yep, that's one of the concern I had with the syscon/regmap
approach :-(, but I guess I'll give this solution a try and post a new
version of this series ;-).

Can we just leave the rtt as an rtc problem on the side for now and bind
it to the rtc-at91sam9 driver.

If we ever decide to add a new driver using the RTT for another purpose
we will still be able to reference the RTT block like this (and keep
the existing rtt node definition):


rtt-based-rtc {
	compatible = "atmel,rtt-rtc";
	atmel,rtt = <&rtt>;
	atmel,time-reg = <&gpbr 0x0>;
}

rtt-based-xdev {
	compatible = "atmel,rtt-xdev";
	atmel,rtt = <&rtt>;
	/*...*/
}

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
