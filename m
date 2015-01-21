Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbbAVBk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:40:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43672 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbbAVBkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:40:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [RFC PATCH] xen,apic: Setup our own APIC driver and validator for APIC IDs.
Date: Wed, 21 Jan 2015 16:56:55 -0500
Message-Id: <1421877415-4249-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Via CPUID masking and the different apic-> overrides we
effectively make PV guests only but with the default APIC
driver. That is OK as an PV guest should never access any
APIC registers. However, the APIC is also used to limit the
amount of CPUs if the APIC IDs are incorrect - and since we
mask the x2APIC from the CPUID - any APIC IDs above 0xFF
are deemed incorrect by the default APIC routines.

As such add a new routine to check for APIC ID which will
be only used if the CPUID (native one) tells us the system
is using x2APIC.

This allows us to boot with more than 255 CPUs if running
as initial domain.

Reported-by: Cathy Avery <cathy.avery@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/apic.c      | 131 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c |  90 +-------------------------------
 2 files changed, 132 insertions(+), 89 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index 7005ced..3b2bd06 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -7,6 +7,7 @@
 #include <xen/xen.h>
 #include <xen/interface/physdev.h>
 #include "xen-ops.h"
+#include "smp.h"
 
 static unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
 {
@@ -28,7 +29,137 @@ static unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
 	return 0xfd;
 }
 
+static unsigned long xen_set_apic_id(unsigned int x)
+{
+	WARN_ON(1);
+	return x;
+}
+
+static unsigned int xen_get_apic_id(unsigned long x)
+{
+	return ((x)>>24) & 0xFFu;
+}
+
+static u32 xen_apic_read(u32 reg)
+{
+	struct xen_platform_op op = {
+		.cmd = XENPF_get_cpuinfo,
+		.interface_version = XENPF_INTERFACE_VERSION,
+		.u.pcpu_info.xen_cpuid = 0,
+	};
+	int ret = 0;
+
+	/* Shouldn't need this as APIC is turned off for PV, and we only
+	 * get called on the bootup processor. But just in case. */
+	if (!xen_initial_domain() || smp_processor_id())
+		return 0;
+
+	if (reg == APIC_LVR)
+		return 0x10;
+
+	if (reg != APIC_ID)
+		return 0;
+
+	ret = HYPERVISOR_dom0_op(&op);
+	if (ret)
+		return 0;
+
+	return op.u.pcpu_info.apic_id << 24;
+}
+
+static void xen_apic_write(u32 reg, u32 val)
+{
+	/* Warn to see if there's any stray references */
+	WARN_ON(1);
+}
+
+static u64 xen_apic_icr_read(void)
+{
+	return 0;
+}
+
+static void xen_apic_icr_write(u32 low, u32 id)
+{
+	/* Warn to see if there's any stray references */
+	WARN_ON(1);
+}
+
+static void xen_apic_wait_icr_idle(void)
+{
+        return;
+}
+
+static u32 xen_safe_apic_wait_icr_idle(void)
+{
+        return 0;
+}
+
+
+static int probe_xen(void)
+{
+	if (xen_pv_domain())
+		return 1;
+
+	return 0;
+}
+
+static int xen_id_always_valid(int apicid)
+{
+	return 1;
+}
+
+static struct apic xen_apic = {
+	.name = "Xen",
+	.probe = probe_xen,
+	/* The rest is copied from the default. */
+};
+
+/*
+ * This is needed as in enlighten.c we mask the x2APIC bit because we
+ * do not want PV guests to use anything but most of the default apic routines.
+ *
+ * However the default ->apic_id_valid enforces that the APIC ID MUST
+ * be below 0xFF which is not the case for x2APIC - so we need a way
+ * to allow that to function properly.
+ */
+static bool __init xen_check_x2apic(void)
+{
+#ifdef CONFIG_X2APIC
+	unsigned int ax, bx, cx, dx;
+
+	ax = 1;
+	cx = 0; /* Don't care about dx, and bx */
+	native_cpuid(&ax, &bx, &cx, &dx);
+	if (cx & (1 << (X86_FEATURE_X2APIC % 32)))
+		return true;
+#endif
+	return false;
+}
+
 void __init xen_init_apic(void)
 {
 	x86_io_apic_ops.read = xen_io_apic_read;
+
+	memcpy(&xen_apic, apic, sizeof(struct apic));
+	xen_apic.probe = probe_xen;
+	xen_apic.name = "Xen";
+
+	xen_apic.read = xen_apic_read;
+	xen_apic.write = xen_apic_write;
+	xen_apic.icr_read = xen_apic_icr_read;
+	xen_apic.icr_write = xen_apic_icr_write;
+	xen_apic.wait_icr_idle = xen_apic_wait_icr_idle;
+	xen_apic.safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
+	xen_apic.set_apic_id = xen_set_apic_id;
+	xen_apic.get_apic_id = xen_get_apic_id;
+
+	xen_apic.send_IPI_allbutself = xen_send_IPI_allbutself;
+	xen_apic.send_IPI_mask_allbutself = xen_send_IPI_mask_allbutself;
+	xen_apic.send_IPI_mask = xen_send_IPI_mask;
+	xen_apic.send_IPI_all = xen_send_IPI_all;
+	xen_apic.send_IPI_self = xen_send_IPI_self;
+
+	if (xen_check_x2apic())
+		xen_apic.apic_id_valid = xen_id_always_valid;
 }
+apic_driver(xen_apic);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 78a881b..6c13a45 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -927,92 +927,6 @@ static void xen_io_delay(void)
 {
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
-static unsigned long xen_set_apic_id(unsigned int x)
-{
-	WARN_ON(1);
-	return x;
-}
-static unsigned int xen_get_apic_id(unsigned long x)
-{
-	return ((x)>>24) & 0xFFu;
-}
-static u32 xen_apic_read(u32 reg)
-{
-	struct xen_platform_op op = {
-		.cmd = XENPF_get_cpuinfo,
-		.interface_version = XENPF_INTERFACE_VERSION,
-		.u.pcpu_info.xen_cpuid = 0,
-	};
-	int ret = 0;
-
-	/* Shouldn't need this as APIC is turned off for PV, and we only
-	 * get called on the bootup processor. But just in case. */
-	if (!xen_initial_domain() || smp_processor_id())
-		return 0;
-
-	if (reg == APIC_LVR)
-		return 0x10;
-
-	if (reg != APIC_ID)
-		return 0;
-
-	ret = HYPERVISOR_dom0_op(&op);
-	if (ret)
-		return 0;
-
-	return op.u.pcpu_info.apic_id << 24;
-}
-
-static void xen_apic_write(u32 reg, u32 val)
-{
-	/* Warn to see if there's any stray references */
-	WARN_ON(1);
-}
-
-static u64 xen_apic_icr_read(void)
-{
-	return 0;
-}
-
-static void xen_apic_icr_write(u32 low, u32 id)
-{
-	/* Warn to see if there's any stray references */
-	WARN_ON(1);
-}
-
-static void xen_apic_wait_icr_idle(void)
-{
-        return;
-}
-
-static u32 xen_safe_apic_wait_icr_idle(void)
-{
-        return 0;
-}
-
-static void set_xen_basic_apic_ops(void)
-{
-	apic->read = xen_apic_read;
-	apic->write = xen_apic_write;
-	apic->icr_read = xen_apic_icr_read;
-	apic->icr_write = xen_apic_icr_write;
-	apic->wait_icr_idle = xen_apic_wait_icr_idle;
-	apic->safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
-	apic->set_apic_id = xen_set_apic_id;
-	apic->get_apic_id = xen_get_apic_id;
-
-#ifdef CONFIG_SMP
-	apic->send_IPI_allbutself = xen_send_IPI_allbutself;
-	apic->send_IPI_mask_allbutself = xen_send_IPI_mask_allbutself;
-	apic->send_IPI_mask = xen_send_IPI_mask;
-	apic->send_IPI_all = xen_send_IPI_all;
-	apic->send_IPI_self = xen_send_IPI_self;
-#endif
-}
-
-#endif
-
 static void xen_clts(void)
 {
 	struct multicall_space mcs;
@@ -1601,7 +1515,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	/*
 	 * set up the basic apic ops.
 	 */
-	set_xen_basic_apic_ops();
+	xen_init_apic();
 #endif
 
 	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
@@ -1714,8 +1628,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
 		if (HYPERVISOR_dom0_op(&op) == 0)
 			boot_params.kbd_status = op.u.firmware_info.u.kbd_shift_flags;
 
-		xen_init_apic();
-
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
 
-- 
2.1.0

