Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbbAXOG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:06:27 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:49276 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbbAXOE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:27 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 25/32] drivers/base: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:31 -0500
Message-Id: <1422108218-25398-26-git-send-email-tj@kernel.org>
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

* Line termination only requires one extra space at the end of the
  buffer.  Use PAGE_SIZE - 1 instead of PAGE_SIZE - 2 when formatting.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/cpu.c  | 2 +-
 drivers/base/node.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index f829a4c..f160ea4 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -245,7 +245,7 @@ static ssize_t print_cpus_offline(struct device *dev,
 	if (!alloc_cpumask_var(&offline, GFP_KERNEL))
 		return -ENOMEM;
 	cpumask_andnot(offline, cpu_possible_mask, cpu_online_mask);
-	n = cpulist_scnprintf(buf, len, offline);
+	n = scnprintf(buf, len, "%*pbl", cpumask_pr_args(offline));
 	free_cpumask_var(offline);
 
 	/* display offline cpus >= nr_cpu_ids */
diff --git a/drivers/base/node.c b/drivers/base/node.c
index a3b82e9..36fabe43 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -605,7 +605,8 @@ static ssize_t print_nodes_state(enum node_states state, char *buf)
 {
 	int n;
 
-	n = nodelist_scnprintf(buf, PAGE_SIZE-2, node_states[state]);
+	n = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+		      nodemask_pr_args(&node_states[state]));
 	buf[n++] = '\n';
 	buf[n] = '\0';
 	return n;
-- 
2.1.0

