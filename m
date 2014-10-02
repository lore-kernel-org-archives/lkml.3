Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaJBO3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:29:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42724 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaJBO3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:29:23 -0400
Message-ID: <1412260136.4875.9.camel@pengutronix.de>
Subject: Re: [PATCH v2 4/4] ARM: dts: mt8135: Add pinctrl node for mt8135.
From: Lucas Stach <l.stach@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Hongzhou.Yang" <srv_hongzhou.yang@mediatek.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>, srv_heupstream@mediatek.com,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>, dandan.he@mediatek.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 02 Oct 2014 16:28:56 +0200
In-Reply-To: <CACRpkdbtN-BDEwpJO2swnOjCe3UJhD5WOXXKBV0hPOe2M2=k7Q@mail.gmail.com>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
	 <1411443545-24951-5-git-send-email-srv_hongzhou.yang@mediatek.com>
	 <CACRpkda-K7w-bY0uSdnZvzEKEeQg38oExoHPSW61kEv9Wv20mA@mail.gmail.com>
	 <20140924124044.GC4992@pengutronix.de>
	 <CACRpkdbtN-BDEwpJO2swnOjCe3UJhD5WOXXKBV0hPOe2M2=k7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Am Donnerstag, den 02.10.2014, 16:02 +0200 schrieb Linus Walleij:
> On Wed, Sep 24, 2014 at 2:40 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Wed, Sep 24, 2014 at 01:23:09PM +0200, Linus Walleij wrote:
> 
> >> I haven't got to reviewing the driver, but this looks just wrong.
> >>
> >> Have the magic numbers in the driver.
> >>
> >> Use strings to describe functions, not integers.
> >
> > Interrupts, clocks, gpios, dma channels, nearly everything in the device tree is
> > arbitrarily numbered. Instead of "irq-i2c0" we have <0 36 IRQ_TYPE_LEVEL_HIGH>
> > in the device tree. These numbers can be resolved efficiently in the
> > driver by shifting them to get a bitmask or by adding them as offset to
> > a register base.
> > Why do you want to make pinctrl different?
> 
> Because pin control is about combining groups of pins with
> certain functions.
> 
> > Thanks to the recently
> > introduced defines in the device trees these numbers are not magic at
> > all anymore.
> 
> Yeah that is good but not what I'm after here.
> 
> >> We need to move toward standardized device tree bindings
> >> for this stuff, and that means using strings, not magic
> >> numbers.
> >
> > Agreed for standardized device tree bindings, but not for using strings.
> 
> What is the alternative? Device Tree is very much about strings,
> as is shown by the pin config bindings.
> 
Mhm, maybe we are still talking about different things but I just don't
get your point. Traditionally DT is more about plain numbers than
strings. Look at the early examples of PCI or other bus bindings,
defined back in the IEEE 1275 days. Almost everything back then has
been mapped to plain numbers.

Using strings only bloats the DT, not only in it's source form, but also
as a compiled DTB. Having a verbose string based binding is just painful
to work with (I can tell from experience here, as I personally built the
pinmux setup for two Tegra boards). Working with a condensed number
based binding like the one used on i.MX is much easier IMHO.

Most importantly I don't see any benefit in writing:
pin_state_a {
	pins = "i2c0_scl", "i2c0_sda";
	function = "i2c0";
};

instead of
#include <dt-binding/pinctrl/mediatek_foo.h>
pin_state_a {
	pins = <I2C0_SCL>, <I2C0_SDA>;
	function = <I2C0>;
}

Using plain integers makes it much easier to index into pinctrl driver
specific arrays without doing all this string matching in the kernel. It
seems we are eating CPU cycles here for no good reason.

Could you please explain where you see the benefit of using strings
instead of plain integers with proper binding defines attached to them?

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

