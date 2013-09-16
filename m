Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3IPXMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:12:24 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:55311 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3IPXJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:49 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Simek <monstr@monstr.eu>,
        Jonas Bonn <jonas@southpole.se>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        microblaze-uclinux@itee.uq.edu.au, linux@openrisc.net
Subject: [PATCH 18/28] of: create default early_init_dt_add_memory_arch
Date: Mon, 16 Sep 2013 18:09:14 -0500
Message-Id: <1379372965-22359-19-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Create a weak version of early_init_dt_add_memory_arch which uses
memblock or is an empty function when memblock is not enabled. This
will unify all architectures except ones with custom memory bank
structs.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: linux@lists.openrisc.net
Cc: devicetree@vger.kernel.org
---
 arch/arm64/kernel/setup.c     | 18 ------------------
 arch/metag/kernel/devtree.c   |  6 ------
 arch/microblaze/kernel/prom.c |  5 -----
 arch/openrisc/kernel/prom.c   |  6 ------
 arch/x86/kernel/devicetree.c  | 10 ----------
 drivers/of/fdt.c              | 11 +++++++++++
 6 files changed, 11 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index b4461e1..3790004 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -147,24 +147,6 @@ static void __init setup_machine_fdt(phys_addr_t dt_phys)
 	pr_info("Machine: %s\n", machine_name);
 }
 
-void __init early_init_dt_add_memory_arch(u64 base, u64 size)
-{
-	base &= PAGE_MASK;
-	size &= PAGE_MASK;
-	if (base + size < PHYS_OFFSET) {
-		pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
-			   base, base + size);
-		return;
-	}
-	if (base < PHYS_OFFSET) {
-		pr_warning("Ignoring memory range 0x%llx - 0x%llx\n",
-			   base, PHYS_OFFSET);
-		size -= PHYS_OFFSET - base;
-		base = PHYS_OFFSET;
-	}
-	memblock_add(base, size);
-}
-
 /*
  * Limit the memory size that was specified via FDT.
  */
diff --git a/arch/metag/kernel/devtree.c b/arch/metag/kernel/devtree.c
index 049af56..2c6ee6d 100644
--- a/arch/metag/kernel/devtree.c
+++ b/arch/metag/kernel/devtree.c
@@ -23,12 +23,6 @@
 #include <asm/page.h>
 #include <asm/mach/arch.h>
 
-void __init early_init_dt_add_memory_arch(u64 base, u64 size)
-{
-	pr_err("%s(%llx, %llx)\n",
-	       __func__, base, size);
-}
-
 void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
 	return alloc_bootmem_align(size, align);
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index e13686e..951e4d6 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -41,11 +41,6 @@
 #include <asm/sections.h>
 #include <asm/pci-bridge.h>
 
-void __init early_init_dt_add_memory_arch(u64 base, u64 size)
-{
-	memblock_add(base, size);
-}
-
 #ifdef CONFIG_EARLY_PRINTK
 static char *stdout;
 
diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index fbed459..6dbcaa8 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -47,12 +47,6 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 
-void __init early_init_dt_add_memory_arch(u64 base, u64 size)
-{
-	size &= PAGE_MASK;
-	memblock_add(base, size);
-}
-
 void __init early_init_devtree(void *params)
 {
 	early_init_dt_scan(params);
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 0db805c..2f5cb37 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -36,16 +36,6 @@ unsigned long pci_address_to_pio(phys_addr_t address)
 }
 EXPORT_SYMBOL_GPL(pci_address_to_pio);
 
-void __init early_init_dt_scan_chosen_arch(unsigned long node)
-{
-	BUG();
-}
-
-void __init early_init_dt_add_memory_arch(u64 base, u64 size)
-{
-	BUG();
-}
-
 void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
 	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 0714dd4..a9dce7a 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -688,6 +688,17 @@ u64 __init dt_mem_next_cell(int s, __be32 **cellp)
 	return of_read_number(p, s);
 }
 
+void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+#ifdef CONFIG_HAVE_MEMBLOCK
+	base &= PAGE_MASK;
+	size &= PAGE_MASK;
+	memblock_add(base, size);
+#else
+	pr_err("%s: ignoring memory (%llx, %llx)\n", __func__, base, size);
+#endif
+}
+
 /**
  * early_init_dt_scan_memory - Look for an parse memory nodes
  */
-- 
1.8.1.2

