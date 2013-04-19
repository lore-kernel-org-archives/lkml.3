Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab3DSJcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:32:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31313 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S967975Ab3DSJ3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:29:22 -0400
X-IronPort-AV: E=Sophos;i="4.87,508,1363104000"; 
   d="scan'208";a="7095290"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, davej@redhat.com, agordeev@redhat.com,
        suresh.b.siddha@intel.com, mst@redhat.com, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com, rientjes@google.com, tj@kernel.org,
        laijs@cn.fujitsu.com, hannes@cmpxchg.org, davem@davemloft.net,
        mgorman@suse.de, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v1 05/12] x86, numa, acpi, memory-hotplug: Consider hotplug info when cleanup numa_meminfo.
Date: Fri, 19 Apr 2013 17:31:42 +0800
Message-Id: <1366363909-12771-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1366363909-12771-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1366363909-12771-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/19 17:27:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/19 17:27:28,
	Serialize complete at 2013/04/19 17:27:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have introduced hotplug info into struct numa_meminfo, we need
to consider it when cleanup numa_meminfo.

The original logic in numa_cleanup_meminfo() is:
Merge blocks on the same node, holes between which don't overlap with
memory on other nodes.

This patch modifies numa_cleanup_meminfo() logic like this:
Merge blocks with the same hotpluggable type on the same node, holes
between which don't overlap with memory on other nodes.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index ecf37fd..26d1800 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -296,18 +296,22 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 			}
 
 			/*
-			 * Join together blocks on the same node, holes
-			 * between which don't overlap with memory on other
-			 * nodes.
+			 * Join together blocks on the same node, with the same
+			 * hotpluggable flags, holes between which don't overlap
+			 * with memory on other nodes.
 			 */
 			if (bi->nid != bj->nid)
 				continue;
+			if (bi->hotpluggable != bj->hotpluggable)
+				continue;
+
 			start = min(bi->start, bj->start);
 			end = max(bi->end, bj->end);
 			for (k = 0; k < mi->nr_blks; k++) {
 				struct numa_memblk *bk = &mi->blk[k];
 
-				if (bi->nid == bk->nid)
+				if (bi->nid == bk->nid &&
+				    bi->hotpluggable == bk->hotpluggable)
 					continue;
 				if (start < bk->end && end > bk->start)
 					break;
@@ -327,6 +331,7 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 	for (i = mi->nr_blks; i < ARRAY_SIZE(mi->blk); i++) {
 		mi->blk[i].start = mi->blk[i].end = 0;
 		mi->blk[i].nid = NUMA_NO_NODE;
+		mi->blk[i].hotpluggable = false;
 	}
 
 	return 0;
-- 
1.7.1

