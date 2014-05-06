Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533AbaEFAlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:41:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005AbaEFAlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:41:14 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] KVM: x86: pass ctxt to fetch helper function
Date: Mon,  5 May 2014 20:40:57 -0400
Message-Id: <1399336859-7227-2-git-send-email-bsd@redhat.com>
In-Reply-To: <1399336859-7227-1-git-send-email-bsd@redhat.com>
References: <1399336859-7227-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following patches, our adress caching struct that's
embedded within struct x86_emulate_ctxt will need to be
accessed

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/x86.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 122410d..17e3d661 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4061,10 +4061,11 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 }
 
 static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
-				      struct kvm_vcpu *vcpu, u32 access,
+				      struct x86_emulate_ctxt *ctxt, u32 access,
 				      struct x86_exception *exception)
 {
 	void *data = val;
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int r = X86EMUL_CONTINUE;
 
 	while (bytes) {
@@ -4098,7 +4099,7 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 
-	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu,
+	return kvm_read_guest_virt_helper(addr, val, bytes, ctxt,
 					  access | PFERR_FETCH_MASK,
 					  exception);
 }
@@ -4110,7 +4111,7 @@ int kvm_read_guest_virt(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 
-	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access,
+	return kvm_read_guest_virt_helper(addr, val, bytes, ctxt, access,
 					  exception);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_virt);
@@ -4119,8 +4120,7 @@ static int kvm_read_guest_virt_system(struct x86_emulate_ctxt *ctxt,
 				      gva_t addr, void *val, unsigned int bytes,
 				      struct x86_exception *exception)
 {
-	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, 0, exception);
+	return kvm_read_guest_virt_helper(addr, val, bytes, ctxt, 0, exception);
 }
 
 int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
-- 
1.8.3.1

