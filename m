Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab3CLSKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:10:53 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:48328 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab3CLSKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:10:51 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F79273676@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F79273676@DQHE02.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 12 Mar 2013 11:10:29 -0700
Message-ID: <CAK5ve-KT3NEv=MYv2ZQ9YQ8L-TS9KFaL0VNXzO7KoG9gvSRGcg@mail.gmail.com>
Subject: Re: [PATCH 2/3] leds: add LED Trigger for camera function
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeong, Daniel" <Daniel.Jeong@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 12:36 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
> Some LED devices support flash/torch functionality through the LED subsystem.
> This patch enables direct LED trigger controls by the driver.
> Flash on/off and torch on/off can be done simply by other driver space.
> Two trigger APIs are added, ledtrig_flash_ctrl() and ledtrig_torch_ctrl().
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/trigger/Kconfig          |    8 +++++
>  drivers/leds/trigger/Makefile         |    1 +
>  drivers/leds/trigger/ledtrig-camera.c |   57 +++++++++++++++++++++++++++++++++
>  include/linux/leds.h                  |    8 +++++
>  4 files changed, 74 insertions(+)
>  create mode 100644 drivers/leds/trigger/ledtrig-camera.c
>
> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index eaa286d..49794b4 100644
> --- a/drivers/leds/trigger/Kconfig
> +++ b/drivers/leds/trigger/Kconfig
> @@ -100,4 +100,12 @@ config LEDS_TRIGGER_TRANSIENT
>           GPIO/PWM based hardware.
>           If unsure, say Y.
>
> +config LEDS_TRIGGER_CAMERA
> +       tristate "LED Camera Flash/Torch Trigger"
> +       depends on LEDS_TRIGGERS
> +       help
> +         This allows LEDs to be controlled as a camera flash/torch device.
> +         This enables direct flash/torch on/off by the driver, kernel space.
> +         If unsure, say Y.
> +
>  endif # LEDS_TRIGGERS
> diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
> index 554e46e..1abf48d 100644
> --- a/drivers/leds/trigger/Makefile
> +++ b/drivers/leds/trigger/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_LEDS_TRIGGER_GPIO)         += ledtrig-gpio.o
>  obj-$(CONFIG_LEDS_TRIGGER_CPU)         += ledtrig-cpu.o
>  obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)  += ledtrig-default-on.o
>  obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)   += ledtrig-transient.o
> +obj-$(CONFIG_LEDS_TRIGGER_CAMERA)      += ledtrig-camera.o
> diff --git a/drivers/leds/trigger/ledtrig-camera.c b/drivers/leds/trigger/ledtrig-camera.c
> new file mode 100644
> index 0000000..9bd73a8
> --- /dev/null
> +++ b/drivers/leds/trigger/ledtrig-camera.c
> @@ -0,0 +1,57 @@
> +/*
> + * Camera Flash and Torch On/Off Trigger
> + *
> + * based on ledtrig-ide-disk.c
> + *
> + * Copyright 2013 Texas Instruments
> + *
> + * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/leds.h>
> +
> +DEFINE_LED_TRIGGER(ledtrig_flash);
> +DEFINE_LED_TRIGGER(ledtrig_torch);
> +
> +void ledtrig_flash_ctrl(bool on)
> +{
> +       enum led_brightness brt = on ? LED_FULL : LED_OFF;
> +
> +       led_trigger_event(ledtrig_flash, brt);
> +}
> +EXPORT_SYMBOL_GPL(ledtrig_flash_ctrl);
> +
> +void ledtrig_torch_ctrl(bool on)
> +{
> +       enum led_brightness brt = on ? LED_FULL : LED_OFF;
> +
> +       led_trigger_event(ledtrig_torch, brt);
> +}
> +EXPORT_SYMBOL_GPL(ledtrig_torch_ctrl);
> +
> +static int __init ledtrig_camera_init(void)
> +{
> +       led_trigger_register_simple("flash", &ledtrig_flash);
> +       led_trigger_register_simple("torch", &ledtrig_torch);
> +       return 0;
> +}
> +module_init(ledtrig_camera_init);
> +
> +static void __exit ledtrig_camera_exit(void)
> +{
> +       led_trigger_unregister_simple(ledtrig_torch);
> +       led_trigger_unregister_simple(ledtrig_flash);
> +}
> +module_exit(ledtrig_camera_exit);
> +
> +MODULE_DESCRIPTION("LED Trigger for Camera Flash/Torch Control");
> +MODULE_AUTHOR("Milo Kim");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 0d9b5ee..197ca9e 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -215,6 +215,14 @@ extern void ledtrig_ide_activity(void);
>  #define ledtrig_ide_activity() do {} while(0)
>  #endif
>
> +#if defined(CONFIG_LEDS_TRIGGER_CAMERA) || defined(CONFIG_LEDS_TRIGGER_CAMERA_MODULE)
> +extern void ledtrig_flash_ctrl(bool on);
> +extern void ledtrig_torch_ctrl(bool on);
> +#else
> +#define ledtrig_flash_ctrl(x) do {} while(0)
> +#define ledtrig_torch_ctrl(x) do {} while(0)

It's better don't use #define macros but use real empty functions like this:
static inline void ledtrig_flash_ctrl(bool on)
{
        return;
}

> +#endif
> +
>  /*
>   * Generic LED platform data for describing LED names and default triggers.
>   */
> --
> 1.7.9.5
>
>
> Best Regards,
> Milo
>
>
