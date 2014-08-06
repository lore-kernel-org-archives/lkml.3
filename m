Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbaHFTfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:35:51 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57516 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbaHFTft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:35:49 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rabin Vincent <rabin@rab.in>,
        Liu hua <sdu.liu@huawei.com>, Mark Salter <msalter@redhat.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>, Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/7] arm: use fixmap for text patching when text is RO
Date: Wed,  6 Aug 2014 12:32:41 -0700
Message-Id: <1407353564-21478-5-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407353564-21478-1-git-send-email-keescook@chromium.org>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin@rab.in>

Use fixmaps for text patching when the kernel text is read-only,
inspired by x86.  This makes jump labels and kprobes work with the
currently available CONFIG_DEBUG_SET_MODULE_RONX and the upcoming
CONFIG_DEBUG_RODATA options.

Signed-off-by: Rabin Vincent <rabin@rab.in>
[update for "ARM: 8031/2: change fixmap mapping region to support 32 CPUs"]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/fixmap.h |  4 +++
 arch/arm/kernel/jump_label.c  |  2 +-
 arch/arm/kernel/patch.c       | 70 ++++++++++++++++++++++++++++++++++++++-----
 arch/arm/kernel/patch.h       | 12 +++++++-
 4 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index 3ed08232be55..056f2be273a3 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -19,6 +19,10 @@ enum fixed_addresses {
 	FIX_KMAP_BEGIN,
 	FIX_KMAP_END = (FIX_KMAP_NR_PTES * FIX_KMAP_NR_CPUS) - 1,
 
+	/* Support writing RO kernel text via kprobes, jump labels, etc. */
+	FIX_TEXT_POKE0,
+	FIX_TEXT_POKE1,
+
 	__end_of_fixed_addresses
 };
 
diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
index 4ce4f789446d..afeeb9ea6f43 100644
--- a/arch/arm/kernel/jump_label.c
+++ b/arch/arm/kernel/jump_label.c
@@ -19,7 +19,7 @@ static void __arch_jump_label_transform(struct jump_entry *entry,
 		insn = arm_gen_nop();
 
 	if (is_static)
-		__patch_text(addr, insn);
+		__patch_text_early(addr, insn);
 	else
 		patch_text(addr, insn);
 }
diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
index 07314af47733..03dd4e39c833 100644
--- a/arch/arm/kernel/patch.c
+++ b/arch/arm/kernel/patch.c
@@ -1,8 +1,11 @@
 #include <linux/kernel.h>
+#include <linux/spinlock.h>
 #include <linux/kprobes.h>
+#include <linux/mm.h>
 #include <linux/stop_machine.h>
 
 #include <asm/cacheflush.h>
+#include <asm/fixmap.h>
 #include <asm/smp_plat.h>
 #include <asm/opcodes.h>
 
@@ -13,21 +16,69 @@ struct patch {
 	unsigned int insn;
 };
 
-void __kprobes __patch_text(void *addr, unsigned int insn)
+static DEFINE_SPINLOCK(patch_lock);
+
+static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags)
+{
+	unsigned int uintaddr = (uintptr_t) addr;
+	bool module = !core_kernel_text(uintaddr);
+	struct page *page;
+
+	if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
+		page = vmalloc_to_page(addr);
+	else if (!module && IS_ENABLED(CONFIG_DEBUG_RODATA))
+		page = virt_to_page(addr);
+	else
+		return addr;
+
+	if (flags)
+		spin_lock_irqsave(&patch_lock, *flags);
+
+	set_fixmap(fixmap, page_to_phys(page));
+
+	return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));
+}
+
+static void __kprobes patch_unmap(int fixmap, unsigned long *flags)
+{
+	clear_fixmap(fixmap);
+
+	if (flags)
+		spin_unlock_irqrestore(&patch_lock, *flags);
+}
+
+void __kprobes __patch_text_real(void *addr, unsigned int insn, bool remap)
 {
 	bool thumb2 = IS_ENABLED(CONFIG_THUMB2_KERNEL);
+	unsigned int uintaddr = (uintptr_t) addr;
+	bool twopage = false;
+	unsigned long flags;
+	void *waddr = addr;
 	int size;
 
+	if (remap)
+		waddr = patch_map(addr, FIX_TEXT_POKE0, &flags);
+
 	if (thumb2 && __opcode_is_thumb16(insn)) {
-		*(u16 *)addr = __opcode_to_mem_thumb16(insn);
+		*(u16 *)waddr = __opcode_to_mem_thumb16(insn);
 		size = sizeof(u16);
-	} else if (thumb2 && ((uintptr_t)addr & 2)) {
+	} else if (thumb2 && (uintaddr & 2)) {
 		u16 first = __opcode_thumb32_first(insn);
 		u16 second = __opcode_thumb32_second(insn);
-		u16 *addrh = addr;
+		u16 *addrh0 = waddr;
+		u16 *addrh1 = waddr + 2;
 
-		addrh[0] = __opcode_to_mem_thumb16(first);
-		addrh[1] = __opcode_to_mem_thumb16(second);
+		twopage = (uintaddr & ~PAGE_MASK) == PAGE_SIZE - 2;
+		if (twopage && remap)
+			addrh1 = patch_map(addr + 2, FIX_TEXT_POKE1, NULL);
+
+		*addrh0 = __opcode_to_mem_thumb16(first);
+		*addrh1 = __opcode_to_mem_thumb16(second);
+
+		if (twopage && addrh1 != addr + 2) {
+			flush_kernel_vmap_range(addrh1, 2);
+			patch_unmap(FIX_TEXT_POKE1, NULL);
+		}
 
 		size = sizeof(u32);
 	} else {
@@ -36,10 +87,15 @@ void __kprobes __patch_text(void *addr, unsigned int insn)
 		else
 			insn = __opcode_to_mem_arm(insn);
 
-		*(u32 *)addr = insn;
+		*(u32 *)waddr = insn;
 		size = sizeof(u32);
 	}
 
+	if (waddr != addr) {
+		flush_kernel_vmap_range(waddr, twopage ? size / 2 : size);
+		patch_unmap(FIX_TEXT_POKE0, &flags);
+	}
+
 	flush_icache_range((uintptr_t)(addr),
 			   (uintptr_t)(addr) + size);
 }
diff --git a/arch/arm/kernel/patch.h b/arch/arm/kernel/patch.h
index b4731f2dac38..77e054c2f6cd 100644
--- a/arch/arm/kernel/patch.h
+++ b/arch/arm/kernel/patch.h
@@ -2,6 +2,16 @@
 #define _ARM_KERNEL_PATCH_H
 
 void patch_text(void *addr, unsigned int insn);
-void __patch_text(void *addr, unsigned int insn);
+void __patch_text_real(void *addr, unsigned int insn, bool remap);
+
+static inline void __patch_text(void *addr, unsigned int insn)
+{
+	__patch_text_real(addr, insn, true);
+}
+
+static inline void __patch_text_early(void *addr, unsigned int insn)
+{
+	__patch_text_real(addr, insn, false);
+}
 
 #endif
-- 
1.9.1

