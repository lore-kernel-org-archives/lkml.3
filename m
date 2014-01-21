Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaAUTFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:05:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:38081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaAUTFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:05:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208,223";a="470270768"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
Subject: [PATCH v3 4/4] KVM/X86: Enable Intel MPX for guest
Thread-Topic: [PATCH v3 4/4] KVM/X86: Enable Intel MPX for guest
Thread-Index: Ac8W262ptZY/EYu/RluA4aAR04+ltw==
Date: Tue, 21 Jan 2014 19:04:58 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350149E363@SHSMSX101.ccr.corp.intel.com>
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

>From c2b3b4347b4c8b0aa6b5e97c161fd4d34b0ef4d3 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Fri, 13 Dec 2013 02:34:48 +0800
Subject: [PATCH v3 4/4] KVM/X86: Enable Intel MPX for guest.

This patch enable Intel MPX feature to guest.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kvm/cpuid.c |    2 +-
 arch/x86/kvm/x86.c   |    3 +++
 arch/x86/kvm/x86.h   |    3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2d661e6..e30d4ce 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -303,7 +303,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	/* cpuid 7.0.ebx */
 	const u32 kvm_supported_word9_x86_features =
 		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | f_invpcid | F(RTM);
+		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(MPX);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ca2269..410421a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -597,6 +597,9 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	if (xcr0 & ~valid_bits)
 		return 1;
 
+	if ((!(xcr0 & XSTATE_BNDREGS)) != (!(xcr0 & XSTATE_BNDCSR)))
+		return 1;
+
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->arch.xcr0 = xcr0;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 587fb9e..985e40e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -122,7 +122,8 @@ int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
 	gva_t addr, void *val, unsigned int bytes,
 	struct x86_exception *exception);
 
-#define KVM_SUPPORTED_XCR0	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define KVM_SUPPORTED_XCR0	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM \
+				| XSTATE_BNDREGS | XSTATE_BNDCSR)
 extern u64 host_xcr0;
 
 extern struct static_key kvm_no_apic_vcpu;
-- 
1.7.1
