Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaDCWVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:21:41 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:40514 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaDCWRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:49 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 17/20] powerpc: use libfdt accessors for header data
Date: Thu,  3 Apr 2014 17:17:00 -0500
Message-Id: <1396563423-30893-18-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
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
 arch/powerpc/kernel/prom.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index f9a44ce..300e151 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -117,14 +117,14 @@ static void __init move_device_tree(void)
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
 
@@ -324,9 +324,9 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
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
@@ -599,7 +599,7 @@ static void __init early_reserve_mem(void)
 	__be64 *reserve_map;
 
 	reserve_map = (__be64 *)(((unsigned long)initial_boot_params) +
-			be32_to_cpu(initial_boot_params->off_mem_rsvmap));
+			fdt_off_mem_rsvmap(initial_boot_params));
 
 	/* Look for the new "reserved-regions" property in the DT */
 	early_reserve_mem_dt();
-- 
1.8.3.2

