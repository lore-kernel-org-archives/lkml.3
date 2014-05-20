Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaETN6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:58:13 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35347 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaETN5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:21 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 14/16] drm: sti: add debug to TVout
Date: Tue, 20 May 2014 15:56:24 +0200
Message-Id: <1400594186-8956-15-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use debugfs to dump information about TVout

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/sti_tvout.c | 181 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 181 insertions(+)

diff --git a/drivers/gpu/drm/sti/sti_tvout.c b/drivers/gpu/drm/sti/sti_tvout.c
index 3e679a0..fb199c4 100644
--- a/drivers/gpu/drm/sti/sti_tvout.c
+++ b/drivers/gpu/drm/sti/sti_tvout.c
@@ -18,6 +18,7 @@
 #include "sti_tvout.h"
 #include "sti_hdmi.h"
 #include "sti_hda.h"
+#include "sti_drm_drv.h"
 
 /* glue regsiters */
 #define TVO_CSC_MAIN_M0                  0x000
@@ -605,6 +606,186 @@ void sti_tvout_disable(struct sti_tvout *tvout,
 			connector->stop(connector);
 }
 
+/*
+ * Debugfs
+ */
+#define TVOUT_DBG_DUMP(reg) seq_printf(m, "\n %-25s 0x%08X", #reg, \
+		readl(tvout->regs + reg))
+#define TVOUT_CONNECTOR_NAME_MAX_LENGHT 10
+#define MAX_STRING_LENGTH 55
+
+static int sti_tvout_dbg_type_to_connector_name(enum sti_tvout_connector_type
+						type, char *name)
+{
+	switch (type) {
+	case STI_TVOUT_CONNECTOR_HDMI:
+		snprintf(name, TVOUT_CONNECTOR_NAME_MAX_LENGHT, "HDMI");
+		break;
+	case STI_TVOUT_CONNECTOR_HDA:
+		snprintf(name, TVOUT_CONNECTOR_NAME_MAX_LENGHT, "HD Analog");
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static void tvout_dbg_vip(struct seq_file *m, int val)
+{
+	int r, g, b, tmp, mask;
+	char str[MAX_STRING_LENGTH];
+	static const char *const reorder[] = { "Y_G", "Cb_B", "Cr_R" };
+	static const char *const clipping[] = { "No", "EAV/SAV",
+		"Limited range RGB/Y", "Limited range Cb/Cr",
+		"decided by register" };
+	static const char *const round[] = { "8-bit", "10-bit", "12-bit" };
+	static const char *const input_sel[] = { "Main (color matrix enabled)",
+		"Main (color matrix by-passed)", "", "", "", "", "", "",
+		"Aux (color matrix enabled)", "Aux (color matrix by-passed)",
+		"", "", "", "", "", "Force value"
+	};
+
+	seq_puts(m, "\t");
+
+	mask = TVO_VIP_REORDER_MASK << TVO_VIP_REORDER_R_SHIFT;
+	r = (val & mask) >> TVO_VIP_REORDER_R_SHIFT;
+	mask = TVO_VIP_REORDER_MASK << TVO_VIP_REORDER_G_SHIFT;
+	g = (val & mask) >> TVO_VIP_REORDER_G_SHIFT;
+	mask = TVO_VIP_REORDER_MASK << TVO_VIP_REORDER_B_SHIFT;
+	b = (val & mask) >> TVO_VIP_REORDER_B_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "Reorder: %s->%s %s->%s %s->%s",
+		 reorder[r], reorder[TVO_VIP_REORDER_CR_R_SEL],
+		 reorder[g], reorder[TVO_VIP_REORDER_Y_G_SEL],
+		 reorder[b], reorder[TVO_VIP_REORDER_CB_B_SEL]);
+	seq_printf(m, "%-55s", str);
+
+	mask = TVO_VIP_CLIP_MASK << TVO_VIP_CLIP_SHIFT;
+	tmp = (val & mask) >> TVO_VIP_CLIP_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "Clipping: %s", clipping[tmp]);
+	seq_printf(m, "%-55s", str);
+
+	seq_printf(m, "\n%-40s", "");
+
+	mask = TVO_VIP_RND_MASK << TVO_VIP_RND_SHIFT;
+	tmp = (val & mask) >> TVO_VIP_RND_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH,
+		 "Round: input data rounded to %s per component", round[tmp]);
+	seq_printf(m, "%-55s", str);
+
+	tmp = (val & TVO_VIP_SEL_INPUT_MASK);
+	snprintf(str, MAX_STRING_LENGTH, "Input selection: %s", input_sel[tmp]);
+	seq_printf(m, "%-55s", str);
+}
+
+static void tvout_dbg_hd_dac_cfg(struct seq_file *m, int val)
+{
+	seq_puts(m, "\t HD DAC ");
+	seq_puts(m, val & 1 ? "disabled" : "enabled");
+}
+
+static int tvout_dbg_show(struct seq_file *m,
+			  enum sti_tvout_connector_type type)
+{
+	struct drm_info_node *node = (struct drm_info_node *)m->private;
+	struct drm_device *dev = node->minor->dev;
+	struct sti_drm_private *dev_priv = dev->dev_private;
+	struct sti_tvout *tvout = dev_priv->tvout;
+	struct sti_tvout_connector *connector = tvout->connector[type];
+	char name[TVOUT_CONNECTOR_NAME_MAX_LENGHT];
+	int ret;
+
+	if (!connector)
+		return -1;
+
+	if (!connector->is_enabled)
+		return -1;
+
+	ret = mutex_lock_interruptible(&dev->struct_mutex);
+	if (ret)
+		return ret;
+
+	if (tvout == NULL) {
+		seq_puts(m, "No tvout available");
+		goto out;
+	}
+
+	ret = sti_tvout_dbg_type_to_connector_name(type, name);
+	if (ret) {
+		seq_puts(m, "No connector!");
+		goto out;
+	}
+
+	seq_printf(m, "\n%s connector: ", name);
+	seq_printf(m, "\nTVOUT: (virt base addr = 0x%p)", tvout->regs);
+	if (connector->is_enabled(connector)) {
+		if (connector->main_path) {
+			seq_puts(m, "\n Connected to the main path");
+			TVOUT_DBG_DUMP(TVO_CSC_MAIN_M0);
+			TVOUT_DBG_DUMP(TVO_CSC_MAIN_M1);
+			TVOUT_DBG_DUMP(TVO_CSC_MAIN_M2);
+			TVOUT_DBG_DUMP(TVO_CSC_MAIN_M3);
+			TVOUT_DBG_DUMP(TVO_CSC_MAIN_M4);
+			TVOUT_DBG_DUMP(TVO_CSC_MAIN_M5);
+			TVOUT_DBG_DUMP(TVO_CSC_MAIN_M6);
+			TVOUT_DBG_DUMP(TVO_CSC_MAIN_M7);
+			TVOUT_DBG_DUMP(TVO_MAIN_IN_VID_FORMAT);
+		} else {
+			seq_puts(m, "\n Connected to the auxiliary path");
+			TVOUT_DBG_DUMP(TVO_CSC_AUX_M0);
+			TVOUT_DBG_DUMP(TVO_CSC_AUX_M2);
+			TVOUT_DBG_DUMP(TVO_CSC_AUX_M3);
+			TVOUT_DBG_DUMP(TVO_CSC_AUX_M4);
+			TVOUT_DBG_DUMP(TVO_CSC_AUX_M5);
+			TVOUT_DBG_DUMP(TVO_CSC_AUX_M6);
+			TVOUT_DBG_DUMP(TVO_CSC_AUX_M7);
+			TVOUT_DBG_DUMP(TVO_AUX_IN_VID_FORMAT);
+		}
+	} else
+		seq_puts(m, " Disabled");
+
+	switch (type) {
+	case STI_TVOUT_CONNECTOR_HDMI:
+		TVOUT_DBG_DUMP(TVO_VIP_HDMI);
+		tvout_dbg_vip(m, readl(tvout->regs + TVO_VIP_HDMI));
+		TVOUT_DBG_DUMP(TVO_HDMI_FORCE_COLOR_0);
+		TVOUT_DBG_DUMP(TVO_HDMI_FORCE_COLOR_1);
+		TVOUT_DBG_DUMP(TVO_HDMI_CLIP_VALUE_B_CB);
+		TVOUT_DBG_DUMP(TVO_HDMI_CLIP_VALUE_Y_G);
+		TVOUT_DBG_DUMP(TVO_HDMI_CLIP_VALUE_R_CR);
+		TVOUT_DBG_DUMP(TVO_HDMI_SYNC_SEL);
+		TVOUT_DBG_DUMP(TVO_HDMI_DFV_OBS);
+		break;
+	case STI_TVOUT_CONNECTOR_HDA:
+		TVOUT_DBG_DUMP(TVO_VIP_HDF);
+		tvout_dbg_vip(m, readl(tvout->regs + TVO_VIP_HDF));
+		TVOUT_DBG_DUMP(TVO_HD_SYNC_SEL);
+		TVOUT_DBG_DUMP(TVO_HD_DAC_CFG_OFF);
+		tvout_dbg_hd_dac_cfg(m,
+				     readl(tvout->regs + TVO_HD_DAC_CFG_OFF));
+		break;
+	default:
+		goto out;
+	}
+
+	if (connector->dbg_show)
+		connector->dbg_show(connector, m);
+out:
+	seq_puts(m, "\n\n");
+	mutex_unlock(&dev->struct_mutex);
+	return 0;
+}
+
+int sti_tvout_hdmi_dbg_show(struct seq_file *m, void *arg)
+{
+	return tvout_dbg_show(m, STI_TVOUT_CONNECTOR_HDMI);
+}
+
+int sti_tvout_hda_dbg_show(struct seq_file *m, void *arg)
+{
+	return tvout_dbg_show(m, STI_TVOUT_CONNECTOR_HDA);
+}
+
 static int sti_tvout_bind(struct device *dev, struct device *master, void *data)
 {
 	return 0;
-- 
1.9.1

