Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaBHAtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:49:36 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3248 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbaBHAtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:49:02 -0500
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: <s-anna@ti.com>, <rob.herring@calxeda.com>, <rafael.j.wysocki@intel.com>,
        <mark.langsdorf@calxeda.com>, <tony@atomide.com>,
        <omar.ramirez@copitl.com>
CC: <gregkh@linuxfoundation.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 1/6] mailbox: add core framework
Date: Fri, 7 Feb 2014 16:50:14 -0800
Message-ID: <1391820619-25487-2-git-send-email-courtney.cavin@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mailbox drivers are fragmented, and some implement their own core.
Unify the drivers and implement common functionality in a framework.

Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
---
 drivers/mailbox/Makefile |   1 +
 drivers/mailbox/core.c   | 573 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mbox.h     | 175 +++++++++++++++
 3 files changed, 749 insertions(+)
 create mode 100644 drivers/mailbox/core.c
 create mode 100644 include/linux/mbox.h

diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
index e0facb3..53712ed 100644
--- a/drivers/mailbox/Makefile
+++ b/drivers/mailbox/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_MAILBOX)		+= core.o
 obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
 
 obj-$(CONFIG_OMAP_MBOX)		+= omap-mailbox.o
diff --git a/drivers/mailbox/core.c b/drivers/mailbox/core.c
new file mode 100644
index 0000000..0dc865e
--- /dev/null
+++ b/drivers/mailbox/core.c
@@ -0,0 +1,573 @@
+/*
+ * Generic mailbox implementation
+ *
+ * Copyright (C) 2014 Sony Mobile Communications, AB.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/mbox.h>
+
+static DEFINE_MUTEX(mbox_lock);
+static LIST_HEAD(mbox_adapters);
+
+static DEFINE_MUTEX(mbox_lookup_lock);
+static LIST_HEAD(mbox_lookup_list);
+
+static int __mbox_adapter_request(struct mbox_adapter *adap,
+		struct mbox_channel *chan)
+{
+	int rc;
+
+	if (chan->users > 0) {
+		chan->users++;
+		return 0;
+	}
+
+	if (!try_module_get(adap->ops->owner))
+		return -ENODEV;
+
+	if (adap->ops->request) {
+		rc = adap->ops->request(adap, chan);
+		if (rc) {
+			module_put(adap->ops->owner);
+			return rc;
+		}
+	}
+
+	chan->users++;
+
+	return 0;
+}
+
+static void __mbox_adapter_release(struct mbox_adapter *adap,
+		struct mbox_channel *chan)
+{
+	if (!adap || !chan)
+		return;
+
+	if (chan->users == 0) {
+		dev_err(adap->dev, "device already released\n");
+		return;
+	}
+
+	chan->users--;
+	if (chan->users > 0)
+		return;
+
+	if (adap->ops->release)
+		adap->ops->release(adap, chan);
+	module_put(adap->ops->owner);
+}
+
+static struct mbox_channel *
+mbox_adapter_request_channel(struct mbox_adapter *adap, unsigned int index)
+{
+	struct mbox_channel *chan;
+	int rc;
+
+	if (!adap || index >= adap->nchannels)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&adap->lock);
+	chan = &adap->channels[index];
+
+	rc = __mbox_adapter_request(adap, chan);
+	if (rc)
+		chan = ERR_PTR(rc);
+	mutex_unlock(&adap->lock);
+
+	return chan;
+}
+
+static void mbox_adapter_release_channel(struct mbox_adapter *adap,
+		struct mbox_channel *chan)
+{
+	if (!adap || !chan)
+		return;
+
+	mutex_lock(&adap->lock);
+	__mbox_adapter_release(adap, chan);
+	mutex_unlock(&adap->lock);
+}
+
+static int of_mbox_simple_xlate(struct mbox_adapter *adap,
+		const struct of_phandle_args *args)
+{
+	if (adap->of_n_cells < 1)
+		return -EINVAL;
+	if (args->args[0] >= adap->nchannels)
+		return -EINVAL;
+
+	return args->args[0];
+}
+
+static struct mbox_adapter *of_node_to_mbox_adapter(struct device_node *np)
+{
+	struct mbox_adapter *adap;
+
+	mutex_lock(&mbox_lock);
+	list_for_each_entry(adap, &mbox_adapters, list) {
+		if (adap->dev && adap->dev->of_node == np) {
+			mutex_unlock(&mbox_lock);
+			return adap;
+		}
+	}
+	mutex_unlock(&mbox_lock);
+
+	return ERR_PTR(-EPROBE_DEFER);
+}
+
+static void of_mbox_adapter_add(struct mbox_adapter *adap)
+{
+	if (!adap->dev)
+		return;
+
+	if (!adap->of_xlate) {
+		adap->of_xlate = of_mbox_simple_xlate;
+		adap->of_n_cells = 1;
+	}
+
+	of_node_get(adap->dev->of_node);
+}
+
+static void of_mbox_adapter_remove(struct mbox_adapter *adap)
+{
+	if (!adap->dev)
+		return;
+	of_node_put(adap->dev->of_node);
+}
+
+static struct mbox_channel *
+of_mbox_adapter_request_channel(struct device_node *np, const char *con_id)
+{
+	struct of_phandle_args args;
+	struct mbox_adapter *adap;
+	struct mbox_channel *chan;
+	int index = 0;
+	int rc;
+
+	if (con_id) {
+		index = of_property_match_string(np, "mbox-names", con_id);
+		if (index < 0)
+			return ERR_PTR(index);
+	}
+
+	rc = of_parse_phandle_with_args(np, "mbox", "#mbox-cells",
+			index, &args);
+	if (rc)
+		return ERR_PTR(rc);
+
+	adap = of_node_to_mbox_adapter(args.np);
+	if (IS_ERR(adap)) {
+		chan = ERR_CAST(adap);
+		goto out;
+	}
+
+	if (args.args_count != adap->of_n_cells) {
+		chan = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	index = adap->of_xlate(adap, &args);
+	if (index < 0) {
+		chan = ERR_PTR(index);
+		goto out;
+	}
+
+	chan = mbox_adapter_request_channel(adap, index);
+
+out:
+	of_node_put(args.np);
+	return chan;
+}
+
+/**
+ * mbox_adapter_add() - register a new MBOX adapter
+ * @adap: the adapter to add
+ */
+int mbox_adapter_add(struct mbox_adapter *adap)
+{
+	struct mbox_channel *chan;
+	unsigned int i;
+
+	if (!adap || !adap->dev || !adap->ops || !adap->ops->put_message)
+		return -EINVAL;
+	if (adap->nchannels == 0)
+		return -EINVAL;
+
+	adap->channels = kzalloc(adap->nchannels * sizeof(*chan), GFP_KERNEL);
+	if (!adap->channels)
+		return -ENOMEM;
+
+	for (i = 0; i < adap->nchannels; ++i) {
+		chan = &adap->channels[i];
+		ATOMIC_INIT_NOTIFIER_HEAD(&chan->notifier);
+		chan->adapter = adap;
+		chan->id = i;
+	}
+	mutex_init(&adap->lock);
+
+	mutex_lock(&mbox_lock);
+	list_add(&adap->list, &mbox_adapters);
+
+	of_mbox_adapter_add(adap);
+	mutex_unlock(&mbox_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(mbox_adapter_add);
+
+/**
+ * mbox_adapter_remove() - unregisters a MBOX adapter
+ * @adap: the adapter to remove
+ *
+ * This function may return -EBUSY if the adapter provides a channel which
+ * is still requested.
+ */
+int mbox_adapter_remove(struct mbox_adapter *adap)
+{
+	unsigned int i;
+
+	mutex_lock(&mbox_lock);
+
+	for (i = 0; i < adap->nchannels; ++i) {
+		struct mbox_channel *chan = &adap->channels[i];
+		if (chan->users) {
+			mutex_unlock(&mbox_lock);
+			return -EBUSY;
+		}
+	}
+	list_del_init(&adap->list);
+
+	of_mbox_adapter_remove(adap);
+
+	mutex_unlock(&mbox_lock);
+
+	kfree(adap->channels);
+
+	return 0;
+}
+EXPORT_SYMBOL(mbox_adapter_remove);
+
+static int mbox_channel_put_message(struct mbox_channel *chan,
+		const void *data, unsigned int len)
+{
+	int rc;
+
+	mutex_lock(&chan->adapter->lock);
+	rc = chan->adapter->ops->put_message(chan->adapter, chan, data, len);
+	mutex_unlock(&chan->adapter->lock);
+
+	return rc;
+}
+
+/**
+ * mbox_channel_notify() - notify the core that a channel has a message
+ * @chan: the channel which has data
+ * @data: the location of said data
+ * @len: the length of specified data
+ *
+ * This function may be called from interrupt/no-sleep context.
+ */
+int mbox_channel_notify(struct mbox_channel *chan,
+		const void *data, unsigned int len)
+{
+	return atomic_notifier_call_chain(&chan->notifier, len, (void *)data);
+}
+EXPORT_SYMBOL(mbox_channel_notify);
+
+/**
+ * mbox_add_table() - add a lookup table for adapter consumers
+ * @table: array of consumers to register
+ * @num: number of consumers in array
+ */
+void __init mbox_add_table(struct mbox_lookup *table, unsigned int num)
+{
+	mutex_lock(&mbox_lookup_lock);
+	while (num--) {
+		if (table->provider && (table->dev_id || table->con_id))
+			list_add_tail(&table->list, &mbox_lookup_list);
+		table++;
+	}
+	mutex_unlock(&mbox_lookup_lock);
+}
+EXPORT_SYMBOL(mbox_add_table);
+
+static struct mbox_adapter *mbox_adapter_lookup(const char *name)
+{
+	struct mbox_adapter *adap;
+
+	if (!name)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&mbox_lock);
+	list_for_each_entry(adap, &mbox_adapters, list) {
+		const char *aname = dev_name(adap->dev);
+		if (aname && !strcmp(aname, name)) {
+			mutex_unlock(&mbox_lock);
+			return adap;
+		}
+	}
+	mutex_unlock(&mbox_lock);
+
+	return ERR_PTR(-ENODEV);
+}
+
+static struct mbox_adapter *
+mbox_channel_lookup(struct device *dev, const char *con_id, int *index)
+{
+	const char *dev_id = dev ? dev_name(dev) : NULL;
+	struct mbox_adapter *adap = ERR_PTR(-ENODEV);
+	struct mbox_lookup *lp;
+	int match, best;
+
+	best = 0;
+	mutex_lock(&mbox_lookup_lock);
+	list_for_each_entry(lp, &mbox_lookup_list, list) {
+		match = 0;
+		if (lp->dev_id) {
+			if (!dev_id || strcmp(lp->dev_id, dev_id))
+				continue;
+			match += 2;
+		}
+		if (lp->con_id) {
+			if (!con_id || strcmp(lp->con_id, con_id))
+				continue;
+			match += 1;
+		}
+		if (match <= best)
+			continue;
+		adap = mbox_adapter_lookup(lp->provider);
+		if (IS_ERR(adap))
+			continue;
+		if (index)
+			*index = lp->index;
+		if (match == 3)
+			break;
+		best = match;
+	}
+	mutex_unlock(&mbox_lookup_lock);
+
+	return adap;
+}
+
+/**
+ * struct mbox - MBOX channel consumer
+ * @chan: internal MBOX channel
+ * @nb: notifier to call on message available
+ */
+struct mbox {
+	struct mbox_channel *chan;
+	struct notifier_block *nb;
+};
+
+static struct mbox *
+__mbox_alloc(struct mbox_channel *chan, struct notifier_block *nb)
+{
+	struct mbox *mbox;
+
+	mbox = kzalloc(sizeof(*mbox), GFP_KERNEL);
+	if (mbox == NULL)
+		return ERR_PTR(-ENOMEM);
+	mbox->chan = chan;
+	mbox->nb = nb;
+
+	if (mbox->nb)
+		atomic_notifier_chain_register(&chan->notifier, mbox->nb);
+
+	return mbox;
+}
+
+/**
+ * mbox_request() - lookup and request a MBOX channel
+ * @dev: device for channel consumer
+ * @con_id: consumer name
+ * @nb: notifier block used for receiving messages
+ *
+ * The notifier is called as atomic on new messages, so you may not sleep
+ * in the notifier callback function.
+ */
+struct mbox *mbox_request(struct device *dev, const char *con_id,
+		struct notifier_block *nb)
+{
+	struct mbox_adapter *adap;
+	struct mbox_channel *chan;
+	struct mbox *mbox;
+	int index = 0;
+
+	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
+		return of_mbox_request(dev->of_node, con_id, nb);
+
+	adap = mbox_channel_lookup(dev, con_id, &index);
+	if (IS_ERR(adap))
+		return ERR_CAST(adap);
+
+	chan = mbox_adapter_request_channel(adap, index);
+	if (IS_ERR(chan))
+		return ERR_CAST(chan);
+
+	mbox = __mbox_alloc(chan, nb);
+	if (IS_ERR(mbox))
+		mbox_adapter_release_channel(adap, chan);
+	return mbox;
+}
+EXPORT_SYMBOL(mbox_request);
+
+/**
+ * mbox_release() - release a MBOX channel
+ * @mbox: the channel to release
+ *
+ * This releases a channel previously acquired by mbox_request(). Do not call
+ * this function on devm-allocated MBOX channels.
+ */
+void mbox_release(struct mbox *mbox)
+{
+	struct mbox_channel *chan = mbox->chan;
+	if (mbox->nb)
+		atomic_notifier_chain_unregister(&chan->notifier, mbox->nb);
+	mbox_adapter_release_channel(chan->adapter, chan);
+	kfree(mbox);
+}
+EXPORT_SYMBOL(mbox_release);
+
+/**
+ * mbox_put_message() - post a message to the MBOX channel
+ * @mbox: the channel to post to
+ * @data: location of the message
+ * @len: length of the message
+ *
+ * This function might sleep, and may not be called from interrupt context.
+ */
+int mbox_put_message(struct mbox *mbox, const void *data, unsigned int len)
+{
+	might_sleep();
+	return mbox_channel_put_message(mbox->chan, data, len);
+}
+EXPORT_SYMBOL(mbox_put_message);
+
+/**
+ * of_mbox_request() - lookup in DT and request a MBOX channel
+ * @np: device node for lookup
+ * @con_id: consumer id
+ * @nb: notifier block used for receiving messages
+ *
+ * The notifier is called as atomic on new messages, so you may not sleep
+ * in the notifier callback function.
+ */
+struct mbox *of_mbox_request(struct device_node *np, const char *con_id,
+		struct notifier_block *nb)
+{
+	struct mbox_channel *chan;
+	struct mbox *mbox;
+
+	chan = of_mbox_adapter_request_channel(np, con_id);
+	if (IS_ERR(chan))
+		return ERR_CAST(chan);
+
+	mbox = __mbox_alloc(chan, nb);
+	if (IS_ERR(mbox))
+		mbox_adapter_release_channel(chan->adapter, chan);
+	return mbox;
+}
+EXPORT_SYMBOL(of_mbox_request);
+
+static int devm_mbox_match(struct device *dev, void *res, void *data)
+{
+	struct mbox **p = res;
+
+	if (WARN_ON(!p || !*p))
+		return 0;
+
+	return *p == data;
+}
+
+static void __devm_mbox_release(struct device *dev, void *res)
+{
+	mbox_release(*(struct mbox **)res);
+}
+
+/**
+ * devm_mbox_release() - resource managed mbox_release()
+ * @dev: device for channel consumer
+ * @mbox: MBOX channel
+ *
+ * Release a MBOX channel previously allocated using devm_mbox_request() or
+ * devm_of_mbox_request().  Calling this function is usually not necessary,
+ * as devm-allocated resources are automatically released on driver detach.
+ */
+void devm_mbox_release(struct device *dev, struct mbox *mbox)
+{
+	WARN_ON(devres_release(dev, __devm_mbox_release,
+				devm_mbox_match, mbox));
+}
+EXPORT_SYMBOL(devm_mbox_release);
+
+/**
+ * devm_mbox_request() - resource managed mbox_request()
+ * @dev: device for channel consumer
+ * @con_id: consumer id
+ * @nb: notifier block used for receiving messages
+ *
+ * This function behaves like mbox_request() but the acquired channel
+ * will be automatically released on driver detach.
+ */
+struct mbox *devm_mbox_request(struct device *dev, const char *con_id,
+		struct notifier_block *nb)
+{
+	struct mbox **ptr;
+	struct mbox *mbox;
+
+	ptr = devres_alloc(__devm_mbox_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+	mbox = mbox_request(dev, con_id, nb);
+	if (!IS_ERR(mbox)) {
+		*ptr = mbox;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+	return mbox;
+}
+EXPORT_SYMBOL(devm_mbox_request);
+
+/**
+ * devm_mbox_request() - resource managed of_mbox_request()
+ * @dev: device for channel consumer
+ * @np: device node for lookup
+ * @con_id: consumer id
+ * @nb: notifier block used for receiving messages
+ *
+ * This function behaves like of_mbox_request() but the acquired channel
+ * will be automatically released on driver detach.
+ */
+struct mbox *devm_of_mbox_request(struct device *dev, struct device_node *np,
+		const char *con_id, struct notifier_block *nb)
+{
+	struct mbox **ptr;
+	struct mbox *mbox;
+
+	ptr = devres_alloc(__devm_mbox_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+	mbox = of_mbox_request(np, con_id, nb);
+	if (!IS_ERR(mbox)) {
+		*ptr = mbox;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+	return mbox;
+}
+EXPORT_SYMBOL(devm_of_mbox_request);
diff --git a/include/linux/mbox.h b/include/linux/mbox.h
new file mode 100644
index 0000000..d577b24
--- /dev/null
+++ b/include/linux/mbox.h
@@ -0,0 +1,175 @@
+#ifndef __LINUX_MBOX_H
+#define __LINUX_MBOX_H
+
+#include <linux/notifier.h>
+#include <linux/err.h>
+#include <linux/of.h>
+
+struct mbox_adapter;
+struct mbox_channel;
+
+/**
+ * struct mbox_adapter_ops - MBOX adapter operations
+ * @put_message: hook for putting messages in the channels MBOX
+ * @request: optional hook for requesting an MBOX channel
+ * @release: optional hook for releasing an MBOX channel
+ * @owner: helps prevent removal of modules exporting active MBOX channels
+ */
+struct mbox_adapter_ops {
+	int (*put_message)(struct mbox_adapter *, struct mbox_channel *,
+				const void *, unsigned int);
+	int (*request)(struct mbox_adapter *, struct mbox_channel *);
+	int (*release)(struct mbox_adapter *, struct mbox_channel *);
+	struct module *owner;
+};
+
+struct mbox_channel {
+	unsigned int id;
+	unsigned int users;
+	struct mbox_adapter *adapter;
+	struct atomic_notifier_head notifier;
+};
+
+/**
+ * struct mbox_adapter - MBOX adapter abstraction
+ * @dev: device providing MBOX channels
+ * @ops: callback hooks for this adapter
+ * @nchannels: number of MBOX channels controlled by this adapter
+ * @channels: array of MBOX channels managed internally
+ * @of_xlate: OF translation hook for DT lookups
+ * @of_n_cells: number of cells for DT lookups
+ * @list: list node for internal use
+ * @lock: mutex for internal use
+ */
+struct mbox_adapter {
+	struct device *dev;
+	const struct mbox_adapter_ops *ops;
+	unsigned int nchannels;
+	struct mbox_channel *channels;
+	int (*of_xlate)(struct mbox_adapter *,
+			const struct of_phandle_args *args);
+	unsigned int of_n_cells;
+	struct list_head list;
+	struct mutex lock;
+};
+
+#if IS_ENABLED(CONFIG_MAILBOX)
+
+int mbox_adapter_add(struct mbox_adapter *adap);
+int mbox_adapter_remove(struct mbox_adapter *adap);
+
+int mbox_channel_notify(struct mbox_channel *chan,
+		const void *data, unsigned int len);
+
+#else
+
+static inline int mbox_adapter_add(struct mbox_adapter *adap)
+{
+	return -EINVAL;
+}
+static inline int mbox_adapter_remove(struct mbox_adapter *adap)
+{
+	return -EINVAL;
+}
+
+static inline int mbox_channel_notify(struct mbox_channel *chan,
+		const void *data, unsigned int len)
+{
+	return -EINVAL;
+}
+
+#endif
+
+struct mbox;
+
+#if IS_ENABLED(CONFIG_MAILBOX)
+
+struct mbox *mbox_request(struct device *dev, const char *con_id,
+		struct notifier_block *nb);
+void mbox_release(struct mbox *mbox);
+
+int mbox_put_message(struct mbox *mbox, const void *data, unsigned int len);
+
+struct mbox *of_mbox_request(struct device_node *np, const char *con_id,
+		struct notifier_block *nb);
+
+struct mbox *devm_mbox_request(struct device *dev, const char *con_id,
+		struct notifier_block *nb);
+
+struct mbox *devm_of_mbox_request(struct device *dev, struct device_node *np,
+		const char *con_id, struct notifier_block *nb);
+
+void devm_mbox_release(struct device *dev, struct mbox *mbox);
+
+#else
+
+static inline struct mbox *mbox_request(struct device *dev, const char *con_id,
+		struct notifier_block *nb)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+void mbox_release(struct mbox *mbox)
+{
+}
+
+static inline int mbox_put_message(struct mbox *mbox,
+		const void *data, unsigned int len)
+{
+	return -EINVAL;
+}
+
+static inline struct mbox *of_mbox_request(struct device_node *np,
+		const char *con_id, struct notifier_block *nb)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct mbox *devm_mbox_request(struct device *dev,
+		const char *con_id, struct notifier_block *nb)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct mbox *devm_of_mbox_request(struct device *dev,
+		struct device_node *np, const char *con_id,
+		struct notifier_block *nb)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void devm_mbox_release(struct device *dev, struct mbox *mbox)
+{
+}
+
+#endif
+
+struct mbox_lookup {
+	struct list_head list;
+	const char *provider;
+	unsigned int index;
+	const char *dev_id;
+	const char *con_id;
+};
+
+#define MBOX_LOOKUP(_provider, _index, _dev_id, _con_id)	\
+	{							\
+		.provider = _provider,				\
+		.index = _index,				\
+		.dev_id = _dev_id,				\
+		.con_id = _con_id,				\
+	}
+
+#if IS_ENABLED(CONFIG_MAILBOX)
+
+void mbox_add_table(struct mbox_lookup *table, unsigned int num);
+
+#else
+
+static inline void mbox_add_table(struct mbox_lookup *table, unsigned int num)
+{
+}
+
+#endif
+
+#endif /* __LINUX_MBOX_H */
-- 
1.8.1.5

