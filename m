Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3AXUMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:12:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34378 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3AXUMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:12:20 -0500
Date: Thu, 24 Jan 2013 12:10:58 -0800
From: tip-bot for Alok N Kataria <akataria@vmware.com>
Message-ID: <tip-4cca6ea04d31c22a7d0436949c072b27bde41f86@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, dhecht@vmware.com, hpa@zytor.com,
        mingo@kernel.org, konrad.wilk@oracle.com, dcovelli@vmware.com,
        jeremy@goop.org, tglx@linutronix.de, akataria@vmware.com,
        avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, dhecht@vmware.com,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        dcovelli@vmware.com, jeremy@goop.org, tglx@linutronix.de,
        akataria@vmware.com, avi@redhat.com
In-Reply-To: <1358466282.423.60.camel@akataria-dtop.eng.vmware.com>
References: <1358466282.423.60.camel@akataria-dtop.eng.vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Allow x2apic without IR on VMware platform
Git-Commit-ID: 4cca6ea04d31c22a7d0436949c072b27bde41f86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:11:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cca6ea04d31c22a7d0436949c072b27bde41f86
Gitweb:     http://git.kernel.org/tip/4cca6ea04d31c22a7d0436949c072b27bde41f86
Author:     Alok N Kataria <akataria@vmware.com>
AuthorDate: Thu, 17 Jan 2013 15:44:42 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 13:11:18 +0100

x86/apic: Allow x2apic without IR on VMware platform

This patch updates x2apic initializaition code to allow x2apic
on VMware platform even without interrupt remapping support.
The hypervisor_x2apic_available hook was added in x2apic
initialization code and used by KVM and XEN, before this.
I have also cleaned up that code to export this hook through the
hypervisor_x86 structure.

Compile tested for KVM and XEN configs, this patch doesn't have
any functional effect on those two platforms.

On VMware platform, verified that x2apic is used in physical
mode on products that support this.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Reviewed-by: Doug Covelli <dcovelli@vmware.com>
Reviewed-by: Dan Hecht <dhecht@vmware.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Avi Kivity <avi@redhat.com>
Link: http://lkml.kernel.org/r/1358466282.423.60.camel@akataria-dtop.eng.vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/hypervisor.h | 13 ++++---------
 arch/x86/kernel/cpu/hypervisor.c  |  7 +++++++
 arch/x86/kernel/cpu/vmware.c      | 13 +++++++++++++
 arch/x86/kernel/kvm.c             |  1 +
 arch/x86/xen/enlighten.c          |  1 +
 5 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index b518c75..86095ed 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -25,6 +25,7 @@
 
 extern void init_hypervisor(struct cpuinfo_x86 *c);
 extern void init_hypervisor_platform(void);
+extern bool hypervisor_x2apic_available(void);
 
 /*
  * x86 hypervisor information
@@ -41,6 +42,9 @@ struct hypervisor_x86 {
 
 	/* Platform setup (run once per boot) */
 	void		(*init_platform)(void);
+
+	/* X2APIC detection (run once per boot) */
+	bool		(*x2apic_available)(void);
 };
 
 extern const struct hypervisor_x86 *x86_hyper;
@@ -51,13 +55,4 @@ extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
 extern const struct hypervisor_x86 x86_hyper_xen_hvm;
 extern const struct hypervisor_x86 x86_hyper_kvm;
 
-static inline bool hypervisor_x2apic_available(void)
-{
-	if (kvm_para_available())
-		return true;
-	if (xen_x2apic_para_available())
-		return true;
-	return false;
-}
-
 #endif
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index a8f8fa9..1e7e84a 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -79,3 +79,10 @@ void __init init_hypervisor_platform(void)
 	if (x86_hyper->init_platform)
 		x86_hyper->init_platform();
 }
+
+bool __init hypervisor_x2apic_available(void)
+{
+	return x86_hyper                   &&
+	       x86_hyper->x2apic_available &&
+	       x86_hyper->x2apic_available();
+}
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index d22d0c4..03a3632 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -33,6 +33,9 @@
 
 #define VMWARE_PORT_CMD_GETVERSION	10
 #define VMWARE_PORT_CMD_GETHZ		45
+#define VMWARE_PORT_CMD_GETVCPU_INFO	68
+#define VMWARE_PORT_CMD_LEGACY_X2APIC	3
+#define VMWARE_PORT_CMD_VCPU_RESERVED	31
 
 #define VMWARE_PORT(cmd, eax, ebx, ecx, edx)				\
 	__asm__("inl (%%dx)" :						\
@@ -125,10 +128,20 @@ static void __cpuinit vmware_set_cpu_features(struct cpuinfo_x86 *c)
 	set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
 }
 
+/* Checks if hypervisor supports x2apic without VT-D interrupt remapping. */
+static bool __init vmware_legacy_x2apic_available(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	VMWARE_PORT(GETVCPU_INFO, eax, ebx, ecx, edx);
+	return (eax & (1 << VMWARE_PORT_CMD_VCPU_RESERVED)) == 0 &&
+	       (eax & (1 << VMWARE_PORT_CMD_LEGACY_X2APIC)) != 0;
+}
+
 const __refconst struct hypervisor_x86 x86_hyper_vmware = {
 	.name			= "VMware",
 	.detect			= vmware_platform,
 	.set_cpu_features	= vmware_set_cpu_features,
 	.init_platform		= vmware_platform_setup,
+	.x2apic_available	= vmware_legacy_x2apic_available,
 };
 EXPORT_SYMBOL(x86_hyper_vmware);
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 9c2bd8b..2b44ea5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -505,6 +505,7 @@ static bool __init kvm_detect(void)
 const struct hypervisor_x86 x86_hyper_kvm __refconst = {
 	.name			= "KVM",
 	.detect			= kvm_detect,
+	.x2apic_available	= kvm_para_available,
 };
 EXPORT_SYMBOL_GPL(x86_hyper_kvm);
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 138e566..8b4c56d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1668,6 +1668,7 @@ const struct hypervisor_x86 x86_hyper_xen_hvm __refconst = {
 	.name			= "Xen HVM",
 	.detect			= xen_hvm_platform,
 	.init_platform		= xen_hvm_guest_init,
+	.x2apic_available	= xen_x2apic_para_available,
 };
 EXPORT_SYMBOL(x86_hyper_xen_hvm);
 #endif
