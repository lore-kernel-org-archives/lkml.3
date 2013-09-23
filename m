Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3IWDWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 23:22:12 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53744 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3IWDWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 23:22:10 -0400
MIME-Version: 1.0
In-Reply-To: <1378196941-23390-3-git-send-email-sonic.adi@gmail.com>
References: <1378196941-23390-1-git-send-email-sonic.adi@gmail.com>
	<1378196941-23390-3-git-send-email-sonic.adi@gmail.com>
Date: Mon, 23 Sep 2013 11:22:10 +0800
Message-ID: <CAMk6uB=D0ChRi6-J+wBSKFEMrzko1RHMeSSxaFn+gzmEGE3uYw@mail.gmail.com>
Subject: Re: [PATCH 3/3 v4] blackfin: pinctrl-adi2: Enable PINCTRL framework
 for BF54x and BF60x.
From: Steven Miao <realmz6@gmail.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Steven Miao <realmz6@gmail.com>

On Tue, Sep 3, 2013 at 4:29 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> - Remove unused macro MAX_RESOURCES
> - Override blackfin legacy peripheral pinmux request and free APIs by
> devm_pinctrl_get_select_default() to init the peripheral portmux setting.
>
> v3-chagnes:
> - Move pinctrl soc data out of blackfin arch folder.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  arch/blackfin/Kconfig                           |  4 ++++
>  arch/blackfin/include/asm/portmux.h             | 19 +++++++++++++++++--
>  arch/blackfin/mach-bf548/include/mach/portmux.h |  2 --
>  arch/blackfin/mach-bf609/include/mach/portmux.h |  2 --
>  4 files changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index 9eff25b..ed7157f 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -324,6 +324,10 @@ config GPIO_ADI
>         def_bool y
>         depends on (BF51x || BF52x || BF53x || BF538 || BF539 || BF561)
>
> +config PINCTRL
> +       def_bool y
> +       depends on BF54x || BF60x
> +
>  config MEM_MT48LC64M4A2FB_7E
>         bool
>         depends on (BFIN533_STAMP)
> diff --git a/arch/blackfin/include/asm/portmux.h b/arch/blackfin/include/asm/portmux.h
> index 9b1e2c3..7aa2043 100644
> --- a/arch/blackfin/include/asm/portmux.h
> +++ b/arch/blackfin/include/asm/portmux.h
> @@ -17,14 +17,29 @@
>  #define P_MAYSHARE     0x2000
>  #define P_DONTCARE     0x1000
>
> -
> +#ifdef CONFIG_PINCTRL
> +#include <asm/irq_handler.h>
> +
> +#define gpio_pint_regs bfin_pint_regs
> +#define adi_internal_set_wake bfin_internal_set_wake
> +
> +#define peripheral_request(per, label) 0
> +#define peripheral_free(per)
> +#define peripheral_request_list(per, label) \
> +       (pdev ? (IS_ERR(devm_pinctrl_get_select_default(&pdev->dev)) \
> +       ? -EINVAL : 0) : 0)
> +#define peripheral_free_list(per)
> +#else
>  int peripheral_request(unsigned short per, const char *label);
>  void peripheral_free(unsigned short per);
>  int peripheral_request_list(const unsigned short per[], const char *label);
>  void peripheral_free_list(const unsigned short per[]);
> +#endif
>
> -#include <asm/gpio.h>
> +#include <linux/err.h>
> +#include <linux/pinctrl/pinctrl.h>
>  #include <mach/portmux.h>
> +#include <linux/gpio.h>
>
>  #ifndef P_SPORT2_TFS
>  #define P_SPORT2_TFS P_UNDEF
> diff --git a/arch/blackfin/mach-bf548/include/mach/portmux.h b/arch/blackfin/mach-bf548/include/mach/portmux.h
> index e222462..d9f8632 100644
> --- a/arch/blackfin/mach-bf548/include/mach/portmux.h
> +++ b/arch/blackfin/mach-bf548/include/mach/portmux.h
> @@ -7,8 +7,6 @@
>  #ifndef _MACH_PORTMUX_H_
>  #define _MACH_PORTMUX_H_
>
> -#define MAX_RESOURCES  MAX_BLACKFIN_GPIOS
> -
>  #define P_SPORT2_TFS   (P_DEFINED | P_IDENT(GPIO_PA0) | P_FUNCT(0))
>  #define P_SPORT2_DTSEC (P_DEFINED | P_IDENT(GPIO_PA1) | P_FUNCT(0))
>  #define P_SPORT2_DTPRI (P_DEFINED | P_IDENT(GPIO_PA2) | P_FUNCT(0))
> diff --git a/arch/blackfin/mach-bf609/include/mach/portmux.h b/arch/blackfin/mach-bf609/include/mach/portmux.h
> index 2e1a51c..fe34191 100644
> --- a/arch/blackfin/mach-bf609/include/mach/portmux.h
> +++ b/arch/blackfin/mach-bf609/include/mach/portmux.h
> @@ -7,8 +7,6 @@
>  #ifndef _MACH_PORTMUX_H_
>  #define _MACH_PORTMUX_H_
>
> -#define MAX_RESOURCES  MAX_BLACKFIN_GPIOS
> -
>  /* EMAC RMII Port Mux */
>  #define P_MII0_MDC     (P_DEFINED | P_IDENT(GPIO_PC6) | P_FUNCT(0))
>  #define P_MII0_MDIO    (P_DEFINED | P_IDENT(GPIO_PC7) | P_FUNCT(0))
> --
> 1.8.2.3
>
>
