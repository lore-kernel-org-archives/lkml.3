Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaLENmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:42:45 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17592 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaLENmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:42:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 05 Dec 2014 05:40:19 -0800
From: Arto Merilainen <amerilainen@nvidia.com>
To: <myungjoo.ham@samsung.com>, <kyungmin.park@samsung.com>,
        <tomeu.vizoso@collabora.com>, <gnurou@gmail.com>
CC: <javier.martinez@collabora.co.uk>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <grant.likely@linaro.org>, <srasal@nvidia.com>,
        <amerilainen@nvidia.com>
Subject: [RFC RESEND 2/3] PM / devfreq: Add watermark simple governor
Date: Fri, 5 Dec 2014 15:41:31 +0200
Message-ID: <1417786892-477-3-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1417786892-477-1-git-send-email-amerilainen@nvidia.com>
References: <1417786892-477-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shridhar Rasal <srasal@nvidia.com>

This patch adds a new devfreq governor, watermark simple. The
governor decides next frequency naively by selecting the previous
frequency in the frequency table if we received low watermark
- or the next frequency in case we received high watermark.

Signed-off-by: Shridhar Rasal <srasal@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/devfreq/Kconfig                 |   7 +
 drivers/devfreq/Makefile                |   1 +
 drivers/devfreq/governor_wmark_simple.c | 245 ++++++++++++++++++++++++++++++++
 3 files changed, 253 insertions(+)
 create mode 100644 drivers/devfreq/governor_wmark_simple.c

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index faf4e70c42e0..37710d999ffe 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -63,6 +63,13 @@ config DEVFREQ_GOV_USERSPACE
 	  Otherwise, the governor does not change the frequnecy
 	  given at the initialization.
 
+config DEVFREQ_GOV_WMARK_SIMPLE
+	tristate "Simple Watermark"
+	help
+	  Sets the frequency based on monitor watermark events.
+	  This governor returns the next frequency from frequency table
+	  based on type watermark event.
+
 comment "DEVFREQ Drivers"
 
 config ARM_EXYNOS4_BUS_DEVFREQ
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index 16138c9e0d58..92024eeb73b6 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)	+= governor_simpleondemand.o
 obj-$(CONFIG_DEVFREQ_GOV_PERFORMANCE)	+= governor_performance.o
 obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
 obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
+obj-$(CONFIG_DEVFREQ_GOV_WMARK_SIMPLE)	+= governor_wmark_simple.o
 
 # DEVFREQ Drivers
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
diff --git a/drivers/devfreq/governor_wmark_simple.c b/drivers/devfreq/governor_wmark_simple.c
new file mode 100644
index 000000000000..bd14adcc84cb
--- /dev/null
+++ b/drivers/devfreq/governor_wmark_simple.c
@@ -0,0 +1,245 @@
+/*
+ * Copyright (c) 2014, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/devfreq.h>
+#include <linux/debugfs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/notifier.h>
+#include <linux/platform_device.h>
+
+#include "governor.h"
+
+struct wmark_gov_info {
+	/* probed from the devfreq */
+	unsigned int		*freqlist;
+	int			freq_count;
+
+	/* algorithm parameters */
+	unsigned int		p_high_wmark;
+	unsigned int		p_low_wmark;
+
+	/* dynamically changing data */
+	enum watermark_type	event;
+	unsigned int		last_request;
+
+	/* common data */
+	struct devfreq		*df;
+	struct platform_device	*pdev;
+	struct dentry		*debugdir;
+};
+
+static unsigned long freqlist_up(struct wmark_gov_info *wmarkinfo,
+				 unsigned long curr_freq)
+{
+	int i, pos;
+
+	for (i = 0; i < wmarkinfo->freq_count; i++)
+		if (wmarkinfo->freqlist[i] > curr_freq)
+			break;
+
+	pos = min(wmarkinfo->freq_count - 1, i);
+
+	return wmarkinfo->freqlist[pos];
+}
+
+static unsigned int freqlist_down(struct wmark_gov_info *wmarkinfo,
+				  unsigned long curr_freq)
+{
+	int i, pos;
+
+	for (i = wmarkinfo->freq_count - 1; i >= 0; i--)
+		if (wmarkinfo->freqlist[i] < curr_freq)
+			break;
+
+	pos = max(0, i);
+	return wmarkinfo->freqlist[pos];
+}
+
+static int devfreq_watermark_target_freq(struct devfreq *df,
+					 unsigned long *freq)
+{
+	struct wmark_gov_info *wmarkinfo = df->data;
+	struct devfreq_dev_status dev_stat;
+	int err;
+
+	err = df->profile->get_dev_status(df->dev.parent, &dev_stat);
+	if (err < 0)
+		return err;
+
+	switch (wmarkinfo->event) {
+	case HIGH_WATERMARK_EVENT:
+		*freq = freqlist_up(wmarkinfo, dev_stat.current_frequency);
+
+		/* always enable low watermark */
+		df->profile->set_low_wmark(df->dev.parent,
+					   wmarkinfo->p_low_wmark);
+
+		/* disable high watermark if no change */
+		if (*freq == wmarkinfo->last_request)
+			df->profile->set_high_wmark(df->dev.parent, 1000);
+		break;
+	case LOW_WATERMARK_EVENT:
+		*freq = freqlist_down(wmarkinfo, dev_stat.current_frequency);
+
+		/* always enable high watermark */
+		df->profile->set_high_wmark(df->dev.parent,
+					    wmarkinfo->p_high_wmark);
+
+		/* disable low watermark if no change */
+		if (*freq == wmarkinfo->last_request)
+			df->profile->set_low_wmark(df->dev.parent, 0);
+		break;
+	default:
+		break;
+	}
+
+	/* Mark that you handled event */
+	wmarkinfo->event = NO_WATERMARK_EVENT;
+	wmarkinfo->last_request = *freq;
+
+	return 0;
+}
+
+static void devfreq_watermark_debug_start(struct devfreq *df)
+{
+	struct wmark_gov_info *wmarkinfo = df->data;
+	char dirname[128];
+
+	snprintf(dirname, sizeof(dirname), "%s_scaling",
+		to_platform_device(df->dev.parent)->name);
+
+	if (!wmarkinfo)
+		return;
+
+	wmarkinfo->debugdir = debugfs_create_dir(dirname, NULL);
+	if (!wmarkinfo->debugdir)
+		return;
+
+	debugfs_create_u32("low_wmark", S_IRUGO | S_IWUSR,
+			   wmarkinfo->debugdir, &wmarkinfo->p_low_wmark);
+	debugfs_create_u32("high_wmark", S_IRUGO | S_IWUSR,
+			   wmarkinfo->debugdir, &wmarkinfo->p_high_wmark);
+}
+
+static void devfreq_watermark_debug_stop(struct devfreq *df)
+{
+	struct wmark_gov_info *wmarkinfo = df->data;
+
+	debugfs_remove_recursive(wmarkinfo->debugdir);
+}
+
+static int devfreq_watermark_start(struct devfreq *df)
+{
+	struct wmark_gov_info *wmarkinfo;
+	struct platform_device *pdev = to_platform_device(df->dev.parent);
+
+	if (!df->profile->freq_table) {
+		dev_err(&pdev->dev, "Frequency table missing\n");
+		return -EINVAL;
+	}
+
+	wmarkinfo = kzalloc(sizeof(struct wmark_gov_info), GFP_KERNEL);
+	if (!wmarkinfo)
+		return -ENOMEM;
+
+	df->data = (void *)wmarkinfo;
+	wmarkinfo->freqlist = df->profile->freq_table;
+	wmarkinfo->freq_count = df->profile->max_state;
+	wmarkinfo->event = NO_WATERMARK_EVENT;
+	wmarkinfo->df = df;
+	wmarkinfo->pdev = pdev;
+	wmarkinfo->p_low_wmark = 100;
+	wmarkinfo->p_high_wmark = 600;
+
+	devfreq_watermark_debug_start(df);
+
+	return 0;
+}
+
+static int devfreq_watermark_event_handler(struct devfreq *df,
+					   unsigned int event,
+					   void *wmark_type)
+{
+	int ret = 0;
+	struct wmark_gov_info *wmarkinfo = df->data;
+	enum watermark_type *type = wmark_type;
+
+	switch (event) {
+	case DEVFREQ_GOV_START:
+		devfreq_watermark_start(df);
+		wmarkinfo = df->data;
+		if (df->profile->set_low_wmark)
+			df->profile->set_low_wmark(df->dev.parent,
+						   wmarkinfo->p_low_wmark);
+		if (df->profile->set_high_wmark)
+			df->profile->set_high_wmark(df->dev.parent,
+						    wmarkinfo->p_high_wmark);
+		break;
+	case DEVFREQ_GOV_STOP:
+		devfreq_watermark_debug_stop(df);
+		break;
+	case DEVFREQ_GOV_SUSPEND:
+		devfreq_monitor_suspend(df);
+		break;
+
+	case DEVFREQ_GOV_RESUME:
+		if (df->profile->set_low_wmark)
+			df->profile->set_low_wmark(df->dev.parent,
+						   wmarkinfo->p_low_wmark);
+		if (df->profile->set_high_wmark)
+			df->profile->set_high_wmark(df->dev.parent,
+						    wmarkinfo->p_high_wmark);
+		devfreq_monitor_resume(df);
+		break;
+
+	case DEVFREQ_GOV_WMARK:
+		/* Set watermark interrupt type */
+		wmarkinfo->event = *type;
+
+		mutex_lock(&df->lock);
+		update_devfreq(df);
+		mutex_unlock(&df->lock);
+
+		break;
+
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static struct devfreq_governor devfreq_watermark = {
+	.name = "wmark_simple",
+	.get_target_freq = devfreq_watermark_target_freq,
+	.event_handler = devfreq_watermark_event_handler,
+};
+
+
+static int __init devfreq_watermark_init(void)
+{
+	return devfreq_add_governor(&devfreq_watermark);
+}
+
+static void __exit devfreq_watermark_exit(void)
+{
+	devfreq_remove_governor(&devfreq_watermark);
+}
+
+rootfs_initcall(devfreq_watermark_init);
+module_exit(devfreq_watermark_exit);
-- 
1.8.1.5

