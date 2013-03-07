Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab3CGO7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:59:08 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:32997 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3CGO7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:59:04 -0500
Subject: [RFC PATCH 3/5] crash dump bitmap: scan memory pages in kernel
 crash process
To: mingo@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        hpa@zytor.com, yinghai@kernel.org, vgoyal@redhat.com
From: Jingbai Ma <jingbai.ma@hp.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 22:58:55 +0800
Message-ID: <20130307145854.29098.59673.stgit@k.asiapacific.hpqcorp.net>
In-Reply-To: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the kernel crash process, call generate_crash_dump_bitmap() to scans
all memory pages, clear the bit for all excluded memory pages in the
reserved memory.

Signed-off-by: Jingbai Ma <jingbai.ma@hp.com>
---
 kernel/crash_dump_bitmap.c |  156 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/kexec.c             |    5 +
 2 files changed, 161 insertions(+), 0 deletions(-)

diff --git a/kernel/crash_dump_bitmap.c b/kernel/crash_dump_bitmap.c
index e743cdd..eed13ca 100644
--- a/kernel/crash_dump_bitmap.c
+++ b/kernel/crash_dump_bitmap.c
@@ -23,6 +23,8 @@
 
 #ifdef CONFIG_CRASH_DUMP_BITMAP
 
+#define virt_to_pfn(kaddr) (__pa(kaddr) >> PAGE_SHIFT)
+
 phys_addr_t crash_dump_bitmap_mem;
 EXPORT_SYMBOL(crash_dump_bitmap_mem);
 
@@ -35,6 +37,7 @@ EXPORT_SYMBOL(crash_dump_bitmap_ctrl);
 struct crash_dump_bitmap_info crash_dump_bitmap_info;
 EXPORT_SYMBOL(crash_dump_bitmap_info);
 
+
 /* Location of the reserved area for the crash_dump_bitmap */
 struct resource crash_dump_bitmap_res = {
 	.name  = "Crash dump bitmap",
@@ -42,4 +45,157 @@ struct resource crash_dump_bitmap_res = {
 	.end   = 0,
 	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
 };
+
+inline void set_crash_dump_bitmap(unsigned long pfn, int val)
+{
+	phys_addr_t paddr = crash_dump_bitmap_info.bitmap + (pfn >> 3);
+	unsigned char *vaddr;
+	unsigned char bit = (pfn & 7);
+
+	if (unlikely(paddr > (crash_dump_bitmap_mem
+		+ crash_dump_bitmap_mem_size))) {
+		pr_err(
+		"crash_dump_bitmap: pfn exceed limit. pfn=%ld, addr=0x%llX\n",
+		pfn, paddr);
+		return;
+	}
+
+	vaddr = (unsigned char *)__va(paddr);
+
+	if (val)
+		*vaddr |= (1U << bit);
+	else
+		*vaddr &= (~(1U << bit));
+}
+
+void generate_crash_dump_bitmap(void)
+{
+	pg_data_t *pgdat;
+	struct zone *zone;
+	unsigned long flags;
+	int order, t;
+	struct list_head *curr;
+	unsigned long zone_free_pages;
+	phys_addr_t addr;
+
+	if (!crash_dump_bitmap_mem) {
+		pr_info("crash_dump_bitmap: no crash_dump_bitmap memory.\n");
+		return;
+	}
+
+	pr_info(
+	"Excluding pages: bitmap=%d, cache=%d, private=%d, user=%d, free=%d\n",
+		crash_dump_bitmap_ctrl.exclude_crash_dump_bitmap_pages,
+		crash_dump_bitmap_ctrl.exclude_cache_pages,
+		crash_dump_bitmap_ctrl.exclude_cache_private_pages,
+		crash_dump_bitmap_ctrl.exclude_user_pages,
+		crash_dump_bitmap_ctrl.exclude_free_pages);
+
+	crash_dump_bitmap_info.free_pages = 0;
+	crash_dump_bitmap_info.cache_pages = 0;
+	crash_dump_bitmap_info.cache_private_pages = 0;
+	crash_dump_bitmap_info.user_pages = 0;
+	crash_dump_bitmap_info.hwpoison_pages = 0;
+
+	/* Set all bits on bitmap */
+	memset(__va(crash_dump_bitmap_info.bitmap), 0xff,
+		crash_dump_bitmap_info.bitmap_size);
+
+	/* Exclude all crash_dump_bitmap pages */
+	if (crash_dump_bitmap_ctrl.exclude_crash_dump_bitmap_pages) {
+		for (addr = crash_dump_bitmap_mem; addr <
+			crash_dump_bitmap_mem + crash_dump_bitmap_mem_size;
+			addr += PAGE_SIZE)
+				set_crash_dump_bitmap(
+					virt_to_pfn(__va(addr)), 0);
+	}
+
+	/* Exclude unnecessary pages */
+	for_each_online_pgdat(pgdat) {
+		unsigned long i;
+		unsigned long flags;
+
+		pgdat_resize_lock(pgdat, &flags);
+		for (i = 0; i < pgdat->node_spanned_pages; i++) {
+			struct page *page;
+			unsigned long pfn = pgdat->node_start_pfn + i;
+
+			if (!pfn_valid(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+
+			/* Exclude the cache pages without the private page */
+			if (crash_dump_bitmap_ctrl.exclude_cache_pages
+				&& (PageLRU(page) || PageSwapCache(page))
+				&& !page_has_private(page) && !PageAnon(page)) {
+					set_crash_dump_bitmap(pfn, 0);
+					crash_dump_bitmap_info.cache_pages++;
+			}
+			/* Exclude the cache pages with private page */
+			else if (
+			crash_dump_bitmap_ctrl.exclude_cache_private_pages
+				&& (PageLRU(page) || PageSwapCache(page))
+				&& !PageAnon(page)) {
+					set_crash_dump_bitmap(pfn, 0);
+				crash_dump_bitmap_info.cache_private_pages++;
+			}
+			/* Exclude the pages used by user process */
+			else if (crash_dump_bitmap_ctrl.exclude_user_pages
+					&& PageAnon(page)) {
+					set_crash_dump_bitmap(pfn, 0);
+					crash_dump_bitmap_info.user_pages++;
+			}
+#ifdef CONFIG_MEMORY_FAILURE
+			/* Exclude the hwpoison pages */
+			else if (PageHWPoison(page)) {
+					set_crash_dump_bitmap(pfn, 0);
+					crash_dump_bitmap_info.hwpoison_pages++;
+			}
+#endif
+		}
+		pgdat_resize_unlock(pgdat, &flags);
+	}
+
+	/* Exclude the free pages managed by a buddy system */
+	if (crash_dump_bitmap_ctrl.exclude_free_pages) {
+		for_each_populated_zone(zone) {
+			if (!zone->spanned_pages)
+				continue;
+
+			spin_lock_irqsave(&zone->lock, flags);
+
+			zone_free_pages = 0;
+			for_each_migratetype_order(order, t) {
+				list_for_each(
+				curr, &zone->free_area[order].free_list[t]) {
+					unsigned long i;
+					struct page *page = list_entry(curr,
+						struct page, lru);
+					for (i = 0; i < (1 << order); i++) {
+						set_crash_dump_bitmap(
+						page_to_pfn(page + i), 0);
+						zone_free_pages++;
+					crash_dump_bitmap_info.free_pages++;
+					}
+				}
+			}
+			spin_unlock_irqrestore(&zone->lock, flags);
+		}
+	}
+
+	pr_info("crash_dump_bitmap: excluded pages: cache=%ld, private=%ld\n",
+		crash_dump_bitmap_info.cache_pages,
+		crash_dump_bitmap_info.cache_private_pages);
+	pr_info("crash_dump_bitmap: excluded pages: user=%ld, free=%ld\n",
+		crash_dump_bitmap_info.user_pages,
+		crash_dump_bitmap_info.free_pages);
+	pr_info("crash_dump_bitmap: excluded pages: hwpoison=%ld\n",
+		crash_dump_bitmap_info.hwpoison_pages);
+}
+EXPORT_SYMBOL(generate_crash_dump_bitmap);
+#else
+void generate_crash_dump_bitmap(void)
+{
+}
 #endif /* CONFIG_CRASH_DUMP_BITMAP */
diff --git a/kernel/kexec.c b/kernel/kexec.c
index bddd3d7..ce00f0f 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -32,6 +32,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
+#include <linux/crash_dump_bitmap.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1097,6 +1098,7 @@ void crash_kexec(struct pt_regs *regs)
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
+			generate_crash_dump_bitmap();
 			machine_kexec(kexec_crash_image);
 		}
 		mutex_unlock(&kexec_mutex);
@@ -1495,6 +1497,9 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_SYMBOL(mem_map);
 	VMCOREINFO_SYMBOL(contig_page_data);
 #endif
+#ifdef CONFIG_CRASH_DUMP_BITMAP
+	VMCOREINFO_SYMBOL(crash_dump_bitmap_info);
+#endif
 #ifdef CONFIG_SPARSEMEM
 	VMCOREINFO_SYMBOL(mem_section);
 	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);

