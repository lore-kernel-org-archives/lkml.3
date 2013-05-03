Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337Ab3ECAJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:09:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55235 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760376Ab3ECABm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:01:42 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v3 23/31] x86: memlayout: add a arch specific inital memlayout setter.
Date: Thu,  2 May 2013 17:00:55 -0700
Message-Id: <1367539263-19999-24-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367539263-19999-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050300-7182-0000-0000-00000684B9B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86, we have numa_info specifically to track the numa layout, which
is precisely the data memlayout needs, so use it to create an initial
memlayout.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/x86/mm/numa.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index a71c4e2..75819ef 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -11,6 +11,7 @@
 #include <linux/nodemask.h>
 #include <linux/sched.h>
 #include <linux/topology.h>
+#include <linux/dnuma.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -32,6 +33,33 @@ __initdata
 #endif
 ;
 
+#ifdef CONFIG_DYNAMIC_NUMA
+void __init memlayout_global_init(void)
+{
+	struct numa_meminfo *mi = &numa_meminfo;
+	int i;
+	struct numa_memblk *blk;
+	struct memlayout *ml = memlayout_create(ML_INITIAL);
+	if (WARN_ON(!ml))
+		return;
+
+	pr_devel("x86/memlayout: adding ranges from numa_meminfo\n");
+	for (i = 0; i < mi->nr_blks; i++) {
+		blk = mi->blk + i;
+		pr_devel("  adding range {%LX[%LX]-%LX[%LX]}:%d\n",
+			 PFN_DOWN(blk->start), blk->start,
+			 PFN_DOWN(blk->end - PAGE_SIZE / 2 - 1),
+			 blk->end - 1, blk->nid);
+		memlayout_new_range(ml, PFN_DOWN(blk->start),
+				PFN_DOWN(blk->end - PAGE_SIZE / 2 - 1),
+				blk->nid);
+	}
+	pr_devel("  done adding ranges from numa_meminfo\n");
+
+	memlayout_commit(ml);
+}
+#endif
+
 static int numa_distance_cnt;
 static u8 *numa_distance;
 
-- 
1.8.2.2

