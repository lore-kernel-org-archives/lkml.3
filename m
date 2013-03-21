Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3CUTQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:16:30 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53415 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab3CUTQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:16:28 -0400
X-IronPort-AV: E=Sophos;i="4.84,888,1355097600"; 
   d="scan'208";a="14783237"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/4] xen/arm: SMP support
Date: Thu, 21 Mar 2013 19:16:18 +0000
Message-ID: <1363893380-14309-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1303211848150.5135@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1303211848150.5135@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Map vcpu_info using VCPUOP_register_vcpu_info on secondary cpus.

Call enable_percpu_irq on every cpu.

Actually pass a percpu variable to request_percpu_irq.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 18b0049..ffbedce 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -2,6 +2,7 @@
 #include <xen/events.h>
 #include <xen/grant_table.h>
 #include <xen/hvm.h>
+#include <xen/interface/vcpu.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/memory.h>
 #include <xen/interface/hvm/params.h>
@@ -32,6 +33,7 @@ struct shared_info xen_dummy_shared_info;
 struct shared_info *HYPERVISOR_shared_info = (void *)&xen_dummy_shared_info;
 
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
+DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 
 /* These are unused until we support booting "pre-ballooned" */
 unsigned long xen_released_pages;
@@ -148,6 +150,32 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
 
+static int __init xen_secondary_init(unsigned int cpu)
+{
+	struct vcpu_register_vcpu_info info;
+	struct vcpu_info *vcpup;
+	int err;
+
+	if (cpu == 0)
+		return 0;
+
+	pr_info("Xen: initializing cpu%d\n", cpu);
+	vcpup = &per_cpu(xen_vcpu_info, cpu);
+
+	info.mfn = __pa(vcpup) >> PAGE_SHIFT;
+	info.offset = offset_in_page(vcpup);
+
+	err = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_info, cpu, &info);
+	if (err) {
+		pr_debug("register_vcpu_info failed: err=%d\n", err);
+	} else {
+		/* This cpu is using the registered vcpu info, even if
+		   later ones fail to. */
+		per_cpu(xen_vcpu, cpu) = vcpup;
+	}
+	return 0;
+}
+
 /*
  * see Documentation/devicetree/bindings/arm/xen.txt for the
  * documentation of the Xen Device Tree format.
@@ -163,6 +191,7 @@ static int __init xen_guest_init(void)
 	const char *version = NULL;
 	const char *xen_prefix = "xen,xen-";
 	struct resource res;
+	int i;
 
 	node = of_find_compatible_node(NULL, NULL, "xen,xen");
 	if (!node) {
@@ -216,6 +245,8 @@ static int __init xen_guest_init(void)
 	 * is required to use VCPUOP_register_vcpu_info to place vcpu info
 	 * for secondary CPUs as they are brought up. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
+	for_each_online_cpu(i)
+		xen_secondary_init(i);
 
 	gnttab_init();
 	if (!xen_initial_domain())
@@ -231,20 +262,27 @@ static irqreturn_t xen_arm_callback(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static __init void xen_percpu_enable_events(void *unused)
+{
+	enable_percpu_irq(xen_events_irq, 0);
+}
+
 static int __init xen_init_events(void)
 {
+	int i;
+
 	if (!xen_domain() || xen_events_irq < 0)
 		return -ENODEV;
 
 	xen_init_IRQ();
 
 	if (request_percpu_irq(xen_events_irq, xen_arm_callback,
-			"events", xen_vcpu)) {
+			"events", &xen_vcpu)) {
 		pr_err("Error requesting IRQ %d\n", xen_events_irq);
 		return -EINVAL;
 	}
 
-	enable_percpu_irq(xen_events_irq, 0);
+	on_each_cpu(xen_percpu_enable_events, NULL, 0);
 
 	return 0;
 }
-- 
1.7.2.5

