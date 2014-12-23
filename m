Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaLWNKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:10:51 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:42846 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbaLWNKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:10:49 -0500
Message-ID: <549969D4.5020303@cogentembedded.com>
Date: Tue, 23 Dec 2014 16:10:44 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        baolu.lu@linux.intel.com
Subject: Re: [RFC/PATCH] extcon: otg_gpio: add driver for USB OTG port controlled
 by GPIO(s)
References: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/23/2014 1:43 AM, David Cohen wrote:

> Some platforms have an USB OTG port fully (or partially) controlled by
> GPIOs:

> (1) USB ID is connected directly to GPIO

> Optionally:
> (2) VBUS is enabled by a GPIO (when ID is grounded)

    Can't the host driver still control Vbus?

> (3) Platform has 2 USB controllers connected to same port: one for
>      device and one for host role. D+/- are switched between phys
>      by GPIO.

> As per initial version, this driver has the duty to control whether
> USB-Host cable is plugged in or not:
>   - If yes, OTG port is configured for host role
>   - If no, by standard, the OTG port is configured for device role

> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---

> Hi,

> Some Intel Bay Trail boards have an unusual way to handle the USB OTG port:
>   - The USB ID pin is connected directly to GPIO on SoC
>   - When in host role, VBUS is provided by enabling a GPIO
>   - Device and host roles are supported by 2 independent controllers with D+/-
>     pins from port switched between different phys according a GPIO level.

> The ACPI table describes this USB port as a (virtual) device with all the
> necessary GPIOs. This driver implements support to this virtual device as an
> extcon class driver. All drivers that depend on the USB OTG port state (USB phy,
> PMIC, charge detection) will listen to extcon events.

    It's very close to my setup on R-Car R8A7791 based boards. :-)
I have already submitted Maxim MAX3355 OTG chip GPIO-based driver.

> Comments are welcome.

> Br, David
> ---
>
>   drivers/extcon/Kconfig           |   8 ++
>   drivers/extcon/Makefile          |   1 +
>   drivers/extcon/extcon-otg_gpio.c | 200 +++++++++++++++++++++++++++++++++++++++
>   3 files changed, 209 insertions(+)
>   create mode 100644 drivers/extcon/extcon-otg_gpio.c
>
> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> index 6a1f7de6fa54..e8010cda4642 100644
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -93,4 +93,12 @@ config EXTCON_SM5502
>   	  Silicon Mitus SM5502. The SM5502 is a USB port accessory
>   	  detector and switch.
>
> +config EXTCON_OTG_GPIO
> +	tristate "VIRTUAL USB OTG PORT support"
> +	depends on GPIOLIB
> +	help
> +	  Say Y here to enable support for virtual USB OTG port device
> +	  controlled by GPIOs. This driver can be used when at least USB ID pin
> +	  is connected directly to GPIO.
> +

    The entries in this file seem alphabetically sorted.

>   endif # MULTISTATE_SWITCH
> diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
> index 0370b42e5a27..9e81088c6584 100644
> --- a/drivers/extcon/Makefile
> +++ b/drivers/extcon/Makefile
> @@ -12,3 +12,4 @@ obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
>   obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
>   obj-$(CONFIG_EXTCON_RT8973A)	+= extcon-rt8973a.o
>   obj-$(CONFIG_EXTCON_SM5502)	+= extcon-sm5502.o
> +obj-$(CONFIG_EXTCON_OTG_GPIO) += extcon-otg_gpio.o

    The lines here are sorted too.

> diff --git a/drivers/extcon/extcon-otg_gpio.c b/drivers/extcon/extcon-otg_gpio.c
> new file mode 100644
> index 000000000000..c5ee765a5f4f
> --- /dev/null
> +++ b/drivers/extcon/extcon-otg_gpio.c
> @@ -0,0 +1,200 @@
[...]
> +static irqreturn_t vuport_isr(int irq, void *priv)
> +{
> +	return IRQ_WAKE_THREAD;
> +}

    It's the same as the default IRQ handler...

> +	ret = devm_request_threaded_irq(dev, gpiod_to_irq(vup->gpio_usb_id),
> +					vuport_isr, vuport_thread_isr,

    ... so you probably can just pass NULL instead of vuport_isr, no?

[...]

> +static int __init vuport_init(void)
> +{
> +	return platform_driver_register(&vuport_driver);
> +}
> +subsys_initcall(vuport_init);

    Hm, why?

WBR, Sergei

