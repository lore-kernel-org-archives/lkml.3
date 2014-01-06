Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbaAFWlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:41:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbaAFWk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 3.10 057/129] KVM: x86: Fix APIC map calculation after re-enabling
Date: Mon,  6 Jan 2014 14:38:06 -0800
Message-Id: <20140106223901.233525541@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1364,6 +1364,10 @@ void kvm_lapic_set_base(struct kvm_vcpu
 		return;
 	}
 
+	if (!kvm_vcpu_is_bsp(apic->vcpu))
+		value &= ~MSR_IA32_APICBASE_BSP;
+	vcpu->arch.apic_base = value;
+
 	/* update jump label if enable bit changes */
 	if ((vcpu->arch.apic_base ^ value) & MSR_IA32_APICBASE_ENABLE) {
 		if (value & MSR_IA32_APICBASE_ENABLE)
@@ -1373,10 +1377,6 @@ void kvm_lapic_set_base(struct kvm_vcpu
 		recalculate_apic_map(vcpu->kvm);
 	}
 
-	if (!kvm_vcpu_is_bsp(apic->vcpu))
-		value &= ~MSR_IA32_APICBASE_BSP;
-
-	vcpu->arch.apic_base = value;
 	if ((old_value ^ value) & X2APIC_ENABLE) {
 		if (value & X2APIC_ENABLE) {
 			u32 id = kvm_apic_id(apic);


