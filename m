Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab3ENM0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:26:12 -0400
Received: from intranet.asianux.com ([58.214.24.6]:21716 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab3ENM0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:26:11 -0400
X-Spam-Score: -100.8
Message-ID: <51922D30.8000809@asianux.com>
Date: Tue, 14 May 2013 20:25:20 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: tj@kernel.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/workqueue.c: better to free related resources when
 failure occurs in wq_numa_init()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When NUMA node mapping not available for one cpu, need disabling NUMA
support and proceed.

Also better to release unused resources (the original code can not
cause issue, only waste some memory).


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/workqueue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1ae6028..a763079 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4911,6 +4911,9 @@ static void __init wq_numa_init(void)
 		if (WARN_ON(node == NUMA_NO_NODE)) {
 			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
 			/* happens iff arch is bonkers, let's just proceed */
+			for_each_node(node)
+				free_cpumask_var(tbl[node]);
+			kfree(tbl);
 			return;
 		}
 		cpumask_set_cpu(cpu, tbl[node]);
-- 
1.7.11.7
