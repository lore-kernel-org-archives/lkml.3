Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaGQE5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 00:57:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:33677 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaGQE5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 00:57:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="362384290"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 1/3] KVM: nVMX: Fix virtual interrupt delivery injection 
Date: Thu, 17 Jul 2014 12:56:49 +0800
Message-Id: <1405573011-41330-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug reported in https://bugzilla.kernel.org/show_bug.cgi?id=73331, 
after the patch http://www.spinics.net/lists/kvm/msg105230.html applied, there is
some progress and the L2 can boot up, however, slowly. The original idea of this 
fix vid injection patch is from "Zhang, Yang Z" <yang.z.zhang@intel.com>.

Interrupt which delivered by vid should be injected to L1 by L0 if current is in 
L1, or should be injected to L2 by L0 through the old injection way if L1 doesn't 
have set VM_EXIT_ACK_INTR_ON_EXIT. The current logic doen't consider these cases. 
This patch fix it by vid intr to L1 if current is L1 or L2 through old injection 
way if L1 doen't have VM_EXIT_ACK_INTR_ON_EXIT set.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: "Zhang, Yang Z" <yang.z.zhang@intel.com>
---
 arch/x86/kvm/vmx.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 021d84a..ad36646 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7112,8 +7112,22 @@ static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
 {
 	if (max_irr == -1)
 		return;
-
-	vmx_set_rvi(max_irr);
+	if (!is_guest_mode(vcpu)) {
+		vmx_set_rvi(max_irr);
+	} else if (is_guest_mode(vcpu) && !nested_exit_on_intr(vcpu)) {
+		/*
+		 * Fall back to old way to inject the interrupt since there
+		 * is no vAPIC-v for L2.
+		 */
+		if (vcpu->arch.exception.pending ||
+				vcpu->arch.nmi_injected ||
+				vcpu->arch.interrupt.pending)
+			return;
+		else if (vmx_interrupt_allowed(vcpu)) {
+			kvm_queue_interrupt(vcpu, max_irr, false);
+			vmx_inject_irq(vcpu);
+		}
+	}
 }
 
 static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
-- 
1.9.1

