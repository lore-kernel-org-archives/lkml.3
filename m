Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaBJNad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:30:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaBJN33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:29:29 -0500
Date: Mon, 10 Feb 2014 05:28:19 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e97df76377b8b3b1f7dfd5d6f8a1d5a31438b140@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, alan@lxorguk.ukuu.org.uk,
        vince@deater.net, tglx@linutronix.de, junk@eslaf.co.uk
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        alan@lxorguk.ukuu.org.uk, vince@deater.net, junk@eslaf.co.uk,
        tglx@linutronix.de
In-Reply-To: <20140206170815.GW2936@laptop.programming.kicks-ass.net>
References: <20140206170815.GW2936@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/p6:
  Add userspace RDPMC quirk for PPro
Git-Commit-ID: e97df76377b8b3b1f7dfd5d6f8a1d5a31438b140
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:28:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e97df76377b8b3b1f7dfd5d6f8a1d5a31438b140
Gitweb:     http://git.kernel.org/tip/e97df76377b8b3b1f7dfd5d6f8a1d5a31438b140
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 5 Feb 2014 20:48:51 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:08:24 +0100

perf/x86/intel/p6: Add userspace RDPMC quirk for PPro

PPro machines can die hard when PCE gets enabled due to a CPU erratum.
The safe way it so disable it by default and keep it disabled.

See erratum 26 in:

  http://download.intel.com/design/archives/processors/pro/docs/24268935.pdf

Reported-and-Tested-by: Mark Davies <junk@eslaf.co.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vince@deater.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140206170815.GW2936@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c    |  6 ++++-
 arch/x86/kernel/cpu/perf_event.h    |  1 +
 arch/x86/kernel/cpu/perf_event_p6.c | 48 +++++++++++++++++++++++++------------
 3 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b886451..1246b85 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1521,6 +1521,8 @@ static int __init init_hw_perf_events(void)
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
+	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
+
 	for (quirk = x86_pmu.quirks; quirk; quirk = quirk->next)
 		quirk->func();
 
@@ -1534,7 +1536,6 @@ static int __init init_hw_perf_events(void)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
 				   0, x86_pmu.num_counters, 0, 0);
 
-	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
 	if (x86_pmu.event_attrs)
@@ -1820,6 +1821,9 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	if (ret)
 		return ret;
 
+	if (x86_pmu.attr_rdpmc_broken)
+		return -ENOTSUPP;
+
 	if (!!val != !!x86_pmu.attr_rdpmc) {
 		x86_pmu.attr_rdpmc = !!val;
 		smp_call_function(change_rdpmc, (void *)val, 1);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index c1a8618..4972c24 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -409,6 +409,7 @@ struct x86_pmu {
 	/*
 	 * sysfs attrs
 	 */
+	int		attr_rdpmc_broken;
 	int		attr_rdpmc;
 	struct attribute **format_attrs;
 	struct attribute **event_attrs;
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index b1e2fe1..7c1a0c0 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -231,31 +231,49 @@ static __initconst const struct x86_pmu p6_pmu = {
 
 };
 
+static __init void p6_pmu_rdpmc_quirk(void)
+{
+	if (boot_cpu_data.x86_mask < 9) {
+		/*
+		 * PPro erratum 26; fixed in stepping 9 and above.
+		 */
+		pr_warn("Userspace RDPMC support disabled due to a CPU erratum\n");
+		x86_pmu.attr_rdpmc_broken = 1;
+		x86_pmu.attr_rdpmc = 0;
+	}
+}
+
 __init int p6_pmu_init(void)
 {
+	x86_pmu = p6_pmu;
+
 	switch (boot_cpu_data.x86_model) {
-	case 1:
-	case 3:  /* Pentium Pro */
-	case 5:
-	case 6:  /* Pentium II */
-	case 7:
-	case 8:
-	case 11: /* Pentium III */
-	case 9:
-	case 13:
-		/* Pentium M */
+	case  1: /* Pentium Pro */
+		x86_add_quirk(p6_pmu_rdpmc_quirk);
+		break;
+
+	case  3: /* Pentium II - Klamath */
+	case  5: /* Pentium II - Deschutes */
+	case  6: /* Pentium II - Mendocino */
 		break;
+
+	case  7: /* Pentium III - Katmai */
+	case  8: /* Pentium III - Coppermine */
+	case 10: /* Pentium III Xeon */
+	case 11: /* Pentium III - Tualatin */
+		break;
+
+	case  9: /* Pentium M - Banias */
+	case 13: /* Pentium M - Dothan */
+		break;
+
 	default:
-		pr_cont("unsupported p6 CPU model %d ",
-			boot_cpu_data.x86_model);
+		pr_cont("unsupported p6 CPU model %d ", boot_cpu_data.x86_model);
 		return -ENODEV;
 	}
 
-	x86_pmu = p6_pmu;
-
 	memcpy(hw_cache_event_ids, p6_hw_cache_event_ids,
 		sizeof(hw_cache_event_ids));
 
-
 	return 0;
 }
