Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaKQTIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:08:45 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:65357 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaKQTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:08:41 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v3 13/13] perf/x86: add syfs entry to disable HT bug workaround
Date: Mon, 17 Nov 2014 20:07:05 +0100
Message-Id: <1416251225-17721-14-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416251225-17721-1-git-send-email-eranian@google.com>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

This patch adds a sysfs entry:

	/sys/devices/cpu/ht_bug_workaround

to activate/deactivate the PMU HT bug workaround.

To activate (activated by default):
 # echo 1 > /sys/devices/cpu/ht_bug_workaround

To deactivate:
 # echo 0 > /sys/devices/cpu/ht_bug_workaround

Results effective only once there is no more active
events.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c | 44 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2d5e7a9..5a5515e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1881,10 +1881,54 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	return count;
 }
 
+static ssize_t get_attr_xsu(struct device *cdev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	int ff = is_ht_workaround_enabled();
+
+	return snprintf(buf, 40, "%d\n", ff);
+}
+
+static ssize_t set_attr_xsu(struct device *cdev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
+	unsigned long val;
+	unsigned long flags;
+	int ff = is_ht_workaround_enabled();
+	ssize_t ret;
+
+	/*
+	 * if workaround, disabled, no effect
+	 */
+	if (!excl_cntrs)
+		return count;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&excl_cntrs->lock, flags);
+	if (!!val != ff) {
+		if (!val)
+			x86_pmu.flags &= ~PMU_FL_EXCL_ENABLED;
+		else
+			x86_pmu.flags |= PMU_FL_EXCL_ENABLED;
+	}
+	spin_unlock_irqrestore(&excl_cntrs->lock, flags);
+	return count;
+}
+
 static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
+static DEVICE_ATTR(ht_bug_workaround, S_IRUSR | S_IWUSR, get_attr_xsu,
+		   set_attr_xsu);
 
 static struct attribute *x86_pmu_attrs[] = {
 	&dev_attr_rdpmc.attr,
+	&dev_attr_ht_bug_workaround.attr,
 	NULL,
 };
 
-- 
1.9.1

