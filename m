Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaFMKq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:46:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:21143 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaFMKqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:46:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Dn71fGXWlywYJkoOl5JMS
Date: Fri, 13 Jun 2014 03:46:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: "Gupta, Pekon" <pekon@ti.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/36] mtd: nand: omap: Move IRQ handling from GPMC to
 NAND driver
Message-ID: <20140613104610.GS17845@atomide.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
 <1402477001-31132-6-git-send-email-rogerq@ti.com>
 <20140613071820.GI17845@atomide.com>
 <539AAA8C.2070709@ti.com>
 <20140613075856.GQ17845@atomide.com>
 <20980858CB6D3A4BAE95CA194937D5E73EAF51DB@DBDE04.ent.ti.com>
 <539AB4E4.6050408@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539AB4E4.6050408@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140613 01:24]:
> On 06/13/2014 11:13 AM, Gupta, Pekon wrote:
> >> From: Tony Lindgren [mailto:tony@atomide.com]
> >>> * Roger Quadros <rogerq@ti.com> [140613 00:40]:
> >>>> On 06/13/2014 10:18 AM, Tony Lindgren wrote:
> >>>>> * Roger Quadros <rogerq@ti.com> [140611 01:58]:
> >>>
> >>> OK. But wait pin edge detection was not yet being used and I couldn't
> >>> think of how it would ever be used. Any ideas?
> >>
> >> Maybe to wake-up the system on bus activity or something?
> >>
> > Sorry, I wasn't able to review this series.
> > But just as pointer, GPMC driver was used for interfacing many
> > non-memory devices like Ethernet (smc91x) and in past GPMC has been
> > proved to work with camera devices too, but that's wasn't mainlined.
> > So keeping IRQ and few other things in GPMC driver is helpful.
> > 
> 
> On further study it seems that the wait pin edge detection is only used in the NAND controller use case.
> see section 10.1.5.14.2.2 Ready Pin Monitored by Hardware Interrupt

It seems they can be used for anything slow like NOR and NAND.
 
> For memory devices, no software wait pin intervention is necessary and doesn't even make sense.

Still seems that it's use can be generic though, not limited
to NAND.
 
> So I don't agree on managing the IRQSTATUS and IRQENABLE register in the GPMC driver. It is adding unnecessary complexity. I don't mind having a wrapper around it though like the other nand registers.

But all the consumer driver should need to do is request_irq()
on it? That's pretty much the most common interface we have
for drivers :)
 
> To be frank, I think it is cleaner if the NAND driver directly accesses the NAND registers.
> I don't see why we should make things complicated just because the hardware designers didn't create a clear register split between GPMC and NAND.

Because they are in separate hardware modules :)

Who knows why it was set up this way. Maybe the plan was to have
the common features in GPMC that then can be used by various MTD
devices.
 
> Only the GPMC_CONFIG register needs to remain with the GPMC driver.

And managing clocks and runtime PM in general. In any case, let's
not let drivers tinker with the GPMC registers directly though.
Some kind of abstraction via existing frameworks or with regmap
is needed.

Regards,

Tony
