Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbaDQL3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:29:53 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37883 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbaDQL3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:29:45 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-ae-534fbb26c268
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        Tomasz Figa <t.figa@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/S5P EXYNOS
	AR...),
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 2/3] drivers/base: provide lightweight framework for
 componentized devices
Date: Thu, 17 Apr 2014 13:28:49 +0200
Message-id: <1397734130-21019-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397734130-21019-1-git-send-email-a.hajda@samsung.com>
References: <1397734130-21019-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xq7pqu/2DDTbsk7S4te4cq0XvuZNM
	Fn8nHWO3uPL1PZtF8+L1bBaT7k9gsTjb9IbdYtPja6wWl3fNYbOYcX4fk8Xty7wWa4/cZbdY
	P+M1iwOvR0tzD5vH71+TGD22f3vA6rF/7hp2j/vdx5k8Ni+p9+jbsorR4/MmuQCOKC6blNSc
	zLLUIn27BK6MZ59DC7q1KpY+PMHcwPhRqYuRk0NCwERi2ufNrBC2mMSFe+vZuhi5OIQEljJK
	zDy8mhnC6WOSeDVtOyNIFZuApsTfzTfZQGwRAWWJvxNXMYIUMQtsZ5FoOjoRLCEskCAx7d82
	li5GDg4WAVWJvk1VIGFeAWeJW42dUNsUJJZ9WcsMYnMKuEi8+9fFClIuBFTz/a/tBEbeBYwM
	qxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCAvXLDsbFx6wOMQpwMCrx8HL89gsWYk0sK67M
	PcQowcGsJMLbvN4/WIg3JbGyKrUoP76oNCe1+BAjEwenVAPjzBMSet+6xL6cm5sp2/trUtzE
	gxNcU306HphX9s76d9i4P2HqTE9+v9mGu070cUs1T5gUe2un7WFNkxkv/9hfecvBZ6syb/Xe
	//E7laY6sxx7plrWJ5L7dpKxsZjiZO5ZNff6OOSd7SUWOTMecM6TeGrYqSd3TmvvnVU7zD1O
	7GyYOdXEVsRdiaU4I9FQi7moOBEA+UYTXTICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many subsystems (eg. DRM, ALSA) requires that multiple devices should
be composed into one superdevice. The superdevice cannot start until
all components are ready and it should stop before any of its components
becomes not-ready.
This framework provides a way to track readiness of all components with
minimal impact on the code of the drivers.
The superdevice provides pending_components structure and adds all components
to it, device drivers removes themselves from the list if they becomes ready.
If the list becomes empty callback is fired which causes superdevice to start.
Later if any components wants to become not-ready it adds again itself to the
list and callback is fired to stop superdevice.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/base/Kconfig               |  3 ++
 drivers/base/Makefile              |  1 +
 drivers/base/pending_components.c  | 93 ++++++++++++++++++++++++++++++++++++++
 include/linux/pending_components.h | 30 ++++++++++++
 4 files changed, 127 insertions(+)
 create mode 100644 drivers/base/pending_components.c
 create mode 100644 include/linux/pending_components.h

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index ec36e77..71ce050 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -278,4 +278,7 @@ config CMA_AREAS
 
 endif
 
+config PENDING_COMPONENTS
+	boolean
+
 endmenu
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 04b314e..3a51654 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 obj-$(CONFIG_REGMAP)	+= regmap/
 obj-$(CONFIG_SOC_BUS) += soc.o
 obj-$(CONFIG_PINCTRL) += pinctrl.o
+obj-$(CONFIG_PENDING_COMPONENTS) += pending_components.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
diff --git a/drivers/base/pending_components.c b/drivers/base/pending_components.c
new file mode 100644
index 0000000..f15104e
--- /dev/null
+++ b/drivers/base/pending_components.c
@@ -0,0 +1,93 @@
+/*
+ * Lightweight framework for handling componentized devices.
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * pending_components structure contains list of components which are not yet
+ * ready. Components can remove or add themselves from/to the list. If the list
+ * becomes empty/non-empty optional callback is fired.
+*/
+
+#include <linux/pending_components.h>
+#include <linux/slab.h>
+
+struct pending_components_node {
+	struct list_head list;
+	void *data;
+};
+
+int pending_components_insert(struct pending_components *set, void *item)
+{
+	struct pending_components_node *n;
+	int ret = 0;
+
+	mutex_lock(&set->lock);
+
+	list_for_each_entry(n, &set->list, list) {
+		if (n->data == item)
+			goto out;
+	}
+
+	n = kmalloc(sizeof(*n), GFP_KERNEL);
+	if (!n) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	n->data = item;
+	list_add_tail(&n->list, &set->list);
+	if (set->callback && set->list.next == set->list.prev)
+		ret = set->callback(set, false);
+
+out:
+	mutex_unlock(&set->lock);
+
+	return ret;
+}
+
+int pending_components_delete(struct pending_components *set, void *item)
+{
+	struct pending_components_node *n;
+	int ret = 0;
+
+	mutex_lock(&set->lock);
+
+	list_for_each_entry(n, &set->list, list) {
+		if (n->data == item) {
+			list_del(&n->list);
+			kfree(n);
+			if (set->callback && list_empty(&set->list))
+				ret = set->callback(set, true);
+			break;
+		}
+	}
+
+	mutex_unlock(&set->lock);
+
+	return ret;
+}
+
+void pending_components_set_callback(struct pending_components *set,
+				     pending_components_callback cb)
+{
+	mutex_lock(&set->lock);
+
+	set->callback = cb;
+
+	mutex_unlock(&set->lock);
+}
+
+void pending_components_cleanup(struct pending_components *set)
+{
+	struct pending_components_node *n, *tmp;
+
+	list_for_each_entry_safe(n, tmp, &set->list, list) {
+		list_del(&n->list);
+		kfree(n);
+	}
+}
diff --git a/include/linux/pending_components.h b/include/linux/pending_components.h
new file mode 100644
index 0000000..dd29616
--- /dev/null
+++ b/include/linux/pending_components.h
@@ -0,0 +1,30 @@
+#ifndef PENDING_COMPONENTS_H
+#define PENDING_COMPONENTS_H
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+
+struct pending_components;
+
+typedef int (*pending_components_callback)(struct pending_components *set,
+					   bool empty);
+
+struct pending_components {
+	struct mutex lock;
+	struct list_head list;
+	pending_components_callback callback;
+};
+
+#define DEFINE_PENDING_COMPONENTS(set) \
+	struct pending_components set = { \
+		.lock = __MUTEX_INITIALIZER(set.lock), \
+		.list = LIST_HEAD_INIT(set.list) \
+	}
+
+int pending_components_insert(struct pending_components *set, void *item);
+int pending_components_delete(struct pending_components *set, void *item);
+void pending_components_set_callback(struct pending_components *set,
+				     pending_components_callback cb);
+void pending_components_cleanup(struct pending_components *set);
+
+#endif /* PENDING_COMPONENTS_H */
-- 
1.8.3.2

