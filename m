Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3AYMGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:06:07 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57956 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771Ab3AYMGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:06:02 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Mike Turquette <mturquette@linaro.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: RE: RE: [PATCH v4 12/12] video: da8xx-fb: CCF clock divider handling
Thread-Topic: RE: [PATCH v4 12/12] video: da8xx-fb: CCF clock divider
 handling
Thread-Index: AQHN+V/MaSDyqI8pmkmZ9mAn8r3xs5hW/6oAgAFRCtCAAAkKAIABj9Vw
Date: Fri, 25 Jan 2013 12:05:44 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA9383E@DBDE01.ent.ti.com>
References: <cover.1358937685.git.afzal@ti.com>
 <fa8dab522507e087d5a94bac13dda71544911707.1358937685.git.afzal@ti.com>
 <20130123202204.9205.66575@quantum>
 <C8443D0743D26F4388EA172BF4E2A7A93EA92ADF@DBDE01.ent.ti.com>
 <20130124170044.10623.45314@quantum>
In-Reply-To: <20130124170044.10623.45314@quantum>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0PC66bT020184

Hi Mike,

On Thu, Jan 24, 2013 at 22:30:44, Mike Turquette wrote:
> Quoting Mohammed, Afzal (2013-01-24 03:36:02)

> > So there are 3 - LIDD is actually not for present use case, CORE could
> > be clubbed with the divider to have a composite clock. And CORE is
> > in functional clock path and logically it's perfectly alright to have
> > the composite clock.

> Some of the clock names are a bit generic, so a question that I'm going
> to repeat throughout my response: "is this clock only inside of your
> video IP ?"

Yes these three clocks are inside LCDC IP.

> Regarding the CORE clock, is this only inside of your IP or are you
> referring to the SoC CORE clock which is driven by a DPLL and clocks
> DDR and many other peripherals (often MMC, UART, etc)?

Sorry for the confusion, here CORE refers to clock inside LCDC IP. This
CORE should not be confused with CORE PLL. Actually I used CORE so that
it corresponds to the nomenclature in LCDC section of TRM.

> Note that this is from my past experience with OMAP, and I'm making an
> assumption that the clock scheme between OMAP and Da Vinci/AM335x parts
> isn't very different.

Additional detail: DaVinci doesn't have these 3 clocks controls available,
so these three are required only on AM335x (which has IP version 2 )

> Is there a public TRM I can look at?  It would help me understand this
> without having to ask you so many annoying questions ;)

No problem, http://www.ti.com/product/am3359


> > And now we are left with DMA, this is actually in the interface clock
> > path which driver in unaware. An option would be to have DMA clock
> > as child of CORE plus divider composite clock, even though logically
> > DMA can't be considered in the same path.

> Why is the driver unaware of the interface clk?  For instance OMAP3 had
> separate fclk and iclk for IPs and drivers would call clk_enable on
> both.  Or am I misunderstanding something?

HWMOD handles enabling those upon pm_runtime calls, HWMOD makes an alias
for main clock with "fck", but not for "ick", so currently "ick" is
unavailable for the driver, continued below ..

> In general I don't think the clock subtree should be modeled in a way
> that is convenient for software, but instead model the actual hardware.
> Trust me, if you don't model the actual hardware then you will be very
> confused when you come back and revisit this code in 6 months and can't
> remember why things are so weird looking.

Ok, then it seems an omap clock entry for con-id "ick" should be created
as follows (dpll_core_m4_ck supplies interface clock),

CLK("4830e000.lcdc",    "ick",          &dpll_core_m4_ck,       CK_AM33XX)

And then in the driver, DMA gate clock should be made a child of this clock
(obtained with con-id "ick").

Let me know your opinion on this.

Regards
Afzal



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
