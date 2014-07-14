Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbaGNLki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:40:38 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39755 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbaGNLj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:39:29 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 19/19] KVM: x86: use kvm_read_guest_page for emulator accesses
Date: Mon, 14 Jul 2014 13:38:43 +0200
Message-Id: <1405337923-4776-20-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
References: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emulator accesses are always done a page at a time, either by the emulator
itself (for fetches) or because we need to query the MMU for address
translations.  Speed up these accesses by using kvm_read_guest_page
and, in the case of fetches, by inlining kvm_read_guest_virt_helper and
dropping the loop around kvm_read_guest_page.

This final tweak saves 30-100 more clock cycles (4-10%), bringing the
count (as measured by kvm-unit-tests) down to 720-1100 clock cycles on
a Sandy Bridge Xeon host, compared to 2300-3200 before the whole series
and 925-1700 after the first two low-hanging fruit changes.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 905edf8557e7..f750b69ca443 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4085,7 +4085,8 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 
 		if (gpa == UNMAPPED_GVA)
 			return X86EMUL_PROPAGATE_FAULT;
-		ret = kvm_read_guest(vcpu->kvm, gpa, data, toread);
+		ret = kvm_read_guest_page(vcpu->kvm, gpa >> PAGE_SHIFT, data,
+					  offset, toread);
 		if (ret < 0) {
 			r = X86EMUL_IO_NEEDED;
 			goto out;
@@ -4106,10 +4107,24 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+	unsigned offset;
+	int ret;
 
-	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu,
-					  access | PFERR_FETCH_MASK,
-					  exception);
+	/* Inline kvm_read_guest_virt_helper for speed.  */
+	gpa_t gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr, access|PFERR_FETCH_MASK,
+						    exception);
+	if (unlikely(gpa == UNMAPPED_GVA))
+		return X86EMUL_PROPAGATE_FAULT;
+
+	offset = addr & (PAGE_SIZE-1);
+	if (WARN_ON(offset + bytes > PAGE_SIZE))
+		bytes = (unsigned)PAGE_SIZE - offset;
+	ret = kvm_read_guest_page(vcpu->kvm, gpa >> PAGE_SHIFT, val,
+				  offset, bytes);
+	if (unlikely(ret < 0))
+		return X86EMUL_IO_NEEDED;
+
+	return X86EMUL_CONTINUE;
 }
 
 int kvm_read_guest_virt(struct x86_emulate_ctxt *ctxt,
-- 
1.8.3.1

