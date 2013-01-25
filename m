Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3AYMQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:16:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42466 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab3AYMQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:16:41 -0500
Date: Fri, 25 Jan 2013 04:16:28 -0800
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-4c38cd7b6641f3f2cdf9c4f450c2628e2e400c1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1359040242-8269-2-git-send-email-eranian@google.com>
References: <1359040242-8269-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86] perf/x86: Support CPU specific sysfs events
Git-Commit-ID: 4c38cd7b6641f3f2cdf9c4f450c2628e2e400c1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:16:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c38cd7b6641f3f2cdf9c4f450c2628e2e400c1e
Gitweb:     http://git.kernel.org/tip/4c38cd7b6641f3f2cdf9c4f450c2628e2e400c1e
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 24 Jan 2013 16:10:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 10:19:00 +0100

perf/x86: Support CPU specific sysfs events

Add a way for the CPU initialization code to register additional
events, and merge them into the events attribute directory. Used
in the next patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: namhyung.kim@lge.com
Link: http://lkml.kernel.org/r/1359040242-8269-2-git-send-email-eranian@google.com
[ small cleanups ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.h |  1 +
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6774c17..f133091 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1335,6 +1335,32 @@ static void __init filter_events(struct attribute **attrs)
 	}
 }
 
+/* Merge two pointer arrays */
+static __init struct attribute **merge_attr(struct attribute **a, struct attribute **b)
+{
+	struct attribute **new;
+	int j, i;
+
+	for (j = 0; a[j]; j++)
+		;
+	for (i = 0; b[i]; i++)
+		j++;
+	j++;
+
+	new = kmalloc(sizeof(struct attribute *) * j, GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+	j = 0;
+	for (i = 0; a[i]; i++)
+		new[j++] = a[i];
+	for (i = 0; b[i]; i++)
+		new[j++] = b[i];
+	new[j] = NULL;
+
+	return new;
+}
+
 static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
 			  char *page)
 {
@@ -1476,6 +1502,14 @@ static int __init init_hw_perf_events(void)
 	else
 		filter_events(x86_pmu_events_group.attrs);
 
+	if (x86_pmu.cpu_events) {
+		struct attribute *tmp;
+
+		tmp = merge_attr(x86_pmu_events_group.attrs, x86_pmu.cpu_events);
+		if (!WARN_ON(!tmp))
+			x86_pmu_events_group.attrs = tmp;
+	}
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 115c1ea..4170043 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -355,6 +355,7 @@ struct x86_pmu {
 	struct attribute **format_attrs;
 
 	ssize_t		(*events_sysfs_show)(char *page, u64 config);
+	struct attribute **cpu_events;
 
 	/*
 	 * CPU Hotplug hooks
