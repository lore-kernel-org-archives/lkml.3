Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaBZPuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:50:22 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:48018 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBZPtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:49:31 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org, jan.kiszka@siemens.com
Subject: [PATCH 2/4] KVM: x86: change vcpu->arch.switch_db_regs to a bit mask
Date: Wed, 26 Feb 2014 16:49:11 +0100
Message-Id: <1393429753-20857-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393429753-20857-1-git-send-email-pbonzini@redhat.com>
References: <1393429753-20857-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next patch will add another bit that we can test with the
same "if".

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 6 +++++-
 arch/x86/kvm/x86.c              | 6 ++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e714f8c08ccf..6b3b067f4780 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -337,6 +337,10 @@ struct kvm_pmu {
 	u64 reprogram_pmi;
 };
 
+enum {
+	KVM_DEBUGREG_BP_ENABLED = 1,
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -463,7 +467,7 @@ struct kvm_vcpu_arch {
 	struct mtrr_state_type mtrr_state;
 	u32 pat;
 
-	int switch_db_regs;
+	unsigned switch_db_regs;
 	unsigned long db[KVM_NR_DB_REGS];
 	unsigned long dr6;
 	unsigned long dr7;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 109985016389..c01dddce6df0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -759,7 +759,9 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
 	else
 		dr7 = vcpu->arch.dr7;
 	kvm_x86_ops->set_dr7(vcpu, dr7);
-	vcpu->arch.switch_db_regs = (dr7 & DR7_BP_EN_MASK);
+	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_BP_ENABLED;
+	if (dr7 & DR7_BP_EN_MASK)
+		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
 }
 
 static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
-- 
1.8.3.1


