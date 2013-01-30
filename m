Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3A3B21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:28:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3A3B2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:28:25 -0500
Date: Tue, 29 Jan 2013 17:28:14 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-4f7b92263ad68cdc72b11808320d9c881bfa857e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, jarkko.sakkinen@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, jarkko.sakkinen@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-11-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-11-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, realmode: Separate real_mode reserve and setup
Git-Commit-ID: 4f7b92263ad68cdc72b11808320d9c881bfa857e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:28:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f7b92263ad68cdc72b11808320d9c881bfa857e
Gitweb:     http://git.kernel.org/tip/4f7b92263ad68cdc72b11808320d9c881bfa857e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:51 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:13:24 -0800

x86, realmode: Separate real_mode reserve and setup

After we switch to use #PF handler help to set page table, init_level4_pgt
will only have entries set after init_mem_mapping().
We need to move copying init_level4_pgt to trampoline_pgd after that.

So split reserve and setup, and move the setup after init_mem_mapping()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-11-git-send-email-yinghai@kernel.org
Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/realmode.h |  3 ++-
 arch/x86/kernel/setup.c         |  4 +++-
 arch/x86/realmode/init.c        | 32 ++++++++++++++++++++------------
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index fe1ec5b..9c6b890 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -58,6 +58,7 @@ extern unsigned char boot_gdt[];
 extern unsigned char secondary_startup_64[];
 #endif
 
-extern void __init setup_real_mode(void);
+void reserve_real_mode(void);
+void setup_real_mode(void);
 
 #endif /* _ARCH_X86_REALMODE_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5552d04..85a8290 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -999,12 +999,14 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
 			(max_pfn_mapped<<PAGE_SHIFT) - 1);
 
-	setup_real_mode();
+	reserve_real_mode();
 
 	trim_platform_memory_ranges();
 
 	init_mem_mapping();
 
+	setup_real_mode();
+
 	memblock.current_limit = get_max_mapped();
 	dma_contiguous_reserve(0);
 
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index ffee06a..4b5bdc8 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -8,9 +8,26 @@
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
 
-void __init setup_real_mode(void)
+void __init reserve_real_mode(void)
 {
 	phys_addr_t mem;
+	unsigned char *base;
+	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
+
+	/* Has to be under 1M so we can execute real-mode AP code. */
+	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
+	if (!mem)
+		panic("Cannot allocate trampoline\n");
+
+	base = __va(mem);
+	memblock_reserve(mem, size);
+	real_mode_header = (struct real_mode_header *) base;
+	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
+	       base, (unsigned long long)mem, size);
+}
+
+void __init setup_real_mode(void)
+{
 	u16 real_mode_seg;
 	u32 *rel;
 	u32 count;
@@ -25,16 +42,7 @@ void __init setup_real_mode(void)
 	u64 efer;
 #endif
 
-	/* Has to be in very low memory so we can execute real-mode AP code. */
-	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
-	if (!mem)
-		panic("Cannot allocate trampoline\n");
-
-	base = __va(mem);
-	memblock_reserve(mem, size);
-	real_mode_header = (struct real_mode_header *) base;
-	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
-	       base, (unsigned long long)mem, size);
+	base = (unsigned char *)real_mode_header;
 
 	memcpy(base, real_mode_blob, size);
 
@@ -84,7 +92,7 @@ void __init setup_real_mode(void)
 }
 
 /*
- * setup_real_mode() gets called very early, to guarantee the
+ * reserve_real_mode() gets called very early, to guarantee the
  * availability of low memory. This is before the proper kernel page
  * tables are set up, so we cannot set page permissions in that
  * function. Also trampoline code will be executed by APs so we
