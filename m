Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaGCCEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:04:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:51130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbaGCCER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:04:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,592,1400050800"; 
   d="scan'208";a="567593305"
From: kan.liang@intel.com
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, andi@firstfloor.org,
        Kan Liang <kan.liang@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH V2 3/3] kvm: ignore LBR and offcore rsp
Date: Wed,  2 Jul 2014 11:14:15 -0700
Message-Id: <1404324855-15166-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

With -cpu host KVM reports LBR and offcore support, so the perf driver may accesses the LBR and offcore MSRs.
However, there is no LBR and offcore virtualization support yet. This could causes guest to crash.
As a workaround, KVM just simply ignore the LBR and offcore_rsp MSRs to lie the guest.

For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL = y.
And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n.
Start the guest with -cpu host.
Run perf record with --branch-any or --branch-filter in guest to trigger LBR #GP.
Run perf stat offcore events (E.g. LLC-loads/LLC-load-misses ...) in guest to trigger offcore_rsp #GP

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kvm/pmu.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cbecaa9..ad9b4fa 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -331,6 +331,15 @@ bool kvm_pmu_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_OFFCORE_RSP_0:
+	case MSR_OFFCORE_RSP_1:
+	/* At most 8-deep LBR for core and atom */
+	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 7:
+	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 7:
+	/* 16-deep LBR for core i3/i5/i7 series processors */
+	case MSR_LBR_NHM_FROM ... MSR_LBR_NHM_FROM + 15:
+	case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 15:
+		return 1; /* to avoid crashes */
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)
 			|| get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0)
@@ -358,6 +367,16 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		*data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_OFFCORE_RSP_0:
+	case MSR_OFFCORE_RSP_1:
+	/* At most 8-deep LBR for core and atom */
+	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 7:
+	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 7:
+	/* 16-deep LBR for core i3/i5/i7 series processors */
+	case MSR_LBR_NHM_FROM ... MSR_LBR_NHM_FROM + 15:
+	case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 15:
+		*data = 0;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, index, MSR_IA32_PERFCTR0)) ||
 				(pmc = get_fixed_pmc(pmu, index))) {
@@ -409,6 +428,16 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_OFFCORE_RSP_0:
+	case MSR_OFFCORE_RSP_1:
+	/* At most 8-deep LBR for core and atom */
+	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 7:
+	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 7:
+	/* 16-deep LBR for core i3/i5/i7 series processors */
+	case MSR_LBR_NHM_FROM ... MSR_LBR_NHM_FROM + 15:
+	case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 15:
+		/* dummy for now */
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, index, MSR_IA32_PERFCTR0)) ||
 				(pmc = get_fixed_pmc(pmu, index))) {
-- 
1.8.3.1

