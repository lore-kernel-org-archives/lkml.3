Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaK1NlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:41:10 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35834 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366AbaK1NlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:41:09 -0500
From: Andre Przywara <andre.przywara@arm.com>
To: will.deacon@arm.com
Cc: catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: add module support for alternatives fixups
Date: Fri, 28 Nov 2014 13:40:45 +0000
Message-Id: <1417182045-7858-1-git-send-email-andre.przywara@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20141125152954.GF8541@arm.com>
References: <20141125152954.GF8541@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel patches all necessary instructions once at boot
time, so modules are not covered by this.
Change the apply_alternatives() function to take a beginning and an
end pointer and introduce a new variant (apply_alternatives_all()) to
cover the existing use case for the static kernel image section.
Add a module_finalize() function to arm64 to check for an
alternatives section in a module and patch only the instructions from
that specific area.
Since that module code is not touched before the module
initialization has ended, we don't need to halt the machine before
doing the patching in the module's code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi Will,

so this patch make alternatives patching now work with modules. This
required some changes in the core alternatives code, so it would have
looked better when folded in (but it's already too late for this, I
guess). I have tested this quickly with modules with and without
alternatives sections in them, all seems to work fine.
Not sure if this is too much for -next at this time, though, so I
will leave this decision to you.
I will come up with a proper solution for the .exit.text issue later.

Cheers,
Andre.

 arch/arm64/include/asm/alternative.h |    3 ++-
 arch/arm64/kernel/alternative.c      |   29 +++++++++++++++++++++++++----
 arch/arm64/kernel/module.c           |   18 ++++++++++++++++++
 arch/arm64/kernel/smp.c              |    2 +-
 4 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index f6d206e..d261f01 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -13,7 +13,8 @@ struct alt_instr {
 	u8  alt_len;		/* size of new instruction(s), <= orig_len */
 };
 
-void apply_alternatives(void);
+void apply_alternatives_all(void);
+void apply_alternatives(void *start, size_t length);
 void free_alternatives_memory(void);
 
 #define ALTINSTR_ENTRY(feature)						      \
diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index 5992ea4..f20cd5b 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -28,12 +28,18 @@
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 
-static int __apply_alternatives(void *dummy)
+struct alt_region {
+	struct alt_instr *begin;
+	struct alt_instr *end;
+};
+
+static int __apply_alternatives(void *alt_region)
 {
 	struct alt_instr *alt;
+	struct alt_region *region = alt_region;
 	u8 *origptr, *replptr;
 
-	for (alt = __alt_instructions; alt < __alt_instructions_end; alt++) {
+	for (alt = region->begin; alt < region->end; alt++) {
 		if (!cpus_have_cap(alt->cpufeature))
 			continue;
 
@@ -51,10 +57,25 @@ static int __apply_alternatives(void *dummy)
 	return 0;
 }
 
-void apply_alternatives(void)
+void apply_alternatives_all(void)
 {
+	struct alt_region region = {
+		.begin	= __alt_instructions,
+		.end	= __alt_instructions_end,
+	};
+
 	/* better not try code patching on a live SMP system */
-	stop_machine(__apply_alternatives, NULL, NULL);
+	stop_machine(__apply_alternatives, &region, NULL);
+}
+
+void apply_alternatives(void *start, size_t length)
+{
+	struct alt_region region = {
+		.begin	= start,
+		.end	= start + length,
+	};
+
+	__apply_alternatives(&region);
 }
 
 void free_alternatives_memory(void)
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 1eb1cc9..fd027b1 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -26,6 +26,7 @@
 #include <linux/moduleloader.h>
 #include <linux/vmalloc.h>
 #include <asm/insn.h>
+#include <asm/sections.h>
 
 #define	AARCH64_INSN_IMM_MOVNZ		AARCH64_INSN_IMM_MAX
 #define	AARCH64_INSN_IMM_MOVK		AARCH64_INSN_IMM_16
@@ -394,3 +395,20 @@ overflow:
 	       me->name, (int)ELF64_R_TYPE(rel[i].r_info), val);
 	return -ENOEXEC;
 }
+
+int module_finalize(const Elf_Ehdr *hdr,
+		    const Elf_Shdr *sechdrs,
+		    struct module *me)
+{
+	const Elf_Shdr *s, *se;
+	const char *secstrs = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+
+	for (s = sechdrs, se = sechdrs + hdr->e_shnum; s < se; s++) {
+		if (strcmp(".altinstructions", secstrs + s->sh_name) == 0) {
+			apply_alternatives((void *)s->sh_addr, s->sh_size);
+			return 0;
+		}
+	}
+
+	return 0;
+}
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 0ef8789..7ae6ee0 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -310,7 +310,7 @@ void cpu_die(void)
 void __init smp_cpus_done(unsigned int max_cpus)
 {
 	pr_info("SMP: Total of %d processors activated.\n", num_online_cpus());
-	apply_alternatives();
+	apply_alternatives_all();
 }
 
 void __init smp_prepare_boot_cpu(void)
-- 
1.7.9.5

