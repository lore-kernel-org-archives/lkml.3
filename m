Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3LDAlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:41:45 -0500
Received: from mga14.intel.com ([143.182.124.37]:49145 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab3LDAll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:41:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,821,1378882800"; 
   d="scan'208";a="438056541"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Feng Tang <feng.tang@intel.com>, sfi-devel@simplefirmware.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 2/3] ACPI/SFI: Fix wrong <acpi/acpi.h> inclusion in SFI/ACPI wrapper - acpi_disabled linkage.
Date: Wed,  4 Dec 2013 08:38:21 +0800
Message-Id: <a65e60de44632715aaf4488ed190125ed0bb6820.1386116927.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1386116927.git.lv.zheng@intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com> <cover.1386116927.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Linux kernel, ACPICA is wrapped and safely exported by CONFIG_ACPI.  So
all external modules should depend on CONFIG_ACPI rather than using ACPICA
header directly for stubbing.  But if we moves <acpi/acpi.h> inclusions
into "#ifdef CONFIG_ACPI", build breakge can help to detect wrong ACPICA
dependent modules.

One of the build breakage is:
arch/x86/pci/mmconfig-shared.c:389:1: error: unknown type name 'acpi_status'
arch/x86/pci/mmconfig-shared.c:389:47: warning: 'struct acpi_resource' declared inside parameter list [enabled by default]
arch/x86/pci/mmconfig-shared.c:389:47: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
arch/x86/pci/mmconfig-shared.c: In function 'check_mcfg_resource':
arch/x86/pci/mmconfig-shared.c:392:33: error: storage size of 'address' isn't known
arch/x86/pci/mmconfig-shared.c:393:2: error: unknown type name 'acpi_status'
arch/x86/pci/mmconfig-shared.c:395:9: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig-shared.c:395:19: error: 'ACPI_RESOURCE_TYPE_FIXED_MEMORY32' undeclared (first use in this function)
arch/x86/pci/mmconfig-shared.c:395:19: note: each undeclared identifier is reported only once for each function it appears in
arch/x86/pci/mmconfig-shared.c:397:8: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig-shared.c:399:11: error: 'AE_OK' undeclared (first use in this function)
arch/x86/pci/mmconfig-shared.c:400:35: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig-shared.c:401:33: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig-shared.c:402:19: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig-shared.c:404:11: error: 'AE_CTRL_TERMINATE' undeclared (first use in this function)
arch/x86/pci/mmconfig-shared.c:407:10: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig-shared.c:407:20: error: 'ACPI_RESOURCE_TYPE_ADDRESS32' undeclared (first use in this function)
arch/x86/pci/mmconfig-shared.c:408:10: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig-shared.c:408:20: error: 'ACPI_RESOURCE_TYPE_ADDRESS64' undeclared (first use in this function)
arch/x86/pci/mmconfig-shared.c:411:2: error: implicit declaration of function 'acpi_resource_to_address64' [-Werror=implicit-function-declaration]
arch/x86/pci/mmconfig-shared.c:412:2: error: implicit declaration of function 'ACPI_FAILURE' [-Werror=implicit-function-declaration]
arch/x86/pci/mmconfig-shared.c:414:31: error: 'ACPI_MEMORY_RANGE' undeclared (first use in this function)
arch/x86/pci/mmconfig-shared.c:392:33: warning: unused variable 'address' [-Wunused-variable]
arch/x86/pci/mmconfig-shared.c: At top level:
arch/x86/pci/mmconfig-shared.c:425:1: error: unknown type name 'acpi_status'
arch/x86/pci/mmconfig-shared.c:425:41: error: unknown type name 'acpi_handle'
arch/x86/pci/mmconfig-shared.c: In function 'is_acpi_reserved':
arch/x86/pci/mmconfig-shared.c:447:2: error: implicit declaration of function 'acpi_get_devices' [-Werror=implicit-function-declaration]
arch/x86/pci/mmconfig-shared.c:447:30: error: 'find_mboard_resource' undeclared (first use in this function)
arch/x86/pci/mmconfig-shared.c: At top level:
arch/x86/pci/mmconfig-shared.c:389:20: warning: 'check_mcfg_resource' defined but not used [-Wunused-function]

The root cause of this breakage is:
1. The following commit doesn't protect ACPICA functions like
   acpi_get_devices()/acpi_walk_resources()/acpi_resource_to_address64() in
   CONFIG_SFI=y and CONFIG_ACPI=n environment:
    Commit: 5f0db7a2fb78895a197f64e548333b3bbd433996
    Author: Feng Tang <feng.tang@intel.com>
    Subject: SFI: Hook PCI MMCONFIG
    First check ACPI, and if that fails, ask SFI to find the MCFG.
   So it actually depends on the logic that in !CONFIG_ACPI builds, code
   blocks under "if (!acpi_disabled)" will not be linked in.

This patch fixes this issue by introducing a stub for MCFG entry checker
is_acpi_reserved() in !CONFIG_ACPI builds.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>
Cc: sfi-devel@simplefirmware.org
Cc: linux-pci@vger.kernel.org
---
 arch/x86/pci/mmconfig-shared.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 082e881..9f23a77 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -370,6 +370,7 @@ static int __init pci_mmcfg_check_hostbridge(void)
 	return !list_empty(&pci_mmcfg_list);
 }
 
+#ifdef CONFIG_ACPI
 static acpi_status check_mcfg_resource(struct acpi_resource *res, void *data)
 {
 	struct resource *mcfg_res = data;
@@ -436,6 +437,12 @@ static int is_acpi_reserved(u64 start, u64 end, unsigned not_used)
 
 	return mcfg_res.flags;
 }
+#else
+static inline int is_acpi_reserved(u64 start, u64 end, unsigned not_used)
+{
+	return 0;
+}
+#endif
 
 typedef int (*check_reserved_t)(u64 start, u64 end, unsigned type);
 
-- 
1.7.10

