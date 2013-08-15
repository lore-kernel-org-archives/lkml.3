Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab3HOLLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:11:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:27097 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab3HOLLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:11:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,885,1367971200"; 
   d="scan'208";a="44511060"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 06/10] xen/arm,arm64: move Xen initialization earlier
Date: Thu, 15 Aug 2013 12:10:50 +0100
Message-ID: <1376565054-24153-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


Changes in v3:
- add missing __init in xen_early_init declaration.
---
 arch/arm/include/asm/xen/hypervisor.h |    8 ++++++++
 arch/arm/kernel/setup.c               |    2 ++
 arch/arm/xen/enlighten.c              |   21 ++++++++++++++-------
 arch/arm64/kernel/setup.c             |    2 ++
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/xen/hypervisor.h b/arch/arm/include/asm/xen/hypervisor.h
index d7ab99a..2782591 100644
--- a/arch/arm/include/asm/xen/hypervisor.h
+++ b/arch/arm/include/asm/xen/hypervisor.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_ARM_XEN_HYPERVISOR_H
 #define _ASM_ARM_XEN_HYPERVISOR_H
 
+#include <linux/init.h>
+
 extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
 
@@ -16,4 +18,10 @@ static inline enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	return PARAVIRT_LAZY_NONE;
 }
 
+#ifdef CONFIG_XEN
+void __init xen_early_init(void);
+#else
+static inline void xen_early_init(void) { return; }
+#endif
+
 #endif /* _ASM_ARM_XEN_HYPERVISOR_H */
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 63af9a7..cb7b8e2 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -45,6 +45,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cachetype.h>
 #include <asm/tlbflush.h>
+#include <asm/xen/hypervisor.h>
 
 #include <asm/prom.h>
 #include <asm/mach/arch.h>
@@ -889,6 +890,7 @@ void __init setup_arch(char **cmdline_p)
 
 	arm_dt_init_cpu_maps();
 	psci_init();
+	xen_early_init();
 #ifdef CONFIG_SMP
 	if (is_smp()) {
 		if (!mdesc->smp_init || !mdesc->smp_init()) {
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index c9770ba..14d17ab 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -195,21 +195,19 @@ static void xen_power_off(void)
  * documentation of the Xen Device Tree format.
  */
 #define GRANT_TABLE_PHYSADDR 0
-static int __init xen_guest_init(void)
+void __init xen_early_init(void)
 {
-	struct xen_add_to_physmap xatp;
-	static struct shared_info *shared_info_page = 0;
+	struct resource res;
 	struct device_node *node;
 	int len;
 	const char *s = NULL;
 	const char *version = NULL;
 	const char *xen_prefix = "xen,xen-";
-	struct resource res;
 
 	node = of_find_compatible_node(NULL, NULL, "xen,xen");
 	if (!node) {
 		pr_debug("No Xen support\n");
-		return 0;
+		return;
 	}
 	s = of_get_property(node, "compatible", &len);
 	if (strlen(xen_prefix) + 3  < len &&
@@ -217,10 +215,10 @@ static int __init xen_guest_init(void)
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
@@ -232,6 +230,15 @@ static int __init xen_guest_init(void)
 		xen_start_info->flags |= SIF_INITDOMAIN|SIF_PRIVILEGED;
 	else
 		xen_start_info->flags &= ~(SIF_INITDOMAIN|SIF_PRIVILEGED);
+}
+
+static int __init xen_guest_init(void)
+{
+	struct xen_add_to_physmap xatp;
+	static struct shared_info *shared_info_page = 0;
+
+	if (!xen_domain())
+		return 0;
 
 	if (!shared_info_page)
 		shared_info_page = (struct shared_info *)
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index add6ea6..e0d438a 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -53,6 +53,7 @@
 #include <asm/traps.h>
 #include <asm/memblock.h>
 #include <asm/psci.h>
+#include <asm/xen/hypervisor.h>
 
 unsigned int processor_id;
 EXPORT_SYMBOL(processor_id);
@@ -267,6 +268,7 @@ void __init setup_arch(char **cmdline_p)
 	unflatten_device_tree();
 
 	psci_init();
+	xen_early_init();
 
 	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
 #ifdef CONFIG_SMP
-- 
1.7.2.5

