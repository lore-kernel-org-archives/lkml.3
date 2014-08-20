Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaHTWB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:01:57 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:35094 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaHTWBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <1408506009-29923-1-git-send-email-zyw@rock-chips.com>
References: <1408506009-29923-1-git-send-email-zyw@rock-chips.com>
Date: Wed, 20 Aug 2014 15:01:54 -0700
X-Google-Sender-Auth: 31psOFtzRcsVXKBYSBVyi0FLFck
Message-ID: <CAD=FV=W1JNibtJMkyTW3ASo3MjWxS-Yjw7vNDVq-4pCL+a0_Og@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] Clk: RK808: Add clkout driver for RK808
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Aug 19, 2014 at 8:40 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v2: None
>
>  drivers/clk/Kconfig     |    9 +++
>  drivers/clk/Makefile    |    1 +
>  drivers/clk/clk-rk808.c |  146 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 156 insertions(+)
>  create mode 100644 drivers/clk/clk-rk808.c
>
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index cfd3af7..84e0590 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -38,6 +38,15 @@ config COMMON_CLK_MAX77686
>         ---help---
>           This driver supports Maxim 77686 crystal oscillator clock.
>
> +config COMMON_CLK_RK808
> +       tristate "Clock driver for RK808"
> +       depends on MFD_RK808
> +       ---help---
> +         This driver supports RK808 crystal oscillator clock. These
> +         multi-function devices have two fixed-rate oscillators,
> +         clocked at 32KHz each. Clkout1 is always on, Clkout2 can off
> +         by control register.
> +
>  config COMMON_CLK_SI5351
>         tristate "Clock driver for SiLabs 5351A/B/C"
>         depends on I2C
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index f537a0b..99f53d5 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -28,6 +28,7 @@ obj-$(CONFIG_ARCH_NOMADIK)            += clk-nomadik.o
>  obj-$(CONFIG_ARCH_NSPIRE)              += clk-nspire.o
>  obj-$(CONFIG_COMMON_CLK_PALMAS)                += clk-palmas.o
>  obj-$(CONFIG_CLK_PPC_CORENET)          += clk-ppc-corenet.o
> +obj-$(CONFIG_COMMON_CLK_RK808)         += clk-rk808.o
>  obj-$(CONFIG_COMMON_CLK_S2MPS11)       += clk-s2mps11.o
>  obj-$(CONFIG_COMMON_CLK_SI5351)                += clk-si5351.o
>  obj-$(CONFIG_COMMON_CLK_SI570)         += clk-si570.o
> diff --git a/drivers/clk/clk-rk808.c b/drivers/clk/clk-rk808.c
> new file mode 100644
> index 0000000..8d0467a
> --- /dev/null
> +++ b/drivers/clk/clk-rk808.c
> @@ -0,0 +1,146 @@
> +/*
> + * Clkout driver for Rockchip RK808
> + *
> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
> + *
> + * Author: Chris Zhong <zyw@rock-chips.com>
> + * Author: Zhang Qing <zhangqing@rock-chips.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/rk808>

This is the wrong name for the file, so this doesn't compile.

It makes me question how this was tested.

Once I fix this I get a slew of other compiler errors.  Perhaps you
managed to post an old version?
