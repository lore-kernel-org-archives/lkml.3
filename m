Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbbAXOKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:10:40 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:61905 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbbAXOEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:04 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH 10/32] ia64: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:16 -0500
Message-Id: <1422108218-25398-11-git-send-email-tj@kernel.org>
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
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/topology.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index f295f9a..965ab42 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -217,14 +217,12 @@ static ssize_t show_number_of_sets(struct cache_info *this_leaf, char *buf)
 
 static ssize_t show_shared_cpu_map(struct cache_info *this_leaf, char *buf)
 {
-	ssize_t	len;
 	cpumask_t shared_cpu_map;
 
 	cpumask_and(&shared_cpu_map,
 				&this_leaf->shared_cpu_map, cpu_online_mask);
-	len = cpumask_scnprintf(buf, NR_CPUS+1, &shared_cpu_map);
-	len += sprintf(buf+len, "\n");
-	return len;
+	return scnprintf(buf, PAGE_SIZE, "%*pb\n",
+			 cpumask_pr_args(&shared_cpu_map));
 }
 
 static ssize_t show_type(struct cache_info *this_leaf, char *buf)
-- 
2.1.0

