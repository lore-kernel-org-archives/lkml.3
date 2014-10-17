Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaJQNOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:14:23 -0400
Received: from mail.logicbricks.com ([89.201.165.134]:17285 "EHLO
	mail.logicbricks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaJQNM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:12:59 -0400
From: Davor Joja <davorjoja@logicbricks.com>
To: <linux-kernel@vger.kernel.org>
CC: Davor Joja <davorjoja@logicbricks.com>
Subject: [PATCH 04/10] fbdev: xylon: Framebuffer driver pixel clock
Date: Fri, 17 Oct 2014 15:06:55 +0200
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413551221-15187-1-git-send-email-davorjoja@logicbricks.com>
References: <1413551221-15187-1-git-send-email-davorjoja@logicbricks.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.0.95]
Message-ID: <06278195-f6b2-49e5-8bb8-70807594077e@mail.xylon.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver pixel clock control functionality supporting Xylon logiCLK IP
core clock generator.

Signed-off-by: Davor Joja <davorjoja@logicbricks.com>
---
 drivers/video/fbdev/xylon/xylonfb_pixclk.c | 115 +++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)
 create mode 100644 drivers/video/fbdev/xylon/xylonfb_pixclk.c

diff --git a/drivers/video/fbdev/xylon/xylonfb_pixclk.c b/drivers/video/fbdev/xylon/xylonfb_pixclk.c
new file mode 100644
index 0000000..5f82b50
--- /dev/null
+++ b/drivers/video/fbdev/xylon/xylonfb_pixclk.c
@@ -0,0 +1,115 @@
+/*
+ * Xylon logiCVC frame buffer driver pixel clock control
+ *
+ * Copyright (C) 2014 Xylon d.o.o.
+ * Author: Davor Joja <davor.joja@logicbricks.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+
+struct xylonfb_pixclk {
+	struct device *dev;
+	struct device_node *dn;
+	struct clk *clk;
+};
+
+#if defined(CONFIG_FB_XYLON_PIXCLK_LOGICLK)
+static const struct of_device_id logiclk_of_match[] = {
+	{ .compatible = "xylon,logiclk-1.02.b" },
+	{/* end of table */}
+};
+static struct xylonfb_pixclk logiclk;
+#endif
+
+bool xylonfb_hw_pixclk_supported(struct device *dev, struct device_node *dn);
+void xylonfb_hw_pixclk_unload(struct device_node *dn);
+int xylonfb_hw_pixclk_set(struct device *dev, struct device_node *dn,
+			  unsigned long pixclk_khz);
+
+#if defined(CONFIG_FB_XYLON_PIXCLK)
+static int xylonfb_hw_pixclk_set_freq(struct device *dev,
+				      struct device_node *dn,
+				      unsigned long freq_khz)
+{
+	struct clk *clk = NULL;
+
+#if defined(CONFIG_FB_XYLON_PIXCLK_LOGICLK)
+	if (dn == logiclk.dn)
+		clk = logiclk.clk;
+#endif
+
+	if (clk && clk_set_rate(clk, (freq_khz * 1000))) {
+		dev_err(dev, "failed set pixel clock frequency\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+#endif
+
+bool xylonfb_hw_pixclk_supported(struct device *dev, struct device_node *dn)
+{
+	struct clk **clk;
+	bool clk_dev = false;
+
+#if defined(CONFIG_FB_XYLON_PIXCLK_LOGICLK)
+	if (of_match_node(logiclk_of_match, of_get_parent(dn))) {
+		clk = &logiclk.clk;
+		logiclk.dev = dev;
+		logiclk.dn = dn;
+		clk_dev = true;
+	}
+#endif
+
+	if (clk_dev) {
+		*clk = devm_clk_get(dev, NULL);
+		if (IS_ERR(*clk)) {
+			dev_err(dev, "failed get pixel clock\n");
+			return false;
+		}
+		if (clk_prepare_enable(*clk)) {
+			dev_err(dev,
+				"failed prepare/enable pixel clock\n");
+			return false;
+		}
+
+		return true;
+	} else {
+		return false;
+	}
+}
+
+void xylonfb_hw_pixclk_unload(struct device_node *dn)
+{
+	struct clk *clk = NULL;
+
+#if defined(CONFIG_FB_XYLON_PIXCLK_LOGICLK)
+	clk = logiclk.clk;
+#endif
+
+	if (clk)
+		clk_disable_unprepare(clk);
+}
+
+int xylonfb_hw_pixclk_set(struct device *dev, struct device_node *dn,
+			  unsigned long pixclk_khz)
+{
+#if defined(CONFIG_FB_XYLON_PIXCLK)
+	return xylonfb_hw_pixclk_set_freq(dev, dn, pixclk_khz);
+#else
+	dev_warn(dev, "pixel clock control not supported\n");
+	return -ENODEV;
+#endif
+}
-- 
1.9.1

