Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3JGQcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:32:48 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:59638 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab3JGQa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:30:26 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Michal Simek <monstr@monstr.eu>,
        Jonas Bonn <jonas@southpole.se>, linux-arm-kernel@lists.infradead.org,
        microblaze-uclinux@itee.uq.edu.au, linux@openrisc.net
Subject: [PATCH v2 19/29] of: create default early_init_dt_add_memory_arch
Date: Mon,  7 Oct 2013 11:29:27 -0500
Message-Id: <1381163377-21044-20-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Create a weak version of early_init_dt_add_memory_arch which uses
memblock. This will unify all architectures except ones with custom
memory bank structs.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Jonas Bonn <jonas@southpole.se>
Acked-by: Grant Likely <grant.likely@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: microblaze-uclinux@itee.uq.edu.au
Cc: linux@lists.openrisc.net
Cc: devicetree@vger.kernel.org
---
 arch/arm64/kernel/setup.c     | 18 ------------------
 arch/microblaze/kernel/prom.c |  5 -----
 arch/openrisc/kernel/prom.c   |  6 ------
 drivers/of/fdt.c              | 19 +++++++++++++++++++
 4 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 4a5f624..7feb0c9 100644
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
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index bfbfda5..5bc55b6 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -775,6 +775,25 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK
+void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	const u64 phys_offset = __pa(PAGE_OFFSET);
+	base &= PAGE_MASK;
+	size &= PAGE_MASK;
+	if (base + size < phys_offset) {
+		pr_warning("Ignoring memory block 0x%llx - 0x%llx\n",
+			   base, base + size);
+		return;
+	}
+	if (base < phys_offset) {
+		pr_warning("Ignoring memory range 0x%llx - 0x%llx\n",
+			   base, phys_offset);
+		size -= phys_offset - base;
+		base = phys_offset;
+	}
+	memblock_add(base, size);
+}
+
 /*
  * called from unflatten_device_tree() to bootstrap devicetree itself
  * Architectures can override this definition if memblock isn't used
-- 
1.8.1.2

