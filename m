Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaFLXIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:08:31 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39019 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaFLXIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:08:30 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] sched: Fix compiler warnings
Date: Thu, 12 Jun 2014 16:08:13 -0700
Message-Id: <1402614493-12521-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 143e1e28cb (sched: Rework sched_domain topology definition)
introduced a number of functions with a return value of 'const int'.
gcc doesn't know what to do with that and, if the kernel is compiled
with W=1, complains with the following warnings whenever sched.h
is included.

include/linux/sched.h:875:25: warning:
	type qualifiers ignored on function return type
include/linux/sched.h:882:25: warning:
	type qualifiers ignored on function return type
include/linux/sched.h:889:25: warning:
	type qualifiers ignored on function return type
include/linux/sched.h:1002:21: warning:
	type qualifiers ignored on function return type

Drop 'const' from the function declarations to fix the problem.

Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/sched.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ea74596..65046b3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -872,21 +872,21 @@ enum cpu_idle_type {
 #define SD_NUMA			0x4000	/* cross-node balancing */
 
 #ifdef CONFIG_SCHED_SMT
-static inline const int cpu_smt_flags(void)
+static inline int cpu_smt_flags(void)
 {
 	return SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
 }
 #endif
 
 #ifdef CONFIG_SCHED_MC
-static inline const int cpu_core_flags(void)
+static inline int cpu_core_flags(void)
 {
 	return SD_SHARE_PKG_RESOURCES;
 }
 #endif
 
 #ifdef CONFIG_NUMA
-static inline const int cpu_numa_flags(void)
+static inline int cpu_numa_flags(void)
 {
 	return SD_NUMA;
 }
@@ -999,7 +999,7 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
 bool cpus_share_cache(int this_cpu, int that_cpu);
 
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
-typedef const int (*sched_domain_flags_f)(void);
+typedef int (*sched_domain_flags_f)(void);
 
 #define SDTL_OVERLAP	0x01
 
-- 
1.9.1

