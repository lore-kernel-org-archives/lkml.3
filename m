Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbbAXOEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:35 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:55173 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbbAXOEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:31 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 28/32] padata: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:34 -0500
Message-Id: <1422108218-25398-29-git-send-email-tj@kernel.org>
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
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 161402f..b38bea9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -917,15 +917,10 @@ static ssize_t show_cpumask(struct padata_instance *pinst,
 	else
 		cpumask = pinst->cpumask.pcpu;
 
-	len = bitmap_scnprintf(buf, PAGE_SIZE, cpumask_bits(cpumask),
-			       nr_cpu_ids);
-	if (PAGE_SIZE - len < 2)
-		len = -EINVAL;
-	else
-		len += sprintf(buf + len, "\n");
-
+	len = snprintf(buf, PAGE_SIZE, "%*pb\n",
+		       nr_cpu_ids, cpumask_bits(cpumask));
 	mutex_unlock(&pinst->lock);
-	return len;
+	return len < PAGE_SIZE ? len : -EINVAL;
 }
 
 static ssize_t store_cpumask(struct padata_instance *pinst,
-- 
2.1.0

