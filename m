Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbaDBUSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:18:23 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42850 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758915AbaDBUNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 03/40] intel_idle: Support Intel Atom Processor C2000 Product Family
Date: Wed,  2 Apr 2014 22:12:49 +0200
Message-Id: <2aa86e03cdb2567a97d3f8a4d931208ae177b0f7.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fab04b2208dd1d4121319f0096c5a5f4b70abc54 upstream.

Support the "Intel(R) Atom(TM) Processor C2000 Product Family",
formerly code-named Avoton.  It is based on the next generation
Intel Atom processor architecture, formerly code-named Silvermont.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/idle/intel_idle.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index d47bb0f267f7..000d370519d9 100644
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
@@ -465,6 +481,11 @@ static const struct idle_cpu idle_cpu_hsw = {
 	.disable_promotion_to_c1e = true,
 };
 
+static const struct idle_cpu idle_cpu_avn = {
+	.state_table = avn_cstates,
+	.disable_promotion_to_c1e = true,
+};
+
 #define ICPU(model, cpu) \
 	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_MWAIT, (unsigned long)&cpu }
 
@@ -486,6 +507,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
 	ICPU(0x3f, idle_cpu_hsw),
 	ICPU(0x45, idle_cpu_hsw),
 	ICPU(0x46, idle_cpu_hsw),
+	ICPU(0x4D, idle_cpu_avn),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
-- 
1.9.1

