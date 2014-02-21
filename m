Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbaBUR53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:57:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:8960 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262AbaBUR5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:57:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,520,1389772800"; 
   d="scan'208,223";a="479267464"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: [PATCH v4 3/3] KVM: x86: Enable Intel MPX for guest
Thread-Topic: [PATCH v4 3/3] KVM: x86: Enable Intel MPX for guest
Thread-Index: Ac8vLlqhffa0mA48RJ+9cL55JkIR2w==
Date: Fri, 21 Feb 2014 17:57:15 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233501509C2B@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8b3a3b1f08c166e0c2cdc6162e6fa95d9c7ad2ec Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Sat, 22 Feb 2014 08:53:27 +0800
Subject: [PATCH v4 3/3] KVM: x86: Enable Intel MPX for guest

This patch enable Intel MPX feature to guest.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kvm/cpuid.c |    2 +-
 arch/x86/kvm/x86.c   |    6 ++++++
 arch/x86/kvm/x86.h   |    3 ++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b241325..b377d83 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -303,7 +303,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	/* cpuid 7.0.ebx */
 	const u32 kvm_supported_word9_x86_features =
 		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(RDSEED) |
+		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(MPX) | F(RDSEED) |
 		F(ADX);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 89e4e27..3570e71 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -599,6 +599,9 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	u64 old_xcr0 = vcpu->arch.xcr0;
 	u64 valid_bits;
 
+	if (!kvm_x86_ops->mpx_supported || !kvm_x86_ops->mpx_supported())
+		xcr0 &= ~(XSTATE_BNDREGS | XSTATE_BNDCSR);
+
 	/* Only support XCR_XFEATURE_ENABLED_MASK(xcr0) now  */
 	if (index != XCR_XFEATURE_ENABLED_MASK)
 		return 1;
@@ -616,6 +619,9 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	if (xcr0 & ~valid_bits)
 		return 1;
 
+	if ((!(xcr0 & XSTATE_BNDREGS)) != (!(xcr0 & XSTATE_BNDCSR)))
+		return 1;
+
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->arch.xcr0 = xcr0;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 8da5823..392ecbf 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -122,7 +122,8 @@ int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
 	gva_t addr, void *val, unsigned int bytes,
 	struct x86_exception *exception);
 
-#define KVM_SUPPORTED_XCR0	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define KVM_SUPPORTED_XCR0     (XSTATE_FP | XSTATE_SSE | XSTATE_YMM \
+				| XSTATE_BNDREGS | XSTATE_BNDCSR)
 extern u64 host_xcr0;
 
 extern unsigned int min_timer_period_us;
-- 
1.7.1
