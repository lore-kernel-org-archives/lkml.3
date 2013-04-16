Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936009Ab3DPTwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 15:52:00 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:29556 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935589Ab3DPTv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 15:51:58 -0400
Message-ID: <516DABC8.1040606@parallels.com>
Date: Tue, 16 Apr 2013 23:51:36 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 7/5] mem-soft-dirty: Reshuffle CONFIG_ options to be more
 Arch-friendly
References: <51669E5F.4000801@parallels.com>
In-Reply-To: <51669E5F.4000801@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Stephen Rothwell pointed out, config options, that depend on
architecture support, are better to be wrapped into a select +
depends on scheme.

Do this for CONFIG_MEM_SOFT_DIRTY, as it currently works only
for X86.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>

---

diff --git a/arch/Kconfig b/arch/Kconfig
index 1455579..71c06ab 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -365,6 +365,9 @@ config HAVE_IRQ_TIME_ACCOUNTING
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	bool
 
+config HAVE_ARCH_SOFT_DIRTY
+	bool
+
 config HAVE_MOD_ARCH_SPECIFIC
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3d..81c0843 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -120,6 +120,7 @@ config X86
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
+	select HAVE_ARCH_SOFT_DIRTY
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index eb97470..ebf9373 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -294,8 +294,6 @@ static inline pmd_t pmd_mknotpresent(pmd_t pmd)
 	return pmd_clear_flags(pmd, _PAGE_PRESENT);
 }
 
-#define __HAVE_SOFT_DIRTY
-
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_SOFT_DIRTY;
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index d74bdd2..a2ca78f 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -386,7 +386,7 @@ static inline void ptep_modify_prot_commit(struct mm_struct *mm,
 #define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
-#ifndef __HAVE_SOFT_DIRTY
+#ifndef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return 0;
diff --git a/mm/Kconfig b/mm/Kconfig
index 147689e..7deac66 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -474,7 +474,7 @@ config FRONTSWAP
 
 config MEM_SOFT_DIRTY
 	bool "Track memory changes"
-	depends on CHECKPOINT_RESTORE && X86
+	depends on CHECKPOINT_RESTORE && HAVE_ARCH_SOFT_DIRTY
 	select PROC_PAGE_MONITOR
 	help
 	  This option enables memory changes tracking by introducing a
