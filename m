Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaFMIOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:14:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51182 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaFMIOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:14:33 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Tony Lindgren <tony@atomide.com>, "Quadros, Roger" <rogerq@ti.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
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
Subject: RE: [PATCH 05/36] mtd: nand: omap: Move IRQ handling from GPMC to
 NAND driver
Thread-Topic: [PATCH 05/36] mtd: nand: omap: Move IRQ handling from GPMC to
 NAND driver
Thread-Index: AQHPhtes4NPruj0zSE2Fv0jE2/E6y5tuSygAgAAFnICAAF0GAA==
Date: Fri, 13 Jun 2014 08:13:55 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAF51DB@DBDE04.ent.ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
 <1402477001-31132-6-git-send-email-rogerq@ti.com>
 <20140613071820.GI17845@atomide.com> <539AAA8C.2070709@ti.com>
 <20140613075856.GQ17845@atomide.com>
In-Reply-To: <20140613075856.GQ17845@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From: Tony Lindgren [mailto:tony@atomide.com]
>>* Roger Quadros <rogerq@ti.com> [140613 00:40]:
>>> On 06/13/2014 10:18 AM, Tony Lindgren wrote:
>> >> * Roger Quadros <rogerq@ti.com> [140611 01:58]:
>> >> Since the Interrupt Events are used only by the NAND driver,
>> >> there is no point in managing the Interrupt registers
>> >> in the GPMC driver and complicating it with irqchip modeling.
>> >>
>> >> Let's manage the interrupt registers directly in the NAND driver
>> >> and get rid of irqchip model from GPMC driver.
>> >>
>> >> Get rid of IRQ commands and unused commands from gpmc_configure() in
>> >> the GPMC driver.
>> >
>> > This seems like a step backward to me. The GPMC interrupt enable
>> > register can do edge detection on the wait pins, how is that
>> > limited to NAND?
>>
>> OK. But wait pin edge detection was not yet being used and I couldn't
>> think of how it would ever be used. Any ideas?
>
>Maybe to wake-up the system on bus activity or something?
>
Sorry, I wasn't able to review this series.
But just as pointer, GPMC driver was used for interfacing many
non-memory devices like Ethernet (smc91x) and in past GPMC has been
proved to work with camera devices too, but that's wasn't mainlined.
So keeping IRQ and few other things in GPMC driver is helpful.




>> > Further, let's not start mixing GPMC hardware module register
>> > access with the NAND driver register access. They can be clocked
>> > separately. And bugs in the NAND driver can cause issues in other
>> > GPMC using drivers.
>>
>> I understood that NAND controller is integrated into the GPMC module and they are clocked
>> the same. Not sure why the hardware designers would keep the registers so closely knit.
>
>Yeah. Maybe regmap could provide some abstraction to the the
>NAND registers.
>
As you mentioned, GPMC has two set of registers:
(a) Chip-select registers (CONFIGx_cs) for device specific parameters
 (like device-width, signal-timings, etc) which are statically programmed
during probe or via DT.
(b) ECC registers which are continuously reconfigured based on
 ECC engine.

*Ideal Scenario*
NAND driver should be considered equivalent to protocol driver,
Therefore ideally it should use only those registers which are
specific to NAND (b).

*Actual Scenario*
But most NAND device today are ONFI compliant and they have
almost all device parameters like device-width, signal-timings
burned on-die in an ONFI page. These values are read back from
NAND device during device_probe() and then re-configured back
Chip-select registers (a).
Hence NAND driver needs access of both (a) and (b), which is why
You need to export complete GPMC register set to NAND driver.
However this is not the case and has been discussed earlier too..

http://lists.infradead.org/pipermail/linux-mtd/2013-October/049284.html
http://lists.infradead.org/pipermail/linux-mtd/2013-October/049347.html
(Just pointing out my version of history, would be good to read the
entire discussion. But the summary was that we need to re-configure
some GPMC chip-select registers (a) based on probe done in
NAND driver. So we need all GPMC registers exposed to NAND driver).




>> FYI. memory/ti-amif.c and mtd/nand/davinci_nand.c share the AMIF register space in the
>> same way. I thought it'd be nice to be consistent across TI drivers.
>
>Probably they did not yet learn the problems caused by it :)
>
I havn't reviewed the ti-amif.c driver completely but I think they too
configure device signal timing statically based on DT. But as per
today this is frowned upon because:

(1) Its difficult for layman user to decipher NAND signal timings
from datasheet and then convert it into controller understandable DT

(2) ONFI parameter page on NAND has these timings specified
on-die itself, and these timings are characterized for best performance
so NAND driver should re-configure these timings after probe.
Refer below mail from '<Rob Herring> robherring2@gmail.com'
http://lists.infradead.org/pipermail/linux-mtd/2014-April/053488.html


Considering all these details, please re-review the changes you plan
for GPMC driver.

with regards, pekon
