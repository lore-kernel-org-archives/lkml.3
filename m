Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbaIKUdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:33:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaIKUdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:33:45 -0400
Date: Thu, 11 Sep 2014 13:33:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: mathieu.poirier@linaro.org
Cc: will.deacon@arm.com, linux@arm.linux.org.uk, pratikp@codeaurora.org,
        varshney@ti.com, Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, panchaxari.prasannamurthy@linaro.org,
        kaixu.xia@linaro.org, marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dsaxena@linaro.org
Subject: Re: [PATCH 01/11 v6] coresight: add CoreSight core layer framework
Message-ID: <20140911203344.GA7593@kroah.com>
References: <1410450558-12358-1-git-send-email-mathieu.poirier@linaro.org>
 <1410450558-12358-2-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410450558-12358-2-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some first impressions in glancing at the code, not a complete review at
all:

On Thu, Sep 11, 2014 at 09:49:08AM -0600, mathieu.poirier@linaro.org wrote:
> --- /dev/null
> +++ b/drivers/coresight/coresight.c
> @@ -0,0 +1,663 @@
> +/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
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
> +#define pr_fmt(fmt) "coresight: " fmt

MODULE_NAME ?

> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/io.h>
> +#include <linux/err.h>
> +#include <linux/export.h>
> +#include <linux/slab.h>
> +#include <linux/semaphore.h>
> +#include <linux/clk.h>
> +#include <linux/coresight.h>
> +#include <linux/of_platform.h>
> +#include <linux/debugfs.h>
> +#include <linux/delay.h>
> +
> +#include "coresight-priv.h"
> +
> +struct dentry *cs_debugfs_parent = NULL;
> +
> +static LIST_HEAD(coresight_orph_conns);
> +static LIST_HEAD(coresight_devs);

You are a struct device, you don't need a separate list, why not just
iterate over your bus list of devices?

> +/**
> + * @id:		unique ID of the component.
> + * @conns:	list of connections associated to this component.
> + * @type:	as defined by @coresight_dev_type.
> + * @subtype:	as defined by @coresight_dev_subtype.
> + * @ops:	generic operations for this component, as defined
> +		by @coresight_ops.
> + * @de:		handle on a component's debugfs entry.
> + * @dev:	The device entity associated to this component.
> + * @kref:	keeping count on component references.
> + * @dev_link:	link of current component into list of all components
> +		discovered in the system.
> + * @path_link:	link of current component into the path being enabled.
> + * @owner:	typically "THIS_MODULE".
> + * @enable:	'true' if component is currently part of an active path.
> + * @activated:	'true' only if a _sink_ has been activated.  A sink can be
> +		activated but not yet enabled.  Enabling for a _sink_
> +		happens when a source has been selected for that it.
> + */
> +struct coresight_device {
> +	int id;

Why not use the device name instead?

> +	struct coresight_connection *conns;
> +	int nr_conns;
> +	enum coresight_dev_type type;
> +	struct coresight_dev_subtype subtype;
> +	const struct coresight_ops *ops;
> +	struct dentry *de;

All devices have a dentry?  in debugfs?  isn't that overkill?

> +	struct device dev;
> +	struct kref kref;

You CAN NOT have two reference counts in the same structure, that's a
huge design mistake.  Stick with one reference count, otherwise they are
guaranteed to get out of sync and bad things will happen.

> +	struct list_head dev_link;

As discussed above, I don't think you need this.

> +	struct list_head path_link;

Odds are, you don't need this either.

> +	struct module *owner;

devices aren't owned by modules, they are data, not code.


> +	bool enable;	/* true only if configured as part of a path */
> +	bool activated;	/* true only if a sink is part of a path */
> +};
> +
> +#define to_coresight_device(d) container_of(d, struct coresight_device, dev)
> +
> +#define source_ops(csdev)	csdev->ops->source_ops
> +#define sink_ops(csdev)		csdev->ops->sink_ops
> +#define link_ops(csdev)		csdev->ops->link_ops
> +
> +#define CORESIGHT_DEBUGFS_ENTRY(__name, __entry_name,			\
> +				 __mode, __get, __set, __fmt)		\
> +DEFINE_SIMPLE_ATTRIBUTE(__name ## _ops, __get, __set, __fmt)		\

Use the RW and RO only versions please.  No need to ever set your own
mode value.

thanks,

greg k-h
