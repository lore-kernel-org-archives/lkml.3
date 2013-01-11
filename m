Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3AKJxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:53:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3AKJxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:53:51 -0500
Date: Fri, 11 Jan 2013 10:53:48 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jianguo Wu <wujianguo@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: mmots: memory-hotplug-remove-memmap-of-sparse-vmemmap.patch compile
 fix
Message-ID: <20130111095348.GB7286@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defconfig for x86_64 complains:
arch/x86/mm/init_64.c: In function ‘vmemmap_free’:
arch/x86/mm/init_64.c:1317: error: implicit declaration of function ‘remove_pagetable’

vmemmap_free is only used for CONFIG_MEMORY_HOTPLUG so let's move it
inside ifdef

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 arch/x86/mm/init_64.c |   16 ++++++++--------
 include/linux/mm.h    |    2 ++
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9920ffc..ddd3b58 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -981,6 +981,14 @@ remove_pagetable(unsigned long start, unsigned long end, bool direct)
 	flush_tlb_all();
 }
 
+void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
+{
+	unsigned long start = (unsigned long)memmap;
+	unsigned long end = (unsigned long)(memmap + nr_pages);
+
+	remove_pagetable(start, end, false);
+}
+
 static void __meminit
 kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 {
@@ -1309,14 +1317,6 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 	return 0;
 }
 
-void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
-{
-	unsigned long start = (unsigned long)memmap;
-	unsigned long end = (unsigned long)(memmap + nr_pages);
-
-	remove_pagetable(start, end, false);
-}
-
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0d880df..7c57bd0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1721,7 +1721,9 @@ int vmemmap_populate_basepages(struct page *start_page,
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
+#ifdef CONFIG_MEMORY_HOTPLUG
 void vmemmap_free(struct page *memmap, unsigned long nr_pages);
+#endif
 void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
 				  unsigned long size);
 
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
