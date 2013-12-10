Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3LJKKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:10:51 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:62611 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3LJKKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:10:49 -0500
Message-ID: <52A6E820.2030905@huawei.com>
Date: Tue, 10 Dec 2013 18:08:32 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <linux-efi@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] mm,x86: use E820_X_MAX instead of ARRAY_SIZE(e820.map)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use E820_X_MAX instead of ARRAY_SIZE(e820.map).
Code simplification, no functional changes.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 arch/x86/kernel/e820.c         |   10 +++++-----
 arch/x86/kernel/early-quirks.c |    2 +-
 arch/x86/kernel/setup.c        |    6 +++---
 arch/x86/platform/efi/efi.c    |    2 +-
 arch/x86/xen/setup.c           |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 174da5f..97800ba 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -112,7 +112,7 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 {
 	int x = e820x->nr_map;
 
-	if (x >= ARRAY_SIZE(e820x->map)) {
+	if (x >= E820_X_MAX) {
 		printk(KERN_ERR "e820: too many entries; ignoring [mem %#010llx-%#010llx]\n",
 		       (unsigned long long) start,
 		       (unsigned long long) (start + size - 1));
@@ -564,7 +564,7 @@ void __init update_e820(void)
 	u32 nr_map;
 
 	nr_map = e820.nr_map;
-	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
+	if (sanitize_e820_map(e820.map, E820_X_MAX, &nr_map))
 		return;
 	e820.nr_map = nr_map;
 	printk(KERN_INFO "e820: modified physical RAM map:\n");
@@ -575,7 +575,7 @@ static void __init update_e820_saved(void)
 	u32 nr_map;
 
 	nr_map = e820_saved.nr_map;
-	if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
+	if (sanitize_e820_map(e820_saved.map, E820_X_MAX, &nr_map))
 		return;
 	e820_saved.nr_map = nr_map;
 }
@@ -668,7 +668,7 @@ void __init parse_e820_ext(u64 phys_addr, u32 data_len)
 	entries = sdata->len / sizeof(struct e820entry);
 	extmap = (struct e820entry *)(sdata->data);
 	__append_e820_map(extmap, entries);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820.map, E820_X_MAX, &e820.nr_map);
 	early_iounmap(sdata, data_len);
 	printk(KERN_INFO "e820: extended physical RAM map:\n");
 	e820_print_map("extended");
@@ -901,7 +901,7 @@ void __init finish_e820_parsing(void)
 	if (userdef) {
 		u32 nr = e820.nr_map;
 
-		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
+		if (sanitize_e820_map(e820.map, E820_X_MAX, &nr) < 0)
 			early_panic("Invalid user supplied memory map");
 		e820.nr_map = nr;
 
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index bc4a088..281caa2 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -372,7 +372,7 @@ static void __init intel_graphics_stolen(int num, int slot, int func)
 				/* Mark this space as reserved */
 				e820_add_region(start, size, E820_RESERVED);
 				sanitize_e820_map(e820.map,
-						  ARRAY_SIZE(e820.map),
+						  E820_X_MAX,
 						  &e820.nr_map);
 			}
 			return;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cb233bc..c734467 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -472,7 +472,7 @@ static void __init e820_reserve_setup_data(void)
 	if (!found)
 		return;
 
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820.map, E820_X_MAX, &e820.nr_map);
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
 	printk(KERN_INFO "extended physical RAM map:\n");
 	e820_print_map("reserve setup_data");
@@ -770,7 +770,7 @@ static void __init trim_bios_range(void)
 	 */
 	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
 
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820.map, E820_X_MAX, &e820.nr_map);
 }
 
 /* called before trim_bios_range() to spare extra sanitize */
@@ -1015,7 +1015,7 @@ void __init setup_arch(char **cmdline_p)
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
 				  E820_RESERVED);
-		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+		sanitize_e820_map(e820.map, E820_X_MAX, &e820.nr_map);
 		printk(KERN_INFO "fixed physical RAM map:\n");
 		e820_print_map("bad_ppro");
 	}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 92c0234..2e0fdcc 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -367,7 +367,7 @@ static void __init do_add_efi_memmap(void)
 		}
 		e820_add_region(start, size, e820_type);
 	}
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820.map, E820_X_MAX, &e820.nr_map);
 }
 
 int __init efi_memblock_x86_reserve_range(void)
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 68c054f..10550ff 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -485,7 +485,7 @@ char * __init xen_memory_setup(void)
 	memblock_reserve(__pa(xen_start_info->mfn_list),
 			 xen_start_info->pt_base - xen_start_info->mfn_list);
 
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820.map, E820_X_MAX, &e820.nr_map);
 
 	return "Xen";
 }
-- 
1.7.1


