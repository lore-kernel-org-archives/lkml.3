Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3FMHgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:36:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37745 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab3FMHgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:36:00 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 03/11] gpio: davinci: Modify to platform driver
Thread-Topic: [PATCH 03/11] gpio: davinci: Modify to platform driver
Thread-Index: AQHOVrtf6gwEFoq/8kygHsiS/vHYRpkwAbsAgACPoZCAALxDgIAAxFyQgAC16gCAAItCwA==
Date: Thu, 13 Jun 2013 07:32:21 +0000
Deferred-Delivery: Thu, 13 Jun 2013 07:32:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EADA883@DBDE04.ent.ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
 <1369206634-6778-4-git-send-email-avinashphilip@ti.com>
 <51B71056.9010103@ti.com>
 <518397C60809E147AF5323E0420B992E3EAD9D75@DBDE04.ent.ti.com>
 <51B826BF.7050009@ti.com>
 <518397C60809E147AF5323E0420B992E3EADA252@DBDE04.ent.ti.com>
 <51B96410.7000807@ti.com>
In-Reply-To: <51B96410.7000807@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5D7aN0M027147

On Thu, Jun 13, 2013 at 11:47:52, Nori, Sekhar wrote:
> On 6/12/2013 5:40 PM, Philip, Avinash wrote:
> > On Wed, Jun 12, 2013 at 13:13:59, Nori, Sekhar wrote:
> >> On 6/11/2013 6:25 PM, Philip, Avinash wrote:
> >>
> >>> On Tue, Jun 11, 2013 at 17:26:06, Nori, Sekhar wrote:
> >>
> >>>> On 5/22/2013 12:40 PM, Philip Avinash wrote:
> >>
> >>>>> @@ -179,13 +204,10 @@ static int __init davinci_gpio_setup(void)
> >>>>>  		gpiochip_add(&ctlrs[i].chip);
> >>>>>  	}
> >>>>>  
> >>>>> -	soc_info->gpio_ctlrs = ctlrs;
> >>>>
> >>>>> -	soc_info->gpio_ctlrs_num = DIV_ROUND_UP(ngpio, 32);
> >>>>
> >>>> You drop setting gpio_ctlrs_num here and don't introduce it anywhere
> >>>> else in the patchset so in effect you render the inline gpio get/set API
> >>>> useless. Looks like this initialization should be moved to platform code?
> >>>
> >>> With [PATCH 08/11] ARM: davinci: start using gpiolib support gpio get/set API
> >>> Has no more dependency on soc_info->gpio_ctlrs_num.
> >>
> >> With this series, you have removed support for inline gpio get/set API.
> >> I see that the inline functions are still available for use on
> >> tnetv107x. I wonder why it is important to keep these for tnetv107x when
> >> not necessary for other DaVinci devices?
> > 
> > To support DT boot in da850, gpio davinci has to be converted to a driver and
> > remove references to davinci_soc_info from driver. But tnetv107x has 
> > separate GPIO driver and reference to davinci_soc_info can also be removed.
> > But I didn't found defconfig support for tnetv107x platforms and left untouched.
> > As I will not be able to build and test on tnetv107x, I prefer to not touch it.
> 
> You can always build it by enabling it in menuconfig. Its an ARMv6
> platform so you will have to disable other ARMv5 based platforms from
> while enabling it. ARMv5 and ARMv6 cannot co-exist in the same image.

I will try and update.

> 
> > 
> >>
> >> When you are removing this feature, please note it prominently in your
> >> cover letter and patch description.
> > 
> > Ok
> > 
> >> Also, please provide some data on 
> >> how the latency now compares to that of inline access earlier. This is
> >> important especially for the read.
> > 
> > I am not sure whether I understood correctly or not? Meanwhile I had done
> > an experiment by reading printk timing before and after gpio_get_value from
> > a test module. I think this will help in software latency for inline access over
> > gpiolib specific access.
> > 
> > gpio_get_value latency testing code
> > 
> > +
> > +       local_irq_disable();
> > +       pr_emerg("%d %x\n", __LINE__, jiffies);
> > +       gpio_get_value(gpio_num);
> > +       pr_emerg("%d %x\n", __LINE__, jiffies);
> > +       local_irq_enable();
> > 
> > inline gpio functions with interrupt disabled
> > [   29.734337] 81 ffff966c
> > [   29.736847] 83 ffff966c
> > 
> > Time diff = 	0.00251
> > 
> > gpio library with interrupt disabled
> > 
> > [  272.876763] 81 fffff567
> > [  272.879291] 83 fffff567
> > 
> > Time diff =	0.002528
> > 
> > Inline function takes less time as expected.
> 
> Okay, please note these experiments in your cover letter. Its an 18usec
> difference. I have no reference to say if that will affect any
> application, but it will at least serve as information for someone who
> may get affected by it.

Ok I will give above details in commit message.

> 
> > 
> >> For the writes, gpio clock will
> >> mostly determine how soon the value changes on the pin.
> >>
> >> I am okay with removing the inline access feature. It helps simplify
> >> code and most arm machines don't use them. I would just like to see some
> >> data for justification as this can be seen as feature regression. Also,
> >> if we are removing it, its better to also remove it completely and get
> >> the LOC savings instead of just stopping its usage.
> > 
> > I see build failure with below patch for tnetv107x
> > [v6,6/6] Davinci: tnetv107x default configuration 
> 
> Where is this patch?

This patch is not in mainline and got it from patchwork
https://patchwork.kernel.org/patch/97853/

> What is the commit-id if it is in mainline? Where
> is the failure log?

With tnetv107x_defconfig build is failing

arch/arm/mach-davinci/board-tnetv107x-evm.c:282:15: error:
 'davinci_timer_init' undeclared here (not in a function)
arch/arm/mach-davinci/board-tnetv107x-evm.c:284:15: error:
 'davinci_init_late' undeclared here (not in a function)
make[1]: *** [arch/arm/mach-davinci/board-tnetv107x-evm.o] Error 1

Following patch fixes the build above breakage

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index ba79837..4a9c320 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -30,6 +30,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>

+#include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/edma.h>
 #include <mach/mux.h>
@@ -147,7 +148,7 @@ static struct davinci_nand_pdata nand_config = {
        .ecc_bits       = 1,
 };

-static struct davinci_uart_config serial_config __initconst = {
+static struct davinci_uart_config serial_config = {
        .enabled_uarts  = BIT(1),
 };

@@ -245,7 +246,7 @@ static struct ti_ssp_data ssp_config = {
        },
 };

-static struct tnetv107x_device_info evm_device_info __initconst = {
+static struct tnetv107x_device_info evm_device_info = {
        .serial_config          = &serial_config,
        .mmc_config[1]          = &mmc_config,  /* controller 1 */
        .nand_config[0]         = &nand_config, /* chip select 0 */



> 
> > 
> > So I prefer to leave tnetv107x platform for now.
> 
> I don't think that's acceptable. At least by me.

I think 2 options are available
1. Convert gpio-tnetv107x.c to platform driver. This will help in
	removing gpio references in davinci_soc_info structure.
2. Remove inline gpio api support and start use gpiolib support.

I prefer first option. It will help in removing
<arch/arm/mach-davinci/include/mach/gpio-davinci.h>.

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
