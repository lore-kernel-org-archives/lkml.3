Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaFQJPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:15:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52978 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbaFQJPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:15:33 -0400
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [RFC PATCH v4 3/7] thermal: introduce the Power Actor API
Date: Tue, 17 Jun 2014 10:14:49 +0100
Message-Id: <1402996493-3578-4-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402996493-3578-1-git-send-email-javi.merino@arm.com>
References: <1402996493-3578-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 17 Jun 2014 09:15:22.0268 (UTC) FILETIME=[AA8D95C0:01CF8A0C]
X-MC-Unique: 114061710153102401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s5H9FgOw005754

This patch introduces the Power Actor API in the thermal framework.
With it, devices that can report their power consumption and control
it can be registered.  This base interface is meant to be used to
derive specific power actors, such as a cpu power actor.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 Documentation/thermal/power_actor.txt | 56 +++++++++++++++++++++++++++++
 drivers/thermal/Kconfig               |  3 ++
 drivers/thermal/Makefile              |  3 ++
 drivers/thermal/power_actor.c         | 68 +++++++++++++++++++++++++++++++++++
 drivers/thermal/power_actor.h         | 61 +++++++++++++++++++++++++++++++
 5 files changed, 191 insertions(+)
 create mode 100644 Documentation/thermal/power_actor.txt
 create mode 100644 drivers/thermal/power_actor.c
 create mode 100644 drivers/thermal/power_actor.h

diff --git a/Documentation/thermal/power_actor.txt b/Documentation/thermal/power_actor.txt
new file mode 100644
index 000000000000..11ca2d0bf0bd
--- /dev/null
+++ b/Documentation/thermal/power_actor.txt
@@ -0,0 +1,56 @@
+Power Actor API
+===============
+
+The base power actor API is meant to be used to derive specific power
+actors, such as a cpu power actor.  Power actors can be registered by
+calling `power_actor_register()` and should be unregistered by calling
+`power_actor_unregister()` with the `struct power_actor *` received in
+the call to `power_actor_register()`.
+
+This can't be implemented using the cooling device API because:
+
+1.  get_max_state() gives you the maximum cooling state which, for
+    passive devices, is the minimum performance (frequency in case of
+    cpufreq cdev).  get_max_power() gives you the maximum power, which
+    gives you the maximum performance (frequency in the case of CPUs,
+    GPUs and buses)
+
+2.  You need to pass the thermal_zone_device to all the callbacks,
+    something that the current cooling device API doesn't do.
+
+Callbacks
+---------
+
+1. u32 get_req_power(struct power_actor *actor,
+					struct thermal_zone_device *tz)
+@actor: a valid `struct power_actor *` registered with
+        `power_actor_register()`
+@tz:	the thermal zone closest to the actor (typically, the thermal
+		zone the caller is operating on)
+
+`get_req_power()` returns the current requested power in milliwatts.
+
+2. u32 get_max_power(struct power_actor *actor,
+					struct thermal_zone_device *tz)
+@actor: a valid `struct power_actor *` registered with
+        `power_actor_register()`
+@tz:	the thermal zone closest to the actor (typically, the thermal
+		zone the caller is operating on)
+
+`get_max_power()` returns the maximum power that the device could
+consume if it was fully utilized.  It's a function as some devices'
+maximum power consumption can change due to external factors such as
+temperature.
+
+3. int set_power(struct power_actor *actor,
+				struct thermal_zone_device *tz, u32 power)
+@actor: a valid `struct power_actor *` registered with
+        `power_actor_register()`
+@tz:	the thermal zone closest to the actor (typically, the thermal
+		zone the caller is operating on)
+@power: power in milliwatts
+
+`set_power()` should configure the device to consume @power
+milliwatts.
+
+Returns 0 on success, -E* on error.
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index f9a13867cb70..ce4ebe17252c 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -89,6 +89,9 @@ config THERMAL_GOV_USER_SPACE
 	help
 	  Enable this to let the user space manage the platform thermals.
 
+config THERMAL_POWER_ACTOR
+	bool
+
 config CPU_THERMAL
 	bool "generic cpu cooling support"
 	depends on CPU_FREQ
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index de0636a57a64..d83aa42ab573 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -14,6 +14,9 @@ thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
 thermal_sys-$(CONFIG_THERMAL_GOV_STEP_WISE)	+= step_wise.o
 thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)	+= user_space.o
 
+# power actors
+obj-$(CONFIG_THERMAL_POWER_ACTOR) += power_actor.o
+
 # cpufreq cooling
 thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
 
diff --git a/drivers/thermal/power_actor.c b/drivers/thermal/power_actor.c
new file mode 100644
index 000000000000..d4f7bdbe371e
--- /dev/null
+++ b/drivers/thermal/power_actor.c
@@ -0,0 +1,68 @@
+/*
+ * Basic interface for power actors
+ *
+ * Copyright (C) 2014 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) "Power actor: " fmt
+
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#include "power_actor.h"
+
+LIST_HEAD(actor_list);
+DEFINE_MUTEX(actor_list_lock);
+
+/**
+ * power_actor_register() - Register an actor in the power actor API
+ * @ops:	&struct power_actor_ops for this actor
+ * @privdata:	pointer to private data related to the actor
+ *
+ * Return: The &struct power_actor * on success, ERR_PTR() on failure
+ */
+struct power_actor *power_actor_register(struct power_actor_ops *ops,
+					void *privdata)
+{
+	struct power_actor *actor;
+
+	if (!ops->get_req_power || !ops->get_max_power || !ops->set_power)
+		return ERR_PTR(-EINVAL);
+
+	actor = kzalloc(sizeof(*actor), GFP_KERNEL);
+	if (!actor)
+		return ERR_PTR(-ENOMEM);
+
+	actor->ops = ops;
+	actor->data = privdata;
+
+	mutex_lock(&actor_list_lock);
+	list_add(&actor->actor_node, &actor_list);
+	mutex_unlock(&actor_list_lock);
+
+	return actor;
+}
+
+/**
+ * power_actor_unregister() - Unregister an actor
+ * @actor:	the actor to unregister
+ */
+void power_actor_unregister(struct power_actor *actor)
+{
+	mutex_lock(&actor_list_lock);
+	list_del(&actor->actor_node);
+	mutex_unlock(&actor_list_lock);
+
+	kfree(actor);
+}
diff --git a/drivers/thermal/power_actor.h b/drivers/thermal/power_actor.h
new file mode 100644
index 000000000000..d3ae3ea80387
--- /dev/null
+++ b/drivers/thermal/power_actor.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) 2014 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __POWER_ACTOR_H__
+#define __POWER_ACTOR_H__
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+
+struct power_actor;
+
+/**
+ * struct power_actor_ops - callbacks for power actors
+ * @get_req_power:	return the current requested power in milliwatts
+ * @get_max_power:	return the max power that the device can currently
+ *			consume in milliwatts
+ * @set_power:		configure the device to consume a certain power in
+ *			milliwatts
+ */
+struct power_actor_ops {
+	u32 (*get_req_power)(struct power_actor *,
+			struct thermal_zone_device *);
+	u32 (*get_max_power)(struct power_actor *,
+			struct thermal_zone_device *);
+	int (*set_power)(struct power_actor *, struct thermal_zone_device *,
+			u32);
+};
+
+/**
+ * struct power_actor - structure for a power actor
+ * @ops:	callbacks for the power actor
+ * @data:	a private pointer for type-specific data
+ * @actor_node:	node in actor_list
+ */
+struct power_actor {
+	struct power_actor_ops *ops;
+	void *data;
+	struct list_head actor_node;
+};
+
+struct power_actor *power_actor_register(struct power_actor_ops *ops,
+					void *privdata);
+void power_actor_unregister(struct power_actor *actor);
+
+extern struct list_head actor_list;
+extern struct mutex actor_list_lock;
+
+#endif /* __POWER_ACTOR_H__ */
-- 
1.9.1


