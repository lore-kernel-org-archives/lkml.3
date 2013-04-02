Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615Ab3DBQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:16:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7949 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761063Ab3DBQQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:16:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,394,1363132800"; 
   d="scan'208";a="16963390"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <will.deacon@arm.com>, <arnd@arndb.de>, <nicolas.pitre@linaro.org>,
        <Stefano.Stabellini@eu.citrix.com>, <rob.herring@calxeda.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v5 3/3] xen/arm: introduce xen_early_init, use PSCI on xen
Date: Tue, 2 Apr 2013 17:16:14 +0100
Message-ID: <1364919374-7836-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1304021700380.5078@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304021700380.5078@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split xen_guest_init in two functions, one of them (xen_early_init) is
going to be called very early from setup_arch.

Change machine_desc->smp_init to xen_smp_init if Xen is present on the
platform. xen_smp_init just sets smp_ops to psci_smp_ops.

Introduce a dependency for ARM_PSCI in XEN.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/Kconfig                      |    1 +
 arch/arm/include/asm/xen/hypervisor.h |    6 ++++++
 arch/arm/kernel/setup.c               |    3 +++
 arch/arm/xen/enlighten.c              |   27 ++++++++++++++++++++-------
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c3bdce..66658d3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1891,6 +1891,7 @@ config XEN
 	bool "Xen guest support on ARM (EXPERIMENTAL)"
 	depends on ARM && AEABI && OF
 	depends on CPU_V7 && !CPU_V6
+	depends on ARM_PSCI
 	depends on !GENERIC_ATOMIC64
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
index 7e193df..67d911f 100644
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
index b002822..ee09357 100644
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
@@ -176,27 +178,30 @@ static int __init xen_secondary_init(unsigned int cpu)
 	return 0;
 }
 
+static void __init xen_smp_init(void)
+{
+	if (psci_smp_available())
+		smp_set_ops(&psci_smp_ops);
+}
+
 /*
  * see Documentation/devicetree/bindings/arm/xen.txt for the
  * documentation of the Xen Device Tree format.
  */
 #define GRANT_TABLE_PHYSADDR 0
-static int __init xen_guest_init(void)
+void __init xen_early_init(void)
 {
-	struct xen_add_to_physmap xatp;
-	static struct shared_info *shared_info_page = 0;
 	struct device_node *node;
 	int len;
 	const char *s = NULL;
 	const char *version = NULL;
 	const char *xen_prefix = "xen,xen-";
 	struct resource res;
-	int i;
 
 	node = of_find_compatible_node(NULL, NULL, "xen,xen");
 	if (!node) {
 		pr_debug("No Xen support\n");
-		return 0;
+		return;
 	}
 	s = of_get_property(node, "compatible", &len);
 	if (strlen(xen_prefix) + 3  < len &&
@@ -204,15 +209,23 @@ static int __init xen_guest_init(void)
 		version = s + strlen(xen_prefix);
 	if (version == NULL) {
 		pr_debug("Xen version not found\n");
-		return 0;
+		return;
 	}
 	if (of_address_to_resource(node, GRANT_TABLE_PHYSADDR, &res))
-		return 0;
+		return;
 	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
 	xen_events_irq = irq_of_parse_and_map(node, 0);
 	pr_info("Xen %s support found, events_irq=%d gnttab_frame_pfn=%lx\n",
 			version, xen_events_irq, xen_hvm_resume_frames);
 	xen_domain_type = XEN_HVM_DOMAIN;
+	machine_desc->smp_init = xen_smp_init;
+}
+
+static int __init xen_guest_init(void)
+{
+	struct xen_add_to_physmap xatp;
+	static struct shared_info *shared_info_page = 0;
+	int i;
 
 	xen_setup_features();
 	if (xen_feature(XENFEAT_dom0))
-- 
1.7.2.5

