Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaIDRpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:45:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbaIDRpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:45:06 -0400
Message-ID: <5408A513.6090603@redhat.com>
Date: Thu, 04 Sep 2014 19:44:51 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Gleb Natapov <gleb@cloudius-systems.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jroedel@suse.de, agraf@suse.de,
        valentine.sinitsyn@gmail.com, jan.kiszka@siemens.com,
        avi@cloudius-systems.com
Subject: Re: [PATCH 3/4] KVM: x86: inject nested page faults on emulated instructions
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com> <1409670830-14544-4-git-send-email-pbonzini@redhat.com> <20140904070220.GL9842@cloudius-systems.com> <54087343.5050409@redhat.com> <20140904150500.GA25317@minantech.com>
In-Reply-To: <20140904150500.GA25317@minantech.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/09/2014 17:05, Gleb Natapov ha scritto:
>> > 
>> > If you do that, KVM gets down to the "if (writeback)" and writes the 
>> > ctxt->eip from L2 into the L1 EIP.
> Heh, that's a bummer. We should not write back if an instruction caused a vmexit.
> 

You're right, that works.

Paolo

-------------- 8< -------------
Subject: [PATCH] KVM: x86: skip writeback on injection of nested exception

If a nested page fault happens during emulation, we will inject a vmexit,
not a page fault.  However because writeback happens after the injection,
we will write ctxt->eip from L2 into the L1 EIP.  We do not write back
if an instruction caused an interception vmexit---do the same for page
faults.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/x86.c              | 15 ++++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 08cc299..c989651 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -893,7 +893,6 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gfn_t gfn, void *data, int offset, int len,
 			    u32 access);
-void kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
 static inline int __kvm_irq_line_state(unsigned long *irq_state,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e4ed85e..3541946 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -408,12 +408,14 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 
-void kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
+static bool kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 {
 	if (mmu_is_nested(vcpu) && !fault->nested_page_fault)
 		vcpu->arch.nested_mmu.inject_page_fault(vcpu, fault);
 	else
 		vcpu->arch.mmu.inject_page_fault(vcpu, fault);
+
+	return fault->nested_page_fault;
 }
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
@@ -4929,16 +4931,18 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 	}
 }
 
-static void inject_emulated_exception(struct kvm_vcpu *vcpu)
+static bool inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	if (ctxt->exception.vector == PF_VECTOR)
-		kvm_propagate_fault(vcpu, &ctxt->exception);
-	else if (ctxt->exception.error_code_valid)
+		return kvm_propagate_fault(vcpu, &ctxt->exception);
+
+	if (ctxt->exception.error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception.vector,
 				      ctxt->exception.error_code);
 	else
 		kvm_queue_exception(vcpu, ctxt->exception.vector);
+	return false;
 }
 
 static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
@@ -5300,8 +5304,9 @@ restart:
 	}
 
 	if (ctxt->have_exception) {
-		inject_emulated_exception(vcpu);
 		r = EMULATE_DONE;
+		if (inject_emulated_exception(vcpu))
+			return r;
 	} else if (vcpu->arch.pio.count) {
 		if (!vcpu->arch.pio.in) {
 			/* FIXME: return into emulator if single-stepping.  */
-- 
1.9.3


