Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030630AbaLLP1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:27:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:6440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030588AbaLLP0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:26:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807627"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 23/26] KVM: Update Posted-Interrupts Descriptor when vCPU is preempted
Date: Fri, 12 Dec 2014 23:14:57 +0800
Message-Id: <1418397300-10870-24-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the Posted-Interrupts Descriptor when vCPU
is preempted.

sched out:
- Set 'SN' to suppress furture non-urgent interrupts posted for
the vCPU.

sched in:
- Clear 'SN'
- Change NDST if vCPU is scheduled to a different CPU
- Set 'NV' to POSTED_INTR_VECTOR

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/vmx.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ee3b735..bf2e6cd 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1916,10 +1916,54 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
 		vmx->loaded_vmcs->cpu = cpu;
 	}
+
+	if (irq_remapping_cap(IRQ_POSTING_CAP)) {
+		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+		struct pi_desc old, new;
+		unsigned int dest;
+
+		memset(&old, 0, sizeof(old));
+		memset(&new, 0, sizeof(new));
+
+		do {
+			old.control = new.control = pi_desc->control;
+			if (vcpu->cpu != cpu) {
+				dest = cpu_physical_id(cpu);
+
+				if (x2apic_enabled())
+					new.ndst = dest;
+				else
+					new.ndst = (dest << 8) & 0xFF00;
+			}
+
+			pi_clear_sn(&new);
+
+			/* set 'NV' to 'notification vector' */
+			new.nv = POSTED_INTR_VECTOR;
+		} while (cmpxchg(&pi_desc->control, old.control,
+				new.control) != old.control);
+	}
 }
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	if (irq_remapping_cap(IRQ_POSTING_CAP)) {
+		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+		struct pi_desc old, new;
+
+		memset(&old, 0, sizeof(old));
+		memset(&new, 0, sizeof(new));
+
+		/* Set SN when the vCPU is preempted */
+		if (vcpu->preempted) {
+			do {
+				old.control = new.control = pi_desc->control;
+				pi_set_sn(&new);
+			} while (cmpxchg(&pi_desc->control, old.control,
+					new.control) != old.control);
+		}
+	}
+
 	__vmx_load_host_state(to_vmx(vcpu));
 	if (!vmm_exclusive) {
 		__loaded_vmcs_clear(to_vmx(vcpu)->loaded_vmcs);
-- 
1.9.1

