Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3CGBb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:31:28 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:65298 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3CGBb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:31:26 -0500
Date: Thu, 7 Mar 2013 09:30:08 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Brown <davidb@codeaurora.org>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] platform-drivers: msm: add single-wire serial bus
 interface (SSBI) driver
Message-ID: <20130307013008.GA2910@kroah.com>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
 <1362616187-21089-2-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362616187-21089-2-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 04:29:42PM -0800, David Brown wrote:
> +menu "Qualcomm MSM SSBI bus support"
> +	depends on ARCH_MSM

Why?

> +config MSM_SSBI
> +	bool "Qualcomm Single-wire Serial Bus Interface (SSBI)"

Why can't this be a module?

The multi-platform (or whatever it's called), requires that things be
modules and not built in.

> +	help
> +	  If you say yes to this option, support will be included for the
> +	  built-in SSBI interface on Qualcomm MSM family processors.
> +
> +	  This is required for communicating with Qualcomm PMICs and
> +	  other devices that have the SSBI interface.
> +
> +endmenu
> diff --git a/drivers/ssbi/Makefile b/drivers/ssbi/Makefile
> new file mode 100644
> index 0000000..ea8c1e4
> --- /dev/null
> +++ b/drivers/ssbi/Makefile
> @@ -0,0 +1,4 @@
> +#
> +# Makefile for the MSM specific device drivers.

MSM?

No comment needed at all in this file :)

> --- /dev/null
> +++ b/drivers/ssbi/ssbi.c
> @@ -0,0 +1,397 @@
> +/* Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
> + * Copyright (c) 2010, Google Inc.
> + *
> + * Original authors: Code Aurora Forum
> + *
> + * Author: Dima Zavin <dima@android.com>
> + *  - Largely rewritten from original to not be an i2c driver.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#define pr_fmt(fmt) "%s: " fmt, __func__
> +
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/msm_ssbi.h>
> +#include <linux/module.h>
> +
> +/* SSBI 2.0 controller registers */
> +#define SSBI2_CMD			0x0008
> +#define SSBI2_RD			0x0010
> +#define SSBI2_STATUS			0x0014
> +#define SSBI2_MODE2			0x001C
> +
> +/* SSBI_CMD fields */
> +#define SSBI_CMD_RDWRN			(1 << 24)
> +
> +/* SSBI_STATUS fields */
> +#define SSBI_STATUS_RD_READY		(1 << 2)
> +#define SSBI_STATUS_READY		(1 << 1)
> +#define SSBI_STATUS_MCHN_BUSY		(1 << 0)
> +
> +/* SSBI_MODE2 fields */
> +#define SSBI_MODE2_REG_ADDR_15_8_SHFT	0x04
> +#define SSBI_MODE2_REG_ADDR_15_8_MASK	(0x7f << SSBI_MODE2_REG_ADDR_15_8_SHFT)
> +
> +#define SET_SSBI_MODE2_REG_ADDR_15_8(MD, AD) \
> +	(((MD) & 0x0F) | ((((AD) >> 8) << SSBI_MODE2_REG_ADDR_15_8_SHFT) & \
> +	SSBI_MODE2_REG_ADDR_15_8_MASK))
> +
> +/* SSBI PMIC Arbiter command registers */
> +#define SSBI_PA_CMD			0x0000
> +#define SSBI_PA_RD_STATUS		0x0004
> +
> +/* SSBI_PA_CMD fields */
> +#define SSBI_PA_CMD_RDWRN		(1 << 24)
> +#define SSBI_PA_CMD_ADDR_MASK		0x7fff /* REG_ADDR_7_0, REG_ADDR_8_14*/
> +
> +/* SSBI_PA_RD_STATUS fields */
> +#define SSBI_PA_RD_STATUS_TRANS_DONE	(1 << 27)
> +#define SSBI_PA_RD_STATUS_TRANS_DENIED	(1 << 26)
> +
> +#define SSBI_TIMEOUT_US			100
> +
> +struct msm_ssbi {
> +	struct device		*dev;
> +	struct device		*slave;

Really?  Two pointers to devices?  Why?  Shouldn't this have a struct
device embedded in it instead of the dev member being a pointer?

> +	void __iomem		*base;
> +	spinlock_t		lock;
> +	enum msm_ssbi_controller_type controller_type;
> +	int (*read)(struct msm_ssbi *, u16 addr, u8 *buf, int len);
> +	int (*write)(struct msm_ssbi *, u16 addr, u8 *buf, int len);
> +};
> +
> +#define to_msm_ssbi(dev)	platform_get_drvdata(to_platform_device(dev))

That doesn't work for the above structure, right?

> +static inline u32 ssbi_readl(struct msm_ssbi *ssbi, u32 reg)
> +{
> +	return readl(ssbi->base + reg);
> +}
> +
> +static inline void ssbi_writel(struct msm_ssbi *ssbi, u32 val, u32 reg)
> +{
> +	writel(val, ssbi->base + reg);
> +}

Did you run sparse on this file?

> +static int ssbi_wait_mask(struct msm_ssbi *ssbi, u32 set_mask, u32 clr_mask)
> +{
> +	u32 timeout = SSBI_TIMEOUT_US;
> +	u32 val;
> +
> +	while (timeout--) {
> +		val = ssbi_readl(ssbi, SSBI2_STATUS);
> +		if (((val & set_mask) == set_mask) && ((val & clr_mask) == 0))
> +			return 0;
> +		udelay(1);

Busy loop?  Really?

> +	}
> +
> +	dev_err(ssbi->dev, "%s: timeout (status %x set_mask %x clr_mask %x)\n",
> +		__func__, ssbi_readl(ssbi, SSBI2_STATUS), set_mask, clr_mask);

Why polute the log with this?  What can a user do with it?


> +	return -ETIMEDOUT;
> +}
> +
> +static int
> +msm_ssbi_read_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
> +{
> +	u32 cmd = SSBI_CMD_RDWRN | ((addr & 0xff) << 16);
> +	int ret = 0;
> +
> +	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
> +		u32 mode2 = ssbi_readl(ssbi, SSBI2_MODE2);
> +		mode2 = SET_SSBI_MODE2_REG_ADDR_15_8(mode2, addr);
> +		ssbi_writel(ssbi, mode2, SSBI2_MODE2);
> +	}
> +
> +	while (len) {
> +		ret = ssbi_wait_mask(ssbi, SSBI_STATUS_READY, 0);
> +		if (ret)
> +			goto err;
> +
> +		ssbi_writel(ssbi, cmd, SSBI2_CMD);
> +		ret = ssbi_wait_mask(ssbi, SSBI_STATUS_RD_READY, 0);
> +		if (ret)
> +			goto err;
> +		*buf++ = ssbi_readl(ssbi, SSBI2_RD) & 0xff;
> +		len--;
> +	}
> +
> +err:
> +	return ret;
> +}
> +
> +static int
> +msm_ssbi_write_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
> +{
> +	int ret = 0;
> +
> +	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
> +		u32 mode2 = ssbi_readl(ssbi, SSBI2_MODE2);
> +		mode2 = SET_SSBI_MODE2_REG_ADDR_15_8(mode2, addr);
> +		ssbi_writel(ssbi, mode2, SSBI2_MODE2);
> +	}

Perhaps have a controller type write function that can handle this type
of stuff instead of putting it in the "generic" write path?

> +	while (len) {
> +		ret = ssbi_wait_mask(ssbi, SSBI_STATUS_READY, 0);
> +		if (ret)
> +			goto err;
> +
> +		ssbi_writel(ssbi, ((addr & 0xff) << 16) | *buf, SSBI2_CMD);
> +		ret = ssbi_wait_mask(ssbi, 0, SSBI_STATUS_MCHN_BUSY);
> +		if (ret)
> +			goto err;
> +		buf++;
> +		len--;
> +	}
> +
> +err:
> +	return ret;
> +}
> +
> +static inline int
> +msm_ssbi_pa_transfer(struct msm_ssbi *ssbi, u32 cmd, u8 *data)
> +{
> +	u32 timeout = SSBI_TIMEOUT_US;
> +	u32 rd_status = 0;
> +
> +	ssbi_writel(ssbi, cmd, SSBI_PA_CMD);
> +
> +	while (timeout--) {
> +		rd_status = ssbi_readl(ssbi, SSBI_PA_RD_STATUS);
> +
> +		if (rd_status & SSBI_PA_RD_STATUS_TRANS_DENIED) {
> +			dev_err(ssbi->dev, "%s: transaction denied (0x%x)\n",
> +					__func__, rd_status);
> +			return -EPERM;
> +		}
> +
> +		if (rd_status & SSBI_PA_RD_STATUS_TRANS_DONE) {
> +			if (data)
> +				*data = rd_status & 0xff;
> +			return 0;
> +		}
> +		udelay(1);

Busy loop again?

> +	}
> +
> +	dev_err(ssbi->dev, "%s: timeout, status 0x%x\n", __func__, rd_status);

Don't polute the logs unless you want the user to do something with the
information.


> +	return -ETIMEDOUT;
> +}
> +
> +static int
> +msm_ssbi_pa_read_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
> +{
> +	u32 cmd;
> +	int ret = 0;
> +
> +	cmd = SSBI_PA_CMD_RDWRN | (addr & SSBI_PA_CMD_ADDR_MASK) << 8;
> +
> +	while (len) {
> +		ret = msm_ssbi_pa_transfer(ssbi, cmd, buf);
> +		if (ret)
> +			goto err;
> +		buf++;
> +		len--;
> +	}
> +
> +err:
> +	return ret;
> +}
> +
> +static int
> +msm_ssbi_pa_write_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
> +{
> +	u32 cmd;
> +	int ret = 0;
> +
> +	while (len) {
> +		cmd = (addr & SSBI_PA_CMD_ADDR_MASK) << 8 | *buf;
> +		ret = msm_ssbi_pa_transfer(ssbi, cmd, NULL);
> +		if (ret)
> +			goto err;
> +		buf++;
> +		len--;
> +	}
> +
> +err:
> +	return ret;
> +}
> +
> +int msm_ssbi_read(struct device *dev, u16 addr, u8 *buf, int len)
> +{
> +	struct msm_ssbi *ssbi = to_msm_ssbi(dev);
> +	unsigned long flags;
> +	int ret;
> +
> +	if (ssbi->dev != dev)
> +		return -ENXIO;
> +
> +	spin_lock_irqsave(&ssbi->lock, flags);
> +	ret = ssbi->read(ssbi, addr, buf, len);
> +	spin_unlock_irqrestore(&ssbi->lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(msm_ssbi_read);

msm_*?  Why not just ssbi_*?

EXPORT_SYMBOL_GPL()?

> +static struct platform_driver msm_ssbi_driver = {
> +	.probe		= msm_ssbi_probe,
> +	.remove		= __exit_p(msm_ssbi_remove),

You just oopsed if someone unbound your device from the driver from
userspace.  Not good.

thanks,

greg k-h
