Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbbAXOGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:06:24 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:43697 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbbAXOE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:28 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 26/32] slub: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:32 -0500
Message-Id: <1422108218-25398-27-git-send-email-tj@kernel.org>
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

* This is an equivalent conversion but the whole function should be
  converted to use scnprinf famiily of functions rather than
  performing custom output length predictions in multiple places.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index fe376fe..0f9d0d4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4070,20 +4070,16 @@ static int list_locations(struct kmem_cache *s, char *buf,
 
 		if (num_online_cpus() > 1 &&
 				!cpumask_empty(to_cpumask(l->cpus)) &&
-				len < PAGE_SIZE - 60) {
-			len += sprintf(buf + len, " cpus=");
-			len += cpulist_scnprintf(buf + len,
-						 PAGE_SIZE - len - 50,
-						 to_cpumask(l->cpus));
-		}
+				len < PAGE_SIZE - 60)
+			len += scnprintf(buf + len, PAGE_SIZE - len - 50,
+					 " cpus=%*pbl",
+					 cpumask_pr_args(to_cpumask(l->cpus)));
 
 		if (nr_online_nodes > 1 && !nodes_empty(l->nodes) &&
-				len < PAGE_SIZE - 60) {
-			len += sprintf(buf + len, " nodes=");
-			len += nodelist_scnprintf(buf + len,
-						  PAGE_SIZE - len - 50,
-						  l->nodes);
-		}
+				len < PAGE_SIZE - 60)
+			len += scnprintf(buf + len, PAGE_SIZE - len - 50,
+					 " nodes=%*pbl",
+					 nodemask_pr_args(&l->nodes));
 
 		len += sprintf(buf + len, "\n");
 	}
-- 
2.1.0

