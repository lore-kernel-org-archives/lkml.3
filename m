Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbaDBH46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:56:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaDBH4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:56:55 -0400
Date: Wed, 2 Apr 2014 00:55:14 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-e69af4657e7764d03ad555f0b583d9c4217bcefa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, acme@ghostprotocols.net, peterz@infradead.org,
        eranian@gmail.com, vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        acme@ghostprotocols.net, eranian@gmail.com, vincent.weaver@maine.edu,
        tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1404020045290.17889@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404020045290.17889@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Enable DRAM RAPL support on Intel Haswell
Git-Commit-ID: e69af4657e7764d03ad555f0b583d9c4217bcefa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e69af4657e7764d03ad555f0b583d9c4217bcefa
Gitweb:     http://git.kernel.org/tip/e69af4657e7764d03ad555f0b583d9c4217bcefa
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Wed, 2 Apr 2014 00:49:55 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 2 Apr 2014 07:16:27 +0200

perf/x86: Enable DRAM RAPL support on Intel Haswell

It turns out all Haswell processors (including the Desktop
variant)  support RAPL DRAM readings in addition to package,
pp0, and pp1.

I've confirmed RAPL DRAM readings on my model 60 Haswell
desktop.

See the 4th-gen-core-family-desktop-vol-2-datasheet.pdf
available from the Intel website for confirmation.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@gmail.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1404020045290.17889@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 33 ++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 5ad35ad..3cec947 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -59,7 +59,7 @@
 #define INTEL_RAPL_PKG		0x2	/* pseudo-encoding */
 #define RAPL_IDX_RAM_NRG_STAT	2	/* DRAM */
 #define INTEL_RAPL_RAM		0x3	/* pseudo-encoding */
-#define RAPL_IDX_PP1_NRG_STAT	3	/* DRAM */
+#define RAPL_IDX_PP1_NRG_STAT	3	/* gpu */
 #define INTEL_RAPL_PP1		0x4	/* pseudo-encoding */
 
 /* Clients have PP0, PKG */
@@ -72,6 +72,12 @@
 			 1<<RAPL_IDX_PKG_NRG_STAT|\
 			 1<<RAPL_IDX_RAM_NRG_STAT)
 
+/* Servers have PP0, PKG, RAM, PP1 */
+#define RAPL_IDX_HSW	(1<<RAPL_IDX_PP0_NRG_STAT|\
+			 1<<RAPL_IDX_PKG_NRG_STAT|\
+			 1<<RAPL_IDX_RAM_NRG_STAT|\
+			 1<<RAPL_IDX_PP1_NRG_STAT)
+
 /*
  * event code: LSB 8 bits, passed in attr->config
  * any other bit is reserved
@@ -425,6 +431,24 @@ static struct attribute *rapl_events_cln_attr[] = {
 	NULL,
 };
 
+static struct attribute *rapl_events_hsw_attr[] = {
+	EVENT_PTR(rapl_cores),
+	EVENT_PTR(rapl_pkg),
+	EVENT_PTR(rapl_gpu),
+	EVENT_PTR(rapl_ram),
+
+	EVENT_PTR(rapl_cores_unit),
+	EVENT_PTR(rapl_pkg_unit),
+	EVENT_PTR(rapl_gpu_unit),
+	EVENT_PTR(rapl_ram_unit),
+
+	EVENT_PTR(rapl_cores_scale),
+	EVENT_PTR(rapl_pkg_scale),
+	EVENT_PTR(rapl_gpu_scale),
+	EVENT_PTR(rapl_ram_scale),
+	NULL,
+};
+
 static struct attribute_group rapl_pmu_events_group = {
 	.name = "events",
 	.attrs = NULL, /* patched at runtime */
@@ -631,11 +655,14 @@ static int __init rapl_pmu_init(void)
 	switch (boot_cpu_data.x86_model) {
 	case 42: /* Sandy Bridge */
 	case 58: /* Ivy Bridge */
-	case 60: /* Haswell */
-	case 69: /* Haswell-Celeron */
 		rapl_cntr_mask = RAPL_IDX_CLN;
 		rapl_pmu_events_group.attrs = rapl_events_cln_attr;
 		break;
+	case 60: /* Haswell */
+	case 69: /* Haswell-Celeron */
+		rapl_cntr_mask = RAPL_IDX_HSW;
+		rapl_pmu_events_group.attrs = rapl_events_hsw_attr;
+		break;
 	case 45: /* Sandy Bridge-EP */
 	case 62: /* IvyTown */
 		rapl_cntr_mask = RAPL_IDX_SRV;
