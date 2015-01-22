Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbbAVIwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:52:21 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40756 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbbAVIwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:52:13 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoffer Dall <cdall@cs.columbia.edu>,
        "linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Wei Huang <wei@redhat.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the arm64 tree
In-Reply-To: <20150122160704.5ad5aeb9@canb.auug.org.au> (Stephen Rothwell's
	message of "Thu, 22 Jan 2015 05:07:04 +0000")
Organization: ARM Ltd
References: <20150122160704.5ad5aeb9@canb.auug.org.au>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
Date: Thu, 22 Jan 2015 08:51:54 +0000
Message-ID: <87r3unfb9x.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22 2015 at  5:07:04 am GMT, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

Hi Stephen,

> Today's linux-next merge of the kvm-arm tree got a conflict in
> arch/arm64/include/asm/kvm_arm.h between commit 6e53031ed840 ("arm64:
> kvm: remove ESR_EL2_* macros") from the arm64 tree and commit
> 0d97f8848104 ("arm/arm64: KVM: add tracing support for arm64 exit
> handler") from the kvm-arm tree.
>
> I fixed it up (see below, but this probably requires more work) and can
> carry the fix as necessary (no action is required).

Thanks for dealing with this. I think the following patch should be
applied on top of your resolution, making the new macro part of the
asm/esr.h file.

Mark, Wei: does it match your expectations?

Thanks,

	M.

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 6216709..92bbae3 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -96,6 +96,7 @@
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
+#define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
 
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 53fbc1e..94674eb 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -192,6 +192,4 @@
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
 
-#define ESR_EL2_HVC_IMM_MASK	((1UL << 16) - 1)
-
 #endif /* __ARM64_KVM_ARM_H__ */
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b861ff6..bbc17cd 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -133,7 +133,7 @@ static inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
 
 static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
 {
-	return kvm_vcpu_get_hsr(vcpu) & ESR_EL2_HVC_IMM_MASK;
+	return kvm_vcpu_get_hsr(vcpu) & ESR_ELx_xVC_IMM_MASK;
 }
 
 static inline bool kvm_vcpu_dabt_isvalid(const struct kvm_vcpu *vcpu)

-- 
Jazz is not dead. It just smells funny.
