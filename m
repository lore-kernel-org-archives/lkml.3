Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaAUTDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:03:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:34724 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaAUTDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:03:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208,223";a="462415903"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
Subject: [PATCH v3 3/4] KVM/X86: add MSR_IA32_BNDCFGS to msrs_to_save
Thread-Topic: [PATCH v3 3/4] KVM/X86: add MSR_IA32_BNDCFGS to msrs_to_save
Thread-Index: Ac8W23wwbfT8NENpQ26YAT4TyNOmOQ==
Date: Tue, 21 Jan 2014 19:03:36 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350149E349@SHSMSX101.ccr.corp.intel.com>
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

>From d1992769911f34cb319fe638d32ae604bd2a6ce8 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Fri, 13 Dec 2013 02:33:08 +0800
Subject: [PATCH v3 3/4] KVM/X86: add MSR_IA32_BNDCFGS to msrs_to_save

Add MSR_IA32_BNDCFGS to msrs_to_save, and corresponding logic
to kvm_get/set_msr().

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/include/asm/vmx.h |    2 ++
 arch/x86/kvm/vmx.c         |    6 ++++++
 arch/x86/kvm/x86.c         |    2 +-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 1bf4681..47b4c88 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -175,6 +175,8 @@ enum vmcs_field {
 	GUEST_PDPTR2_HIGH               = 0x0000280f,
 	GUEST_PDPTR3                    = 0x00002810,
 	GUEST_PDPTR3_HIGH               = 0x00002811,
+	GUEST_BNDCFGS                   = 0x00002812,
+	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6d7d9ad..a6a7556 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2465,6 +2465,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 	case MSR_IA32_SYSENTER_ESP:
 		data = vmcs_readl(GUEST_SYSENTER_ESP);
 		break;
+	case MSR_IA32_BNDCFGS:
+		data = vmcs_readl(GUEST_BNDCFGS);
+		break;
 	case MSR_TSC_AUX:
 		if (!to_vmx(vcpu)->rdtscp_enabled)
 			return 1;
@@ -2524,6 +2527,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_SYSENTER_ESP:
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
+	case MSR_IA32_BNDCFGS:
+		vmcs_writel(GUEST_BNDCFGS, data);
+		break;
 	case MSR_IA32_TSC:
 		kvm_write_tsc(vcpu, msr_info);
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1657ca2..8ca2269 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -852,7 +852,7 @@ static u32 msrs_to_save[] = {
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
 	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
-	MSR_IA32_FEATURE_CONTROL
+	MSR_IA32_FEATURE_CONTROL, MSR_IA32_BNDCFGS
 };
 
 static unsigned num_msrs_to_save;
-- 
1.7.1
