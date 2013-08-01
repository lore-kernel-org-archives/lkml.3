Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab3HAAgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:36:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30542 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3HAAgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:36:08 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1375292732-7627-4-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1307311833040.4893@kaball.uk.xensource.com> <1375292732-7627-4-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH RFC 4/8] xen/arm,arm64: move Xen initialization earlier
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 31 Jul 2013 20:35:32 -0400
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stefano.Stabellini@eu.citrix.com, Ian.Campbell@citrix.com
Message-ID: <dc5fc8ce-2248-443c-87c5-6bd3c0c259b2@email.android.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
>Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>---
> arch/arm/include/asm/xen/hypervisor.h |    6 ++++++
> arch/arm/kernel/setup.c               |    2 ++
> arch/arm/xen/enlighten.c              |   21 ++++++++++++++-------
> arch/arm64/kernel/setup.c             |    2 ++
> 4 files changed, 24 insertions(+), 7 deletions(-)
>
>diff --git a/arch/arm/include/asm/xen/hypervisor.h
>b/arch/arm/include/asm/xen/hypervisor.h
>index d7ab99a..17b3ea2 100644
>--- a/arch/arm/include/asm/xen/hypervisor.h
>+++ b/arch/arm/include/asm/xen/hypervisor.h
>@@ -16,4 +16,10 @@ static inline enum paravirt_lazy_mode
>paravirt_get_lazy_mode(void)
> 	return PARAVIRT_LAZY_NONE;
> }
> 
>+#ifdef CONFIG_XEN
>+void xen_early_init(void);

You look to be missing an __init here
>+#else
>+static inline void xen_early_init(void) { return; }
>+#endif
>+
> #endif /* _ASM_ARM_XEN_HYPERVISOR_H */
>diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
>index 63af9a7..cb7b8e2 100644
>--- a/arch/arm/kernel/setup.c
>+++ b/arch/arm/kernel/setup.c
>@@ -45,6 +45,7 @@
> #include <asm/cacheflush.h>
> #include <asm/cachetype.h>
> #include <asm/tlbflush.h>
>+#include <asm/xen/hypervisor.h>
> 
> #include <asm/prom.h>
> #include <asm/mach/arch.h>
>@@ -889,6 +890,7 @@ void __init setup_arch(char **cmdline_p)
> 
> 	arm_dt_init_cpu_maps();
> 	psci_init();
>+	xen_early_init();
> #ifdef CONFIG_SMP
> 	if (is_smp()) {
> 		if (!mdesc->smp_init || !mdesc->smp_init()) {
>diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
>index c9770ba..14d17ab 100644
>--- a/arch/arm/xen/enlighten.c
>+++ b/arch/arm/xen/enlighten.c
>@@ -195,21 +195,19 @@ static void xen_power_off(void)
>  * documentation of the Xen Device Tree format.
>  */
> #define GRANT_TABLE_PHYSADDR 0
>-static int __init xen_guest_init(void)
>+void __init xen_early_init(void)
> {
>-	struct xen_add_to_physmap xatp;
>-	static struct shared_info *shared_info_page = 0;
>+	struct resource res;
> 	struct device_node *node;
> 	int len;
> 	const char *s = NULL;
> 	const char *version = NULL;
> 	const char *xen_prefix = "xen,xen-";
>-	struct resource res;
> 
> 	node = of_find_compatible_node(NULL, NULL, "xen,xen");
> 	if (!node) {
> 		pr_debug("No Xen support\n");
>-		return 0;
>+		return;
> 	}
> 	s = of_get_property(node, "compatible", &len);
> 	if (strlen(xen_prefix) + 3  < len &&
>@@ -217,10 +215,10 @@ static int __init xen_guest_init(void)
> 		version = s + strlen(xen_prefix);
> 	if (version == NULL) {
> 		pr_debug("Xen version not found\n");
>-		return 0;
>+		return;
> 	}
> 	if (of_address_to_resource(node, GRANT_TABLE_PHYSADDR, &res))
>-		return 0;
>+		return;
> 	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
> 	xen_events_irq = irq_of_parse_and_map(node, 0);
> 	pr_info("Xen %s support found, events_irq=%d gnttab_frame_pfn=%lx\n",
>@@ -232,6 +230,15 @@ static int __init xen_guest_init(void)
> 		xen_start_info->flags |= SIF_INITDOMAIN|SIF_PRIVILEGED;
> 	else
> 		xen_start_info->flags &= ~(SIF_INITDOMAIN|SIF_PRIVILEGED);
>+}
>+
>+static int __init xen_guest_init(void)
>+{
>+	struct xen_add_to_physmap xatp;
>+	static struct shared_info *shared_info_page = 0;
>+
>+	if (!xen_domain())
>+		return 0;
> 
> 	if (!shared_info_page)
> 		shared_info_page = (struct shared_info *)
>diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>index add6ea6..e0d438a 100644
>--- a/arch/arm64/kernel/setup.c
>+++ b/arch/arm64/kernel/setup.c
>@@ -53,6 +53,7 @@
> #include <asm/traps.h>
> #include <asm/memblock.h>
> #include <asm/psci.h>
>+#include <asm/xen/hypervisor.h>
> 
> unsigned int processor_id;
> EXPORT_SYMBOL(processor_id);
>@@ -267,6 +268,7 @@ void __init setup_arch(char **cmdline_p)
> 	unflatten_device_tree();
> 
> 	psci_init();
>+	xen_early_init();
> 
> 	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
> #ifdef CONFIG_SMP


