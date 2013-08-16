Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3HPSt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:49:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3HPStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:49:22 -0400
Date: Fri, 16 Aug 2013 11:49:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH RFC 1/3] spmi: Linux driver framework for SPMI
Message-ID: <20130816184921.GB31510@kroah.com>
References: <cover.1376596224.git.joshc@codeaurora.org>
 <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 01:37:09PM -0700, Josh Cartwright wrote:
> +++ b/drivers/spmi/spmi.c
> @@ -0,0 +1,449 @@
> +/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
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
> +#define pr_fmt(fmt) "%s: " fmt, __func__
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/idr.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/spmi.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +
> +#include "spmi-dbgfs.h"
> +
> +static DEFINE_MUTEX(board_lock);
> +static DEFINE_IDR(ctrl_idr);
> +
> +static void spmi_dev_release(struct device *dev)
> +{
> +	struct spmi_device *spmidev = to_spmi_device(dev);
> +	kfree(spmidev);
> +}
> +
> +static struct device_type spmi_dev_type = {
> +	.release	= spmi_dev_release,
> +};

I give a lot of people crap when they get things wrong with the driver
model, so it's only fair to call out when it's done correctly.

Nice job here, thanks for getting this right.

> +static void spmi_ctrl_release(struct device *dev)
> +{
> +	struct spmi_controller *ctrl = to_spmi_controller(dev);
> +	complete(&ctrl->dev_released);

When is this memory going to be freed?

Ah, you think it will be when you remove the device later on:

> +int spmi_del_controller(struct spmi_controller *ctrl)
> +{
> +	struct spmi_controller *found;
> +
> +	if (!ctrl)
> +		return -EINVAL;
> +
> +	/* Check that the ctrl has been added */
> +	mutex_lock(&board_lock);
> +	found = idr_find(&ctrl_idr, ctrl->nr);
> +	mutex_unlock(&board_lock);
> +
> +	if (found != ctrl)
> +		return -EINVAL;
> +
> +	spmi_dfs_del_controller(ctrl);
> +
> +	/* Remove all the clients associated with this controller */
> +	mutex_lock(&board_lock);
> +	bus_for_each_dev(&spmi_bus_type, NULL, ctrl, spmi_ctrl_remove_device);
> +	idr_remove(&ctrl_idr, ctrl->nr);
> +	mutex_unlock(&board_lock);
> +
> +	init_completion(&ctrl->dev_released);
> +	device_unregister(&ctrl->dev);
> +	wait_for_completion(&ctrl->dev_released);

But you just leaked memory, right?

You should never have to wait for this to happen, why did you need to
add this?  Why not just a simple call to kfree() in the release
function?

thanks,

greg k-h
