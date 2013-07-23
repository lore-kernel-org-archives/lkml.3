Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3GWHdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:33:08 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:54046 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab3GWHdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <1373972146-12133-2-git-send-email-sonic.adi@gmail.com>
References: <1373972146-12133-1-git-send-email-sonic.adi@gmail.com>
	<1373972146-12133-2-git-send-email-sonic.adi@gmail.com>
Date: Tue, 23 Jul 2013 15:33:04 +0800
Message-ID: <CAJxxZ0No3myDiUi8+Gdw_aEyeFA9zd2RS_0SoUFxZxCQfKk2zA@mail.gmail.com>
Subject: Re: [PATCH 2/3] blackfin: gpio: Remove none gpio lib code.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "buildroot-devel@blackfin.uclinux.org" 
	<buildroot-devel@blackfin.uclinux.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping

On Tue, Jul 16, 2013 at 6:55 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> - Remove non gpio lib code from blackfin architecture.
> - Limit the lagecy blackfin gpio driver to bf5xx processors only.
> - Remove unused definition of the pint power functions.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  arch/blackfin/Kconfig            |   7 ++
>  arch/blackfin/include/asm/gpio.h | 157 +++++----------------------------------
>  2 files changed, 27 insertions(+), 137 deletions(-)
>
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index 3b6abc5..9307e7a 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -53,6 +53,9 @@ config GENERIC_BUG
>  config ZONE_DMA
>         def_bool y
>
> +config GENERIC_GPIO
> +       def_bool y
> +
>  config FORCE_MAX_ZONEORDER
>         int
>         default "14"
> @@ -318,6 +321,10 @@ config BF53x
>         depends on (BF531 || BF532 || BF533 || BF534 || BF536 || BF537)
>         default y
>
> +config GPIO_ADI
> +       def_bool y
> +       depends on (BF51x || BF52x || BF53x || BF538 || BF539 || BF561)
> +
>  config MEM_MT48LC64M4A2FB_7E
>         bool
>         depends on (BFIN533_STAMP)
> diff --git a/arch/blackfin/include/asm/gpio.h b/arch/blackfin/include/asm/gpio.h
> index 98d0133..99d338c 100644
> --- a/arch/blackfin/include/asm/gpio.h
> +++ b/arch/blackfin/include/asm/gpio.h
> @@ -25,8 +25,12 @@
>
>  #ifndef __ASSEMBLY__
>
> +#ifndef CONFIG_PINCTRL
> +
>  #include <linux/compiler.h>
> -#include <linux/gpio.h>
> +#include <asm/blackfin.h>
> +#include <asm/portmux.h>
> +#include <asm/irq_handler.h>
>
>  /***********************************************************
>  *
> @@ -45,7 +49,6 @@
>  * MODIFICATION HISTORY :
>  **************************************************************/
>
> -#if !BFIN_GPIO_PINT
>  void set_gpio_dir(unsigned, unsigned short);
>  void set_gpio_inen(unsigned, unsigned short);
>  void set_gpio_polar(unsigned, unsigned short);
> @@ -115,7 +118,6 @@ struct gpio_port_t {
>         unsigned short dummy16;
>         unsigned short inen;
>  };
> -#endif
>
>  #ifdef BFIN_SPECIAL_GPIO_BANKS
>  void bfin_special_gpio_free(unsigned gpio);
> @@ -127,25 +129,21 @@ void bfin_special_gpio_pm_hibernate_suspend(void);
>  #endif
>
>  #ifdef CONFIG_PM
> -int bfin_pm_standby_ctrl(unsigned ctrl);
> +void bfin_gpio_pm_hibernate_restore(void);
> +void bfin_gpio_pm_hibernate_suspend(void);
> +int bfin_gpio_pm_wakeup_ctrl(unsigned gpio, unsigned ctrl);
> +int bfin_gpio_pm_standby_ctrl(unsigned ctrl);
>
>  static inline int bfin_pm_standby_setup(void)
>  {
> -       return bfin_pm_standby_ctrl(1);
> +       return bfin_gpio_pm_standby_ctrl(1);
>  }
>
>  static inline void bfin_pm_standby_restore(void)
>  {
> -       bfin_pm_standby_ctrl(0);
> +       bfin_gpio_pm_standby_ctrl(0);
>  }
>
> -void bfin_gpio_pm_hibernate_restore(void);
> -void bfin_gpio_pm_hibernate_suspend(void);
> -void bfin_pint_suspend(void);
> -void bfin_pint_resume(void);
> -
> -# if !BFIN_GPIO_PINT
> -int gpio_pm_wakeup_ctrl(unsigned gpio, unsigned ctrl);
>
>  struct gpio_port_s {
>         unsigned short data;
> @@ -161,7 +159,6 @@ struct gpio_port_s {
>         unsigned short reserved;
>         unsigned short mux;
>  };
> -# endif
>  #endif /*CONFIG_PM*/
>
>  /***********************************************************
> @@ -178,36 +175,29 @@ struct gpio_port_s {
>  *************************************************************
>  * MODIFICATION HISTORY :
>  **************************************************************/
> -
> -int bfin_gpio_request(unsigned gpio, const char *label);
> -void bfin_gpio_free(unsigned gpio);
>  int bfin_gpio_irq_request(unsigned gpio, const char *label);
>  void bfin_gpio_irq_free(unsigned gpio);
> -int bfin_gpio_direction_input(unsigned gpio);
> -int bfin_gpio_direction_output(unsigned gpio, int value);
> -int bfin_gpio_get_value(unsigned gpio);
> -void bfin_gpio_set_value(unsigned gpio, int value);
> +void bfin_gpio_irq_prepare(unsigned gpio);
> +
> +static inline int irq_to_gpio(unsigned irq)
> +{
> +       return irq - GPIO_IRQ_BASE;
> +}
> +#endif /* CONFIG_PINCTRL */
>
>  #include <asm/irq.h>
>  #include <asm/errno.h>
>
> -#ifdef CONFIG_GPIOLIB
>  #include <asm-generic/gpio.h>          /* cansleep wrappers */
>
>  static inline int gpio_get_value(unsigned int gpio)
>  {
> -       if (gpio < MAX_BLACKFIN_GPIOS)
> -               return bfin_gpio_get_value(gpio);
> -       else
> -               return __gpio_get_value(gpio);
> +       return __gpio_get_value(gpio);
>  }
>
>  static inline void gpio_set_value(unsigned int gpio, int value)
>  {
> -       if (gpio < MAX_BLACKFIN_GPIOS)
> -               bfin_gpio_set_value(gpio, value);
> -       else
> -               __gpio_set_value(gpio, value);
> +       __gpio_set_value(gpio, value);
>  }
>
>  static inline int gpio_cansleep(unsigned int gpio)
> @@ -219,113 +209,6 @@ static inline int gpio_to_irq(unsigned gpio)
>  {
>         return __gpio_to_irq(gpio);
>  }
> -
> -#else /* !CONFIG_GPIOLIB */
> -
> -static inline int gpio_request(unsigned gpio, const char *label)
> -{
> -       return bfin_gpio_request(gpio, label);
> -}
> -
> -static inline void gpio_free(unsigned gpio)
> -{
> -       return bfin_gpio_free(gpio);
> -}
> -
> -static inline int gpio_direction_input(unsigned gpio)
> -{
> -       return bfin_gpio_direction_input(gpio);
> -}
> -
> -static inline int gpio_direction_output(unsigned gpio, int value)
> -{
> -       return bfin_gpio_direction_output(gpio, value);
> -}
> -
> -static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
> -{
> -       return -EINVAL;
> -}
> -
> -static inline int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
> -{
> -       int err;
> -
> -       err = bfin_gpio_request(gpio, label);
> -       if (err)
> -               return err;
> -
> -       if (flags & GPIOF_DIR_IN)
> -               err = bfin_gpio_direction_input(gpio);
> -       else
> -               err = bfin_gpio_direction_output(gpio,
> -                       (flags & GPIOF_INIT_HIGH) ? 1 : 0);
> -
> -       if (err)
> -               bfin_gpio_free(gpio);
> -
> -       return err;
> -}
> -
> -static inline int gpio_request_array(const struct gpio *array, size_t num)
> -{
> -       int i, err;
> -
> -       for (i = 0; i < num; i++, array++) {
> -               err = gpio_request_one(array->gpio, array->flags, array->label);
> -               if (err)
> -                       goto err_free;
> -       }
> -       return 0;
> -
> -err_free:
> -       while (i--)
> -               bfin_gpio_free((--array)->gpio);
> -       return err;
> -}
> -
> -static inline void gpio_free_array(const struct gpio *array, size_t num)
> -{
> -       while (num--)
> -               bfin_gpio_free((array++)->gpio);
> -}
> -
> -static inline int __gpio_get_value(unsigned gpio)
> -{
> -       return bfin_gpio_get_value(gpio);
> -}
> -
> -static inline void __gpio_set_value(unsigned gpio, int value)
> -{
> -       return bfin_gpio_set_value(gpio, value);
> -}
> -
> -static inline int gpio_get_value(unsigned gpio)
> -{
> -       return __gpio_get_value(gpio);
> -}
> -
> -static inline void gpio_set_value(unsigned gpio, int value)
> -{
> -       return __gpio_set_value(gpio, value);
> -}
> -
> -static inline int gpio_to_irq(unsigned gpio)
> -{
> -       if (likely(gpio < MAX_BLACKFIN_GPIOS))
> -               return gpio + GPIO_IRQ_BASE;
> -
> -       return -EINVAL;
> -}
> -
> -#include <asm-generic/gpio.h>          /* cansleep wrappers */
> -#endif /* !CONFIG_GPIOLIB */
> -
> -static inline int irq_to_gpio(unsigned irq)
> -{
> -       return (irq - GPIO_IRQ_BASE);
> -}
> -
>  #endif /* __ASSEMBLY__ */
>
>  #endif /* __ARCH_BLACKFIN_GPIO_H__ */
> --
> 1.8.2.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
