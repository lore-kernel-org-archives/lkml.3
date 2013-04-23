Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3DWWTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:19:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab3DWVwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:52:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>
Subject: [ 02/42] kvm/powerpc/e500mc: fix tlb invalidation on cpu migration
Date: Tue, 23 Apr 2013 14:52:00 -0700
Message-Id: <20130423215205.812693825@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Wood <scottwood@freescale.com>

commit c5e6cb051c5f7d56f05bd6a4af22cb300a4ced79 upstream.

The existing check handles the case where we've migrated to a different
core than we last ran on, but it doesn't handle the case where we're
still on the same cpu we last ran on, but some other vcpu has run on
this cpu in the meantime.

Without this, guest segfaults (and other misbehavior) have been seen in
smp guests.

Signed-off-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/e500mc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -108,6 +108,8 @@ void kvmppc_mmu_msr_notify(struct kvm_vc
 {
 }
 
+static DEFINE_PER_CPU(struct kvm_vcpu *, last_vcpu_on_cpu);
+
 void kvmppc_core_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
@@ -136,8 +138,11 @@ void kvmppc_core_vcpu_load(struct kvm_vc
 	mtspr(SPRN_GDEAR, vcpu->arch.shared->dar);
 	mtspr(SPRN_GESR, vcpu->arch.shared->esr);
 
-	if (vcpu->arch.oldpir != mfspr(SPRN_PIR))
+	if (vcpu->arch.oldpir != mfspr(SPRN_PIR) ||
+	    __get_cpu_var(last_vcpu_on_cpu) != vcpu) {
 		kvmppc_e500_tlbil_all(vcpu_e500);
+		__get_cpu_var(last_vcpu_on_cpu) = vcpu;
+	}
 
 	kvmppc_load_guest_fp(vcpu);
 }


