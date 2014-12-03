Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaLCHuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:50:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbaLCHuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852345"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 12/25] KVM: Initialize VT-d Posted-Interrupts Descriptor
Date: Wed,  3 Dec 2014 15:39:41 +0800
Message-Id: <1417592394-24343-13-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initializes the VT-d Posted-Interrupts Descriptor.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/vmx.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0b1383e..66ca275 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -45,6 +45,7 @@
 #include <asm/perf_event.h>
 #include <asm/debugreg.h>
 #include <asm/kexec.h>
+#include <asm/irq_remapping.h>
 
 #include "trace.h"
 
@@ -4433,6 +4434,30 @@ static void ept_set_mmio_spte_mask(void)
 	kvm_mmu_set_mmio_spte_mask((0x3ull << 62) | 0x6ull);
 }
 
+static void pi_desc_init(struct vcpu_vmx *vmx)
+{
+	unsigned int dest;
+
+	if (!irq_remapping_cap(IRQ_POSTING_CAP))
+		return;
+
+	/*
+	 * Initialize Posted-Interrupt Descriptor
+	 */
+
+	pi_clear_sn(&vmx->pi_desc);
+	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
+
+	/* Physical mode for Notificaiton Event */
+	vmx->pi_desc.ndm = 0;
+	dest = cpu_physical_id(vmx->vcpu.cpu);
+
+	if (x2apic_enabled())
+		vmx->pi_desc.ndst = dest;
+	else
+		vmx->pi_desc.ndst = (dest << 8) & 0xFF00;
+}
+
 /*
  * Sets up the vmcs for emulated real mode.
  */
@@ -4476,6 +4501,8 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 
 		vmcs_write64(POSTED_INTR_NV, POSTED_INTR_VECTOR);
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
+
+		pi_desc_init(vmx);
 	}
 
 	if (ple_gap) {
-- 
1.7.1

