Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaDWBWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:22:01 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58743 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbaDWBTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:19:11 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 18/21] powerpc: use libfdt accessors for header data
Date: Tue, 22 Apr 2014 20:18:18 -0500
Message-Id: <1398215901-25609-19-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

With libfdt support, we can take advantage of helper accessors in libfdt
for accessing the FDT header data. This makes the code more readable and
makes the FDT blob structure more opaque to the kernel. This also
prepares for removing struct boot_param_header completely.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
v2: As powerpc is the only platform needing FDT header access, make
 prom.c include libfdt directly.
 
 arch/powerpc/kernel/Makefile |  1 +
 arch/powerpc/kernel/prom.c   | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index fcc9a89..fab19ec 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -2,6 +2,7 @@
 # Makefile for the linux kernel.
 #
 
+CFLAGS_prom.o		= -I$(src)/../../../scripts/dtc/libfdt
 CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index b1de8e3..0239f0b 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -33,6 +33,7 @@
 #include <linux/memblock.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/libfdt.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -117,14 +118,14 @@ static void __init move_device_tree(void)
 	DBG("-> move_device_tree\n");
 
 	start = __pa(initial_boot_params);
-	size = be32_to_cpu(initial_boot_params->totalsize);
+	size = fdt_totalsize(initial_boot_params);
 
 	if ((memory_limit && (start + size) > PHYSICAL_START + memory_limit) ||
 			overlaps_crashkernel(start, size) ||
 			overlaps_initrd(start, size)) {
 		p = __va(memblock_alloc(size, PAGE_SIZE));
 		memcpy(p, initial_boot_params, size);
-		initial_boot_params = (struct boot_param_header *)p;
+		initial_boot_params = p;
 		DBG("Moved device tree to 0x%p\n", p);
 	}
 
@@ -324,9 +325,9 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 		 * version 2 of the kexec param format adds the phys cpuid of
 		 * booted proc.
 		 */
-		if (be32_to_cpu(initial_boot_params->version) >= 2) {
+		if (fdt_version(initial_boot_params) >= 2) {
 			if (be32_to_cpu(intserv[i]) ==
-			    be32_to_cpu(initial_boot_params->boot_cpuid_phys)) {
+			    fdt_boot_cpuid_phys(initial_boot_params)) {
 				found = boot_cpu_count;
 				found_thread = i;
 			}
@@ -599,7 +600,7 @@ static void __init early_reserve_mem(void)
 	__be64 *reserve_map;
 
 	reserve_map = (__be64 *)(((unsigned long)initial_boot_params) +
-			be32_to_cpu(initial_boot_params->off_mem_rsvmap));
+			fdt_off_mem_rsvmap(initial_boot_params));
 
 	/* Look for the new "reserved-regions" property in the DT */
 	early_reserve_mem_dt();
-- 
1.9.1

