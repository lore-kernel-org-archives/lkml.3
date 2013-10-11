Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab3JKIAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:00:38 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:50069 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3JKIAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:00:36 -0400
MIME-Version: 1.0
In-Reply-To: <20131010162015.GC29913@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
	<20131003054221.8941.87801.stgit@localhost>
	<5256AA7F.8030005@ti.com>
	<20131010160018.GA29913@atomide.com>
	<CACRpkdaG-PQA39XSjKUgM9TyeD7srgm_8s+NazrDKJ0gmNLcwg@mail.gmail.com>
	<20131010162015.GC29913@atomide.com>
Date: Fri, 11 Oct 2013 10:00:35 +0200
Message-ID: <CACRpkdYF83ghUf60Wmrti53UJ1bWV30GW_P9GjWnsOcZHbsv+Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Roger Quadros <rogerq@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 6:20 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Linus Walleij <linus.walleij@linaro.org> [131010 09:19]:
>> On Thu, Oct 10, 2013 at 6:00 PM, Tony Lindgren <tony@atomide.com> wrote:
>> > * Roger Quadros <rogerq@ti.com> [131010 06:32]:
>> >>
>> >> I tried testing this with the USB EHCI driver, but I'm not getting wake up interrupts
>> >> while the system is still running and only the EHCI controller is runtime suspended.
>> >>
>> >> It seems we need to somehow call _reconfigure_io_chain() to update the daisy chain
>> >> whenever the pad wakeup_enable bit is changed.
>> >
>> > Sounds like this is on omap3? Have you tried calling pcs_soc->rearm() in the
>> > pcs_irq_handle() like the comments there suggest? At least for me that keeps
>> > the wake-up interrupts continuously running on omap3 instead of just idle modes.
>>
>> If the rearm() function is calling this _reconfigure_io_chain my comments
>> on the fact that this is something that should be handled by the pin
>> control driver still apply I think ....
>
> Yes, except that the reconfigure_io_chain registers are in the PRM module, not in
> the SCM module where the pinctrl registers are.. And that shared PRM interrupt is
> used mostly for the internal domain wake-ups, so we should keep that in the PRM
> driver.

That depends.

One-iorange-equals-one-driver is a fallacy, especially given that MFD for
memory-mapped things exist for a reason.

What the pin control driver should do is control the pins. Whether the registers
are spread out in the entire IO-memory does not matter. We did have one system
which placed the IO-muxing together with each peripheral (!) and I did
still want
that to be handled by a single pinctrl driver picking out windows to all these
IO-ranges.

Things like the PRM which has (my guess) a gazillion registers related to its
deep-core SoC stuff should be handled by things like
drivers/mfd/syscon.c, which means it is dead simple for some other driver
using "just this one register" in that range to get a handle at it and poke it
using syscon_node_to_regmap() (just derference an ampersand ref)
syscon_regmap_lookup_by_compatible() (use a compatible string)
all returning a regmap * that you can use to poke these registers.

Yours,
Linus Walleij
