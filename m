Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaHKKOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:14:55 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57125 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaHKKOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:14:53 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
X-Google-Original-From: "Lee, Chun-Yi" <jlee@suse.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Takashi Iwai <tiwai@suse.de>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Hibernate: save e820 table to snapshot header for comparison
Date: Mon, 11 Aug 2014 18:13:07 +0800
Message-Id: <1407751987-21448-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If machine doesn't well handle the e820 persistent when hibernate
resuming, then it may causes page fault when writing image to snapshot
buffer:

[   17.929495] BUG: unable to handle kernel paging request at ffff880069d4f000
[   17.933469] IP: [<ffffffff810a1cf0>] load_image_lzo+0x810/0xe40
[   17.933469] PGD 2194067 PUD 77ffff067 PMD 2197067 PTE 0
[   17.933469] Oops: 0002 [#1] SMP
...

The ffff880069d4f000 page is in e820 reserved region of resume boot
kernel:

[    0.000000] BIOS-e820: [mem 0x0000000069d4f000-0x0000000069e12fff] reserved
...
[    0.000000] PM: Registered nosave memory: [mem 0x69d4f000-0x69e12fff]

So snapshot.c mark the pfn to forbidden pages map. But, this
page is also in the memory bitmap in snapshot image because it's an
original page used by image kernel, so it will also mark as an
unsafe(free) page in prepare_image().

That means the page in e820 when resuming mark as "forbidden" and
"free", it causes get_buffer() treat it as an allocated unsafe page.
Then snapshot_write_next() return this page to load_image, load_image
writing content to this address, but this page didn't really allocated
. So, we got page fault.

Although the root cause is from BIOS, I think aggressive check and
significant message in kernel will better then a page fault for
issue tracking, especially it's not easy to capture e820 table of
resuming when serial console unavailable.

This patch adds code in snapshot.c and e820.c to save the memory check map
in snapshot header. It's useful to compare e820 changed when hibernate
resuming. If e820 regions changed, then it prints e820 diff messages and
return fault to stop whole S4 resume process:

[    7.109482] e820: Check memory region: [mem 0x000000000009f000-0x000000000009ffff] ACPI NVS
[    7.116419] e820: Check memory region: [mem 0x0000000000100000-0x000000006796cfff] usable
[    7.123251]                Old region: [mem 0x0000000000100000-0x000000006796bfff] usable
[    7.130021] e820: Check memory region: [mem 0x000000006796d000-0x000000006796dfff] ACPI data
[    7.136866]                Old region: [mem 0x000000006796c000-0x000000006796cfff] ACPI data
[    7.143746] e820: Check memory region: [mem 0x000000006796e000-0x000000006926d017] usable
[    7.150684]                Old region: [mem 0x000000006796d000-0x000000006926d017] usable
[    7.157688] e820: Check memory region: [mem 0x000000006926d018-0x0000000069297657] usable
...
[    7.374714] e820: Check memory region: [mem 0x0000000100000000-0x000000187fffffff] usable
[    7.378041] PM: Image mismatch: memory map changed
[    7.381314] PM: Read 2398272 kbytes in 0.27 seconds (8882.48 MB/s)
[    7.385476] PM: Error -1 resuming
[    7.388730] PM: Failed to load hibernation image, recovering.
[    7.688989] PM: Basic memory bitmaps freed

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/kernel/e820.c  | 87 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/suspend.h | 18 ++++++++++
 kernel/power/power.h    |  2 ++
 kernel/power/snapshot.c |  3 ++
 4 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 988c00a..5c1d0b7 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -130,7 +130,7 @@ void __init e820_add_region(u64 start, u64 size, int type)
 	__e820_add_region(&e820, start, size, type);
 }
 
-static void __init e820_print_type(u32 type)
+static void e820_print_type(u32 type)
 {
 	switch (type) {
 	case E820_RAM:
@@ -704,6 +704,91 @@ void __init e820_mark_nosave_regions(unsigned long limit_pfn)
 			break;
 	}
 }
+
+int save_mem_chk_map(struct mementry *mem_chk_map)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (i > MEMCHKMAX)
+			break;
+
+		mem_chk_map[i].addr = ei->addr;
+		mem_chk_map[i].size = ei->size;
+		mem_chk_map[i].type = ei->type;
+	}
+
+	/* return number or e820 regions for amount comparison */
+	return e820.nr_map;
+}
+
+static void print_mem_chk_map(int mem_chk_entries, struct mementry *mem_chk_map)
+{
+	int i;
+
+	for (i = 0; i < mem_chk_entries; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		printk(KERN_INFO "e820: Check memory region: [mem %#018Lx-%#018Lx] ",
+		       (unsigned long long) ei->addr,
+		       (unsigned long long) (ei->addr + ei->size - 1));
+		e820_print_type(ei->type);
+		printk(KERN_CONT "\n");
+
+		/* Don't print over the maximum amount of check entries */
+		if (i > MEMCHKMAX)
+			continue;
+
+		if (mem_chk_map[i].addr != ei->addr ||
+		    mem_chk_map[i].size != ei->size ||
+		    mem_chk_map[i].type != ei->type) {
+			printk(KERN_INFO "               Old region: [mem %#018Lx-%#018Lx] ",
+			       (unsigned long long) mem_chk_map[i].addr,
+			       (unsigned long long)
+			       (mem_chk_map[i].addr + mem_chk_map[i].size - 1));
+			e820_print_type(mem_chk_map[i].type);
+			printk(KERN_CONT "\n");
+		}
+	}
+}
+
+bool check_mem_map(int mem_chk_entries, struct mementry *mem_chk_map)
+{
+	int i;
+	bool ret = true;
+
+	if (mem_chk_entries != e820.nr_map) {
+		pr_err("PM: memory check entry number %d:%d\n",
+			mem_chk_entries, e820.nr_map);
+		ret = false;
+		goto Print_map;
+	}
+
+	for (i = 0; i < mem_chk_entries; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (i > MEMCHKMAX)
+			break;
+
+		/* check regions not E820_RAM or E820_RESERVED_KERN */
+		if (ei->type != E820_RAM && ei->type != E820_RESERVED_KERN) {
+			if (mem_chk_map[i].addr != ei->addr ||
+			    mem_chk_map[i].size != ei->size ||
+			    mem_chk_map[i].type != ei->type) {
+				ret = false;
+				goto Print_map;
+			}
+		}
+	}
+
+Print_map:
+	if (!ret)
+		print_mem_chk_map(mem_chk_entries, mem_chk_map);
+
+	return ret;
+}
 #endif
 
 #ifdef CONFIG_ACPI
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 24d63e8..49b43d4 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -309,6 +309,22 @@ struct platform_hibernation_ops {
 };
 
 #ifdef CONFIG_HIBERNATION
+#define MEMCHKMAX 128   /* number of entries in memory check map */
+struct mementry {
+	__u64 addr;     /* start of memory segment */
+	__u64 size;     /* size of memory segment */
+	__u32 type;     /* type of memory segment */
+} __attribute__((packed));
+
+/* arch/x86/kernel/e820.c */
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_32)
+extern int save_mem_chk_map(struct mementry *);
+extern bool check_mem_map(int, struct mementry *);
+#else
+static int save_mem_chk_map(struct mementry *m) {return 0}
+static bool check_mem_map(int n, struct mementry *m) {return true}
+#endif /* CONFIG_X86_64 || CONFIG_X86_32 */
+
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
 static inline void __init register_nosave_region(unsigned long b, unsigned long e)
@@ -333,6 +349,8 @@ extern struct pbe *restore_pblist;
 #else /* CONFIG_HIBERNATION */
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
 static inline void register_nosave_region_late(unsigned long b, unsigned long e) {}
+static int save_mem_chk_map(struct mementry *m) {return 0}
+static bool check_mem_map(int n, struct mementry *m) {return true}
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 5d49dca..83730fc 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -12,6 +12,8 @@ struct swsusp_info {
 	unsigned long		image_pages;
 	unsigned long		pages;
 	unsigned long		size;
+	int                     mem_chk_entries;
+	struct mementry         mem_chk_map[MEMCHKMAX];
 } __aligned(PAGE_SIZE);
 
 #ifdef CONFIG_HIBERNATION
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index c4b8093..9d4f5f9 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1925,6 +1925,7 @@ static int init_header(struct swsusp_info *info)
 	info->pages = snapshot_get_image_size();
 	info->size = info->pages;
 	info->size <<= PAGE_SHIFT;
+	info->mem_chk_entries = save_mem_chk_map(info->mem_chk_map);
 	return init_header_complete(info);
 }
 
@@ -2066,6 +2067,8 @@ static int check_header(struct swsusp_info *info)
 	reason = check_image_kernel(info);
 	if (!reason && info->num_physpages != get_num_physpages())
 		reason = "memory size";
+	if (!reason && !check_mem_map(info->mem_chk_entries, info->mem_chk_map))
+		reason = "memory map changed";
 	if (reason) {
 		printk(KERN_ERR "PM: Image mismatch: %s\n", reason);
 		return -EPERM;
-- 
1.8.4.5

