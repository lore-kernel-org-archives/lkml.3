Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3KIFdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 00:33:35 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:39837 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3KIFdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 00:33:31 -0500
From: Len Brown <lenb@kernel.org>
To: rjw@sisk.pl
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 2/2] intel_idle: Support Intel Atom Processor C2000 Product Family
Date: Sat,  9 Nov 2013 00:30:17 -0500
Message-Id: <c58648637a2565252bc6887336a3ba932484b9d1.1383974976.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <c7553d08fd591b6bc391bd22db68d02650c8d76f.1383974976.git.len.brown@intel.com>
References: <c7553d08fd591b6bc391bd22db68d02650c8d76f.1383974976.git.len.brown@intel.com>
In-Reply-To: <c7553d08fd591b6bc391bd22db68d02650c8d76f.1383974976.git.len.brown@intel.com>
References: <c7553d08fd591b6bc391bd22db68d02650c8d76f.1383974976.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Support the "Intel(R) Atom(TM) Processor C2000 Product Family",
formerly code-named Avoton.  It is based on the next generation
Intel Atom processor architecture, formerly code-named Silvermont.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index fa6964d..2fea107 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1,7 +1,7 @@
 /*
  * intel_idle.c - native hardware idle loop for modern Intel processors
  *
- * Copyright (c) 2010, Intel Corporation.
+ * Copyright (c) 2013, Intel Corporation.
  * Len Brown <len.brown@intel.com>
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -329,6 +329,22 @@ static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
 	{
 		.enter = NULL }
 };
+static struct cpuidle_state avn_cstates[CPUIDLE_STATE_MAX] = {
+	{
+		.name = "C1-AVN",
+		.desc = "MWAIT 0x00",
+		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 2,
+		.target_residency = 2,
+		.enter = &intel_idle },
+	{
+		.name = "C6-AVN",
+		.desc = "MWAIT 0x51",
+		.flags = MWAIT2flg(0x58) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 15,
+		.target_residency = 45,
+		.enter = &intel_idle },
+};
 
 /**
  * intel_idle
@@ -462,6 +478,11 @@ static const struct idle_cpu idle_cpu_hsw = {
 	.disable_promotion_to_c1e = true,
 };
 
+static const struct idle_cpu idle_cpu_avn = {
+	.state_table = avn_cstates,
+	.disable_promotion_to_c1e = true,
+};
+
 #define ICPU(model, cpu) \
 	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_MWAIT, (unsigned long)&cpu }
 
@@ -483,6 +504,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
 	ICPU(0x3f, idle_cpu_hsw),
 	ICPU(0x45, idle_cpu_hsw),
 	ICPU(0x46, idle_cpu_hsw),
+	ICPU(0x4D, idle_cpu_avn),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
-- 
1.8.4

