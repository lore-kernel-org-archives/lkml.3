Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaAOV4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:56:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40855 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbaAOV4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:56:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 124/166] KVM: x86: Fix APIC map calculation after re-enabling
Date: Wed, 15 Jan 2014 13:52:18 -0800
Message-Id: <1389822780-4729-125-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

commit e66d2ae7c67bd9ac982a3d1890564de7f7eabf4b upstream.

Update arch.apic_base before triggering recalculate_apic_map. Otherwise
the recalculation will work against the previous state of the APIC and
will fail to build the correct map when an APIC is hardware-enabled
again.

This fixes a regression of 1e08ec4a13.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/lapic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 360aed5..8da302f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1300,6 +1300,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		return;
 	}
 
+	if (!kvm_vcpu_is_bsp(apic->vcpu))
+		value &= ~MSR_IA32_APICBASE_BSP;
+	vcpu->arch.apic_base = value;
+
 	/* update jump label if enable bit changes */
 	if ((vcpu->arch.apic_base ^ value) & MSR_IA32_APICBASE_ENABLE) {
 		if (value & MSR_IA32_APICBASE_ENABLE)
@@ -1309,10 +1313,6 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		recalculate_apic_map(vcpu->kvm);
 	}
 
-	if (!kvm_vcpu_is_bsp(apic->vcpu))
-		value &= ~MSR_IA32_APICBASE_BSP;
-
-	vcpu->arch.apic_base = value;
 	if (apic_x2apic_mode(apic)) {
 		u32 id = kvm_apic_id(apic);
 		u32 ldr = ((id >> 4) << 16) | (1 << (id & 0xf));
-- 
1.8.3.2

