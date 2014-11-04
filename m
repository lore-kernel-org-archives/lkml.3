Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaKDIu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:50:28 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:58379 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaKDIuX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 4 Nov 2014 03:50:23 -0500
Message-Id: <5458A15A0200007800044A9A@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 04 Nov 2014 08:50:18 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86-64: handle PC-relative relocations on per-CPU
 data
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation of using RIP-relative addressing in many of the
per-CPU accesses.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/boot/compressed/misc.c |   14 +++++++++++++-
 arch/x86/tools/relocs.c         |   38 ++++++++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 11 deletions(-)

--- 3.18-rc3-x86_64-PCrel-per-CPU.orig/arch/x86/boot/compressed/misc.c
+++ 3.18-rc3-x86_64-PCrel-per-CPU/arch/x86/boot/compressed/misc.c
@@ -260,7 +260,7 @@ static void handle_relocations(void *out
 
 	/*
 	 * Process relocations: 32 bit relocations first then 64 bit after.
-	 * Two sets of binary relocations are added to the end of the kernel
+	 * Three sets of binary relocations are added to the end of the kernel
 	 * before compression. Each relocation table entry is the kernel
 	 * address of the location which needs to be updated stored as a
 	 * 32-bit value which is sign extended to 64 bits.
@@ -270,6 +270,8 @@ static void handle_relocations(void *out
 	 * kernel bits...
 	 * 0 - zero terminator for 64 bit relocations
 	 * 64 bit relocation repeated
+	 * 0 - zero terminator for inverse 32 bit relocations
+	 * 32 bit inverse relocation repeated
 	 * 0 - zero terminator for 32 bit relocations
 	 * 32 bit relocation repeated
 	 *
@@ -286,6 +288,16 @@ static void handle_relocations(void *out
 		*(uint32_t *)ptr += delta;
 	}
 #ifdef CONFIG_X86_64
+	while (*--reloc) {
+		long extended = *reloc;
+		extended += map;
+
+		ptr = (unsigned long)extended;
+		if (ptr < min_addr || ptr > max_addr)
+			error("inverse 32-bit relocation outside of kernel!\n");
+
+		*(int32_t *)ptr -= delta;
+	}
 	for (reloc--; *reloc; reloc--) {
 		long extended = *reloc;
 		extended += map;
--- 3.18-rc3-x86_64-PCrel-per-CPU.orig/arch/x86/tools/relocs.c
+++ 3.18-rc3-x86_64-PCrel-per-CPU/arch/x86/tools/relocs.c
@@ -20,7 +20,10 @@ struct relocs {
 
 static struct relocs relocs16;
 static struct relocs relocs32;
+#if ELF_BITS == 64
+static struct relocs relocs32neg;
 static struct relocs relocs64;
+#endif
 
 struct section {
 	Elf_Shdr       shdr;
@@ -762,11 +765,16 @@ static int do_reloc64(struct section *se
 
 	switch (r_type) {
 	case R_X86_64_NONE:
+		/* NONE can be ignored. */
+		break;
+
 	case R_X86_64_PC32:
 		/*
-		 * NONE can be ignored and PC relative relocations don't
-		 * need to be adjusted.
+		 * PC relative relocations don't need to be adjusted unless
+		 * referencing a percpu symbol.
 		 */
+		if (is_percpu_sym(sym, symname))
+			add_reloc(&relocs32neg, offset);
 		break;
 
 	case R_X86_64_32:
@@ -986,7 +994,10 @@ static void emit_relocs(int as_text, int
 	/* Order the relocations for more efficient processing */
 	sort_relocs(&relocs16);
 	sort_relocs(&relocs32);
+#if ELF_BITS == 64
+	sort_relocs(&relocs32neg);
 	sort_relocs(&relocs64);
+#endif
 
 	/* Print the relocations */
 	if (as_text) {
@@ -1007,14 +1018,21 @@ static void emit_relocs(int as_text, int
 		for (i = 0; i < relocs32.count; i++)
 			write_reloc(relocs32.offset[i], stdout);
 	} else {
-		if (ELF_BITS == 64) {
-			/* Print a stop */
-			write_reloc(0, stdout);
-
-			/* Now print each relocation */
-			for (i = 0; i < relocs64.count; i++)
-				write_reloc(relocs64.offset[i], stdout);
-		}
+#if ELF_BITS == 64
+		/* Print a stop */
+		write_reloc(0, stdout);
+
+		/* Now print each relocation */
+		for (i = 0; i < relocs64.count; i++)
+			write_reloc(relocs64.offset[i], stdout);
+
+		/* Print a stop */
+		write_reloc(0, stdout);
+
+		/* Now print each inverse 32-bit relocation */
+		for (i = 0; i < relocs32neg.count; i++)
+			write_reloc(relocs32neg.offset[i], stdout);
+#endif
 
 		/* Print a stop */
 		write_reloc(0, stdout);



