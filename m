Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaALSnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:43:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaALSnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:43:31 -0500
Date: Sun, 12 Jan 2014 10:42:57 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-f228c5b882602697a1adb50d61ff688b0df1eced@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, maria.n.dimakopoulou@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        maria.n.dimakopoulou@gmail.com
In-Reply-To: <1389176153-3128-3-git-send-email-eranian@google.com>
References: <1389176153-3128-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel:
  Add Intel RAPL PP1 energy counter support
Git-Commit-ID: f228c5b882602697a1adb50d61ff688b0df1eced
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:43:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f228c5b882602697a1adb50d61ff688b0df1eced
Gitweb:     http://git.kernel.org/tip/f228c5b882602697a1adb50d61ff688b0df1eced
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 8 Jan 2014 11:15:53 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 10:16:08 +0100

perf/x86/intel: Add Intel RAPL PP1 energy counter support

This patch adds support for the Intel RAPL energy counter
PP1 (Power Plane 1).

On client processors, it usually corresponds to the
energy consumption of the builtin graphic card. That
is why the sysfs event is called energy-gpu.

New event:
 - name: power/energy-gpu/
 - code: event=0x4
 - unit: 2^-32 Joules

On processors without graphics, this should count 0.
The patch only enables this event on client processors.

Reviewed-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: ak@linux.intel.com
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: zheng.z.yan@intel.com
Cc: bp@alien8.de
Cc: vincent.weaver@maine.edu
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389176153-3128-3-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 31 ++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 0e3754e..5ad35ad 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -27,6 +27,10 @@
  *	  event: rapl_energy_dram
  *    perf code: 0x3
  *
+ * dram counter: consumption of the builtin-gpu domain (client only)
+ *	  event: rapl_energy_gpu
+ *    perf code: 0x4
+ *
  * We manage those counters as free running (read-only). They may be
  * use simultaneously by other tools, such as turbostat.
  *
@@ -55,10 +59,13 @@
 #define INTEL_RAPL_PKG		0x2	/* pseudo-encoding */
 #define RAPL_IDX_RAM_NRG_STAT	2	/* DRAM */
 #define INTEL_RAPL_RAM		0x3	/* pseudo-encoding */
+#define RAPL_IDX_PP1_NRG_STAT	3	/* DRAM */
+#define INTEL_RAPL_PP1		0x4	/* pseudo-encoding */
 
 /* Clients have PP0, PKG */
 #define RAPL_IDX_CLN	(1<<RAPL_IDX_PP0_NRG_STAT|\
-			 1<<RAPL_IDX_PKG_NRG_STAT)
+			 1<<RAPL_IDX_PKG_NRG_STAT|\
+			 1<<RAPL_IDX_PP1_NRG_STAT)
 
 /* Servers have PP0, PKG, RAM */
 #define RAPL_IDX_SRV	(1<<RAPL_IDX_PP0_NRG_STAT|\
@@ -315,6 +322,10 @@ static int rapl_pmu_event_init(struct perf_event *event)
 		bit = RAPL_IDX_RAM_NRG_STAT;
 		msr = MSR_DRAM_ENERGY_STATUS;
 		break;
+	case INTEL_RAPL_PP1:
+		bit = RAPL_IDX_PP1_NRG_STAT;
+		msr = MSR_PP1_ENERGY_STATUS;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -367,19 +378,22 @@ static struct attribute_group rapl_pmu_attr_group = {
 };
 
 EVENT_ATTR_STR(energy-cores, rapl_cores, "event=0x01");
-EVENT_ATTR_STR(energy-pkg  , rapl_pkg, "event=0x02");
-EVENT_ATTR_STR(energy-ram  , rapl_ram, "event=0x03");
+EVENT_ATTR_STR(energy-pkg  ,   rapl_pkg, "event=0x02");
+EVENT_ATTR_STR(energy-ram  ,   rapl_ram, "event=0x03");
+EVENT_ATTR_STR(energy-gpu  ,   rapl_gpu, "event=0x04");
 
 EVENT_ATTR_STR(energy-cores.unit, rapl_cores_unit, "Joules");
-EVENT_ATTR_STR(energy-pkg.unit  , rapl_pkg_unit, "Joules");
-EVENT_ATTR_STR(energy-ram.unit  , rapl_ram_unit, "Joules");
+EVENT_ATTR_STR(energy-pkg.unit  ,   rapl_pkg_unit, "Joules");
+EVENT_ATTR_STR(energy-ram.unit  ,   rapl_ram_unit, "Joules");
+EVENT_ATTR_STR(energy-gpu.unit  ,   rapl_gpu_unit, "Joules");
 
 /*
  * we compute in 0.23 nJ increments regardless of MSR
  */
 EVENT_ATTR_STR(energy-cores.scale, rapl_cores_scale, "2.3283064365386962890625e-10");
-EVENT_ATTR_STR(energy-pkg.scale, rapl_pkg_scale, "2.3283064365386962890625e-10");
-EVENT_ATTR_STR(energy-ram.scale, rapl_ram_scale, "2.3283064365386962890625e-10");
+EVENT_ATTR_STR(energy-pkg.scale,     rapl_pkg_scale, "2.3283064365386962890625e-10");
+EVENT_ATTR_STR(energy-ram.scale,     rapl_ram_scale, "2.3283064365386962890625e-10");
+EVENT_ATTR_STR(energy-gpu.scale,     rapl_gpu_scale, "2.3283064365386962890625e-10");
 
 static struct attribute *rapl_events_srv_attr[] = {
 	EVENT_PTR(rapl_cores),
@@ -399,12 +413,15 @@ static struct attribute *rapl_events_srv_attr[] = {
 static struct attribute *rapl_events_cln_attr[] = {
 	EVENT_PTR(rapl_cores),
 	EVENT_PTR(rapl_pkg),
+	EVENT_PTR(rapl_gpu),
 
 	EVENT_PTR(rapl_cores_unit),
 	EVENT_PTR(rapl_pkg_unit),
+	EVENT_PTR(rapl_gpu_unit),
 
 	EVENT_PTR(rapl_cores_scale),
 	EVENT_PTR(rapl_pkg_scale),
+	EVENT_PTR(rapl_gpu_scale),
 	NULL,
 };
 
