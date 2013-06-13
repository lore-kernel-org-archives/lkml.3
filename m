Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab3FMIan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:30:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53871 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab3FMIak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:30:40 -0400
Message-ID: <51B98301.9090404@ti.com>
Date: Thu, 13 Jun 2013 13:59:53 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/11] gpio: davinci: Modify to platform driver
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com> <1369206634-6778-4-git-send-email-avinashphilip@ti.com> <51B71056.9010103@ti.com> <518397C60809E147AF5323E0420B992E3EAD9D75@DBDE04.ent.ti.com> <51B826BF.7050009@ti.com> <518397C60809E147AF5323E0420B992E3EADA252@DBDE04.ent.ti.com> <51B96410.7000807@ti.com> <518397C60809E147AF5323E0420B992E3EADA883@DBDE04.ent.ti.com>
In-Reply-To: <518397C60809E147AF5323E0420B992E3EADA883@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/2013 1:02 PM, Philip, Avinash wrote:

> With tnetv107x_defconfig build is failing
> 
> arch/arm/mach-davinci/board-tnetv107x-evm.c:282:15: error:
>  'davinci_timer_init' undeclared here (not in a function)
> arch/arm/mach-davinci/board-tnetv107x-evm.c:284:15: error:
>  'davinci_init_late' undeclared here (not in a function)
> make[1]: *** [arch/arm/mach-davinci/board-tnetv107x-evm.o] Error 1
> 
> Following patch fixes the build above breakage

The error you are seeing and the patch you provided below have no
correlation.

> 
> diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
> index ba79837..4a9c320 100644
> --- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
> +++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
> @@ -30,6 +30,7 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach-types.h>
> 
> +#include <mach/common.h>
>  #include <mach/irqs.h>
>  #include <mach/edma.h>
>  #include <mach/mux.h>
> @@ -147,7 +148,7 @@ static struct davinci_nand_pdata nand_config = {
>         .ecc_bits       = 1,
>  };
> 
> -static struct davinci_uart_config serial_config __initconst = {
> +static struct davinci_uart_config serial_config = {
>         .enabled_uarts  = BIT(1),
>  };

You can make this __initdata instead - assuming its okay to have this
memory discarded at init.

> 
> @@ -245,7 +246,7 @@ static struct ti_ssp_data ssp_config = {
>         },
>  };
> 
> -static struct tnetv107x_device_info evm_device_info __initconst = {
> +static struct tnetv107x_device_info evm_device_info = {

Same here. You can make this __initdata.

Please send a formal patch for the errors you have seen.

>         .serial_config          = &serial_config,
>         .mmc_config[1]          = &mmc_config,  /* controller 1 */
>         .nand_config[0]         = &nand_config, /* chip select 0 */
> 
> 
> 
>>
>>>
>>> So I prefer to leave tnetv107x platform for now.
>>
>> I don't think that's acceptable. At least by me.
> 
> I think 2 options are available
> 1. Convert gpio-tnetv107x.c to platform driver. This will help in
> 	removing gpio references in davinci_soc_info structure.
> 2. Remove inline gpio api support and start use gpiolib support.
> 
> I prefer first option. It will help in removing
> <arch/arm/mach-davinci/include/mach/gpio-davinci.h>.

Okay. Can you take this up in this series? I understand you may not have
an tnetv107x board, but at least you can get to a series that builds.

Even if you choose to do just option #2, I am OK. What I really want to
see is inline API gone completely (not just remain largely unused). This
will also help you avoid exposing internal data structures like
davinci_gpio_controller exposed to the whole kernel. The worse part
right now is you have two copies of the same structure exposed globally
from two different include folders.

Thanks,
Sekhar
