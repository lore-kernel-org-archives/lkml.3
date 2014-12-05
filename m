Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaLENdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:33:44 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17296 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaLENdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:33:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 05 Dec 2014 05:31:04 -0800
From: Arto Merilainen <amerilainen@nvidia.com>
To: <myungjoo.ham@samsung.com>, <kyungmin.park@samsung.com>,
        <tomeu.vizoso@collabora.com>, <gnurou@gmail.com>
CC: <javier.martinez@collabora.co.uk>, <linuxpm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <grant.likely@linaro.org>,
        <srasal@nvidia.com>, <amerilainen@nvidia.com>
Subject: [RFC 3/3] PM / devfreq: Add watermark active governor
Date: Fri, 5 Dec 2014 15:32:54 +0200
Message-ID: <1417786374-375-4-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1417786374-375-1-git-send-email-amerilainen@nvidia.com>
References: <1417786374-375-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new watermark governor that actively alters the
watermark values based on the current frequency and target load.

The governor takes target load as a given property (80% by default)
and every time when the governor re-estimation is triggered, the
governor checks the current load and calculates the next frequency
that would push the device as close this target load as possible.

At this point also the watermark values are updated so that next
time the interrupt should come when the load change is significant
enough to cause frequency change to either next or previous
frequency.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/devfreq/Kconfig                 |  11 ++
 drivers/devfreq/Makefile                |   1 +
 drivers/devfreq/governor_wmark_active.c | 276 ++++++++++++++++++++++++++++++++
 3 files changed, 288 insertions(+)
 create mode 100644 drivers/devfreq/governor_wmark_active.c

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 37710d999ffe..dc5b207e9c3b 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -70,6 +70,17 @@ config DEVFREQ_GOV_WMARK_SIMPLE
 	  This governor returns the next frequency from frequency table
 	  based on type watermark event.
 
+config DEVFREQ_GOV_WMARK_ACTIVE
+	tristate "Active Watermark"
+	help
+	  Sets the frequency based on monitor watermark events.
+	  This governor calculates relation between current load and
+	  target load. The next frequency is calculated by multiplying
+	  this relation with the current frequency.
+
+	  The watermark values are updated so that the watermarks are
+	  triggered when the above algorithm would change the frequency.
+
 comment "DEVFREQ Drivers"
 
 config ARM_EXYNOS4_BUS_DEVFREQ
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index 92024eeb73b6..91e07aef3b29 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_DEVFREQ_GOV_PERFORMANCE)	+= governor_performance.o
 obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
 obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
 obj-$(CONFIG_DEVFREQ_GOV_WMARK_SIMPLE)	+= governor_wmark_simple.o
+obj-$(CONFIG_DEVFREQ_GOV_WMARK_ACTIVE)	+= governor_wmark_active.o
 
 # DEVFREQ Drivers
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
diff --git a/drivers/devfreq/governor_wmark_active.c b/drivers/devfreq/governor_wmark_active.c
new file mode 100644
index 000000000000..fe67d915d490
--- /dev/null
+++ b/drivers/devfreq/governor_wmark_active.c
@@ -0,0 +1,276 @@
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
+	unsigned int		p_load_target;
+	unsigned int		p_load_max;
+
+	/* common data */
+	struct devfreq		*df;
+	struct platform_device	*pdev;
+	struct dentry		*debugdir;
+};
+
+static unsigned int freqlist_up(struct wmark_gov_info *wmarkinfo,
+				unsigned int curr_freq)
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
+				  unsigned int curr_freq)
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
+static unsigned int freqlist_round(struct wmark_gov_info *wmarkinfo,
+				   unsigned int freq)
+{
+	int i, pos;
+
+	for (i = 0; i < wmarkinfo->freq_count; i++)
+		if (wmarkinfo->freqlist[i] >= freq)
+			break;
+
+	pos = min(wmarkinfo->freq_count - 1, i);
+	return wmarkinfo->freqlist[pos];
+}
+
+static void update_watermarks(struct devfreq *df,
+			      unsigned int current_frequency)
+{
+	struct wmark_gov_info *wmarkinfo = df->data;
+	unsigned int relation = 0, next_freq = 0;
+	unsigned int current_frequency_khz = current_frequency / 1000;
+
+	if (current_frequency == wmarkinfo->freqlist[0]) {
+		/* disable the low watermark if we are at lowest clock */
+		df->profile->set_low_wmark(df->dev.parent, 0);
+	} else {
+		/* calculate the low threshold; what is the load value
+		 * at which we would go into lower frequency given the
+		 * that we are running at the new frequency? */
+		next_freq = freqlist_down(wmarkinfo, current_frequency);
+		relation = ((next_freq / current_frequency_khz) *
+			wmarkinfo->p_load_target) / 1000;
+		df->profile->set_low_wmark(df->dev.parent, relation);
+	}
+
+	if (current_frequency ==
+	    wmarkinfo->freqlist[wmarkinfo->freq_count - 1]) {
+		/* disable the high watermark if we are at highest clock */
+		df->profile->set_high_wmark(df->dev.parent, 1000);
+	} else {
+		/* calculate the high threshold; what is the load value
+		 * at which we would go into highest frequency given the
+		 * that we are running at the new frequency? */
+		next_freq = freqlist_up(wmarkinfo, current_frequency);
+		relation = ((next_freq / current_frequency_khz) *
+			wmarkinfo->p_load_target) / 1000;
+		relation = min(wmarkinfo->p_load_max, relation);
+		df->profile->set_high_wmark(df->dev.parent, relation);
+	}
+
+}
+
+static int devfreq_watermark_target_freq(struct devfreq *df,
+					 unsigned long *freq)
+{
+	struct wmark_gov_info *wmarkinfo = df->data;
+	struct devfreq_dev_status dev_stat;
+	unsigned int load, relation, next_freq;
+	int err;
+
+	err = df->profile->get_dev_status(df->dev.parent, &dev_stat);
+	if (err < 0)
+		return err;
+
+	/* keep current frequency if we do not have proper data available */
+	if (!dev_stat.total_time) {
+		*freq = dev_stat.current_frequency;
+		return 0;
+	}
+
+	/* calculate first load and relation load/p_load_target */
+	load = (dev_stat.busy_time * 1000) / dev_stat.total_time;
+
+	/* if we cross load max...  */
+	if (load >= wmarkinfo->p_load_max) {
+		/* we go directly to the highest frequency. depending
+		 * on frequency table we might never go higher than
+		 * the current frequency (i.e. load should be over 100%
+		 * to make relation push to the next frequency). */
+		*freq = wmarkinfo->freqlist[wmarkinfo->freq_count - 1];
+	} else {
+		/* otherwise, based on relation between current load and
+		 * load target we calculate the "ideal" frequency
+		 * where we would be just at the target */
+		relation = (load * 1000) / wmarkinfo->p_load_target;
+		next_freq = relation * (dev_stat.current_frequency / 1000);
+
+		/* round this frequency */
+		*freq = freqlist_round(wmarkinfo, next_freq);
+	}
+
+	/* update watermarks to match with the new frequency */
+	update_watermarks(df, *freq);
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
+	debugfs_create_u32("load_target", S_IRUGO | S_IWUSR,
+			   wmarkinfo->debugdir, &wmarkinfo->p_load_target);
+	debugfs_create_u32("load_max", S_IRUGO | S_IWUSR,
+			   wmarkinfo->debugdir, &wmarkinfo->p_load_max);
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
+	wmarkinfo->p_load_target = 700;
+	wmarkinfo->p_load_max = 900;
+	wmarkinfo->df = df;
+	wmarkinfo->pdev = pdev;
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
+
+	switch (event) {
+	case DEVFREQ_GOV_START:
+		devfreq_watermark_start(df);
+		wmarkinfo = df->data;
+		update_watermarks(df, wmarkinfo->freqlist[0]);
+		break;
+	case DEVFREQ_GOV_STOP:
+		devfreq_watermark_debug_stop(df);
+		break;
+	case DEVFREQ_GOV_SUSPEND:
+		devfreq_monitor_suspend(df);
+		break;
+
+	case DEVFREQ_GOV_RESUME:
+		wmarkinfo = df->data;
+		update_watermarks(df, wmarkinfo->freqlist[0]);
+		devfreq_monitor_resume(df);
+		break;
+
+	case DEVFREQ_GOV_WMARK:
+		mutex_lock(&df->lock);
+		update_devfreq(df);
+		mutex_unlock(&df->lock);
+		break;
+
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static struct devfreq_governor devfreq_watermark_active = {
+	.name = "wmark_active",
+	.get_target_freq = devfreq_watermark_target_freq,
+	.event_handler = devfreq_watermark_event_handler,
+};
+
+
+static int __init devfreq_watermark_init(void)
+{
+	return devfreq_add_governor(&devfreq_watermark_active);
+}
+
+static void __exit devfreq_watermark_exit(void)
+{
+	devfreq_remove_governor(&devfreq_watermark_active);
+}
+
+rootfs_initcall(devfreq_watermark_init);
+module_exit(devfreq_watermark_exit);
-- 
1.8.1.5

