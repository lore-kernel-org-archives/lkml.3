Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3B0GIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 01:08:09 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41582 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3B0GID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 01:08:03 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/5] staging: android: lowmemorykiller: Add config option to support oom_adj values
Date: Tue, 26 Feb 2013 22:07:34 -0800
Message-Id: <1361945258-24420-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

The conversion to use oom_score_adj instead of the deprecated oom_adj
values breaks existing user-space code. Add a config option to convert
oom_adj values written to oom_score_adj values if they appear to be
valid oom_adj values.

Cc: Android Kernel Team <kernel-team@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig           |    9 +++
 drivers/staging/android/lowmemorykiller.c |   85 +++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 465a28c..5663c61 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -63,6 +63,15 @@ config ANDROID_LOW_MEMORY_KILLER
 	---help---
 	  Registers processes to be killed when memory is low
 
+config ANDROID_LOW_MEMORY_KILLER_AUTODETECT_OOM_ADJ_VALUES
+	bool "Android Low Memory Killer: detect oom_adj values"
+	depends on ANDROID_LOW_MEMORY_KILLER
+	default y
+	---help---
+	  Detect oom_adj values written to
+	  /sys/module/lowmemorykiller/parameters/adj and convert them
+	  to oom_score_adj values.
+
 config ANDROID_INTF_ALARM_DEV
 	bool "Android alarm driver"
 	depends on RTC_CLASS
diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 3b91b0f..7e00bdb 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -175,9 +175,94 @@ static void __exit lowmem_exit(void)
 	unregister_shrinker(&lowmem_shrinker);
 }
 
+#ifdef CONFIG_ANDROID_LOW_MEMORY_KILLER_AUTODETECT_OOM_ADJ_VALUES
+static short lowmem_oom_adj_to_oom_score_adj(short oom_adj)
+{
+	if (oom_adj == OOM_ADJUST_MAX)
+		return OOM_SCORE_ADJ_MAX;
+	else
+		return (oom_adj * OOM_SCORE_ADJ_MAX) / -OOM_DISABLE;
+}
+
+static void lowmem_autodetect_oom_adj_values(void)
+{
+	int i;
+	short oom_adj;
+	short oom_score_adj;
+	int array_size = ARRAY_SIZE(lowmem_adj);
+
+	if (lowmem_adj_size < array_size)
+		array_size = lowmem_adj_size;
+
+	if (array_size <= 0)
+		return;
+
+	oom_adj = lowmem_adj[array_size - 1];
+	if (oom_adj > OOM_ADJUST_MAX)
+		return;
+
+	oom_score_adj = lowmem_oom_adj_to_oom_score_adj(oom_adj);
+	if (oom_score_adj <= OOM_ADJUST_MAX)
+		return;
+
+	lowmem_print(1, "lowmem_shrink: convert oom_adj to oom_score_adj:\n");
+	for (i = 0; i < array_size; i++) {
+		oom_adj = lowmem_adj[i];
+		oom_score_adj = lowmem_oom_adj_to_oom_score_adj(oom_adj);
+		lowmem_adj[i] = oom_score_adj;
+		lowmem_print(1, "oom_adj %d => oom_score_adj %d\n",
+			     oom_adj, oom_score_adj);
+	}
+}
+
+static int lowmem_adj_array_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+
+	ret = param_array_ops.set(val, kp);
+
+	/* HACK: Autodetect oom_adj values in lowmem_adj array */
+	lowmem_autodetect_oom_adj_values();
+
+	return ret;
+}
+
+static int lowmem_adj_array_get(char *buffer, const struct kernel_param *kp)
+{
+	return param_array_ops.get(buffer, kp);
+}
+
+static void lowmem_adj_array_free(void *arg)
+{
+	param_array_ops.free(arg);
+}
+
+static struct kernel_param_ops lowmem_adj_array_ops = {
+	.set = lowmem_adj_array_set,
+	.get = lowmem_adj_array_get,
+	.free = lowmem_adj_array_free,
+};
+
+static const struct kparam_array __param_arr_adj = {
+	.max = ARRAY_SIZE(lowmem_adj),
+	.num = &lowmem_adj_size,
+	.ops = &param_ops_short,
+	.elemsize = sizeof(lowmem_adj[0]),
+	.elem = lowmem_adj,
+};
+#endif
+
 module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
+#ifdef CONFIG_ANDROID_LOW_MEMORY_KILLER_AUTODETECT_OOM_ADJ_VALUES
+__module_param_call(MODULE_PARAM_PREFIX, adj,
+		    &lowmem_adj_array_ops,
+		    .arr = &__param_arr_adj,
+		    S_IRUGO | S_IWUSR, -1);
+__MODULE_PARM_TYPE(adj, "array of short");
+#else
 module_param_array_named(adj, lowmem_adj, short, &lowmem_adj_size,
 			 S_IRUGO | S_IWUSR);
+#endif
 module_param_array_named(minfree, lowmem_minfree, uint, &lowmem_minfree_size,
 			 S_IRUGO | S_IWUSR);
 module_param_named(debug_level, lowmem_debug_level, uint, S_IRUGO | S_IWUSR);
-- 
1.7.10.4

