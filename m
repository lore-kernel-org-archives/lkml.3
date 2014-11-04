Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaKDTpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:45:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKDTpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:45:44 -0500
Date: Tue, 4 Nov 2014 11:45:28 -0800
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-6d24c5f72dfb26e5fa7f02fa9266dfdbae41adba@git.kernel.org>
Cc: jbeulich@suse.com, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, JBeulich@suse.com, mingo@kernel.org
Reply-To: hpa@zytor.com, jbeulich@suse.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org, JBeulich@suse.com
In-Reply-To: <5458A15A0200007800044A9A@mail.emea.novell.com>
References: <5458A15A0200007800044A9A@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86-64:
  Handle PC-relative relocations on per-CPU data
Git-Commit-ID: 6d24c5f72dfb26e5fa7f02fa9266dfdbae41adba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d24c5f72dfb26e5fa7f02fa9266dfdbae41adba
Gitweb:     http://git.kernel.org/tip/6d24c5f72dfb26e5fa7f02fa9266dfdbae41adba
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 4 Nov 2014 08:50:18 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Nov 2014 20:43:14 +0100

x86-64: Handle PC-relative relocations on per-CPU data

This is in preparation of using RIP-relative addressing in many of the
per-CPU accesses.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/5458A15A0200007800044A9A@mail.emea.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/boot/compressed/misc.c | 14 +++++++++++++-
 arch/x86/tools/relocs.c         | 36 +++++++++++++++++++++++++++---------
 2 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 57ab74d..644abd7 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -260,7 +260,7 @@ static void handle_relocations(void *output, unsigned long output_len)
 
 	/*
 	 * Process relocations: 32 bit relocations first then 64 bit after.
-	 * Two sets of binary relocations are added to the end of the kernel
+	 * Three sets of binary relocations are added to the end of the kernel
 	 * before compression. Each relocation table entry is the kernel
 	 * address of the location which needs to be updated stored as a
 	 * 32-bit value which is sign extended to 64 bits.
@@ -270,6 +270,8 @@ static void handle_relocations(void *output, unsigned long output_len)
 	 * kernel bits...
 	 * 0 - zero terminator for 64 bit relocations
 	 * 64 bit relocation repeated
+	 * 0 - zero terminator for inverse 32 bit relocations
+	 * 32 bit inverse relocation repeated
 	 * 0 - zero terminator for 32 bit relocations
 	 * 32 bit relocation repeated
 	 *
@@ -286,6 +288,16 @@ static void handle_relocations(void *output, unsigned long output_len)
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
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index a5efb21..0c2fae8 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -20,7 +20,10 @@ struct relocs {
 
 static struct relocs relocs16;
 static struct relocs relocs32;
+#if ELF_BITS == 64
+static struct relocs relocs32neg;
 static struct relocs relocs64;
+#endif
 
 struct section {
 	Elf_Shdr       shdr;
@@ -762,11 +765,16 @@ static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 
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
@@ -986,7 +994,10 @@ static void emit_relocs(int as_text, int use_real_mode)
 	/* Order the relocations for more efficient processing */
 	sort_relocs(&relocs16);
 	sort_relocs(&relocs32);
+#if ELF_BITS == 64
+	sort_relocs(&relocs32neg);
 	sort_relocs(&relocs64);
+#endif
 
 	/* Print the relocations */
 	if (as_text) {
@@ -1007,14 +1018,21 @@ static void emit_relocs(int as_text, int use_real_mode)
 		for (i = 0; i < relocs32.count; i++)
 			write_reloc(relocs32.offset[i], stdout);
 	} else {
-		if (ELF_BITS == 64) {
-			/* Print a stop */
-			write_reloc(0, stdout);
+#if ELF_BITS == 64
+		/* Print a stop */
+		write_reloc(0, stdout);
 
-			/* Now print each relocation */
-			for (i = 0; i < relocs64.count; i++)
-				write_reloc(relocs64.offset[i], stdout);
-		}
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
