Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaC1Rg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:36:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaC1RbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.13 36/46] KVM: MMU: handle invalid root_hpa at __direct_map
Date: Fri, 28 Mar 2014 10:32:20 -0700
Message-Id: <20140328173139.570364519@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2659,6 +2659,9 @@ static int __direct_map(struct kvm_vcpu
 	int emulate = 0;
 	gfn_t pseudo_gfn;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return 0;
+
 	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
 		if (iterator.level == level) {
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL,


