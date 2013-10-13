Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3JMMCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 08:02:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43717 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab3JMMCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 08:02:01 -0400
Date: Sun, 13 Oct 2013 05:01:49 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-82fa9637a2ba285bcc7c5050c73010b2c1b3d803@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381450698-28710-5-git-send-email-keescook@chromium.org>
References: <1381450698-28710-5-git-send-email-keescook@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, kaslr: Select random position from e820 maps
Git-Commit-ID: 82fa9637a2ba285bcc7c5050c73010b2c1b3d803
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 13 Oct 2013 05:01:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82fa9637a2ba285bcc7c5050c73010b2c1b3d803
Gitweb:     http://git.kernel.org/tip/82fa9637a2ba285bcc7c5050c73010b2c1b3d803
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 10 Oct 2013 17:18:16 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 13 Oct 2013 03:12:19 -0700

x86, kaslr: Select random position from e820 maps

Counts available alignment positions across all e820 maps, and chooses
one randomly for the new kernel base address, making sure not to collide
with unsafe memory areas.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/1381450698-28710-5-git-send-email-keescook@chromium.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/aslr.c | 193 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/boot/compressed/misc.c |  10 +--
 arch/x86/boot/compressed/misc.h |   8 ++
 3 files changed, 202 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 14b24e0..0595798 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -3,6 +3,7 @@
 #ifdef CONFIG_RANDOMIZE_BASE
 #include <asm/msr.h>
 #include <asm/archrandom.h>
+#include <asm/e820.h>
 
 #define I8254_PORT_CONTROL	0x43
 #define I8254_PORT_COUNTER0	0x40
@@ -55,20 +56,210 @@ static unsigned long get_random_long(void)
 	return random;
 }
 
+struct mem_vector {
+	unsigned long start;
+	unsigned long size;
+};
+
+#define MEM_AVOID_MAX 5
+struct mem_vector mem_avoid[MEM_AVOID_MAX];
+
+static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
+{
+	/* Item at least partially before region. */
+	if (item->start < region->start)
+		return false;
+	/* Item at least partially after region. */
+	if (item->start + item->size > region->start + region->size)
+		return false;
+	return true;
+}
+
+static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
+{
+	/* Item one is entirely before item two. */
+	if (one->start + one->size <= two->start)
+		return false;
+	/* Item one is entirely after item two. */
+	if (one->start >= two->start + two->size)
+		return false;
+	return true;
+}
+
+static void mem_avoid_init(unsigned long input, unsigned long input_size,
+			   unsigned long output, unsigned long output_size)
+{
+	u64 initrd_start, initrd_size;
+	u64 cmd_line, cmd_line_size;
+	unsigned long unsafe, unsafe_len;
+	char *ptr;
+
+	/*
+	 * Avoid the region that is unsafe to overlap during
+	 * decompression (see calculations at top of misc.c).
+	 */
+	unsafe_len = (output_size >> 12) + 32768 + 18;
+	unsafe = (unsigned long)input + input_size - unsafe_len;
+	mem_avoid[0].start = unsafe;
+	mem_avoid[0].size = unsafe_len;
+
+	/* Avoid initrd. */
+	initrd_start  = (u64)real_mode->ext_ramdisk_image << 32;
+	initrd_start |= real_mode->hdr.ramdisk_image;
+	initrd_size  = (u64)real_mode->ext_ramdisk_size << 32;
+	initrd_size |= real_mode->hdr.ramdisk_size;
+	mem_avoid[1].start = initrd_start;
+	mem_avoid[1].size = initrd_size;
+
+	/* Avoid kernel command line. */
+	cmd_line  = (u64)real_mode->ext_cmd_line_ptr << 32;
+	cmd_line |= real_mode->hdr.cmd_line_ptr;
+	/* Calculate size of cmd_line. */
+	ptr = (char *)(unsigned long)cmd_line;
+	for (cmd_line_size = 0; ptr[cmd_line_size++]; )
+		;
+	mem_avoid[2].start = cmd_line;
+	mem_avoid[2].size = cmd_line_size;
+
+	/* Avoid heap memory. */
+	mem_avoid[3].start = (unsigned long)free_mem_ptr;
+	mem_avoid[3].size = BOOT_HEAP_SIZE;
+
+	/* Avoid stack memory. */
+	mem_avoid[4].start = (unsigned long)free_mem_end_ptr;
+	mem_avoid[4].size = BOOT_STACK_SIZE;
+}
+
+/* Does this memory vector overlap a known avoided area? */
+bool mem_avoid_overlap(struct mem_vector *img)
+{
+	int i;
+
+	for (i = 0; i < MEM_AVOID_MAX; i++) {
+		if (mem_overlaps(img, &mem_avoid[i]))
+			return true;
+	}
+
+	return false;
+}
+
+unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET / CONFIG_PHYSICAL_ALIGN];
+unsigned long slot_max = 0;
+
+static void slots_append(unsigned long addr)
+{
+	/* Overflowing the slots list should be impossible. */
+	if (slot_max >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
+			CONFIG_PHYSICAL_ALIGN)
+		return;
+
+	slots[slot_max++] = addr;
+}
+
+static unsigned long slots_fetch_random(void)
+{
+	/* Handle case of no slots stored. */
+	if (slot_max == 0)
+		return 0;
+
+	return slots[get_random_long() % slot_max];
+}
+
+static void process_e820_entry(struct e820entry *entry,
+			       unsigned long minimum,
+			       unsigned long image_size)
+{
+	struct mem_vector region, img;
+
+	/* Skip non-RAM entries. */
+	if (entry->type != E820_RAM)
+		return;
+
+	/* Ignore entries entirely above our maximum. */
+	if (entry->addr >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
+		return;
+
+	/* Ignore entries entirely below our minimum. */
+	if (entry->addr + entry->size < minimum)
+		return;
+
+	region.start = entry->addr;
+	region.size = entry->size;
+
+	/* Potentially raise address to minimum location. */
+	if (region.start < minimum)
+		region.start = minimum;
+
+	/* Potentially raise address to meet alignment requirements. */
+	region.start = ALIGN(region.start, CONFIG_PHYSICAL_ALIGN);
+
+	/* Did we raise the address above the bounds of this e820 region? */
+	if (region.start > entry->addr + entry->size)
+		return;
+
+	/* Reduce size by any delta from the original address. */
+	region.size -= region.start - entry->addr;
+
+	/* Reduce maximum size to fit end of image within maximum limit. */
+	if (region.start + region.size > CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
+		region.size = CONFIG_RANDOMIZE_BASE_MAX_OFFSET - region.start;
+
+	/* Walk each aligned slot and check for avoided areas. */
+	for (img.start = region.start, img.size = image_size ;
+	     mem_contains(&region, &img) ;
+	     img.start += CONFIG_PHYSICAL_ALIGN) {
+		if (mem_avoid_overlap(&img))
+			continue;
+		slots_append(img.start);
+	}
+}
+
+static unsigned long find_random_addr(unsigned long minimum,
+				      unsigned long size)
+{
+	int i;
+	unsigned long addr;
+
+	/* Make sure minimum is aligned. */
+	minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
+
+	/* Verify potential e820 positions, appending to slots list. */
+	for (i = 0; i < real_mode->e820_entries; i++) {
+		process_e820_entry(&real_mode->e820_map[i], minimum, size);
+	}
+
+	return slots_fetch_random();
+}
+
 unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
 				      unsigned long output_size)
 {
 	unsigned long choice = (unsigned long)output;
+	unsigned long random;
 
 	if (cmdline_find_option_bool("nokaslr")) {
 		debug_putstr("KASLR disabled...\n");
 		goto out;
 	}
 
-	/* XXX: choose random location. */
+	/* Record the various known unsafe memory ranges. */
+	mem_avoid_init((unsigned long)input, input_size,
+		       (unsigned long)output, output_size);
+
+	/* Walk e820 and find a random address. */
+	random = find_random_addr(choice, output_size);
+	if (!random) {
+		debug_putstr("KASLR could not find suitable E820 region...\n");
+		goto out;
+	}
+
+	/* Always enforce the minimum. */
+	if (random < choice)
+		goto out;
 
+	choice = random;
 out:
 	return (unsigned char *)choice;
 }
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7138768..196eaf3 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -112,14 +112,8 @@ struct boot_params *real_mode;		/* Pointer to real-mode data */
 void *memset(void *s, int c, size_t n);
 void *memcpy(void *dest, const void *src, size_t n);
 
-#ifdef CONFIG_X86_64
-#define memptr long
-#else
-#define memptr unsigned
-#endif
-
-static memptr free_mem_ptr;
-static memptr free_mem_end_ptr;
+memptr free_mem_ptr;
+memptr free_mem_end_ptr;
 
 static char *vidmem;
 static int vidport;
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 0782eb0..24e3e56 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -23,7 +23,15 @@
 #define BOOT_BOOT_H
 #include "../ctype.h"
 
+#ifdef CONFIG_X86_64
+#define memptr long
+#else
+#define memptr unsigned
+#endif
+
 /* misc.c */
+extern memptr free_mem_ptr;
+extern memptr free_mem_end_ptr;
 extern struct boot_params *real_mode;		/* Pointer to real-mode data */
 void __putstr(const char *s);
 #define error_putstr(__x)  __putstr(__x)
