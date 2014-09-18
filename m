Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbaIRQkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:40:11 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:48521 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaIRQkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:40:07 -0400
From: Liang Chen <liangchen.linux@gmail.com>
To: pbonzini@redhat.com
Cc: rkrcmar@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH v3 1/2] KVM: x86: count actual tlb flushes
Date: Thu, 18 Sep 2014 12:38:36 -0400
Message-Id: <1411058317-23646-2-git-send-email-liangchen.linux@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411058317-23646-1-git-send-email-liangchen.linux@gmail.com>
References: <1411058317-23646-1-git-send-email-liangchen.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Radim Krčmář <rkrcmar@redhat.com>

- we count KVM_REQ_TLB_FLUSH requests, not actual flushes
  (KVM can have multiple requests for one flush)
- flushes from kvm_flush_remote_tlbs aren't counted
- it's easy to make a direct request by mistake

Solve these by postponing the counting to kvm_check_request().

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 arch/x86/kvm/mmu.c | 1 -
 arch/x86/kvm/x86.c | 4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9314678..b41fd97 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3452,7 +3452,6 @@ static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 
 void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.tlb_flush;
 	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_flush_tlb);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f1e22d..9eb5458 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6017,8 +6017,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
 			kvm_mmu_sync_roots(vcpu);
-		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
+			++vcpu->stat.tlb_flush;
 			kvm_x86_ops->tlb_flush(vcpu);
+		}
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
 			r = 0;
-- 
1.9.1

