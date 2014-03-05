Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbaCEO0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:26:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41133 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaCEO02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 087/131] KVM: MMU: handle invalid root_hpa at __direct_map
Date: Wed,  5 Mar 2014 14:23:31 +0000
Message-Id: <1394029455-23128-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 989c6b34f6a9480e397b170cc62237e89bf4fdb9 upstream.

It is possible for __direct_map to be called on invalid root_hpa
(-1), two examples:

1) try_async_pf -> can_do_async_pf
    -> vmx_interrupt_allowed -> nested_vmx_vmexit
2) vmx_handle_exit -> vmx_interrupt_allowed -> nested_vmx_vmexit

Then to load_vmcs12_host_state and kvm_mmu_reset_context.

Check for this possibility, let fault exception be regenerated.

BZ: https://bugzilla.redhat.com/show_bug.cgi?id=924916

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9e9285a..5239897 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2691,6 +2691,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 	int emulate = 0;
 	gfn_t pseudo_gfn;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return 0;
+
 	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
 		if (iterator.level == level) {
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL,
-- 
1.9.0

