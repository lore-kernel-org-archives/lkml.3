Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaGBJiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:38:24 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53551 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaGBJiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:38:22 -0400
Message-ID: <53B3D2F9.2030009@linaro.org>
Date: Wed, 02 Jul 2014 10:38:01 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: mathieu.poirier@linaro.org, linus.walleij@linaro.org, will.deacon@arm.com,
        linux@arm.linux.org.uk, robherring2@gmail.com
CC: arve@android.com, john.stultz@linaro.org, pratikp@codeaurora.org,
        varshney@ti.com, Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, panchaxari.prasannamurthy@linaro.org,
        arnd@linaro.org, marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, Tony.Armitstead@arm.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9 v2] coresight: add CoreSight core layer framework
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org> <1403892261-25026-2-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1403892261-25026-2-git-send-email-mathieu.poirier@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/14 19:04, mathieu.poirier@linaro.org wrote:
> diff --git a/drivers/coresight/Kconfig b/drivers/coresight/Kconfig
> new file mode 100644
> index 0000000..fdd4d08
> --- /dev/null
> +++ b/drivers/coresight/Kconfig
> @@ -0,0 +1,10 @@
> +menuconfig CORESIGHT
> +	bool "CoreSight Tracing Support"
> +	select ARM_AMBA
> +	help
> +	  This framework provides an interface for the CoreSight debug and
> +	  trace drivers to register themselves with. It's intended to build
> +	  up a topological view of the CoreSight components and configure
> +	  the right series of components on user input via sysfs. It also

I don't understand this sentence. It makes is sound like user input is
needed somehow.

> diff --git a/drivers/coresight/coresight-priv.h b/drivers/coresight/coresight-priv.h
> new file mode 100644
> index 0000000..da1ebbb
> --- /dev/null
> +++ b/drivers/coresight/coresight-priv.h
> @@ -0,0 +1,69 @@
> +/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
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
> +#ifndef _CORESIGHT_PRIV_H
> +#define _CORESIGHT_PRIV_H
> +
> +#include <linux/bitops.h>
> +#include <linux/io.h>
> +#include <linux/coresight.h>
> +
> +/*
> + * Coresight management registers (0xF00-0xFCC)
> + * 0xFA0 - 0xFA4: Management	registers in PFTv1.0
> + *		  Trace		registers in PFTv1.1
> + */
> +#define CORESIGHT_ITCTRL	(0xF00)
> +#define CORESIGHT_CLAIMSET	(0xFA0)
> +#define CORESIGHT_CLAIMCLR	(0xFA4)
> +#define CORESIGHT_LAR		(0xFB0)
> +#define CORESIGHT_LSR		(0xFB4)
> +#define CORESIGHT_AUTHSTATUS	(0xFB8)
> +#define CORESIGHT_DEVID		(0xFC8)
> +#define CORESIGHT_DEVTYPE	(0xFCC)
> +
> +#define TIMEOUT_US		(100)
> +
> +#define BM(lsb, msb)		((BIT(msb) - BIT(lsb)) + BIT(msb))

Isn't this what GENMASK() already does?

> +#define BMVAL(val, lsb, msb)	((val & BM(lsb, msb)) >> lsb)
> +#define BVAL(val, n)		((val & BIT(n)) >> n)

BVAL() is obfuscation and should be removed.

As an example (taken from one of the patches that consumes this macro):

+	for (i = TIMEOUT_US;
+	     BVAL(cs_readl(drvdata->base, ETB_FFCR), ETB_FFCR_BIT) != 0
+	     && i > 0; i--)
+		udelay(1);

Is not really as readable as:

+	for (i = TIMEOUT_US;
+	     cs_readl(drvdata->base, ETB_FFCR) & ETB_FFCR_BIT && i > 0;
+	     i--)
+		udelay(1);

Within the whole patchset it is only every usedIt is only ever used call
site looks more or less like this:


> +#define cs_writel(addr, val, off)	__raw_writel((val), addr + off)
> +#define cs_readl(addr, off)		__raw_readl(addr + off)

Out of interest, would readl/writel_relaxed() more appropriate?


> +
> +static inline void CS_LOCK(void __iomem *addr)
> +{
> +	do {
> +		/* wait for things to settle */
> +		mb();
> +		cs_writel(addr, 0x0, CORESIGHT_LAR);
> +	} while (0);
> +}
> +
> +static inline void CS_UNLOCK(void __iomem *addr)
> +{
> +	do {
> +		cs_writel(addr, CORESIGHT_UNLOCK, CORESIGHT_LAR);
> +		/* make sure eveyone has seen this */
> +		mb();
> +	} while (0);
> +}
> +
> +#ifdef CONFIG_CORESIGHT_SOURCE_ETM
> +extern unsigned int etm_readl_cp14(u32 off);
> +extern void etm_writel_cp14(u32 val, u32 off);
> +#else
> +static inline unsigned int etm_readl_cp14(u32 off) { return 0; }
> +static inline void etm_writel_cp14(u32 val, u32 off) {}
> +#endif
> +
> +#endif
> diff --git a/drivers/coresight/coresight.c b/drivers/coresight/coresight.c
> new file mode 100644
> index 0000000..6218d86
> --- /dev/null
> +++ b/drivers/coresight/coresight.c
> @@ -0,0 +1,680 @@
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
> +
> +#include "coresight-priv.h"
> +
> +#define NO_SINK		(-1)
> +
> +struct dentry *cs_debugfs_parent = NULL;
> +
> +static int curr_sink = NO_SINK;
> +static LIST_HEAD(coresight_orph_conns);
> +static LIST_HEAD(coresight_devs);
> +static DEFINE_SEMAPHORE(coresight_mutex);

Why is coresight_mutex a semaphore?


> +static int coresight_find_link_inport(struct coresight_device *csdev)
> +{
> +	int i;
> +	struct coresight_device *parent;
> +	struct coresight_connection *conn;
> +
> +	parent = container_of(csdev->path_link.next, struct coresight_device,
> +			     path_link);
> +	for (i = 0; i < parent->nr_conns; i++) {
> +		conn = &parent->conns[i];
> +		if (conn->child_dev == csdev)
> +			return conn->child_port;
> +	}
> +
> +	pr_err("coresight: couldn't find inport, parent: %d, child: %d\n",
> +	       parent->id, csdev->id);
> +	return 0;
> +}
> +
> +static int coresight_find_link_outport(struct coresight_device *csdev)
> +{
> +	int i;
> +	struct coresight_device *child;
> +	struct coresight_connection *conn;
> +
> +	child = container_of(csdev->path_link.prev, struct coresight_device,
> +			      path_link);
> +	for (i = 0; i < csdev->nr_conns; i++) {
> +		conn = &csdev->conns[i];
> +		if (conn->child_dev == child)
> +			return conn->outport;
> +	}
> +
> +	pr_err("coresight: couldn't find outport, parent: %d, child: %d\n",
> +	       csdev->id, child->id);
> +	return 0;
> +}
> +
> +static int coresight_enable_sink(struct coresight_device *csdev)
> +{
> +	int ret;
> +
> +	if (csdev->refcnt.sink_refcnt == 0) {
> +		if (csdev->ops->sink_ops->enable) {
> +			ret = csdev->ops->sink_ops->enable(csdev);
> +			if (ret)
> +				goto err;
> +			csdev->enable = true;
> +		}
> +	}
> +	csdev->refcnt.sink_refcnt++;
> +
> +	return 0;
> +err:
> +	return ret;
> +}
> +
> +static void coresight_disable_sink(struct coresight_device *csdev)
> +{
> +	if (csdev->refcnt.sink_refcnt == 1) {
> +		if (csdev->ops->sink_ops->disable) {
> +			csdev->ops->sink_ops->disable(csdev);
> +			csdev->enable = false;
> +		}
> +	}
> +	csdev->refcnt.sink_refcnt--;
> +}
> +
> +static int coresight_enable_link(struct coresight_device *csdev)
> +{
> +	int ret;
> +	int link_subtype;
> +	int refport, inport, outport;
> +
> +	inport = coresight_find_link_inport(csdev);
> +	outport = coresight_find_link_outport(csdev);
> +
> +	link_subtype = csdev->subtype.link_subtype;
> +	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
> +		refport = inport;
> +	else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
> +		refport = outport;
> +	else
> +		refport = 0;
> +
> +	if (csdev->refcnt.link_refcnts[refport] == 0) {
> +		if (csdev->ops->link_ops->enable) {
> +			ret = csdev->ops->link_ops->enable(csdev, inport,
> +							   outport);
> +			if (ret)
> +				goto err;
> +			csdev->enable = true;
> +		}
> +	}
> +	csdev->refcnt.link_refcnts[refport]++;
> +
> +	return 0;
> +err:
> +	return ret;
> +}
> +
> +static void coresight_disable_link(struct coresight_device *csdev)
> +{
> +	int link_subtype;
> +	int refport, inport, outport;
> +
> +	inport = coresight_find_link_inport(csdev);
> +	outport = coresight_find_link_outport(csdev);
> +
> +	link_subtype = csdev->subtype.link_subtype;
> +	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
> +		refport = inport;
> +	else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
> +		refport = outport;
> +	else
> +		refport = 0;

I already read these 7 lines once...

> +
> +	if (csdev->refcnt.link_refcnts[refport] == 1) {
> +		if (csdev->ops->link_ops->disable) {
> +			csdev->ops->link_ops->disable(csdev, inport, outport);
> +			csdev->enable = false;
> +		}
> +	}
> +	csdev->refcnt.link_refcnts[refport]--;
> +}
> +
> +static int coresight_enable_source(struct coresight_device *csdev)
> +{
> +	int ret;
> +
> +	if (csdev->refcnt.source_refcnt == 0) {
> +		if (csdev->ops->source_ops->enable) {
> +			ret = csdev->ops->source_ops->enable(csdev);
> +			if (ret)
> +				goto err;
> +			csdev->enable = true;
> +		}
> +	}
> +	csdev->refcnt.source_refcnt++;
> +
> +	return 0;
> +err:
> +	return ret;
> +}
> +
> +static void coresight_disable_source(struct coresight_device *csdev)
> +{
> +	if (csdev->refcnt.source_refcnt == 1) {
> +		if (csdev->ops->source_ops->disable) {
> +			csdev->ops->source_ops->disable(csdev);
> +			csdev->enable = false;
> +		}
> +	}
> +	csdev->refcnt.source_refcnt--;
> +}
> +
> +static struct list_head *coresight_build_path(struct coresight_device *csdev,
> +					      struct list_head *path)
> +{
> +	int i;
> +	struct list_head *p;
> +	struct coresight_connection *conn;
> +
> +	if (csdev->id == curr_sink) {
> +		list_add_tail(&csdev->path_link, path);
> +		return path;
> +	}
> +
> +	for (i = 0; i < csdev->nr_conns; i++) {
> +		conn = &csdev->conns[i];
> +		p = coresight_build_path(conn->child_dev, path);
> +		if (p) {
> +			list_add_tail(&csdev->path_link, p);
> +			return p;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +static void coresight_release_path(struct list_head *path)
> +{
> +	struct coresight_device *cd, *temp;
> +
> +	list_for_each_entry_safe(cd, temp, path, path_link)
> +		list_del(&cd->path_link);
> +}
> +
> +static int coresight_enable_path(struct list_head *path, bool incl_source)
> +{
> +	int ret = 0;
> +	struct coresight_device *cd;
> +
> +	list_for_each_entry(cd, path, path_link) {
> +		if (cd == list_first_entry(path, struct coresight_device,
> +					   path_link)) {
> +			ret = coresight_enable_sink(cd);
> +		} else if (list_is_last(&cd->path_link, path)) {
> +			if (incl_source)
> +				ret = coresight_enable_source(cd);
> +		} else {
> +			ret = coresight_enable_link(cd);
> +		}
> +		if (ret)
> +			goto err;
> +	}
> +	return 0;
> +err:
> +	list_for_each_entry_continue_reverse(cd, path, path_link) {
> +		if (cd == list_first_entry(path, struct coresight_device,
> +					   path_link)) {
> +			coresight_disable_sink(cd);
> +		} else if (list_is_last(&cd->path_link, path)) {
> +			if (incl_source)
> +				coresight_disable_source(cd);
> +		} else {
> +			coresight_disable_link(cd);
> +		}
> +	}
> +	return ret;
> +}
> +
> +static void coresight_disable_path(struct list_head *path, bool incl_source)
> +{
> +	struct coresight_device *cd;
> +
> +	list_for_each_entry(cd, path, path_link) {
> +		if (cd == list_first_entry(path, struct coresight_device,
> +					   path_link)) {
> +			coresight_disable_sink(cd);
> +		} else if (list_is_last(&cd->path_link, path)) {
> +			if (incl_source)
> +				coresight_disable_source(cd);
> +		} else {
> +			coresight_disable_link(cd);
> +		}
> +	}
> +}
> +
> +static int coresight_switch_sink(struct coresight_device *csdev)
> +{
> +	int ret = 0;
> +	LIST_HEAD(path);
> +	struct coresight_device *cd;
> +
> +	if (IS_ERR_OR_NULL(csdev))
> +		return -EINVAL;

If we really believe the caller is likely to do something this stupid we
should probably WARN_ON() for their own good.


> +
> +	down(&coresight_mutex);
> +	if (csdev->id == curr_sink)
> +		goto out;
> +
> +	list_for_each_entry(cd, &coresight_devs, dev_link) {
> +		if (cd->type == CORESIGHT_DEV_TYPE_SOURCE && cd->enable) {
> +			coresight_build_path(cd, &path);
> +			coresight_disable_path(&path, false);
> +			coresight_release_path(&path);
> +		}
> +	}
> +	curr_sink = csdev->id;
> +	list_for_each_entry(cd, &coresight_devs, dev_link) {
> +		if (cd->type == CORESIGHT_DEV_TYPE_SOURCE && cd->enable) {
> +			coresight_build_path(cd, &path);
> +			ret = coresight_enable_path(&path, false);
> +			coresight_release_path(&path);
> +			if (ret)
> +				goto err;
> +		}
> +	}
> +out:
> +	up(&coresight_mutex);
> +	return 0;
> +err:
> +	list_for_each_entry(cd, &coresight_devs, dev_link) {
> +		if (cd->type == CORESIGHT_DEV_TYPE_SOURCE && cd->enable)
> +			coresight_disable_source(cd);
> +	}
> +	pr_err("coresight: sink switch failed, sources disabled; try again\n");

coresight_mutex is still locked at this point (so trying again won't
help ;-).


> +	return ret;
> +}
> +
> +int coresight_enable(struct coresight_device *csdev)
> +{
> +	int ret = 0;
> +	LIST_HEAD(path);
> +
> +	if (IS_ERR_OR_NULL(csdev))
> +		return -EINVAL;

WARN_ON() or remove.


> +
> +	down(&coresight_mutex);
> +	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
> +		ret = -EINVAL;
> +		pr_err("coresight: wrong device type in %s\n", __func__);
> +		goto out;
> +	}
> +	if (csdev->enable)
> +		goto out;
> +
> +	coresight_build_path(csdev, &path);
> +	ret = coresight_enable_path(&path, true);
> +	coresight_release_path(&path);
> +	if (ret)
> +		pr_err("coresight: enable failed\n");
> +out:
> +	up(&coresight_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(coresight_enable);
> +
> +void coresight_disable(struct coresight_device *csdev)
> +{
> +	LIST_HEAD(path);
> +
> +	if (IS_ERR_OR_NULL(csdev))
> +		return;
> +
> +	down(&coresight_mutex);
> +	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
> +		pr_err("coresight: wrong device type in %s\n", __func__);
> +		goto out;
> +	}
> +	if (!csdev->enable)
> +		goto out;
> +
> +	coresight_build_path(csdev, &path);
> +	coresight_disable_path(&path, true);
> +	coresight_release_path(&path);
> +out:
> +	up(&coresight_mutex);
> +}
> +EXPORT_SYMBOL_GPL(coresight_disable);
> +
> +void coresight_abort(void)
> +{
> +	struct coresight_device *cd;
> +
> +	if (down_trylock(&coresight_mutex)) {
> +		pr_err("coresight: abort could not be processed\n");
> +		return;
> +	}
> +	if (curr_sink == NO_SINK)
> +		goto out;
> +
> +	list_for_each_entry(cd, &coresight_devs, dev_link) {
> +		if (cd->id == curr_sink) {
> +			if (cd->enable && cd->ops->sink_ops->abort) {
> +				cd->ops->sink_ops->abort(cd);
> +				cd->enable = false;
> +			}
> +		}
> +	}
> +out:
> +	up(&coresight_mutex);
> +}
> +EXPORT_SYMBOL_GPL(coresight_abort);
> +
> +static ssize_t debugfs_curr_sink_get(void *data, u64 *val)
> +{
> +	struct coresight_device *csdev = data;
> +
> +	*val = (csdev->id == curr_sink) ? 1 : 0;
> +	return 0;
> +}
> +
> +static ssize_t debugfs_curr_sink_set(void *data, u64 val)
> +{
> +	struct coresight_device *csdev = data;
> +
> +	if (val)
> +		return coresight_switch_sink(csdev);
> +	else
> +		return -EINVAL;
> +}
> +CORESIGHT_DEBUGFS_ENTRY(debugfs_curr_sink, "curr_sink",
> +			S_IRUGO | S_IWUSR, debugfs_curr_sink_get,
> +			debugfs_curr_sink_set, "%llu\n");
> +
> +static ssize_t debugfs_enable_get(void *data, u64 *val)
> +{
> +	struct coresight_device *csdev = data;
> +
> +	*val = csdev->enable;
> +	return 0;
> +}
> +
> +static ssize_t debugfs_enable_set(void *data, u64 val)
> +{
> +	struct coresight_device *csdev = data;
> +
> +	if (val)
> +		return coresight_enable(csdev);
> +	else
> +		coresight_disable(csdev);
> +
> +	return 0;
> +}
> +CORESIGHT_DEBUGFS_ENTRY(debugfs_enable, "enable",
> +			S_IRUGO | S_IWUSR, debugfs_enable_get,
> +			debugfs_enable_set, "%llu\n");
> +
> +
> +static const struct coresight_ops_entry *coresight_grps_sink[] = {
> +	&debugfs_curr_sink_entry,
> +	NULL,
> +};
> +
> +static const struct coresight_ops_entry *coresight_grps_source[] = {
> +	&debugfs_enable_entry,
> +	NULL,
> +};
> +
> +struct coresight_group_entries {
> +	const char *name;
> +	const struct coresight_ops_entry **entries;
> +};
> +
> +struct coresight_group_entries coresight_debugfs_entries[] = {
> +	{
> +		.name = "none",
> +	},
> +	{
> +		.name = "sink",
> +		.entries = coresight_grps_sink,
> +	},
> +	{
> +		.name = "link",
> +	},
> +	{
> +		.name = "linksink",
> +	},
> +	{
> +		.name = "source",
> +		.entries = coresight_grps_source,
> +	},
> +};
> +
> +static void coresight_device_release(struct device *dev)
> +{
> +	struct coresight_device *csdev = to_coresight_device(dev);
> +	kfree(csdev);
> +}
> +
> +static void coresight_fixup_orphan_conns(struct coresight_device *csdev)
> +{
> +	struct coresight_connection *conn, *temp;
> +
> +	list_for_each_entry_safe(conn, temp, &coresight_orph_conns, link) {
> +		if (conn->child_id == csdev->id) {
> +			conn->child_dev = csdev;
> +			list_del(&conn->link);
> +		}
> +	}
> +}
> +
> +static void coresight_fixup_device_conns(struct coresight_device *csdev)
> +{
> +	int i;
> +	struct coresight_device *cd;
> +	bool found;
> +
> +	for (i = 0; i < csdev->nr_conns; i++) {
> +		found = false;
> +		list_for_each_entry(cd, &coresight_devs, dev_link) {
> +			if (csdev->conns[i].child_id == cd->id) {
> +				csdev->conns[i].child_dev = cd;
> +				found = true;
> +				break;
> +			}
> +		}
> +		if (!found)
> +			list_add_tail(&csdev->conns[i].link,
> +				      &coresight_orph_conns);
> +	}
> +}
> +
> +static int debugfs_coresight_init(void)
> +{
> +	if (!cs_debugfs_parent) {
> +		cs_debugfs_parent = debugfs_create_dir("coresight", 0);
> +		if (IS_ERR(cs_debugfs_parent))
> +			return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct dentry *coresight_debugfs_desc_init(
> +				struct coresight_device *csdev,
> +				const struct coresight_ops_entry **debugfs_ops)
> +{
> +	int i = 0;
> +	struct dentry *parent;
> +	struct device *dev = &csdev->dev;
> +	const struct coresight_ops_entry *ops_entry, **ops_entries;
> +
> +	parent = debugfs_create_dir(dev_name(dev), cs_debugfs_parent);
> +	if (IS_ERR(parent))
> +		return NULL;
> +
> +	/* device-specific ops */
> +	while (debugfs_ops && debugfs_ops[i]) {
> +		ops_entry = debugfs_ops[i];
> +		if (!debugfs_create_file(ops_entry->name, ops_entry->mode,
> +					 parent, dev_get_drvdata(dev->parent),
> +					 ops_entry->ops)) {
> +			debugfs_remove_recursive(parent);
> +			return NULL;
> +		}
> +		i++;
> +	}
> +
> +	/* group-specific ops */
> +	i = 0;
> +	ops_entries = coresight_debugfs_entries[csdev->type].entries;
> +
> +	while (ops_entries && ops_entries[i]) {
> +		if (!debugfs_create_file(ops_entries[i]->name,
> +					 ops_entries[i]->mode,
> +					 parent, csdev, ops_entries[i]->ops)) {
> +			debugfs_remove_recursive(parent);
> +			return NULL;
> +		}
> +		i++;
> +	}
> +
> +	return parent;
> +}
> +
> +struct coresight_device *coresight_register(struct coresight_desc *desc)
> +{
> +	int i;
> +	int ret;
> +	int link_subtype;
> +	int nr_refcnts;
> +	int *refcnts = NULL;
> +	struct coresight_device *csdev;
> +	struct coresight_connection *conns;
> +
> +	if (IS_ERR_OR_NULL(desc))
> +		return ERR_PTR(-EINVAL);
> +
> +	csdev = kzalloc(sizeof(*csdev), GFP_KERNEL);
> +	if (!csdev) {
> +		ret = -ENOMEM;
> +		goto err_kzalloc_csdev;
> +	}
> +
> +	csdev->id = desc->pdata->id;
> +
> +	if (desc->type == CORESIGHT_DEV_TYPE_LINK ||
> +	    desc->type == CORESIGHT_DEV_TYPE_LINKSINK) {
> +		link_subtype = desc->subtype.link_subtype;
> +		if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
> +			nr_refcnts = desc->pdata->nr_inports;
> +		else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
> +			nr_refcnts = desc->pdata->nr_outports;
> +		else
> +			nr_refcnts = 1;
> +
> +		refcnts = kzalloc(sizeof(*refcnts) * nr_refcnts, GFP_KERNEL);
> +		if (!refcnts) {
> +			ret = -ENOMEM;
> +			goto err_kzalloc_refcnts;
> +		}
> +		csdev->refcnt.link_refcnts = refcnts;
> +	}
> +
> +	csdev->nr_conns = desc->pdata->nr_outports;
> +	conns = kzalloc(sizeof(*conns) * csdev->nr_conns, GFP_KERNEL);
> +	if (!conns) {
> +		ret = -ENOMEM;
> +		goto err_kzalloc_conns;
> +	}
> +
> +	for (i = 0; i < csdev->nr_conns; i++) {
> +		conns[i].outport = desc->pdata->outports[i];
> +		conns[i].child_id = desc->pdata->child_ids[i];
> +		conns[i].child_port = desc->pdata->child_ports[i];
> +	}
> +	csdev->conns = conns;
> +
> +	csdev->type = desc->type;
> +	csdev->subtype = desc->subtype;
> +	csdev->ops = desc->ops;
> +	csdev->owner = desc->owner;
> +
> +	csdev->dev.parent = desc->dev;
> +	csdev->dev.release = coresight_device_release;
> +	dev_set_name(&csdev->dev, "%s", desc->pdata->name);
> +
> +	down(&coresight_mutex);
> +	if (desc->pdata->default_sink) {
> +		if (curr_sink == NO_SINK) {
> +			curr_sink = csdev->id;
> +		} else {
> +			ret = -EINVAL;
> +			goto err_default_sink;
> +		}
> +	}
> +
> +	coresight_fixup_device_conns(csdev);
> +
> +	debugfs_coresight_init();

Return value ignored here.


> +	csdev->de = coresight_debugfs_desc_init(csdev, desc->debugfs_ops);
> +
> +	coresight_fixup_orphan_conns(csdev);
> +
> +	list_add_tail(&csdev->dev_link, &coresight_devs);
> +	up(&coresight_mutex);
> +
> +	return csdev;
> ...


> diff --git a/include/linux/coresight.h b/include/linux/coresight.h
> new file mode 100644
> index 0000000..a19420e
> --- /dev/null
> +++ b/include/linux/coresight.h
> @@ -0,0 +1,190 @@
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
> +#ifndef _LINUX_CORESIGHT_H
> +#define _LINUX_CORESIGHT_H
> +
> +#include <linux/device.h>
> +
> +/* Peripheral id registers (0xFD0-0xFEC) */
> +#define CORESIGHT_PERIPHIDR4	(0xFD0)
> +#define CORESIGHT_PERIPHIDR5	(0xFD4)
> +#define CORESIGHT_PERIPHIDR6	(0xFD8)
> +#define CORESIGHT_PERIPHIDR7	(0xFDC)
> +#define CORESIGHT_PERIPHIDR0	(0xFE0)
> +#define CORESIGHT_PERIPHIDR1	(0xFE4)
> +#define CORESIGHT_PERIPHIDR2	(0xFE8)
> +#define CORESIGHT_PERIPHIDR3	(0xFEC)
> +/* Component id registers (0xFF0-0xFFC) */
> +#define CORESIGHT_COMPIDR0	(0xFF0)
> +#define CORESIGHT_COMPIDR1	(0xFF4)
> +#define CORESIGHT_COMPIDR2	(0xFF8)
> +#define CORESIGHT_COMPIDR3	(0xFFC)
> +
> +#define ETM_ARCH_V3_3		(0x23)
> +#define ETM_ARCH_V3_5		(0x25)
> +#define PFT_ARCH_V1_1		(0x31)
> +
> +#define CORESIGHT_UNLOCK	(0xC5ACCE55)
> +
> +enum coresight_clk_rate {
> +	CORESIGHT_CLK_RATE_OFF,
> +	CORESIGHT_CLK_RATE_TRACE,
> +	CORESIGHT_CLK_RATE_HSTRACE,
> +};
> +
> +enum coresight_dev_type {
> +	CORESIGHT_DEV_TYPE_NONE,
> +	CORESIGHT_DEV_TYPE_SINK,
> +	CORESIGHT_DEV_TYPE_LINK,
> +	CORESIGHT_DEV_TYPE_LINKSINK,
> +	CORESIGHT_DEV_TYPE_SOURCE,
> +};
> +
> +enum coresight_dev_subtype_sink {
> +	CORESIGHT_DEV_SUBTYPE_SINK_NONE,
> +	CORESIGHT_DEV_SUBTYPE_SINK_PORT,
> +	CORESIGHT_DEV_SUBTYPE_SINK_BUFFER,
> +};
> +
> +enum coresight_dev_subtype_link {
> +	CORESIGHT_DEV_SUBTYPE_LINK_NONE,
> +	CORESIGHT_DEV_SUBTYPE_LINK_MERG,
> +	CORESIGHT_DEV_SUBTYPE_LINK_SPLIT,
> +	CORESIGHT_DEV_SUBTYPE_LINK_FIFO,
> +};
> +
> +enum coresight_dev_subtype_source {
> +	CORESIGHT_DEV_SUBTYPE_SOURCE_NONE,
> +	CORESIGHT_DEV_SUBTYPE_SOURCE_PROC,
> +	CORESIGHT_DEV_SUBTYPE_SOURCE_BUS,
> +	CORESIGHT_DEV_SUBTYPE_SOURCE_SOFTWARE,
> +};
> +
> +struct coresight_ops_entry {
> +	const char *name;
> +	umode_t mode;
> +	const struct file_operations *ops;
> +};
> +
> +struct coresight_dev_subtype {
> +	enum coresight_dev_subtype_sink sink_subtype;
> +	enum coresight_dev_subtype_link link_subtype;
> +	enum coresight_dev_subtype_source source_subtype;
> +};
> +
> +struct coresight_platform_data {
> +	int id;
> +	int cpu;
> +	const char *name;
> +	int nr_inports;
> +	const int *outports;
> +	const int *child_ids;
> +	const int *child_ports;
> +	int nr_outports;
> +	bool default_sink;
> +	struct clk *clk;
> +};
> +
> +struct coresight_desc {
> +	enum coresight_dev_type type;
> +	struct coresight_dev_subtype subtype;
> +	const struct coresight_ops *ops;
> +	struct coresight_platform_data *pdata;
> +	struct device *dev;
> +	const struct coresight_ops_entry **debugfs_ops;
> +	struct module *owner;
> +};
> +
> +struct coresight_connection {
> +	int outport;
> +	int child_id;
> +	int child_port;
> +	struct coresight_device *child_dev;
> +	struct list_head link;
> +};
> +
> +struct coresight_refcnt {
> +	int sink_refcnt;
> +	int *link_refcnts;
> +	int source_refcnt;
> +};
> +
> +struct coresight_device {
> +	int id;
> +	struct coresight_connection *conns;
> +	int nr_conns;
> +	enum coresight_dev_type type;
> +	struct coresight_dev_subtype subtype;
> +	const struct coresight_ops *ops;
> +	struct dentry *de;
> +	struct device dev;
> +	struct coresight_refcnt refcnt;
> +	struct list_head dev_link;
> +	struct list_head path_link;
> +	struct module *owner;
> +	bool enable;
> +};
> +
> +#define to_coresight_device(d) container_of(d, struct coresight_device, dev)
> +
> +#define CORESIGHT_DEBUGFS_ENTRY(__name, __entry_name,			\
> +				 __mode, __get, __set, __fmt)		\
> +DEFINE_SIMPLE_ATTRIBUTE(__name ## _ops, __get, __set, __fmt)		\
> +static const struct coresight_ops_entry __name ## _entry = {		\
> +	.name = __entry_name,						\
> +	.mode = __mode,							\
> +	.ops  = &__name ## _ops						\
> +}
> +
> +struct coresight_ops_sink {
> +	int (*enable)(struct coresight_device *csdev);
> +	void (*disable)(struct coresight_device *csdev);
> +	void (*abort)(struct coresight_device *csdev);
> +};
> +
> +struct coresight_ops_link {
> +	int (*enable)(struct coresight_device *csdev, int iport, int oport);
> +	void (*disable)(struct coresight_device *csdev, int iport, int oport);
> +};
> +
> +struct coresight_ops_source {
> +	int (*enable)(struct coresight_device *csdev);
> +	void (*disable)(struct coresight_device *csdev);
> +};
> +
> +struct coresight_ops {
> +	const struct coresight_ops_sink *sink_ops;
> +	const struct coresight_ops_link *link_ops;
> +	const struct coresight_ops_source *source_ops;
> +};
> +
> +#ifdef CONFIG_CORESIGHT
> +extern struct coresight_device *
> +coresight_register(struct coresight_desc *desc);
> +extern void coresight_unregister(struct coresight_device *csdev);
> +extern int coresight_enable(struct coresight_device *csdev);
> +extern void coresight_disable(struct coresight_device *csdev);
> +extern void coresight_abort(void);
> +extern struct clk *coresight_get_clk(void);
> +#else
> +static inline struct coresight_device *
> +coresight_register(struct coresight_desc *desc) { return NULL; }
> +static inline void coresight_unregister(struct coresight_device *csdev) {}
> +static inline int
> +coresight_enable(struct coresight_device *csdev) { return -ENOSYS; }
> +static inline void coresight_disable(struct coresight_device *csdev) {}
> +static inline void coresight_abort(void) {}
> +extern struct clk *coresight_get_clk(void) {};
   ^^^^^^                                     ^^

Not static and no return value.

> +#endif
> +
> +#endif

