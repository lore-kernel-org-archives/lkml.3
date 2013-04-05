Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161809Ab3DENMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:12:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:26338 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161682Ab3DENLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:11:49 -0400
X-IronPort-AV: E=Sophos;i="4.87,414,1363132800"; 
   d="scan'208";a="17719688"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <will.deacon@arm.com>, <arnd@arndb.de>, <nicolas.pitre@linaro.org>,
        <Stefano.Stabellini@eu.citrix.com>, <rob.herring@calxeda.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 4/4] xen/arm: introduce xen_early_init, use PSCI on xen
Date: Fri, 5 Apr 2013 14:11:35 +0100
Message-ID: <1365167495-18508-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split xen_guest_init in two functions, one of them (xen_early_init) is
going to be called very early from setup_arch.

Change machine_desc->smp_init to xen_smp_init if Xen is present on the
platform. xen_smp_init just sets smp_ops to psci_smp_ops.

XEN selects ARM_PSCI.

Changes in v6:
- xen_smp_init: call smp_set_ops only ifdef CONFIG_SMP;
- move more of the initialization to xen_guest_init;
- select ARM_PSCI if XEN.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/Kconfig                      |    1 +
 arch/arm/include/asm/xen/hypervisor.h |    6 +++++
 arch/arm/kernel/setup.c               |    3 ++
 arch/arm/xen/enlighten.c              |   36 +++++++++++++++++++++++++-------
 4 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c3bdce..344e299 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1892,6 +1892,7 @@ config XEN
 	depends on ARM && AEABI && OF
 	depends on CPU_V7 && !CPU_V6
 	depends on !GENERIC_ATOMIC64
+	select ARM_PSCI
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
diff --git a/arch/arm/include/asm/xen/hypervisor.h b/arch/arm/include/asm/xen/hypervisor.h
index d7ab99a..17b3ea2 100644
--- a/arch/arm/include/asm/xen/hypervisor.h
+++ b/arch/arm/include/asm/xen/hypervisor.h
@@ -16,4 +16,10 @@ static inline enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	return PARAVIRT_LAZY_NONE;
 }
 
+#ifdef CONFIG_XEN
+void xen_early_init(void);
+#else
+static inline void xen_early_init(void) { return; }
+#endif
+
 #endif /* _ASM_ARM_XEN_HYPERVISOR_H */
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 2f738cb..336305e 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -55,6 +55,8 @@
 #include <asm/unwind.h>
 #include <asm/memblock.h>
 #include <asm/virt.h>
+#include <asm/xen/hypervisor.h>
+#include <xen/xen.h>
 
 #include "atags.h"
 #include "tcm.h"
@@ -768,6 +770,7 @@ void __init setup_arch(char **cmdline_p)
 
 	arm_dt_init_cpu_maps();
 	psci_init();
+	xen_early_init();
 #ifdef CONFIG_SMP
 	if (is_smp()) {
 		if (mdesc->smp_init)
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index b002822..fc1bc2a 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -11,6 +11,8 @@
 #include <xen/xenbus.h>
 #include <xen/page.h>
 #include <xen/xen-ops.h>
+#include <asm/mach/arch.h>
+#include <asm/psci.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include <linux/interrupt.h>
@@ -176,11 +178,33 @@ static int __init xen_secondary_init(unsigned int cpu)
 	return 0;
 }
 
+static void __init xen_smp_init(void)
+{
+#ifdef CONFIG_SMP
+	if (psci_smp_available())
+		smp_set_ops(&psci_smp_ops);
+#endif
+}
+
 /*
  * see Documentation/devicetree/bindings/arm/xen.txt for the
  * documentation of the Xen Device Tree format.
  */
 #define GRANT_TABLE_PHYSADDR 0
+void __init xen_early_init(void)
+{
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "xen,xen");
+	if (!node) {
+		pr_debug("No Xen support\n");
+		return;
+	}
+
+	xen_domain_type = XEN_HVM_DOMAIN;
+	machine_desc->smp_init = xen_smp_init;
+}
+
 static int __init xen_guest_init(void)
 {
 	struct xen_add_to_physmap xatp;
@@ -194,25 +218,21 @@ static int __init xen_guest_init(void)
 	int i;
 
 	node = of_find_compatible_node(NULL, NULL, "xen,xen");
-	if (!node) {
-		pr_debug("No Xen support\n");
-		return 0;
-	}
+
 	s = of_get_property(node, "compatible", &len);
 	if (strlen(xen_prefix) + 3  < len &&
 			!strncmp(xen_prefix, s, strlen(xen_prefix)))
 		version = s + strlen(xen_prefix);
 	if (version == NULL) {
-		pr_debug("Xen version not found\n");
-		return 0;
+		pr_warn("Xen version not found\n");
+		return -EINVAL;
 	}
 	if (of_address_to_resource(node, GRANT_TABLE_PHYSADDR, &res))
-		return 0;
+		return -EINVAL;
 	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
 	xen_events_irq = irq_of_parse_and_map(node, 0);
 	pr_info("Xen %s support found, events_irq=%d gnttab_frame_pfn=%lx\n",
 			version, xen_events_irq, xen_hvm_resume_frames);
-	xen_domain_type = XEN_HVM_DOMAIN;
 
 	xen_setup_features();
 	if (xen_feature(XENFEAT_dom0))
-- 
1.7.2.5

