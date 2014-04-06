Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaDFXjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:39:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59431 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754641AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paolo Bonzini" <pbonzini@redhat.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.429733553@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 15/18] KVM: MMU: handle invalid root_hpa at __direct_map
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2451,6 +2451,9 @@ static int __direct_map(struct kvm_vcpu
 	int emulate = 0;
 	gfn_t pseudo_gfn;
 
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return 0;
+
 	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
 		if (iterator.level == level) {
 			unsigned pte_access = ACC_ALL;

