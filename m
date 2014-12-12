Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030540AbaLLP0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:26:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:15465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030503AbaLLPZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:25:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807414"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 15/26] KVM: add interfaces to control PI outside vmx
Date: Fri, 12 Dec 2014 23:14:49 +0800
Message-Id: <1418397300-10870-16-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pi_clear_sn and pi_set_sn to struct kvm_x86_ops,
so we can set/clear SN outside vmx.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/vmx.c              | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9b45b78..cd4b174 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -773,6 +773,9 @@ struct kvm_x86_ops {
 
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
 	u64 (*get_pi_desc_addr)(struct kvm_vcpu *vcpu);
+
+	void (*pi_clear_sn)(struct kvm_vcpu *vcpu);
+	void (*pi_set_sn)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 81f239b..ee3b735 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -567,6 +567,16 @@ struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
+static void vmx_pi_clear_sn(struct kvm_vcpu *vcpu)
+{
+	pi_clear_sn(vcpu_to_pi_desc(vcpu));
+}
+
+static void vmx_pi_set_sn(struct kvm_vcpu *vcpu)
+{
+	pi_set_sn(vcpu_to_pi_desc(vcpu));
+}
+
 #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
 #define FIELD(number, name)	[number] = VMCS12_OFFSET(name)
 #define FIELD64(number, name)	[number] = VMCS12_OFFSET(name), \
@@ -9256,6 +9266,9 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.sched_in = vmx_sched_in,
 
 	.get_pi_desc_addr = vmx_get_pi_desc_addr,
+
+	.pi_clear_sn = vmx_pi_clear_sn,
+	.pi_set_sn = vmx_pi_set_sn,
 };
 
 static int __init vmx_init(void)
-- 
1.9.1

