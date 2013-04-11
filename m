Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161630Ab3DKMa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:30:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935028Ab3DKMaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:30:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCHv2 arm: initial TI-Nspire support]
Date: Thu, 11 Apr 2013 14:30:05 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux@arm.linux.org.uk, Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <8E071E2D-4FF3-487E-A53B-B6A7C427E421@gmail.com>
In-Reply-To: <8E071E2D-4FF3-487E-A53B-B6A7C427E421@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304111430.05528.arnd@arndb.de>
X-Provags-ID: V02:K0:x54CfKpAiQrqVLuRitfTQXOoraObqhFpaVE+clr/C/y
 OtIhKLYWHP+Q2YkcY1TfgfpbSPaimDJdu0DzO4cPNfRlIREmth
 AZZQbvYa0ZomBOFWctxu1+F0AZE2Dq2tYzNXTZM0Parpv9THDB
 A5BpdVA1Y+j97zeR5LYKlSVHLnIcgWfnf/33LwNMLvNyWbKp6p
 FDN5jDcGv5ZbIYUme0WjZgi8gUXPFT1u/AKb0+reING67Si7cE
 +L4356yMIHq+XUaTTFmqSCs5rYVcclUPz5IhqO1yw5zdXYGynS
 z1fkjXws2VDgWH4Mj4uTiIU5dRzxulm0S9YCgFm8Mav/vGBP9X
 xYrdX367pWlvWZWIrPhw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 April 2013, Daniel Tang wrote:
> This is another updated patch for Linux on TI-Nspire support. 
> 
> Apologies for previously posting updated patches as replies to the first thread. I'll send updated patches in new threads from now to avoid confusion.
> 
> Changes between http://archive.arm.linux.org.uk/lurker/message/20130408.113343.585af217.en.html and v2:
> * Added new drivers to support the irqchip and timers on older models.
> * Added new device trees to support the other models.
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>

Nice!

>  arch/arm/Kconfig                            |   2 +
>  arch/arm/Kconfig.debug                      |  16 ++
>  arch/arm/Makefile                           |   1 +
>  arch/arm/boot/dts/Makefile                  |   3 +
>  arch/arm/boot/dts/nspire-classic.dtsi       |  68 ++++++
>  arch/arm/boot/dts/nspire-clp.dts            |  45 ++++
>  arch/arm/boot/dts/nspire-cx.dts             | 115 ++++++++++
>  arch/arm/boot/dts/nspire-tp.dts             |  44 ++++
>  arch/arm/boot/dts/nspire.dtsi               | 159 ++++++++++++++
>  arch/arm/include/debug/nspire.S             |  28 +++
>  arch/arm/mach-nspire/Kconfig                |  15 ++
>  arch/arm/mach-nspire/Makefile               |   2 +
>  arch/arm/mach-nspire/Makefile.boot          |   0
>  arch/arm/mach-nspire/clcd.c                 | 118 +++++++++++
>  arch/arm/mach-nspire/clcd.h                 |  14 ++
>  arch/arm/mach-nspire/mmio.h                 |  15 ++
>  arch/arm/mach-nspire/nspire.c               | 142 +++++++++++++
>  drivers/clocksource/Makefile                |   1 +
>  drivers/clocksource/nspire-classic-timer.c  | 216 +++++++++++++++++++
>  drivers/input/keyboard/Kconfig              |  10 +
>  drivers/input/keyboard/Makefile             |   1 +
>  drivers/input/keyboard/nspire-keypad.c      | 316 ++++++++++++++++++++++++++++
>  drivers/irqchip/Makefile                    |   1 +
>  drivers/irqchip/irq-nspire-classic.c        | 177 ++++++++++++++++
>  include/clocksource/nspire_classic_timer.h  |  16 ++
>  include/linux/platform_data/nspire-keypad.h |  28 +++
>  26 files changed, 1553 insertions(+)

Please split this up into a series of patches, one for each subsystem.
I would also keep the dts files in a separate patch from the platform
code.


> +bool timer_init;
> +
> +void __init nspire_classic_timer_init(void)
> +{
> +	struct device_node *node;
> +
> +	if (timer_init)
> +		return;
> +
> +	for_each_compatible_node(node, NULL, DT_COMPAT) {
> +		nspire_timer_add(node);
> +	}
> +
> +	timer_init = 1;
> +}
> +
> +CLOCKSOURCE_OF_DECLARE(nspire_classic_timer,
> +		DT_COMPAT, nspire_classic_timer_init)

Why do you need the logic to prevent it from being initilized
twice?  Can't you just remove the direct call to nspire_classic_timer_init
from platform code and rely on of_clk_init() to call it?

Note that the interface has changed in linux-next, you now
get called separately for each matching device, with the device_node
as the argument, so you no longer have to search the device tree,
and can essentially do

CLOCKSOURCE_OF_DECLARE(nspire_classic_timer, DT_COMPAT, nspire_timer_add);

Feel free to rebase your patch on top of the clksrc/cleanup branch
in arm-soc to get the new behavior.

> +#ifdef CONFIG_OF
> +static const struct of_device_id nspire_keypad_dt_match[] = {
> +	{ .compatible = "nspire-keypad" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, nspire_keypad_dt_match);
> +#endif

You should not need the #ifdef.

> +static struct platform_driver nspire_keypad_driver = {
> +	.driver = {
> +		.name = "nspire-keypad",
> +		.owner  = THIS_MODULE,
> +		.of_match_table = of_match_ptr(nspire_keypad_dt_match),
> +	},
> +	.remove = nspire_keypad_remove,
> +	.probe = nspire_keypad_probe
> +};

Please put a comma at the end of the last line in definitions like this.

> diff --git a/include/clocksource/nspire_classic_timer.h b/include/clocksource/nspire_classic_timer.h
> new file mode 100644
> index 0000000..39236f1
> --- /dev/null
> +++ b/include/clocksource/nspire_classic_timer.h

You should not need this file if you do the above.

> diff --git a/include/linux/platform_data/nspire-keypad.h b/include/linux/platform_data/nspire-keypad.h
> new file mode 100644
> index 0000000..03deb64
> --- /dev/null
> +++ b/include/linux/platform_data/nspire-keypad.h

And this file now also isn't needed any more, you can just merge the
fields of struct nspire_keypad_data into struct nspire_keypad.

	Arnd
