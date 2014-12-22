Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaLVHtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:49:31 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41473 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbaLVHt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:49:27 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, peterz@infradead.org, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 1/7] perf: provide sysfs_show for struct perf_pmu_events_attr
Date: Sun, 21 Dec 2014 23:48:46 -0800
Message-Id: <1419234532-22657-2-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419234532-22657-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1419234532-22657-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122207-0037-0000-0000-0000002EF75F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

(struct perf_pmu_events_attr) is defined in include/linux/perf_event.h,
but the only "show" for it is in x86 and contains x86 specific stuff.

Make a generic one for those of us who are just using the event_str.

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/perf_event.h | 3 +++
 kernel/events/core.c       | 8 ++++++++
 2 files changed, 11 insertions(+)

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
index af0a5ba..1808d0e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8276,6 +8276,14 @@ void __init perf_event_init(void)
 		     != 1024);
 }
 
+ssize_t perf_event_sysfs_show(struct device *dev, struct device_attribute *attr,
+			      char *page)
+{
+	struct perf_pmu_events_attr *pmu_attr =
+		container_of(attr, struct perf_pmu_events_attr, attr);
+	return sprintf(page, "%s\n", pmu_attr->event_str);
+}
+
 static int __init perf_event_sysfs_init(void)
 {
 	struct pmu *pmu;
-- 
1.8.3.1

