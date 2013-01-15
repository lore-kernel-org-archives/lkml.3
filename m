Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab3AOKVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:21:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62858 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab3AOKVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:21:07 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355068800"; 
   d="scan'208";a="6591167"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, mhocko@suse.cz, linux-mm@kvack.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan@kernel.org,
        aquini@redhat.com, wency@cn.fujitsu.com, jiang.liu@huawei.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH V2] memory-hotplug: revert register_page_bootmem_info_node() to empty when platform related code is not implemented
Date: Tue, 15 Jan 2013 18:20:03 +0800
Message-Id: <1358245203-4181-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 18:20:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 18:20:21,
	Serialize complete at 2013/01/15 18:20:21
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
revert them to empty as they were before.

It's implemented by adding a new Kconfig option named
CONFIG_HAVE_BOOTMEM_INFO_NODE, which will be automatically selected by
supported archs(currently only on x86_64).

Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
ChangeLog v1->v2:
- Add a Kconfig option named HAVE_BOOTMEM_INFO_NODE suggested by Michal, which
  will be automatically selected by supported archs(currently only on x86_64).
---
 mm/Kconfig          |    8 ++++++++
 mm/memory_hotplug.c |    7 +++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 278e3ab..f8c5799 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -162,10 +162,18 @@ config MOVABLE_NODE
 	  Say Y here if you want to hotplug a whole node.
 	  Say N here if you want kernel to use memory on all nodes evenly.
 
+#
+# Only be set on architectures that have completely implemented memory hotplug
+# feature. If you are not sure, don't touch it.
+#
+config HAVE_BOOTMEM_INFO_NODE
+	def_bool n
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	select MEMORY_ISOLATION
+	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8aa2b56..ef7a5c8 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -189,6 +189,7 @@ static void register_page_bootmem_info_section(unsigned long start_pfn)
 }
 #endif
 
+#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 void register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
 	unsigned long i, pfn, end_pfn, nr_pages;
@@ -230,6 +231,12 @@ void register_page_bootmem_info_node(struct pglist_data *pgdat)
 			register_page_bootmem_info_section(pfn);
 	}
 }
+#else
+void register_page_bootmem_info_node(struct pglist_data *pgdat)
+{
+	/* TODO */
+}
+#endif
 
 static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
 			   unsigned long end_pfn)
-- 
1.7.1

