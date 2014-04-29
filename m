Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188AbaD2TuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:50:19 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:35675 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965168AbaD2TuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:50:15 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, m.chehab@samsung.com, tj@kernel.org,
        olebowle@gmx.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 1/4] drivers/base: add managed token devres interfaces
Date: Tue, 29 Apr 2014 13:49:23 -0600
Message-Id: <6cb20ce23f540c883e60e6ce71302042b034c4aa.1398797955.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1398797954.git.shuah.kh@samsung.com>
References: <cover.1398797954.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1398797954.git.shuah.kh@samsung.com>
References: <cover.1398797954.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Media devices often have hardware resources that are shared
across several functions. These devices appear as a group of
independent devices. Each device implements a function which
could be shared by one or more functions supported by the same
device. For example, tuner is shared by analog and digital TV
functions.

Media drivers that control a single media TV stick are a
diversified group. Analog and digital TV function drivers have
to coordinate access to their shared functions.

Some media devices provide multiple almost-independent functions.
USB and PCI core aids in allowwing multiple drivers to handle these
almost-independent functions. In this model, a em28xx device could
have snd-usb-audio driving the audio function.

As a result, snd-usb-audio driver has to coordinate with the em28xx_*
analog and digital function drivers.

A shared managed resource framework at drivers/base level will
allow a media device to be controlled by drivers that don't
fall under drivers/media and share functions with other media
drivers.

A token devres that can be looked up by a token for locking, try
locking, unlocking will help avoid adding data structure
dependencies between various drivers. This token is a unique
string that can be constructed from a common data structure such as
struct device, bus_name, and hardware address.

The devm_token_* interfaces manage access to token resource.

Interfaces:
    devm_token_create()
    devm_token_destroy()
    devm_token_lock()
    devm_token_unlock()
Usage:
    Create token: Call devm_token_create() with a token id string.
    Lock token: Call devm_token_lock() to lock or try lock a token.
    Unlock token: Call devm_token_unlock().
    Destroy token: Call devm_token_destroy() to delete the token.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/Makefile        |    2 +-
 drivers/base/token_devres.c  |  146 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/token_devres.h |   19 ++++++
 3 files changed, 166 insertions(+), 1 deletion(-)
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
index 0000000..4644642
--- /dev/null
+++ b/drivers/base/token_devres.c
@@ -0,0 +1,146 @@
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
+struct token_devres {
+	struct mutex	lock;
+	bool		in_use;
+	char		id[];
+};
+
+static int devm_token_match(struct device *dev, void *res, void *data)
+{
+	struct token_devres *tkn = res;
+
+	/* compare the token data and return 1 if it matches */
+	return !strcmp(tkn->id, data);
+}
+
+static void devm_token_release(struct device *dev, void *res)
+{
+	struct token_devres *tkn = res;
+
+	mutex_destroy(&tkn->lock);
+}
+
+/* creates a token devres and marks it available */
+int devm_token_create(struct device *dev, const char *id)
+{
+	struct token_devres *tkn;
+	size_t tkn_size;
+
+	tkn_size = sizeof(struct token_devres) + strlen(id) + 1;
+	tkn = devres_alloc(devm_token_release, tkn_size, GFP_KERNEL);
+	if (!tkn)
+		return -ENOMEM;
+
+	strcpy(tkn->id, id);
+	tkn->in_use = false;
+	mutex_init(&tkn->lock);
+
+	devres_add(dev, tkn);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_token_create);
+
+/* If token is available, lock it for the caller, If not return -EBUSY */
+int devm_token_lock(struct device *dev, const char *id)
+{
+	struct token_devres *tkn_ptr;
+	int rc = 0;
+
+	tkn_ptr = devres_find(dev, devm_token_release, devm_token_match,
+				(void *)id);
+	if (tkn_ptr == NULL)
+		return -ENODEV;
+
+	if (!mutex_trylock(&tkn_ptr->lock))
+		return -EBUSY;
+
+	if (tkn_ptr->in_use)
+		rc = -EBUSY;
+	else
+		tkn_ptr->in_use = true;
+
+	mutex_unlock(&tkn_ptr->lock);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(devm_token_lock);
+
+/* If token is locked, unlock */
+int devm_token_unlock(struct device *dev, const char *id)
+{
+	struct token_devres *tkn_ptr;
+
+	tkn_ptr = devres_find(dev, devm_token_release, devm_token_match,
+				(void *) id);
+	if (tkn_ptr == NULL)
+		return -ENODEV;
+
+	mutex_lock(&tkn_ptr->lock);
+	tkn_ptr->in_use = false;
+	mutex_unlock(&tkn_ptr->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_token_unlock);
+
+/* destroy an existing token */
+int devm_token_destroy(struct device *dev, const char *id)
+{
+	int rc;
+
+	rc = devres_release(dev, devm_token_release, devm_token_match,
+				(void *) id);
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

