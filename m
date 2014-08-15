Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaHOH2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 03:28:12 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37975 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346AbaHOH0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:26:41 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 09/14] perf: provide sysfs_show for struct perf_pmu_events_attr
Date: Fri, 15 Aug 2014 00:26:18 -0700
Message-Id: <1408087583-32239-10-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408087583-32239-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1408087583-32239-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081507-5806-0000-0000-000000394956
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <dev@codyps.com>

(struct perf_pmu_events_attr) is defined in include/linux/perf_event.h,
but the only "show" for it is in x86 and contains x86 specific stuff.

Make a generic one for those of us who are just using the event_str.

CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 include/linux/perf_event.h | 3 +++
 kernel/events/core.c       | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a..cef4a56 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -882,6 +882,9 @@ struct perf_pmu_events_attr {
 	const char *event_str;
 };
 
+ssize_t perf_event_sysfs_show(struct device *dev, struct device_attribute *attr,
+			      char *page);
+
 #define PMU_EVENT_ATTR(_name, _var, _id, _show)				\
 static struct perf_pmu_events_attr _var = {				\
 	.attr = __ATTR(_name, 0444, _show, NULL),			\
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1cf24b3..07e126c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8079,6 +8079,14 @@ void __init perf_event_init(void)
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

