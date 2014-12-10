Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaLJPxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:53:47 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:49163 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbaLJPx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:28 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 12/12] percpu: use {cpu|node}mask pr_cont and seq output functions
Date: Wed, 10 Dec 2014 10:52:54 -0500
Message-Id: <1418226774-30215-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418226774-30215-1-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the existing user of cpu{mask|list}_scnprintf() and
node{mask|list}_scnprintf() which use them just to printk or
seq_printf() the resulting buffer to use the following functions
instead respectively.

* For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().

* For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().

Because these conversions usually break up a single output function
call into multiple, the reduction is LOC isn't too big but it removes
unnecessary complexity and/or arbitrary limit on the length printed.

This patch is dependent on the previous patch ("bitmap, cpumask,
nodemask: implement pr_cont variants of formatting functions") which
is planned to go through -mm.  It'd be the easiest to route this
together.  If this should go through the subsystem tree, please wait
till the forementioned patch is merged to mainline.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 mm/percpu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index d39e2f4..3ff9b75 100644
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
@@ -1541,12 +1540,12 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	int *unit_map;
 	int group, unit, i;
 
-	cpumask_scnprintf(cpus_buf, sizeof(cpus_buf), cpu_possible_mask);
-
 #define PCPU_SETUP_BUG_ON(cond)	do {					\
 	if (unlikely(cond)) {						\
 		pr_emerg("PERCPU: failed to initialize, %s", #cond);	\
-		pr_emerg("PERCPU: cpu_possible_mask=%s\n", cpus_buf);	\
+		pr_emerg("PERCPU: cpu_possible_mask=");			\
+		cpumask_pr_cont(cpu_possible_mask);			\
+		pr_cont("\n");						\
 		pcpu_dump_alloc_info(KERN_EMERG, ai);			\
 		BUG();							\
 	}								\
-- 
2.1.0

