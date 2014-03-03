Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaCCS5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:57:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55961 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaCCS5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:57:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 67/67] kvm: x86: fix apic_base enable check
Date: Mon,  3 Mar 2014 10:55:55 -0800
Message-Id: <1393872955-28810-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <drjones@redhat.com>

commit 0dce7cd67fd9055c4a2ff278f8af1431e646d346 upstream.

Commit e66d2ae7c67bd moved the assignment
vcpu->arch.apic_base = value above a condition with
(vcpu->arch.apic_base ^ value), causing that check
to always fail. Use old_value, vcpu->arch.apic_base's
old value, in the condition instead.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ kamal: backport to 3.8 (collect old_value) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6e27290..e77b0f4 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1289,6 +1289,7 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
 
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 {
+	u64 old_value = vcpu->arch.apic_base;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (!apic) {
@@ -1302,7 +1303,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	vcpu->arch.apic_base = value;
 
 	/* update jump label if enable bit changes */
-	if ((vcpu->arch.apic_base ^ value) & MSR_IA32_APICBASE_ENABLE) {
+	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE) {
 		if (value & MSR_IA32_APICBASE_ENABLE)
 			static_key_slow_dec_deferred(&apic_hw_disabled);
 		else
-- 
1.8.3.2

