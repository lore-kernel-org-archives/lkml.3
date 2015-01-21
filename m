Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbbAUDiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:38:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbbAUDiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:38:01 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        keescook@chromium.org, vgoyal@redhat.com, whissi@whissi.de,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH 5/6] change the relocations behavior for kaslr on x86_64
Date: Wed, 21 Jan 2015 11:37:16 +0800
Message-Id: <1421811437-2787-6-git-send-email-bhe@redhat.com>
In-Reply-To: <1421811437-2787-1-git-send-email-bhe@redhat.com>
References: <1421811437-2787-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64, in old kaslr implementaion only physical address of kernel
loading is randomized. Then calculate the delta of physical address
where vmlinux was linked to load and where it is finally loaded. If
delta is not equal to 0, namely there's a new physical address where
kernel is actually decompressed, relocation handling need be done. Then
delta is added to offset of kernel symbol relocation, this makes the
address of kernel text mapping move delta long.

Here the behavior is changed. We randomize both the physical address
where kernel is decompressed and the virtual address where kernel text
is mapped. And relocation handling only depends on virtual address
randomization. Means if and only if virtual address is randomized to
a different value, we add the delta to the offset of kernel relocs.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/misc.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index acd4db1..ca9f28f 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -231,7 +231,8 @@ static void error(char *x)
 }
 
 #if CONFIG_X86_NEED_RELOCS
-static void handle_relocations(void *output, unsigned long output_len)
+static void handle_relocations(void *output, unsigned long output_len,
+				unsigned char *virt_rand_offset)
 {
 	int *reloc;
 	unsigned long delta, map, ptr;
@@ -243,11 +244,6 @@ static void handle_relocations(void *output, unsigned long output_len)
 	 * and where it was actually loaded.
 	 */
 	delta = min_addr - LOAD_PHYSICAL_ADDR;
-	if (!delta) {
-		debug_putstr("No relocation needed... ");
-		return;
-	}
-	debug_putstr("Performing relocations... ");
 
 	/*
 	 * The kernel contains a table of relocation addresses. Those
@@ -259,6 +255,19 @@ static void handle_relocations(void *output, unsigned long output_len)
 	map = delta - __START_KERNEL_map;
 
 	/*
+	 * For x86_64 calculate the delta between where kernel was linked
+	 * and where it was finally mapped.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64))
+		delta = (unsigned long)virt_rand_offset - LOAD_PHYSICAL_ADDR;
+
+	if (!delta) {
+		debug_putstr("No relocation needed... ");
+		return;
+	}
+	debug_putstr("Performing relocations... ");
+
+	/*
 	 * Process relocations: 32 bit relocations first then 64 bit after.
 	 * Three sets of binary relocations are added to the end of the kernel
 	 * before compression. Each relocation table entry is the kernel
@@ -311,7 +320,8 @@ static void handle_relocations(void *output, unsigned long output_len)
 #endif
 }
 #else
-static inline void handle_relocations(void *output, unsigned long output_len)
+static inline void handle_relocations(void *output, unsigned long output_len,
+					unsigned char *virt_rand_offset)
 { }
 #endif
 
@@ -423,7 +433,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
-	handle_relocations(output, output_len);
+	handle_relocations(output, output_len, virt_rand_offset);
 	debug_putstr("done.\nBooting the kernel.\n");
 	return output;
 }
-- 
1.9.3

