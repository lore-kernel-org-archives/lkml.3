Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3LQUv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:51:56 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28443 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3LQUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:51:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v11 09/12] xen/pvh: Piggyback on PVHVM XenBus and event channels for PVH.
Date: Tue, 17 Dec 2013 15:51:40 -0500
Message-Id: <1387313503-31362-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

PVH is a PV guest with a twist - there are certain things
that work in it like HVM and some like PV. There is
a similar mode - PVHVM where we run in HVM mode with
PV code enabled - and this patch explores that.

The most notable PV interfaces are the XenBus and event channels.
For PVH, we will use XenBus and event channels.

For the XenBus mechanism we piggyback on how it is done for
PVHVM guests.

Ditto for the event channel mechanism - we piggyback on PVHVM -
by setting up a specific vector callback and that
vector ends up calling the event channel mechanism to
dispatch the events as needed.

This means that from a pvops perspective, we can use
native_irq_ops instead of the Xen PV specific. Albeit in the
future we could support pirq_eoi_map. But that is
a feature request that can be shared with PVHVM.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c           | 6 ++++++
 arch/x86/xen/irq.c                 | 5 ++++-
 drivers/xen/events.c               | 5 +++++
 drivers/xen/xenbus/xenbus_client.c | 3 ++-
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e420613..7fceb51 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1134,6 +1134,8 @@ void xen_setup_shared_info(void)
 	/* In UP this is as good a place as any to set up shared info */
 	xen_setup_vcpu_info_placement();
 #endif
+	if (xen_pvh_domain())
+		return;
 
 	xen_setup_mfn_list_list();
 }
@@ -1146,6 +1148,10 @@ void xen_setup_vcpu_info_placement(void)
 	for_each_possible_cpu(cpu)
 		xen_vcpu_setup(cpu);
 
+	/* PVH always uses native IRQ ops */
+	if (xen_pvh_domain())
+		return;
+
 	/* xen_vcpu_setup managed to place the vcpu_info within the
 	   percpu area for all cpus, so make use of it */
 	if (have_vcpu_info_placement) {
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 0da7f86..4f7f351 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -5,6 +5,7 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/sched.h>
 #include <xen/interface/vcpu.h>
+#include <xen/features.h>
 #include <xen/events.h>
 
 #include <asm/xen/hypercall.h>
@@ -128,6 +129,8 @@ static const struct pv_irq_ops xen_irq_ops __initconst = {
 
 void __init xen_init_irq_ops(void)
 {
-	pv_irq_ops = xen_irq_ops;
+	/* For PVH we use default pv_irq_ops settings */
+	if (!xen_feature(XENFEAT_hvm_callback_vector))
+		pv_irq_ops = xen_irq_ops;
 	x86_init.irqs.intr_init = xen_init_IRQ;
 }
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4035e83..627a16a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1922,6 +1922,11 @@ void __init xen_init_IRQ(void)
 		if (xen_initial_domain())
 			pci_xen_initial_domain();
 
+		if (xen_feature(XENFEAT_hvm_callback_vector)) {
+			xen_callback_vector();
+			return;
+		}
+
 		pirq_eoi_map = (void *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
 		eoi_gmfn.gmfn = virt_to_mfn(pirq_eoi_map);
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_pirq_eoi_gmfn_v2, &eoi_gmfn);
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index ec097d6..7f7c454 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -45,6 +45,7 @@
 #include <xen/grant_table.h>
 #include <xen/xenbus.h>
 #include <xen/xen.h>
+#include <xen/features.h>
 
 #include "xenbus_probe.h"
 
@@ -743,7 +744,7 @@ static const struct xenbus_ring_ops ring_ops_hvm = {
 
 void __init xenbus_ring_ops_init(void)
 {
-	if (xen_pv_domain())
+	if (xen_pv_domain() && !xen_feature(XENFEAT_auto_translated_physmap))
 		ring_ops = &ring_ops_pv;
 	else
 		ring_ops = &ring_ops_hvm;
-- 
1.8.3.1

