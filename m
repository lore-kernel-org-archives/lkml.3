Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaIPLik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:38:40 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59220 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaIPLij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:38:39 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] kvm: Make init_rmode_tss() return 0 on success.
Date: Tue, 16 Sep 2014 13:38:25 +0200
Message-Id: <1410867505-5941-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In init_rmode_tss(), there two variables indicating the return
value, r and ret, and it return 0 on error, 1 on success. The function
is only called by vmx_set_tss_addr(), and r is redundant.

This patch removes the redundant variable, by making init_rmode_tss()
return 0 on success, -errno on failure.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 41bbddb..1e6b493 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3930,7 +3930,7 @@ static int init_rmode_tss(struct kvm *kvm)
 {
 	gfn_t fn;
 	u16 data = 0;
-	int r, idx, ret = 0;
+	int idx, r;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	fn = kvm->arch.tss_addr >> PAGE_SHIFT;
@@ -3952,13 +3952,9 @@ static int init_rmode_tss(struct kvm *kvm)
 	r = kvm_write_guest_page(kvm, fn, &data,
 				 RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
 				 sizeof(u8));
-	if (r < 0)
-		goto out;
-
-	ret = 1;
 out:
 	srcu_read_unlock(&kvm->srcu, idx);
-	return ret;
+	return r;
 }
 
 static int init_rmode_identity_map(struct kvm *kvm)
@@ -4750,10 +4746,7 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 	if (ret)
 		return ret;
 	kvm->arch.tss_addr = addr;
-	if (!init_rmode_tss(kvm))
-		return  -ENOMEM;
-
-	return 0;
+	return init_rmode_tss(kvm);
 }
 
 static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
-- 
1.7.1

