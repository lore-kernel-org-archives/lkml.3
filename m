Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbbAXOI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:08:28 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:56221 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbbAXOEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:15 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 17/32] percpu: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:23 -0500
Message-Id: <1422108218-25398-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 mm/percpu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index d39e2f4..73c97a5 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1528,7 +1528,6 @@ static void pcpu_dump_alloc_info(const char *lvl,
 int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 				  void *base_addr)
 {
-	static char cpus_buf[4096] __initdata;
 	static int smap[PERCPU_DYNAMIC_EARLY_SLOTS] __initdata;
 	static int dmap[PERCPU_DYNAMIC_EARLY_SLOTS] __initdata;
 	size_t dyn_size = ai->dyn_size;
@@ -1541,12 +1540,11 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	int *unit_map;
 	int group, unit, i;
 
-	cpumask_scnprintf(cpus_buf, sizeof(cpus_buf), cpu_possible_mask);
-
 #define PCPU_SETUP_BUG_ON(cond)	do {					\
 	if (unlikely(cond)) {						\
 		pr_emerg("PERCPU: failed to initialize, %s", #cond);	\
-		pr_emerg("PERCPU: cpu_possible_mask=%s\n", cpus_buf);	\
+		pr_emerg("PERCPU: cpu_possible_mask=%*pb\n",		\
+			 cpumask_pr_args(cpu_possible_mask));		\
 		pcpu_dump_alloc_info(KERN_EMERG, ai);			\
 		BUG();							\
 	}								\
-- 
2.1.0

