Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbbA0BpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:45:24 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35384 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275AbbA0Bnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:43:31 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: dev@codyps.com, peterz@infradead.org, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 1/7] perf: provide sysfs_show for struct perf_pmu_events_attr
Date: Mon, 26 Jan 2015 17:43:04 -0800
Message-Id: <1422322990-9030-2-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012701-0033-0000-0000-000001AE33FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

(struct perf_pmu_events_attr) is defined in include/linux/perf_event.h,
but the only "show" for it is in x86 and contains x86 specific stuff.

Make a generic one for those of us who are just using the event_str.

Changelog[v7]: [Jiri Olsa] Add a check pmu_events->str for similarity
		the RAPL use of sysfs_show().

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/perf_event.h |  3 +++
 kernel/events/core.c       | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 486e84c..58f59bd 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -897,6 +897,9 @@ struct perf_pmu_events_attr {
 	const char *event_str;
 };
 
+ssize_t perf_event_sysfs_show(struct device *dev, struct device_attribute *attr,
+			      char *page);
+
 #define PMU_EVENT_ATTR(_name, _var, _id, _show)				\
 static struct perf_pmu_events_attr _var = {				\
 	.attr = __ATTR(_name, 0444, _show, NULL),			\
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4c1ee7f..934687f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8276,6 +8276,18 @@ void __init perf_event_init(void)
 		     != 1024);
 }
 
+ssize_t perf_event_sysfs_show(struct device *dev, struct device_attribute *attr,
+			      char *page)
+{
+	struct perf_pmu_events_attr *pmu_attr =
+		container_of(attr, struct perf_pmu_events_attr, attr);
+
+	if (pmu_attr->event_str)
+		return sprintf(page, "%s\n", pmu_attr->event_str);
+
+	return 0;
+}
+
 static int __init perf_event_sysfs_init(void)
 {
 	struct pmu *pmu;
-- 
1.8.3.1

