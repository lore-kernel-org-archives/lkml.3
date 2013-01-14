Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3ANKy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:54:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:35439 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab3ANKy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:54:57 -0500
X-IronPort-AV: E=Sophos;i="4.84,467,1355068800"; 
   d="scan'208";a="6583410"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, mhocko@suse.cz, linux-mm@kvack.org
Cc: wency@cn.fujitsu.com, jiang.liu@huawei.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com, linfeng@cn.fujitsu.com
Subject: [PATCH] memory-hotplug: revert register_page_bootmem_info_node() to empty when platform related code is not implemented
Date: Mon, 14 Jan 2013 18:53:55 +0800
Message-Id: <1358160835-30617-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/14 18:54:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/14 18:54:14,
	Serialize complete at 2013/01/14 18:54:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory-hotplug codes for x86_64 have been implemented by patchset:
https://lkml.org/lkml/2013/1/9/124
While other platforms haven't been completely implemented yet.

If we enable both CONFIG_MEMORY_HOTPLUG_SPARSE and CONFIG_SPARSEMEM_VMEMMAP,
register_page_bootmem_info_node() may be buggy, which is a hotplug generic
function but falling back to call platform related function
register_page_bootmem_memmap().

Other platforms such as powerpc it's not implemented, so on such platforms,
revert them as empty as they were before.

Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 mm/memory_hotplug.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8aa2b56..bd93c2e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -189,6 +189,7 @@ static void register_page_bootmem_info_section(unsigned long start_pfn)
 }
 #endif
 
+#ifdef CONFIG_X86_64
 void register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
 	unsigned long i, pfn, end_pfn, nr_pages;
@@ -230,6 +231,14 @@ void register_page_bootmem_info_node(struct pglist_data *pgdat)
 			register_page_bootmem_info_section(pfn);
 	}
 }
+#else
+static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
+{
+	/*
+	 * Todo: platforms other than X86_64 haven't been implemented yet.
+	 */
+}
+#endif
 
 static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
 			   unsigned long end_pfn)
-- 
1.7.1

