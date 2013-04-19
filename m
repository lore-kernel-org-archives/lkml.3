Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3DSSzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:55:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53867
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab3DSSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:55:42 -0400
Message-ID: <1366397724.24945.8.camel@laptop>
Subject: Re: [PATCH 2/2] perf, amd: support for AMD NB and L2I "uncore"
 counters.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 19 Apr 2013 20:55:24 +0200
In-Reply-To: <20130419144100.GA2894@jshin-Toonie>
References: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
	 <1366046483-1765-3-git-send-email-jacob.shin@amd.com>
	 <1366284534.19383.13.camel@laptop> <20130418163315.GA7903@jshin-Toonie>
	 <1366374436.24945.6.camel@laptop> <20130419144100.GA2894@jshin-Toonie>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 09:41 -0500, Jacob Shin wrote:
> 
> Thank you again, for taking the time.

Ah something I just remembered, could you do a patch like the below
one? That makes things like perf stat -A work as expected.

---
commit 314d9f63f385096580e9e2a06eaa0745d92fe4ac
Author: Yan, Zheng <zheng.z.yan@intel.com>
Date:   Mon Sep 10 15:53:49 2012 +0800

    perf/x86: Add cpumask for uncore pmu
    
    This patch adds a cpumask file to the uncore pmu sysfs directory.  The
    cpumask file contains one active cpu for every socket.
    
    Signed-off-by: "Yan, Zheng" <zheng.z.yan@intel.com>
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Acked-by: Ingo Molnar <mingo@kernel.org>
    Cc: Andi Kleen <andi@firstfloor.org>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Stephane Eranian <eranian@google.com>
    Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
    Link: http://lkml.kernel.org/r/1347263631-23175-2-git-send-email-zheng.z.yan@intel.com
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 0a55710..62ec3e6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2341,6 +2341,27 @@ int uncore_pmu_event_init(struct perf_event *event)
 	return ret;
 }
 
+static ssize_t uncore_get_attr_cpumask(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &uncore_cpu_mask);
+
+	buf[n++] = '\n';
+	buf[n] = '\0';
+	return n;
+}
+
+static DEVICE_ATTR(cpumask, S_IRUGO, uncore_get_attr_cpumask, NULL);
+
+static struct attribute *uncore_pmu_attrs[] = {
+	&dev_attr_cpumask.attr,
+	NULL,
+};
+
+static struct attribute_group uncore_pmu_attr_group = {
+	.attrs = uncore_pmu_attrs,
+};
+
 static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
 {
 	int ret;
@@ -2378,8 +2399,8 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 		free_percpu(type->pmus[i].box);
 	kfree(type->pmus);
 	type->pmus = NULL;
-	kfree(type->attr_groups[1]);
-	type->attr_groups[1] = NULL;
+	kfree(type->events_group);
+	type->events_group = NULL;
 }
 
 static void __init uncore_types_exit(struct intel_uncore_type **types)
@@ -2431,9 +2452,10 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 		for (j = 0; j < i; j++)
 			attrs[j] = &type->event_descs[j].attr.attr;
 
-		type->attr_groups[1] = events_group;
+		type->events_group = events_group;
 	}
 
+	type->pmu_group = &uncore_pmu_attr_group;
 	type->pmus = pmus;
 	return 0;
 fail:
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 5b81c18..e68a455 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -369,10 +369,12 @@ struct intel_uncore_type {
 	struct intel_uncore_pmu *pmus;
 	struct intel_uncore_ops *ops;
 	struct uncore_event_desc *event_descs;
-	const struct attribute_group *attr_groups[3];
+	const struct attribute_group *attr_groups[4];
 };
 
-#define format_group attr_groups[0]
+#define pmu_group attr_groups[0]
+#define format_group attr_groups[1]
+#define events_group attr_groups[2]
 
 struct intel_uncore_ops {
 	void (*init_box)(struct intel_uncore_box *);


