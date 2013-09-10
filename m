Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3IJPaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:30:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23526 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3IJPaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:30:09 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: xen-devel@lists.xen.org
Cc: konrad.wilk@oracle.com, david.vrabel@citrix.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v1 2/5] xen/PMU: Sysfs interface for setting Xen PMU mode
Date: Tue, 10 Sep 2013 11:31:47 -0400
Message-Id: <1378827110-4192-3-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set Xen's PMU mode via /sys/hypervisor/pmu/pmu_mode. Add XENPMU hypercall.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/include/asm/xen/hypercall.h |   6 ++
 arch/x86/xen/xen-head.S              |   5 +-
 drivers/xen/sys-hypervisor.c         | 118 +++++++++++++++++++++++++++++++++++
 include/xen/interface/xen.h          |   1 +
 include/xen/interface/xenpmu.h       |  44 +++++++++++++
 5 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 include/xen/interface/xenpmu.h

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index e709884..f022cef 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -465,6 +465,12 @@ HYPERVISOR_tmem_op(
 	return _hypercall1(int, tmem_op, op);
 }
 
+static inline int
+HYPERVISOR_xenpmu_op(unsigned int op, void *arg)
+{
+	return _hypercall2(int, xenpmu_op, op, arg);
+}
+
 static inline void
 MULTI_fpu_taskswitch(struct multicall_entry *mcl, int set)
 {
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 7faed58..f2415e6 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -73,8 +73,11 @@ NEXT_HYPERCALL(sysctl)
 NEXT_HYPERCALL(domctl)
 NEXT_HYPERCALL(kexec_op)
 NEXT_HYPERCALL(tmem_op) /* 38 */
+ENTRY(xenclient_rsvd)
+	.skip 32
+NEXT_HYPERCALL(xenpmu_op) /* 40 */
 ENTRY(xen_hypercall_rsvr)
-	.skip 320
+	.skip 256
 NEXT_HYPERCALL(mca) /* 48 */
 NEXT_HYPERCALL(arch_1)
 NEXT_HYPERCALL(arch_2)
diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
index 96453f8..2218154 100644
--- a/drivers/xen/sys-hypervisor.c
+++ b/drivers/xen/sys-hypervisor.c
@@ -20,6 +20,7 @@
 #include <xen/xenbus.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/version.h>
+#include <xen/interface/xenpmu.h>
 
 #define HYPERVISOR_ATTR_RO(_name) \
 static struct hyp_sysfs_attr  _name##_attr = __ATTR_RO(_name)
@@ -368,6 +369,115 @@ static void xen_properties_destroy(void)
 	sysfs_remove_group(hypervisor_kobj, &xen_properties_group);
 }
 
+struct pmu_mode {
+	const char *name;
+	uint32_t mode;
+};
+struct pmu_mode pmu_modes[] = {
+	{"enable", VPMU_ON},
+	{"priv_enable", VPMU_PRIV},
+	{"disable", 0}
+};
+static ssize_t pmu_mode_store(struct hyp_sysfs_attr *attr,
+			      const char *buffer, size_t len)
+{
+	int ret;
+	struct xenpmu_params xp;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(pmu_modes); i++) {
+		if (!strncmp(buffer, pmu_modes[i].name,
+			     strlen(pmu_modes[i].name))) {
+			xp.control = pmu_modes[i].mode;
+			break;
+		}
+	}
+
+	if (i == ARRAY_SIZE(pmu_modes))
+		return -EINVAL;
+
+	ret = HYPERVISOR_xenpmu_op(XENPMU_mode_set, &xp);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t pmu_mode_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int ret;
+	struct xenpmu_params xp;
+	int i;
+	uint32_t mode;
+
+	ret = HYPERVISOR_xenpmu_op(XENPMU_mode_get, &xp);
+	if (ret)
+		return ret;
+
+	mode = (uint32_t)xp.control & VPMU_MODE_MASK;
+	for (i = 0; i < ARRAY_SIZE(pmu_modes); i++) {
+		if (mode == pmu_modes[i].mode)
+			return sprintf(buffer, "%s\n", pmu_modes[i].name);
+	}
+
+	return -EINVAL;
+}
+HYPERVISOR_ATTR_RW(pmu_mode);
+
+
+static ssize_t pmu_flags_store(struct hyp_sysfs_attr *attr,
+			      const char *buffer, size_t len)
+{
+	int ret;
+	uint32_t flags;
+	struct xenpmu_params xp;
+
+	ret = kstrtou32(buffer, 0, &flags);
+	if (ret)
+		return ret;
+
+	xp.control = flags;
+	ret = HYPERVISOR_xenpmu_op(XENPMU_flags_set, &xp);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t pmu_flags_show(struct hyp_sysfs_attr *attr, char *buffer)
+{
+	int ret;
+	struct xenpmu_params xp;
+
+	ret = HYPERVISOR_xenpmu_op(XENPMU_flags_get, &xp);
+	if (ret)
+		return ret;
+
+	return sprintf(buffer, "0x%x\n", (uint32_t)xp.control);
+}
+HYPERVISOR_ATTR_RW(pmu_flags);
+
+static struct attribute *xen_pmu_attrs[] = {
+	&pmu_mode_attr.attr,
+	&pmu_flags_attr.attr,
+	NULL
+};
+
+static const struct attribute_group xen_pmu_group = {
+	.name = "pmu",
+	.attrs = xen_pmu_attrs,
+};
+
+static int __init xen_pmu_init(void)
+{
+	return sysfs_create_group(hypervisor_kobj, &xen_pmu_group);
+}
+
+static void xen_pmu_destroy(void)
+{
+	sysfs_remove_group(hypervisor_kobj, &xen_pmu_group);
+}
+
 static int __init hyper_sysfs_init(void)
 {
 	int ret;
@@ -390,9 +500,16 @@ static int __init hyper_sysfs_init(void)
 	ret = xen_properties_init();
 	if (ret)
 		goto prop_out;
+	if (xen_initial_domain()) {
+		ret = xen_pmu_init();
+		if (ret)
+			goto pmu_out;
+	}
 
 	goto out;
 
+pmu_out:
+	xen_properties_destroy();
 prop_out:
 	xen_sysfs_uuid_destroy();
 uuid_out:
@@ -407,6 +524,7 @@ out:
 
 static void __exit hyper_sysfs_exit(void)
 {
+	xen_pmu_destroy();
 	xen_properties_destroy();
 	xen_compilation_destroy();
 	xen_sysfs_uuid_destroy();
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 53ec416..c29d427 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -58,6 +58,7 @@
 #define __HYPERVISOR_physdev_op           33
 #define __HYPERVISOR_hvm_op               34
 #define __HYPERVISOR_tmem_op              38
+#define __HYPERVISOR_xenpmu_op            40
 
 /* Architecture-specific hypercall definitions. */
 #define __HYPERVISOR_arch_0               48
diff --git a/include/xen/interface/xenpmu.h b/include/xen/interface/xenpmu.h
new file mode 100644
index 0000000..63c42b1
--- /dev/null
+++ b/include/xen/interface/xenpmu.h
@@ -0,0 +1,44 @@
+#ifndef __XEN_PUBLIC_XENPMU_H__
+#define __XEN_PUBLIC_XENPMU_H__
+
+#include <asm/msr.h>
+
+#include "xen.h"
+
+#define XENPMU_VER_MAJ    0
+#define XENPMU_VER_MIN    0
+
+/* HYPERVISOR_xenpmu_op commands */
+#define XENPMU_mode_get        0
+#define XENPMU_mode_set        1
+#define XENPMU_flags_get       2
+#define XENPMU_flags_set       3
+
+/* Parameter structure for HYPERVISOR_xenpmu_op call */
+struct xenpmu_params {
+	union {
+		struct version {
+			uint8_t maj;
+			uint8_t min;
+		} version;
+		uint64_t pad;
+	};
+	uint64_t control;
+};
+
+/* VPMU modes */
+#define VPMU_MODE_MASK     0xff
+#define VPMU_OFF           0
+/* guests can profile themselves, (dom0 profiles itself and Xen) */
+#define VPMU_ON            (1<<0)
+/*
+ * Only dom0 has access to VPMU and it profiles everyone: itself,
+ * the hypervisor and the guests.
+ */
+#define VPMU_PRIV          (1<<1)
+
+/* VPMU flags */
+#define VPMU_FLAGS_MASK    ((uint32_t)(~VPMU_MODE_MASK))
+#define VPMU_INTEL_BTS     (1<<8) /* Ignored on AMD */
+
+#endif /* __XEN_PUBLIC_XENPMU_H__ */
-- 
1.8.1.4

