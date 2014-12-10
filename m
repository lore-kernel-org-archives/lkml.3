Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbaLJP5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:57:55 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8751 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966AbaLJPtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:00 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-64-54886b68525a
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/CLKDEV SUPPORT),
        linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM),
        dri-devel@lists.freedesktop.org (open list:DRM PANEL DRIVERS),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        boris.brezillon@free-electrons.com
Subject: [RFC 02/15] drivers/base: add restrack framework
Date: Wed, 10 Dec 2014 16:48:20 +0100
Message-id: <1418226513-14105-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xy7oZ2R0hBs++G1ncWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBlTN97iaXgx1zGitvbdzM2MJ5tYOxi5OSQEDCR6FzwhB3CFpO4cG89Wxcj
	F4eQwFJGiUvfjzCDJIQE+pgkpm0zA7HZBDQl/m6+yQZiiwjoSFzv6WYGaWAW2MAusW76PrCE
	sIClxPyXB1hAbBYBVYmfOz+B2bwCzhJfrlxmhdgmJ3Hy2GQwm1PAReLv872MEMucJZZse886
	gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ+Pi6g3HpMatDjAIcjEo8vDsU20KE
	WBPLiitzDzFKcDArifAuTO4IEeJNSaysSi3Kjy8qzUktPsTIxMEp1cC4TG6mTICUSfP+OwxM
	JXlGDG3f5PdPXMPjJatiP3WRwvcDiwVajI9W3nvNcGH76puO7vt5tAs+OH0s1Zdk+tn4TLWX
	hV1fjjvkitR03WQ/7SQZ9fcHbLtuvGJaNZnrYfwf7/RX367zXnUKkpqlVT7jycWkhANR4mEZ
	mzy9pi2/0m64gm8lywolluKMREMt5qLiRABHaCr3bQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

restrack framework allows tracking presence of resources with dynamic life
time. Typical example of such resources are all resources provided by device
drivers, for example clocks, phys, regulators. Since drivers can be bound and
unbound dynamically and unconditionally, resources provided by such drivers
can appear and disappear at any time.

To use restrack in consumer user should call one of *restrack_register
functions. In the function arguments consumer should provide callback and
description of resources which should be tracked. Each resource description
should contain pointer to variable where restrack should store address of
allocated resource and parameters describing specific resource, for example
in case of clock it should be clock name and in case of gpio it should be
gpio name and flags.
The callback should have two arguments:
- dev - device for which callback have been registered,
- ret - return code.
If callback is called with ret == 0 it means all tracked resources are
present, allocated and provided resource pointers are set accordingly.
In case ret == -EPROBE_DEFER it means all resources are present but at least
one of the resources are to be removed after return form the callback.

Simplified example of framework usage on LCD panel driver.

static int lcd_probe(...)
{
	struct restrack *rtrack;

	(...initialization w/o resource allocation ...)

	rtrack = devm_restrack_register(dev, lcd_callback,
		regulator_bulk_restrack_desc(&ctx->supplies[0]),
		regulator_bulk_restrack_desc(&ctx->supplies[1]),
		clk_restrack_desc(&ctx->pll_clk, "pll_clk"),
		clk_restrack_desc(&ctx->bus_clk, "bus_clk"),
		phy_restrack_desc(&ctx->phy, "dsim"),
	);

	return PTR_ERR_OR_NULL(rtrack);
}

void lcd_callback(struct device *dev, int ret)
{
	struct lcd_ctx *ctx = dev_get_drvdata(dev);

	if (ret == 0)
		drm_panel_add(&ctx->panel);
	else if (ret == -EPROBE_DEFER)
		drm_panel_remove(&ctx->panel);
	else
		dev_err(dev, "restrack error %d\n", ret);
}

Please note few things:
1. drm_panel_add calls restrack_up and drm_panel_remove calls restrack_down.
   It is OK to call restrack framework from the callback.
2. In lcd_callback if ret is 0 or -EDEFER_PROBE all resources are valid, ie
   driver for example can call clk_prepare_enable(ctx->pll_clk).
3. No mutexes are needed to protect lcd_ctx in lcd_callback call.
4. All resources are freed by restrack_unregister, which in this case is
   called by devres framework.

To add restrack support to specific framework following things should be
defined:
- structure describing resource with embedded restrack_desc structure,
- at least one exported allocator of such structure,
- few simple operations according to description of struct restrack_ops,
- notifications about adding/removal of the resource.
For details please look at implementations.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/base/Makefile    |   2 +-
 drivers/base/restrack.c  | 344 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/restrack.h | 137 +++++++++++++++++++
 3 files changed, 482 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/restrack.c
 create mode 100644 include/linux/restrack.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 4edff7d..cf9a21e 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o container.o track.o
+			   topology.o container.o track.o restrack.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
diff --git a/drivers/base/restrack.c b/drivers/base/restrack.c
new file mode 100644
index 0000000..e16d8ed
--- /dev/null
+++ b/drivers/base/restrack.c
@@ -0,0 +1,344 @@
+/*
+ * Resource tracking framework
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * restrack framework allows to track presence of resources with dynamic life
+ * time. Typical example of such resources are all resources provided by device
+ * drivers, for example clocks, phys, regulators. Since drivers can be bound and
+ * unbound dynamically and unconditionally, resources provided by such drivers
+ * can appear and disappear at any time.
+ *
+ * To use restrack in consumer user should call one of *restrack_register
+ * functions. In the function arguments consumer should provide callback and
+ * description of resources which should be tracked. Each resource description
+ * should contain pointer to variable where restrack should store address of
+ * allocated resource and parameters describing specific resource, for example
+ * in case of clock it should be clock name and in case of gpio it should be
+ * gpio name and flags.
+ * The callback should have two arguments:
+ * - dev - device for which callback have been registered,
+ * - ret - return code.
+ * If callback is called with ret == 0 it means all tracked resources are
+ * present, allocated and provided resource pointers are set accordingly.
+ * In case ret == -EPROBE_DEFER it means all resources are present but at least
+ * one of the resources are to be removed after return form the callback.
+ *
+ * Simplified example of framework usage on LCD panel driver.
+ *
+ * static int lcd_probe(...)
+ * {
+ *	struct restrack *rtrack;
+ *
+ *	(...initialization w/o resource allocation ...)
+ *
+ *	rtrack = devm_restrack_register(dev, lcd_callback,
+ *		regulator_bulk_restrack_desc(&ctx->supplies[0]),
+ *		regulator_bulk_restrack_desc(&ctx->supplies[1]),
+ *		clk_restrack_desc(&ctx->pll_clk, "pll_clk"),
+ *		clk_restrack_desc(&ctx->bus_clk, "bus_clk"),
+ *		phy_restrack_desc(&ctx->phy, "dsim"),
+ *	);
+ *
+ *	return PTR_ERR_OR_NULL(rtrack);
+ * }
+ *
+ * void lcd_callback(struct device *dev, int ret)
+ * {
+ *	struct lcd_ctx *ctx = dev_get_drvdata(dev);
+ *
+ *	if (ret == 0)
+ *		drm_panel_add(&ctx->panel);
+ *	else if (ret == -EPROBE_DEFER)
+ *		drm_panel_remove(&ctx->panel);
+ *	else
+ *		dev_err(dev, "restrack error %d\n", ret);
+ * }
+ *
+ * Please note few things:
+ * 1. drm_panel_add calls restrack_up and drm_panel_remove calls restrack_down.
+ *    It is OK to call restrack framework from the callback.
+ * 2. In lcd_callback if ret is 0 or -EDEFER_PROBE all resources are valid, ie
+ *    driver for example can call clk_prepare_enable(ctx->pll_clk).
+ * 3. No mutexes are needed to protect lcd_ctx in lcd_callback call.
+ * 4. All resources are freed by restrack_unregister, which in this case is
+ *    called by devres framework.
+ *
+ * To add restrack support to specific framework following things should be
+ * defined:
+ * - structure describing resource with embedded restrack_desc structure,
+ * - at least one exported allocator of such structure,
+ * - few simple operations according to description of struct restrack_ops,
+ * - notifications about adding/removal of the resource.
+ * For details please look at existing implementations.
+ *
+ */
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/restrack.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/track.h>
+
+static DEFINE_TRACKER(restrack);
+
+struct restrack_ctx {
+	struct device *dev;
+	unsigned int count;
+	unsigned int get_count;
+	restrack_fn_t callback;
+	struct restrack_desc *desc[0];
+};
+
+/**
+ * restrack_up - notify that resource provider is up
+ * @type: resource type
+ * @id: resource id
+ * @data: @type dependent cookie, usually pointer to resource provider
+ */
+int restrack_up(unsigned long type, const void *id, void *data)
+{
+	return track_up(&restrack, type, id, data);
+}
+
+/**
+ * restrack_down - notify that resource provider is down
+ * @type: resource type
+ * @id: resource id
+ * @data: @type dependent cookie, usually pointer to resource provider
+ */
+int restrack_down(unsigned long type, const void *id, void *data)
+{
+	return track_down(&restrack, type, id, data);
+}
+
+static void restrack_itb_cb(struct track_block *itb, void *data, bool on)
+{
+	struct restrack_desc *desc;
+	struct restrack_ctx *ctx;
+	int i;
+
+	desc = container_of(itb, struct restrack_desc, itb);
+	ctx = desc->ctx;
+
+	for (i = 0; i < ctx->count; ++i) {
+		struct restrack_desc *d = ctx->desc[i];
+
+		if ((d->if_id != desc->if_id) ||
+		    (d->ops->if_type != desc->ops->if_type))
+			continue;
+
+		pr_debug("%s:%d: if_type=%ld on=%d res=%d/%d\n", __func__,
+			 __LINE__, d->ops->if_type, on, i, ctx->count);
+
+		if (on) {
+			if (!d->status)
+				continue;
+
+			d->status = d->ops->if_up(ctx->dev, d, data);
+
+			if (!d->status)
+				++ctx->get_count;
+
+			if (d->status == -EPROBE_DEFER)
+				continue;
+
+			if (d->status || ctx->get_count == ctx->count)
+				ctx->callback(ctx->dev, d->status);
+		} else {
+			if (!d->status) {
+				if (ctx->get_count-- == ctx->count)
+					ctx->callback(ctx->dev, -EPROBE_DEFER);
+				d->ops->if_down(ctx->dev, d, data);
+			}
+			d->status = -EPROBE_DEFER;
+		}
+	}
+}
+
+/* check if the same interface is present in previous restrack descriptors */
+static bool restrack_find_prev_if(struct restrack_ctx *ctx, int n)
+{
+	struct restrack_desc *desc = ctx->desc[n];
+	int i;
+
+	for (i = 0; i < n; ++i) {
+		struct restrack_desc *d = ctx->desc[i];
+
+		if (d->if_id == desc->if_id &&
+		    d->ops->if_type == desc->ops->if_type)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * restrack_unregister - unregister restrack callback
+ * @ctx: restrack context, previously allocated by __restrack_register
+ */
+
+void restrack_unregister(struct restrack_ctx *ctx)
+{
+	int i;
+
+	i = ctx->count;
+	while (i-- > 0) {
+		struct restrack_desc *desc = ctx->desc[i];
+
+		if (IS_ERR(desc))
+			continue;
+
+		if (restrack_find_prev_if(ctx, i))
+			continue;
+
+		track_unregister(&restrack, &desc->itb, desc->ops->if_type,
+				 desc->if_id);
+	}
+
+	i = ctx->count;
+	while (i-- > 0) {
+		struct restrack_desc *desc = ctx->desc[i];
+
+		if (IS_ERR(desc))
+			continue;
+
+		if (desc->ops->destroy)
+			desc->ops->destroy(ctx->dev, desc);
+		else
+			kfree(desc);
+	}
+
+	kfree(ctx);
+}
+
+/**
+ * __restrack_register - register resource tracker callback
+ * @dev: consumer device
+ * @callback: callback which will be called when:
+ *	- all tracked resources become available, with @ret = 0
+ *	- one of the resources becomes unavailable, with @ret = -EPROBE_DEFER,
+ *	- resource allocation errors, with @ret equal to this error
+ * @count: number of resource descriptors to track
+ * @descs: list of pointers to resource descriptors to track
+ *
+ * It can be called as follows:
+ *	struct restrack_desc *descriptors[] = {
+ *		regulator_bulk_restrack_desc(&ctx->supplies[0]),
+ *		regulator_bulk_restrack_desc(&ctx->supplies[1]),
+ *		clk_restrack_desc(&ctx->pll_clk, "pll_clk"),
+ *		clk_restrack_desc(&ctx->bus_clk, "bus_clk"),
+ *		phy_restrack_desc(&ctx->phy, "dsim"),
+ *	};
+ *	rtrack = __restrack_register(dev, callback,
+ *			ARRAY_SIZE(descriptors), descriptors);
+ */
+struct restrack_ctx *__restrack_register(struct device *dev, restrack_fn_t cb,
+		int count, struct restrack_desc **descriptors)
+{
+	struct restrack_ctx *ctx;
+	int ret, i;
+
+	ctx = kzalloc(sizeof(*ctx) + count * sizeof(ctx->desc[0]),
+			 GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ctx->dev = dev;
+	ctx->count = count;
+	ctx->callback = cb;
+	memcpy(ctx->desc, descriptors, count * sizeof(*descriptors));
+
+	for (i = 0; i < count; ++i) {
+		struct restrack_desc *desc = descriptors[i];
+
+		if (IS_ERR(desc)) {
+			ret = PTR_ERR(desc);
+			goto err_free;
+		}
+		INIT_LIST_HEAD(&desc->itb.list);
+		desc->itb.callback = restrack_itb_cb;
+		desc->ctx = ctx;
+		desc->status = -EPROBE_DEFER;
+		ret = desc->ops->init(dev, desc);
+		if (ret)
+			goto err_free;
+	}
+
+	/* Callbacks should be registered after all fields are initialized,
+	 * otherwise callback could access partially initialized data. */
+	for (i = 0; i < count; ++i) {
+		struct restrack_desc *desc = descriptors[i];
+		const struct restrack_ops *ops = desc->ops;
+
+		/* do not track the same interface twice */
+		if (restrack_find_prev_if(ctx, i))
+			continue;
+
+		ret = track_register(&restrack, &desc->itb, ops->if_type,
+				     desc->if_id);
+		if (ret)
+			goto err_free;
+	}
+
+	return ctx;
+
+err_free:
+	restrack_unregister(ctx);
+
+	return ERR_PTR(ret);
+}
+
+static void devm_restrack_release(struct device *dev, void *res)
+{
+	struct restrack_ctx **ptr = res;
+
+	if (!IS_ERR(*ptr))
+		restrack_unregister(*ptr);
+}
+
+/**
+ * __devm_restrack_register - devm version of __restrack_register
+ * @dev: consumer device
+ * @callback: callback which will be called when:
+ *	- all tracked resources become available, with @ret = 0
+ *	- one of the resources becomes unavailable, with @ret = -EPROBE_DEFER,
+ *	- resource allocation errors, with @ret equal to this error
+ * @count: number of resource descriptors to track
+ * @descs: list of pointers to resource descriptors to track
+ *
+ * It can be called as follows:
+ *	struct restrack_desc *descriptors[] = {
+ *		regulator_bulk_restrack_desc(&ctx->supplies[0]),
+ *		regulator_bulk_restrack_desc(&ctx->supplies[1]),
+ *		clk_restrack_desc(&ctx->pll_clk, "pll_clk"),
+ *		clk_restrack_desc(&ctx->bus_clk, "bus_clk"),
+ *		phy_restrack_desc(&ctx->phy, "dsim"),
+ *	};
+ *	rtrack = __devm_restrack_register(dev, callback,
+ *			ARRAY_SIZE(descriptors), descriptors);
+ */
+struct restrack_ctx *__devm_restrack_register(struct device *dev,
+		restrack_fn_t cb, int count, struct restrack_desc **descs)
+{
+	struct restrack_ctx **ptr;
+
+	ptr = devres_alloc(devm_restrack_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	/* It should be added before __restrack_register to keep correct order
+	 * of resources - restrack callback can also use devres framework.
+	 */
+	devres_add(dev, ptr);
+
+	*ptr = __restrack_register(dev, cb, count, descs);
+
+	return *ptr;
+}
+EXPORT_SYMBOL_GPL(__devm_restrack_register);
diff --git a/include/linux/restrack.h b/include/linux/restrack.h
new file mode 100644
index 0000000..6cf8144f
--- /dev/null
+++ b/include/linux/restrack.h
@@ -0,0 +1,137 @@
+#ifndef RESTRACK_H
+#define RESTRACK_H
+
+#include <linux/track.h>
+
+struct device;
+struct restrack_ctx;
+struct restrack_desc;
+
+int restrack_up(unsigned long type, const void *id, void *data);
+int restrack_down(unsigned long type, const void *id, void *data);
+
+/**
+ * struct restrack_ops - Resource tracker operations for specific resource
+ * @if_type: interface type of provider associated with given resource,
+ *	multiple restrack_ops per if_type are allowed
+ * @init: called by restrack_register to initialize device depended fields
+ *	of the resource descriptor
+ * @destroy: destroy resource descriptor
+ * @if_up: called when provider of given resource becomes available, usually
+ *	it should allocate the resource and fill the variable which was
+ *	provided by restrack_register.
+ * @if_down: called before provider of given resource becomes unavailable. It
+ *	should release the resource and set associated variable to
+ *	-EPROBE_DEFER.
+ *
+ * struct restrack_ops provides set of operations to handle resource specific
+ * operations. It translates resource names specific to consumer device to
+ * track interface id exposed by providers and translates back track
+ * notifications to callback convenient for device driver.
+ * @desc parameter provided in all callbacks is a pointer to common
+ * restrack_desc structure embedded in bigger structure which is usually
+ * allocated by resource specific allocator function.
+ * Callbacks should return 0 on success or error code.
+ */
+struct restrack_ops {
+	unsigned long if_type;
+	int (*init)(struct device *dev, struct restrack_desc *desc);
+	void (*destroy)(struct device *dev, struct restrack_desc *desc);
+	int (*if_up)(struct device *dev, struct restrack_desc *desc,
+		     void *data);
+	void (*if_down)(struct device *dev, struct restrack_desc *desc,
+			void *data);
+};
+
+#define restrack_desc_to_rd(_rd, _var) container_of(_var, typeof(*rd), desc)
+
+#define RESTRACK_DESC_ALLOC(_rd, _ops, _ptr, _name) \
+({ \
+	_rd = kzalloc(sizeof(*_rd), GFP_KERNEL); \
+	if (_rd) { \
+		*_ptr = ERR_PTR(-EPROBE_DEFER); \
+		_rd->ptr = _ptr; \
+		_rd->name = _name; \
+		_rd->desc.ops = &_ops; \
+	} \
+})
+
+/**
+ * struct restrack_desc - resource descriptor
+ * @ops: operations associated with the resource, filled by resource descriptor
+ *	 allocator
+ * @if_id: interface id associated with the resource, filled by @init operation
+ * @itb: iftrack block used by restrack core
+ * @ctx: restrack context used by restrack core
+ * @status: status of the descriptor, used by restrack core
+ */
+struct restrack_desc {
+	const struct restrack_ops *ops;
+	void *if_id;
+	struct track_block itb;
+	struct restrack_ctx *ctx;
+	int status;
+};
+
+typedef void (*restrack_fn_t)(struct device *dev, int ret);
+
+void restrack_unregister(struct restrack_ctx *ctx);
+struct restrack_ctx *__restrack_register(struct device *dev, restrack_fn_t cb,
+		int count, struct restrack_desc **descriptors);
+struct restrack_ctx *__devm_restrack_register(struct device *dev,
+		restrack_fn_t cb, int count,
+		struct restrack_desc **descriptors);
+
+/**
+ * restrack_register - register resource tracking callback
+ * @dev: consumer device
+ * @callback: callback which will be called when:
+ *	- all tracked resources become available, with @ret = 0
+ *	- one of the resources becomes unavailable, with @ret = -EPROBE_DEFER,
+ *	- resource allocation errors, with @ret equal to this error
+ * @descs: list of pointers to resource descriptors to track
+ *
+ * restrack_register is a wrapper macro around @__restrack_register. It can be
+ * called as follows:
+ *	ctx->rtrack = restrack_register(dev, callback,
+ *		regulator_bulk_restrack_desc(&ctx->supplies[0]),
+ *		regulator_bulk_restrack_desc(&ctx->supplies[1]),
+ *		clk_restrack_desc(&ctx->pll_clk, "pll_clk"),
+ *		clk_restrack_desc(&ctx->bus_clk, "bus_clk"),
+ *		phy_restrack_desc(&ctx->phy, "dsim"),
+ *	);
+ */
+#define restrack_register(dev, callback, descs...) \
+({ \
+	struct restrack_desc *desc[] = { descs }; \
+\
+	__restrack_register(dev, callback, ARRAY_SIZE(desc), desc); \
+})
+
+/**
+ * devm_restrack_register - devm version of restrack_register
+ * @dev: consumer device
+ * @callback: callback which will be called when:
+ *	- all tracked resources become available, with @ret = 0
+ *	- one of the resources becomes unavailable, with @ret = -EPROBE_DEFER,
+ *	- resource allocation errors, with @ret equal to this error
+ * @descs: list of pointers to resource descriptors to track
+ *
+ * restrack_register is a wrapper macro around @__restrack_register. It can be
+ * called as follows:
+ *	rtrack = devm_restrack_register(dev, callback,
+ *		regulator_bulk_restrack_desc(&ctx->supplies[0]),
+ *		regulator_bulk_restrack_desc(&ctx->supplies[1]),
+ *		clk_restrack_desc(&ctx->pll_clk, "pll_clk"),
+ *		clk_restrack_desc(&ctx->bus_clk, "bus_clk"),
+ *		phy_restrack_desc(&ctx->phy, "dsim"),
+ *	);
+ */
+#define devm_restrack_register(dev, callback, descs...) \
+({ \
+	struct restrack_desc *desc[] = { descs }; \
+\
+	__devm_restrack_register(dev, callback, ARRAY_SIZE(desc), desc); \
+})
+
+#endif /* RESTRACK_H */
-- 
1.9.1

