Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaKJGjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:39:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:54503 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbaKJGgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:36:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="629364143"
From: Feng Wu <feng.wu@intel.com>
To: gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [PATCH 09/13] KVM: Change NDST field after VCPU scheduling
Date: Mon, 10 Nov 2014 14:26:48 +0800
Message-Id: <1415600812-27773-10-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the NDST filed of Posted-Interrupts
Descriptor after VCPU is scheduled to another physical
CPU.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/kvm/vmx.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4c1a966..fa77714 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1906,6 +1906,31 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
 		vmx->loaded_vmcs->cpu = cpu;
 	}
+
+	if (irq_post_enabled && (vcpu->cpu != cpu)) {
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
+			if (x2apic_mode)
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

