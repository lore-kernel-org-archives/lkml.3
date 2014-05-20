Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaETN5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:57:06 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:40953 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaETN5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:03 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 04/16] drm: sti: add I2C client driver for HDMI
Date: Tue, 20 May 2014 15:56:14 +0200
Message-Id: <1400594186-8956-5-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C client driver to retrieve EDID.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/Makefile  |  3 ++-
 drivers/gpu/drm/sti/sti_ddc.c | 56 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/sti/sti_ddc.c

diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index 5295fc7..6c474eb 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -2,7 +2,8 @@ ccflags-y := -Iinclude/drm
 
 stidrm-y := sti_hdmi.o \
 			sti_hdmi_tx3g0c55phy.o \
-			sti_hdmi_tx3g4c28phy.o
+			sti_hdmi_tx3g4c28phy.o \
+			sti_ddc.o
 
 obj-$(CONFIG_VTAC_STI) += sti_vtac_tx.o sti_vtac_rx.o
 obj-$(CONFIG_VTG_STI) += sti_vtg.o sti_vtg_utils.o
diff --git a/drivers/gpu/drm/sti/sti_ddc.c b/drivers/gpu/drm/sti/sti_ddc.c
new file mode 100644
index 0000000..147a704
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_ddc.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+#include <drm/drmP.h>
+
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+
+#include "sti_hdmi.h"
+
+static int sti_hdmi_ddc_probe(struct i2c_client *client,
+			      const struct i2c_device_id *dev_id)
+{
+	sti_hdmi_attach_ddc_client(client);
+
+	DRM_INFO("%s attached %s into i2c adapter successfully\n",
+		 __func__, client->name);
+
+	return 0;
+}
+
+static int sti_hdmi_ddc_remove(struct i2c_client *client)
+{
+	DRM_INFO("%s detached %s from i2c adapter successfully\n",
+		 __func__, client->name);
+
+	return 0;
+}
+
+static struct i2c_device_id sti_ddc_idtable[] = {
+	{"sti-hdmiddc", 0},
+	{},
+};
+
+static struct of_device_id hdmiddc_match_types[] = {
+	{
+	 .compatible = "st,sti-hdmiddc",
+	 }, {
+	     /* end node */
+	     }
+};
+
+struct i2c_driver ddc_driver = {
+	.driver = {
+		   .name = "sti-hdmiddc",
+		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(hdmiddc_match_types),
+		   },
+	.id_table = sti_ddc_idtable,
+	.probe = sti_hdmi_ddc_probe,
+	.remove = sti_hdmi_ddc_remove,
+	.command = NULL,
+};
-- 
1.9.1

