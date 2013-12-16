Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3LPUUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:20:19 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:39535 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3LPUUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:20:14 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        vincent.weaver@maine.edu, maria.n.dimakopoulou@gmail.com
Subject: [PATCH 2/2] perf/x86: add RAPL PP1 energy counter support
Date: Mon, 16 Dec 2013 21:20:24 +0100
Message-Id: <1387225224-27799-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387225224-27799-1-git-send-email-eranian@google.com>
References: <1387225224-27799-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the RAPL energy counter PP1.

On client processors, it usually correspondss to the
energy consumption of the builtin graphic card.

New event:
- name: power/energy-gfx/
- code: event=0x4
- unit: 2^-32 Joules

On processors without graphics, this should count 0.
The patch only enables this event on client processors.

Signed-off-by: Stephane Eranian <eranian@google.com>

---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 0e3754e..b2dc346 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -55,10 +55,13 @@
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
@@ -315,6 +318,10 @@ static int rapl_pmu_event_init(struct perf_event *event)
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
@@ -369,10 +376,12 @@ static struct attribute_group rapl_pmu_attr_group = {
 EVENT_ATTR_STR(energy-cores, rapl_cores, "event=0x01");
 EVENT_ATTR_STR(energy-pkg  , rapl_pkg, "event=0x02");
 EVENT_ATTR_STR(energy-ram  , rapl_ram, "event=0x03");
+EVENT_ATTR_STR(energy-gfx, rapl_gfx, "event=0x04");
 
 EVENT_ATTR_STR(energy-cores.unit, rapl_cores_unit, "Joules");
 EVENT_ATTR_STR(energy-pkg.unit  , rapl_pkg_unit, "Joules");
 EVENT_ATTR_STR(energy-ram.unit  , rapl_ram_unit, "Joules");
+EVENT_ATTR_STR(energy-gfx.unit  , rapl_gfx_unit, "Joules");
 
 /*
  * we compute in 0.23 nJ increments regardless of MSR
@@ -380,6 +389,7 @@ EVENT_ATTR_STR(energy-ram.unit  , rapl_ram_unit, "Joules");
 EVENT_ATTR_STR(energy-cores.scale, rapl_cores_scale, "2.3283064365386962890625e-10");
 EVENT_ATTR_STR(energy-pkg.scale, rapl_pkg_scale, "2.3283064365386962890625e-10");
 EVENT_ATTR_STR(energy-ram.scale, rapl_ram_scale, "2.3283064365386962890625e-10");
+EVENT_ATTR_STR(energy-gfx.scale, rapl_gfx_scale, "2.3283064365386962890625e-10");
 
 static struct attribute *rapl_events_srv_attr[] = {
 	EVENT_PTR(rapl_cores),
@@ -399,12 +409,15 @@ static struct attribute *rapl_events_srv_attr[] = {
 static struct attribute *rapl_events_cln_attr[] = {
 	EVENT_PTR(rapl_cores),
 	EVENT_PTR(rapl_pkg),
+	EVENT_PTR(rapl_gfx),
 
 	EVENT_PTR(rapl_cores_unit),
 	EVENT_PTR(rapl_pkg_unit),
+	EVENT_PTR(rapl_gfx_unit),
 
 	EVENT_PTR(rapl_cores_scale),
 	EVENT_PTR(rapl_pkg_scale),
+	EVENT_PTR(rapl_gfx_scale),
 	NULL,
 };
 
-- 
1.7.9.5

