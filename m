Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaGBMkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:40:35 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:58353 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaGBMkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:40:32 -0400
Date: Wed, 2 Jul 2014 13:40:24 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 1/3] drivers: reset: stih407: Add softreset, powerdown
 and picophy controllers
Message-ID: <20140702124024.GD8809@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org>
 <1404225047-9495-2-git-send-email-peter.griffin@linaro.org>
 <20140702084819.GD10311@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702084819.GD10311@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Thanks for reviewing, see my inline comments below

> > This patch adds a softreset, powerdown and picophy reset controllers for
> > the STiH407 SoC.
> 
> s/adds a softreset/adds softreset/

Fixed in V2

> 
> >  .../bindings/reset/st,sti-picophyreset.txt         |  41 ++++++
> >  drivers/reset/sti/Kconfig                          |   4 +
> >  drivers/reset/sti/Makefile                         |   1 +
> >  drivers/reset/sti/reset-stih407.c                  | 159 +++++++++++++++++++++
> >  .../dt-bindings/reset-controller/stih407-resets.h  |  60 ++++++++
> 
> Documentation is normally split out as a separate patch.

Ok will seperate out in v2.

> > +Please refer to Documentation/devicetree/bindings/reset/reset.txt
> > +for common reset controller binding usage.
> > +
> > +Required properties:
> > +- compatible: Should be "st,<chip>-softreset"
> 
> You need to list the possible values here in full.

Ok changed in V2
> 
> > +- #reset-cells: 1, see below
> > +
> > +example:
> 
> Nit: s/example/Example

Changed in V2

> 
> > +
> > +	picophyreset: picophyreset-controller {
> > +		#reset-cells = <1>;
> > +		compatible = "st,stih407-picophyreset";
> 
> Nit: Stick the compatible string at the top.

Changed in V2

> > +
> > +example:
> 
> '\n'

Ok Changed in V2, and I capitialized the 'E' whilst I was there.

> 
> > +	usb2_picophy0: usbpicophy@0 {
> > +		resets = <&picophyreset STIH407_PICOPHY0_RESET>;
> > +	};
> > +
> > +Macro definitions for the supported reset channels can be found in:
> > +include/dt-bindings/reset-controller/stih407-resets.h
> > diff --git a/drivers/reset/sti/Kconfig b/drivers/reset/sti/Kconfig
> > index 88d2d03..f8c15a3 100644
> > --- a/drivers/reset/sti/Kconfig
> > +++ b/drivers/reset/sti/Kconfig
> > @@ -12,4 +12,8 @@ config STIH416_RESET
> >  	bool
> >  	select STI_RESET_SYSCFG
> >  
> > +config STIH407_RESET
> > +	bool
> > +	select STI_RESET_SYSCFG
> > +
> 
> No help?

Nope, currently no other platform using reset API has provided help.

> 
> >  endif
> > diff --git a/drivers/reset/sti/Makefile b/drivers/reset/sti/Makefile
> > index be1c976..dc85dfb 100644
> > --- a/drivers/reset/sti/Makefile
> > +++ b/drivers/reset/sti/Makefile
> > @@ -2,3 +2,4 @@ obj-$(CONFIG_STI_RESET_SYSCFG) += reset-syscfg.o
> >  
> >  obj-$(CONFIG_STIH415_RESET) += reset-stih415.o
> >  obj-$(CONFIG_STIH416_RESET) += reset-stih416.o
> > +obj-$(CONFIG_STIH407_RESET) += reset-stih407.o
> 
> Genuine question: how different are these?  Can they be consolidated?

No, the common code is already abstracted into reset-syscfg.c. The SoC specific parts are
in the reset-stiXYZ files.

> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <dt-bindings/reset-controller/stih407-resets.h>
> > +
> > +#include "reset-syscfg.h"
> 
> May as well squash these up.

Fixed in V2, but alters the style versus the other reset-XYZ files in this 
directory.

> 
> > +/*
> > + * STiH407 Peripheral powerdown definitions.
> > + */
> 
> Should be single line comment.

Fixed in V2.
> 
> > +static const char stih407_core[] = "st,stih407-core-syscfg";
> > +static const char stih407_sbc_reg[] = "st,stih407-sbc-reg-syscfg";
> > +static const char stih407_lpm[] = "st,stih407-lpm-syscfg";
> > +
> > +#define STIH407_PDN_0(_bit) \
> > +	_SYSCFG_RST_CH(stih407_core, SYSCFG_5000, _bit, SYSSTAT_5500, _bit)
> > +#define STIH407_PDN_1(_bit) \
> > +	_SYSCFG_RST_CH(stih407_core, SYSCFG_5001, _bit, SYSSTAT_5501, _bit)
> > +#define STIH407_PDN_ETH(_bit, _stat) \
> > +	_SYSCFG_RST_CH(stih407_sbc_reg, SYSCFG_4032, _bit, SYSSTAT_4520, _stat)
> > +
> > +/* Powerdown requests control 0 */
> > +#define SYSCFG_5000	0x0
> > +#define SYSSTAT_5500	0x7d0
> 
> Separate these with a '\n'.

Have fixed in V2
> 
> > +/* Powerdown requests control 1 (High Speed Links) */
> > +#define SYSCFG_5001	0x4
> > +#define SYSSTAT_5501	0x7d4
> > +
> > +/* Ethernet powerdown/status/reset */
> > +#define	SYSCFG_4032	0x80
> > +#define	SYSSTAT_4520	0x820
> > +
> 
> What does this '\n' separate? Is it an Ethernet related value, or not?

Fixed in V2, have removed the '\n'

> 
> > +#define	SYSCFG_4002	0x8
> 
> Can you address the formatting for all of the above.  Sometimes tabs
> are used, other times it's spaces and the padding is also different -

Fixed in V2.

> can you standardise to 3 values post-fixing the '0x' i.e. 0xNNN.

I can change this, but it alters the style versus the other reset-XYZ files
in this directory.

> 
> > +static const struct syscfg_reset_channel_data stih407_powerdowns[] = {
> > +	[STIH407_EMISS_POWERDOWN] = STIH407_PDN_0(1),
> > +	[STIH407_NAND_POWERDOWN] = STIH407_PDN_0(0),
> > +	[STIH407_USB3_POWERDOWN] = STIH407_PDN_1(6),
> > +	[STIH407_USB2_PORT1_POWERDOWN] = STIH407_PDN_1(5),
> > +	[STIH407_USB2_PORT0_POWERDOWN] = STIH407_PDN_1(4),
> > +	[STIH407_PCIE1_POWERDOWN] = STIH407_PDN_1(3),
> > +	[STIH407_PCIE0_POWERDOWN] = STIH407_PDN_1(2),
> > +	[STIH407_SATA1_POWERDOWN] = STIH407_PDN_1(1),
> > +	[STIH407_SATA0_POWERDOWN] = STIH407_PDN_1(0),
> > +	[STIH407_ETH1_POWERDOWN] = STIH407_PDN_ETH(0, 2),
> > +};
> 
> Being a little OCD, I _personally_ like to see the '='s lined up with
> tabs, but some maintainers don't like that.  Philipp's call I guess.

I will leave this one for the maintainer to decide, as maintaining that sort of
alignment can be time consuming.

> > +static struct syscfg_reset_controller_data stih407_picophyreset_controller = {
> > +	.wait_for_ack = false,
> > +	.nr_channels = ARRAY_SIZE(stih407_picophyresets),
> > +	.channels = stih407_picophyresets,
> > +};
> 
> I believe these should be const.

Fixed in V2.

> 
> > +static struct of_device_id stih407_reset_match[] = {
> > +	{.compatible = "st,stih407-powerdown",
> > +	 .data = &stih407_powerdown_controller,},
> > +	{.compatible = "st,stih407-softreset",
> > +	 .data = &stih407_softreset_controller,},
> > +	{.compatible = "st,stih407-picophyreset",
> > +	 .data = &stih407_picophyreset_controller,},
> 
> Formatting should be:
> 
> 	{
> 		.compatible = "st,stih407-picophyreset",
> 	 	.data = &stih407_picophyreset_controller,
> 	},

Changed in V2, but it alters the style versus other reset-XYZ dfiles in this directory.

> > +	{},
> > +};
> > +
> > +static struct platform_driver stih407_reset_driver = {
> > +	.probe = syscfg_reset_probe,
> > +	.driver = {
> > +		   .name = "reset-stih407",
> > +		   .owner = THIS_MODULE,
> 
> Remove this line, it's done for you as part of
> platform_driver_register().

Fixed in V2.

> 
> > +		   .of_match_table = stih407_reset_match,
> > +		   },
> 
> Tabbing is borked.

Fixed in V2

> > +/* Synp GMAC PowerDown */
> > +#define	STIH407_ETH1_POWERDOWN		2
> 
> For consistency, either add a line here, or remove the one 3 up.

Fixed in V2
> 
> > +/* Powerdown requests control 1 */
> > +#define STIH407_USB3_POWERDOWN		3
> > +#define STIH407_USB2_PORT1_POWERDOWN	4
> > +#define STIH407_USB2_PORT0_POWERDOWN	5
> > +#define STIH407_PCIE1_POWERDOWN		6
> > +#define STIH407_PCIE0_POWERDOWN		7
> > +#define STIH407_SATA1_POWERDOWN		8
> > +#define STIH407_SATA0_POWERDOWN		9
> 
> Do these all line up in your editor? 

Yes
> 
> > +#define	STIH407_KEYSCAN_SOFTRESET	26
> > +#define	STIH407_USB2_PORT0_SOFTRESET	27
> > +#define	STIH407_USB2_PORT1_SOFTRESET	28
> 
> Again, you have tabs here and spaces elsewhere.

Fixed in V2

regards,

Peter.
