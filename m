Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3FDMFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:05:33 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58999 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab3FDMF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:05:29 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 07/10] pinctrl: add pinctrl driver for Rockchip SoCs
Date: Tue, 4 Jun 2013 14:05:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
References: <201306030055.15413.heiko@sntech.de> <201306030059.47611.heiko@sntech.de> <CACRpkdbBr7s1NoTQewVOotorHJHLL8Z6-_gAx5GC0x6uNUX0gw@mail.gmail.com>
In-Reply-To: <CACRpkdbBr7s1NoTQewVOotorHJHLL8Z6-_gAx5GC0x6uNUX0gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306041405.13320.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'll just skip over the "right, will fix that" issues and just address the 
unclear ones.

Am Dienstag, 4. Juni 2013, 09:08:09 schrieb Linus Walleij:
> On Mon, Jun 3, 2013 at 12:59 AM, Heiko Stübner <heiko@sntech.de> wrote:
> > This driver adds support the Cortex-A9 based SoCs from Rockchip,
> > so at least the RK2928, RK3066 (a and b) and RK3188.
> > Earlier Rockchip SoCs seem to use similar mechanics for gpio
> > handling so should be supportable with relative small changes.
> > Pull handling on the rk3188 is currently a stub, due to it being
> > a bit different to the earlier SoCs.
> > 
> > Pinmuxing as well as gpio (and interrupt-) handling tested on
> > a rk3066a based machine.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> Overall this is looking very good, mainly minor comments.

> > +Required properties for pin configuration node:
> > +  - rockchip,pins: 4 integers array, represents a group of pins mux and
> > config +    setting. The format is rockchip,pins = <PIN_BANK
> > PIN_BANK_NUM MUX CONFIG>. +    The MUX 0 means gpio and MUX 1 to 3 mean
> > the specific device function +
> > +Bits used for CONFIG:
> > +PULL_AUTO      (1 << 0): indicate this pin needs a pull setting for SoCs
> > +                         that determine the pull up or down themselfs
> 
> Hm, never saw that before...

Citing the original gpio driver:

	/*
	 * Values written to this register independently
	 * control Pullup/Pulldown or not for the
	 * corresponding data bit in GPIO.
	 * 0: pull up/down enable, PAD type will decide
	 * to be up or down, not related with this value
	 * 1: pull up/down disable
	 */

So if it's a pull up or down is decided based on the mux of the pin. Calling 
everything a "pull down" (or up) when it isn't seemed somehow wrong to me.

The rk3188 on the other hand supports both pull up and down separately.

Or should this be selected as PULL_UP | PULL_DOWN in the config?


> > +uart2: serial@20064000 {
> > +       compatible = "snps,dw-apb-uart";
> > +       reg = <0x20064000 0x400>;
> > +       interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
> 
> Using #defines, nice!

everything for bonus-points ;-)

And actually it's definitly easier on me as well, as I don't have to remember 
what each integer value means.

> +++ b/drivers/pinctrl/Kconfig
> @@ -158,6 +158,12 @@ config PINCTRL_DB8540
>         bool "DB8540 pin controller driver"
>         depends on PINCTRL_NOMADIK && ARCH_U8500
> 
> +config PINCTRL_ROCKCHIP
> +       bool
> +       select PINMUX
> +       select PINCONF
> +       select GENERIC_IRQ_CHIP
> 
> Why is this super-simple pin config thing not using
> GENERIC_PINCONF?
> 
> I *know* it is simpler to implement your own thing, but think of the
> poor maintainers that have to wade through 50 identical implementations.
> Do this, it pays off.

generic pinconf sounds interesting ... will give it a try.

The only problem is the pull stuff mentioned above that is either pull up or 
down without the driver having knowledge about it. And generic_pinconf only 
knows about them separately right now.


> BTW: it leads to wanting to use generic pinconf DT bindings as experienced
> by Laurent and others. We need to fix that too...
> 
> (...)
> 
> > +++ b/drivers/pinctrl/pinctrl-rockchip.c
> > +static void rockchip_pin_dbg_show(struct pinctrl_dev *pctldev,
> > +                                       struct seq_file *s, unsigned
> > offset) +{
> > +       seq_printf(s, "%s", dev_name(pctldev->dev));
> > +}
> 
> Nothing else you want to say about the pins here?
> (No big deal for sure, but....)

when using pinconfig_generic, its dump_pin function should be more talkative 
right?


> > +
> > +               data = readl_relaxed(reg);
> > +               data >>= bit;
> > +               data &= 1;
> > +
> > +               return !data;
> 
> That's a bit hard to read, I'd just:
> 
> #include <linux/bitops.h>
> return !(readl_relaxed(reg) & BIT(bit));
> 
> And skip the "data" variable. The ! operator will
> clamp this to a bool (0/1).
> 
> But we all have our habits.

yeah, but sometimes it's also good to try to break them ... your solution is 
much nicer to read (and shorter).


> All I could think of right now...

Thanks for the review
Heiko
