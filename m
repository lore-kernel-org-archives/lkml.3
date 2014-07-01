Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbaGANQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:16:49 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59615 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaGANQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:16:45 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ZEOyeAjzKfwK7uA69NneK
Date: Tue, 1 Jul 2014 06:16:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Mark Brown <broonie@kernel.org>, "Gupta, Pekon" <pekon@ti.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ivan.khoronzhuk@ti.com, Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH 05/36] mtd: nand: omap: Move IRQ handling from GPMC to
 NAND driver
Message-ID: <20140701131618.GQ28884@atomide.com>
References: <1402477001-31132-6-git-send-email-rogerq@ti.com>
 <20140613071820.GI17845@atomide.com>
 <539AAA8C.2070709@ti.com>
 <20140613075856.GQ17845@atomide.com>
 <20980858CB6D3A4BAE95CA194937D5E73EAF51DB@DBDE04.ent.ti.com>
 <539AB4E4.6050408@ti.com>
 <20140613104610.GS17845@atomide.com>
 <539AE390.4080504@ti.com>
 <20140613120839.GV17845@atomide.com>
 <53B2893E.5020306@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B2893E.5020306@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140701 03:13]:
> On 06/13/2014 03:08 PM, Tony Lindgren wrote:
> > * Roger Quadros <rogerq@ti.com> [140613 04:43]:
> >>
> >> OK. I agree about using some kind of abstraction instead of direct access.
> > 
> > Yes and like we chatted on irc, adding a syscon mapping for for
> > the NAND specific registers might do the trick here.
> 
> After looking at the syscon driver, which relies on regmap, it seems that regmap was designed for slow control busses like I2C/SPI and using it for NAND controller register access will have a significant negative impact on performance. In the NAND case the register writes are used for each NAND command cycle and the reads for ECC checks (every page).
> 
> See how much code regmap_read and regmap_mmio_read() translates to for a simple register read i.e. readl().
> http://lxr.free-electrons.com/source/drivers/base/regmap/regmap.c#L1944
> http://lxr.free-electrons.com/source/drivers/base/regmap/regmap-mmio.c#L129
> 
> So I'm not so sure of using regmap/syscon for NAND controller register access.

OK yes I agree, it's not a good solution for a constant
register access that's needed for the ECC registers.
 
> Could there be any other abstraction method of sharing the register space between GPMC and NAND driver?
> I've also added Ivan to the thread, the author of memory/ti-aemif.c driver, to check if he faced any issues with shared register access of the AEMIF/NAND registers.

If there's no common framework available for GPMC to implement,
it's best to just export few functions from gpmc.c for the ECC
calculations.

Regards,

Tony
