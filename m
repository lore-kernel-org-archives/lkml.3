Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaAMQDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:03:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53268 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaAMQDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 096/208] KVM: x86: Fix APIC map calculation after re-enabling
Date: Mon, 13 Jan 2014 15:58:57 +0000
Message-Id: <1389628849-1614-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/lapic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 81d7b23..dedd7c2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1364,6 +1364,10 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		return;
 	}
 
+	if (!kvm_vcpu_is_bsp(apic->vcpu))
+		value &= ~MSR_IA32_APICBASE_BSP;
+	vcpu->arch.apic_base = value;
+
 	/* update jump label if enable bit changes */
 	if ((vcpu->arch.apic_base ^ value) & MSR_IA32_APICBASE_ENABLE) {
 		if (value & MSR_IA32_APICBASE_ENABLE)
@@ -1373,10 +1377,6 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		recalculate_apic_map(vcpu->kvm);
 	}
 
-	if (!kvm_vcpu_is_bsp(apic->vcpu))
-		value &= ~MSR_IA32_APICBASE_BSP;
-
-	vcpu->arch.apic_base = value;
 	if ((old_value ^ value) & X2APIC_ENABLE) {
 		if (value & X2APIC_ENABLE) {
 			u32 id = kvm_apic_id(apic);
-- 
1.8.3.2

