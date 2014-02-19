Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaBSRbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:31:45 -0500
Received: from top.free-electrons.com ([176.31.233.9]:51235 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754536AbaBSRbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:31:44 -0500
Date: Wed, 19 Feb 2014 18:31:42 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b.brezillon@overkiz.com" <b.brezillon@overkiz.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 1/8] ARM: at91: Add at91sam9rl DT SoC support
Message-ID: <20140219173141.GB3038@piout.net>
References: <1392823951-26053-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1392823951-26053-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20140219170020.GA25079@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219170020.GA25079@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/2014 at 17:00:20 +0000, Mark Rutland wrote :
> On Wed, Feb 19, 2014 at 03:32:24PM +0000, Alexandre Belloni wrote:
> > This adds preliminary DT support for the at91sam9rl.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > ---
> >  arch/arm/boot/dts/at91sam9rl.dtsi | 628 ++++++++++++++++++++++++++++++++++++++
> >  arch/arm/mach-at91/at91sam9rl.c   |  16 +
> >  2 files changed, 644 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/at91sam9rl.dtsi
>  
> [...]
> 
> > +                       tcb0: timer@fffa0000 {
> > +                               compatible = "atmel,at91rm9200-tcb";
> > +                               reg = <0xfffa0000 0x100>;
> > +                               interrupts = <16 IRQ_TYPE_LEVEL_HIGH 0
> > +                                             17 IRQ_TYPE_LEVEL_HIGH 0
> > +                                             18 IRQ_TYPE_LEVEL_HIGH 0>;
> > +                       };
> 
> Nit: please bracket list entries individually. Also for other list
> properties like reg and (*-)gpio(s).
> 

OK.

> [...]
> 
> > +                       adc0: adc@fffd0000 {
> > +                               compatible = "atmel,at91sam9260-adc";
> > +                               reg = <0xfffd0000 0x100>;
> > +                               interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
> > +                               atmel,adc-use-external-triggers;
> > +                               atmel,adc-channels-used = <0xf>;
> > +                               atmel,adc-vref = <3300>;
> > +                               atmel,adc-num-channels = <4>;
> > +                               atmel,adc-startup-time = <15>;
> > +                               atmel,adc-channel-base = <0x30>;
> > +                               atmel,adc-drdy-mask = <0x10000>;
> > +                               atmel,adc-status-register = <0x1c>;
> > +                               atmel,adc-trigger-register = <0x04>;
> > +                               atmel,adc-res = <8 10>;
> > +                               atmel,adc-res-names = "lowres", "highres";
> > +                               atmel,adc-use-res = "highres";
> > +
> > +                               trigger@0 {
> > +                                       trigger-name = "timer-counter-0";
> > +                                       trigger-value = <0x1>;
> > +                               };
> 
> A unit-address should go with a reg value. Either this needs a reg and
> the parent node needs #address-cells and #size-cells, or the
> unit-address should go, and the names made unique through other means.
> 

OK, I guess I'll have to fix
Documentation/devicetree/bindings/arm/atmel-adc.txt too.

> [...]
> 
> > +                       pinctrl@fffff400 {
> > +                               #address-cells = <1>;
> > +                               #size-cells = <1>;
> > +                               compatible = "atmel,at91rm9200-pinctrl", "simple-bus";
> 
> NAK. Either this is a atmel,at91rm9200-pinctrl node or a simple-bus. Not
> both; that doesn't make any sense.
> 

Simply a copy paste, I'll fix that here and also the 6 other atmel
dtsi includes.

What is your preference for those using:
compatible = "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "simple-bus"; ?

> > diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
> > index 3651517abedf..d6ee8bb47213 100644
> > --- a/arch/arm/mach-at91/at91sam9rl.c
> > +++ b/arch/arm/mach-at91/at91sam9rl.c
> > @@ -196,6 +196,22 @@ static struct clk_lookup periph_clocks_lookups[] = {
> >         CLKDEV_CON_ID("pioB", &pioB_clk),
> >         CLKDEV_CON_ID("pioC", &pioC_clk),
> >         CLKDEV_CON_ID("pioD", &pioD_clk),
> > +       /* more lookup table for DT entries */
> > +       CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
> > +       CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
> > +       CLKDEV_CON_DEV_ID("usart", "ffffb400.serial", &usart1_clk),
> > +       CLKDEV_CON_DEV_ID("usart", "ffffb800.serial", &usart2_clk),
> > +       CLKDEV_CON_DEV_ID("usart", "ffffbc00.serial", &usart3_clk),
> > +       CLKDEV_CON_DEV_ID("t0_clk", "fffa0000.timer", &tc0_clk),
> > +       CLKDEV_CON_DEV_ID("t1_clk", "fffa0000.timer", &tc1_clk),
> > +       CLKDEV_CON_DEV_ID("t2_clk", "fffa0000.timer", &tc2_clk),
> > +       CLKDEV_CON_DEV_ID("mci_clk", "fffa4000.mmc", &mmc_clk),
> > +       CLKDEV_CON_DEV_ID(NULL, "fffa8000.i2c", &twi0_clk),
> > +       CLKDEV_CON_DEV_ID(NULL, "fffac000.i2c", &twi1_clk),
> > +       CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioA_clk),
> > +       CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
> > +       CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
> > +       CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioD_clk),
> 
> Why can't these clocks be described in the DT?
> 

The issue is twofold:
 - At that point in the series, at91sam9 SoCs are not supported through
   the CCF.
 - Even after supporting CCF, the at91_dt_defconfig is selecting at91
   SoCs that are not supported through the CCF hence preventing us from
   using it.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
