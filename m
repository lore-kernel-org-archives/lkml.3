Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaLCHu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:50:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:5524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbaLCHu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852523"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 22/25] KVM: Change NDST field after vCPU scheduling
Date: Wed,  3 Dec 2014 15:39:51 +0800
Message-Id: <1417592394-24343-23-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the NDST filed of Posted-Interrupts
Descriptor after vCPU is scheduled to another physical
CPU.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/vmx.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a1966b9..e71bf3b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1906,6 +1906,31 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
 		vmx->loaded_vmcs->cpu = cpu;
 	}
+
+	if (irq_remapping_cap(IRQ_POSTING_CAP) && (vcpu->cpu != cpu)) {
+		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+		struct pi_desc old, new;
+		unsigned int dest;
+
+		memset(&old, 0, sizeof(old));
+		memset(&new, 0, sizeof(new));
+
+		pi_set_sn(pi_desc);
+
+		do {
+			old.control = new.control = pi_desc->control;
+
+			dest = cpu_physical_id(cpu);
+
+			if (x2apic_enabled())
+				new.ndst = dest;
+			else
+				new.ndst = (dest << 8) & 0xFF00;
+
+		} while (cmpxchg(&pi_desc->control, old.control,
+				new.control) != old.control);
+		pi_clear_sn(pi_desc);
+	}
 }
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
-- 
1.7.1

