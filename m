Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaLAVCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:02:11 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:57837 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaLAVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:02:09 -0500
Date: Mon, 1 Dec 2014 22:01:12 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: linux@arm.linux.org.uk, robh+dt@kernel.org,
        Jianqun Xu <jay.xu@rock-chips.com>, heiko@sntech.de,
        grant.likely@linaro.org
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Message-ID: <1479569208.4563.1417467672633.JavaMail.open-xchange@oxbaltgw06.schlund.de>
In-Reply-To: <1417419281-9243-3-git-send-email-jay.xu@rock-chips.com>
References: <1417419281-9243-1-git-send-email-jay.xu@rock-chips.com> <1417419281-9243-3-git-send-email-jay.xu@rock-chips.com>
Subject: Re: [PATCH 2/2] rockchip: efuse: add efuse driver for rk3288 efuse
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev32
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V02:K0:QOlZOUWKIQf0HRLV3964WafYv+uLfA/7IDbRZ7lmIU8
 HnOu3M1csMN5yGdhGDy9kqcXP2FP+05lV53E0f5DGyLG7sHr49
 jTA7DnHau3iLAhiQKxFqNuAX0naKssfq0qXGR1prj3/cMKjqzw
 3o7JzetvF4KoE9owQHfL+Hz+gYmh2Z01fm90DnL9/JrObuT0L/
 Mo0GUIVvD871SKyzJGv5TyIUcoExgYHWEPB0Ou5gSGutbZHvPj
 N8nfWbBHlRjaSFjj2JZkRdYse9Ny8HwL1ayOqonxNs4gY0ZPKW
 LZUPd92QjbkvcmuQQTKI/tCr8kCXBDGMm0riHeBRdsp5u+cG2D
 gXsuf9xe+L6g1ps4e7wgFvpoaKYXEQ6/Hx4Hvn0IbYS6sR7tOq
 a6EGofks0RfftfAFmbJY8+PissL1sQvMMVo2TtAEhhQfI+z7oV
 HbUUs
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianqun,

> Jianqun Xu <jay.xu@rock-chips.com> hat am 1. Dezember 2014 um 08:34
> geschrieben:
>
>
> Add driver for efuse found on rk3288 board based on rk3288 SoC.
> Driver will read fuse information of chip at the boot stage of
> kernel, this information new is for further usage.
>
> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
> ---
> arch/arm/mach-rockchip/efuse.c | 165 +++++++++++++++++++++++++++++++++++++++++
> arch/arm/mach-rockchip/efuse.h | 15 ++++
> 2 files changed, 180 insertions(+)
> create mode 100644 arch/arm/mach-rockchip/efuse.c
> create mode 100644 arch/arm/mach-rockchip/efuse.h
>
> diff --git a/arch/arm/mach-rockchip/efuse.c b/arch/arm/mach-rockchip/efuse.c
> new file mode 100644
> index 0000000..326d81e
> --- /dev/null
> +++ b/arch/arm/mach-rockchip/efuse.c
> @@ -0,0 +1,165 @@
> +/* mach-rockchip/efuse.c
> + *
> + * Copyright (c) 2014 Rockchip Electronics Co. Ltd.
> + * Author: Jianqun Xu <jay.xu@rock-chips.com>
> + *
> + * Tmis program is free software; you can redistribute it and/or modify it
> + * under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * Tmis program is distributed in the hope that it will be useful, but
> WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> with
> + * tmis program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA

as far as i know this address is outdated and should be removed.

> + *
> + * Tme full GNU General Public License is included in this distribution in
> the
> + * file called LICENSE.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/of_address.h>
> +#include <linux/io.h>

Please order the includes alphabetical.

> +
> +#include "efuse.h"
> +
> +#define EFUSE_BUF_SIZE (32)
> +#define EFUSE_BUF_LKG_CPU (23)
> +#define EFUSE_BUF_LKG_GPU (24)
> +#define EFUSE_BUF_LKG_LOG (25)
> +
> +struct rk_efuse_info {
> + /* Platform device */
> + struct device *dev;

I think it's not really necessary to store this in the driver data. Better call
the relevant functions with struct platform_device as parameter and get your
driver data from their.

> +
> + /* Hardware resources */
> + void __iomem *regs;
> +
> + /* buffer to store registers' values */
> + unsigned int buf[EFUSE_BUF_SIZE];

The variable name buf isn't very helpful.

> +};
> +
> +static void efuse_writel(struct rk_efuse_info *efuse,
> + unsigned int value,
> + unsigned int offset)
> +{
> + writel_relaxed(value, efuse->regs + offset);
> +}
> +
> +static unsigned int efuse_readl(struct rk_efuse_info *efuse,
> + unsigned int offset)
> +{
> + return readl_relaxed(efuse->regs + offset);
> +}
> +
> +static unsigned int rockchip_efuse_leakage(struct rk_efuse_info *efuse,
> + int channel)
> +{
> + switch (channel) {
> + case EFUSE_BUF_LKG_CPU:
> + case EFUSE_BUF_LKG_GPU:
> + case EFUSE_BUF_LKG_LOG:
> + return efuse->buf[channel];
> + default:
> + dev_err(efuse->dev, "unknown channel\n");
> + return -EINVAL;

Returning a negative value in a function with unsigned return type isn't good.

Printing only "unknown channel" isn't optimal, it would be more helpful to print
also the invalid value.

> + }
> +
> + return 0;

Looks like unreachable code, maybe you could move the default case above down.

Thanks

Stefan
