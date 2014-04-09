Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbaDIPWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:22:14 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:51749
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933829AbaDIPVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:21:31 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, m.chehab@samsung.com, tj@kernel.org,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFC PATCH 2/2] drivers/base: add managed token devres interfaces
Date: Wed,  9 Apr 2014 09:21:08 -0600
Message-Id: <5f21c7e53811aba63f86bcf3e3bfdfdd5aeedf59.1397050852.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1397050852.git.shuah.kh@samsung.com>
References: <cover.1397050852.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1397050852.git.shuah.kh@samsung.com>
References: <cover.1397050852.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Media devices often have hardware resources that are shared
across several functions. For instance, TV tuner cards often
have MUXes, converters, radios, tuners, etc. that are shared
across various functions. However, v4l2, alsa, DVB, usbfs, and
all other drivers have no knowledge of what resources are
shared. For example, users can't access DVB and alsa at the same
time, or the DVB and V4L analog API at the same time, since many
only have one converter that can be in either analog or digital
mode. Accessing and/or changing mode of a converter while it is
in use by another function results in video stream error.

A shared devres that can be locked and unlocked by various drivers
that control media functions on a single media device is needed to
address the above problems.

A token devres that can be looked up by a token for locking, try
locking, unlocking will help avoid adding data structure
dependencies between various media drivers. This token is a unique
string that can be constructed from a common data structure such as
struct device, bus_name, and hardware address.

The devm_token_* interfaces manage access to token resource.

Interfaces:
    devm_token_create()
    devm_token_destroy()
    devm_token_lock()
    devm_token_unlock()
Usage:
    Create token:
        Call devm_token_create() with a token id which is a unique
        string.
    Lock token: Call devm_token_lock() to lock or try lock a token.
    Unlock token: Call devm_token_unlock().
    Destroy token: Call devm_token_destroy() to delete the token.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/Makefile        |    2 +-
 drivers/base/token_devres.c  |  204 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/token_devres.h |   19 ++++
 3 files changed, 224 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/token_devres.c
 create mode 100644 include/linux/token_devres.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 04b314e..924665b 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o container.o
+			   topology.o container.o token_devres.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
diff --git a/drivers/base/token_devres.c b/drivers/base/token_devres.c
new file mode 100644
index 0000000..e7436c5
--- /dev/null
+++ b/drivers/base/token_devres.c
@@ -0,0 +1,204 @@
+/*
+ * drivers/base/token_devres.c - managed token resource
+ *
+ * Copyright (c) 2014 Shuah Khan <shuah.kh@samsung.com>
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ */
+/*
+ * Media devices often have hardware resources that are shared
+ * across several functions. For instance, TV tuner cards often
+ * have MUXes, converters, radios, tuners, etc. that are shared
+ * across various functions. However, v4l2, alsa, DVB, usbfs, and
+ * all other drivers have no knowledge of what resources are
+ * shared. For example, users can't access DVB and alsa at the same
+ * time, or the DVB and V4L analog API at the same time, since many
+ * only have one converter that can be in either analog or digital
+ * mode. Accessing and/or changing mode of a converter while it is
+ * in use by another function results in video stream error.
+ *
+ * A shared devres that can be locked and unlocked by various drivers
+ * that control media functions on a single media device is needed to
+ * address the above problems.
+ *
+ * A token devres that can be looked up by a token for locking, try
+ * locking, unlocking will help avoid adding data structure
+ * dependencies between various media drivers. This token is a unique
+ * string that can be constructed from a common data structure such as
+ * struct device, bus_name, and hardware address.
+ *
+ * The devm_token_* interfaces manage access to token resource.
+ *
+ * Interfaces:
+ *	devm_token_create()
+ *	devm_token_destroy()
+ *	devm_token_lock()
+ *	devm_token_unlock()
+ * Usage:
+ *	Create token:
+ *		Call devm_token_create() with a token id which is
+ *		a unique string.
+ *	Lock token:
+ *		Call devm_token_lock() to lock or try lock a token.
+ *	Unlock token:
+ *		Call devm_token_unlock().
+ *	Destroy token:
+ *		Call devm_token_destroy() to delete the token.
+ *
+*/
+#include <linux/device.h>
+#include <linux/token_devres.h>
+
+#define TOKEN_DEVRES_FREE	0
+#define TOKEN_DEVRES_BUSY	1
+
+struct token_devres {
+	int	status;
+	char	id[];
+};
+
+struct tkn_match {
+	int	status;
+	const	char *id;
+};
+
+static void __devm_token_lock(struct device *dev, void *data)
+{
+	struct token_devres *tptr = data;
+
+	if (tptr && tptr->status == TOKEN_DEVRES_FREE)
+		tptr->status = TOKEN_DEVRES_BUSY;
+
+	return;
+}
+
+static void __devm_token_unlock(struct device *dev, void *data)
+{
+	struct token_devres *tptr = data;
+
+	if (tptr && tptr->status == TOKEN_DEVRES_BUSY)
+		tptr->status = TOKEN_DEVRES_FREE;
+
+	return;
+}
+
+static int devm_token_match(struct device *dev, void *res, void *data)
+{
+	struct token_devres *tkn = res;
+	struct tkn_match *mptr = data;
+	int rc;
+
+	if (!tkn || !data) {
+		WARN_ON(!tkn || !data);
+		return 0;
+	}
+
+	/* compare the token data and return 1 if it matches */
+	if (strcmp(tkn->id, mptr->id) == 0)
+			rc = 1;
+	else
+		rc = 0;
+
+	return rc;
+}
+
+static void devm_token_release(struct device *dev, void *res)
+{
+	dev_info(dev, "devm_token_release(): release token\n");
+	return;
+}
+
+/* creates a token devres and marks it free */
+int devm_token_create(struct device *dev, const char *id)
+{
+	struct token_devres *tkn;
+	size_t tkn_size;
+
+	if (!id)
+		return -EFAULT;
+
+	tkn_size = sizeof(struct token_devres) + strlen(id) + 1;
+	tkn = devres_alloc(devm_token_release, tkn_size, GFP_KERNEL);
+	if (!tkn)
+		return -ENOMEM;
+
+	strcpy(tkn->id, id);
+	tkn->status = TOKEN_DEVRES_FREE;
+
+	devres_add(dev, tkn);
+
+	dev_info(dev, "devm_token_create(): created token: %s\n", id);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_token_create);
+
+/* If token is available, lock it for the caller, If not return -EBUSY */
+int devm_token_lock(struct device *dev, const char *id)
+{
+	struct token_devres *tkn_ptr;
+	struct tkn_match tkn;
+	int rc = 0;
+
+	if (!id)
+		return -EFAULT;
+
+	tkn.id = id;
+
+	tkn_ptr = devres_find(dev, devm_token_release, devm_token_match, &tkn);
+	if (tkn_ptr == NULL)
+		return -ENODEV;
+
+	if (tkn_ptr->status == TOKEN_DEVRES_FREE) {
+		devres_update(dev, devm_token_release, devm_token_match,
+				&tkn, __devm_token_lock);
+		rc = 0;
+	} else
+		rc = -EBUSY;
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(devm_token_lock);
+
+/* If token is locked, unlock */
+int devm_token_unlock(struct device *dev, const char *id)
+{
+	struct token_devres *tkn_ptr;
+	struct tkn_match tkn;
+
+	if (!id)
+		return -EFAULT;
+
+	tkn.id = id;
+
+	tkn_ptr = devres_find(dev, devm_token_release, devm_token_match, &tkn);
+	if (tkn_ptr == NULL)
+		return -ENODEV;
+
+	if (tkn_ptr->status == TOKEN_DEVRES_BUSY) {
+		devres_update(dev, devm_token_release, devm_token_match,
+				&tkn, __devm_token_unlock);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_token_unlock);
+
+/* destroy an existing token */
+int devm_token_destroy(struct device *dev, const char *id)
+{
+	struct tkn_match tkn;
+	int rc;
+
+	if (!id)
+		return -EFAULT;
+
+	tkn.id = id;
+
+	rc = devres_release(dev, devm_token_release, devm_token_match, &tkn);
+	WARN_ON(rc);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_token_destroy);
diff --git a/include/linux/token_devres.h b/include/linux/token_devres.h
new file mode 100644
index 0000000..e411fd5
--- /dev/null
+++ b/include/linux/token_devres.h
@@ -0,0 +1,19 @@
+/*
+ * token_devres.h - managed token resource
+ *
+ * Copyright (c) 2014 Shuah Khan <shuah.kh@samsung.com>
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ */
+#ifndef __LINUX_TOKEN_DEVRES_H
+#define __LINUX_TOKEN_DEVRES_H
+
+struct device;
+
+extern int devm_token_create(struct device *dev, const char *id);
+extern int devm_token_lock(struct device *dev, const char *id);
+extern int devm_token_unlock(struct device *dev, const char *id);
+extern int devm_token_destroy(struct device *dev, const char *id);
+
+#endif	/* __LINUX_TOKEN_DEVRES_H */
-- 
1.7.10.4

