Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaIKFhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 01:37:12 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:12448 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752362AbaIKFhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 01:37:08 -0400
X-IronPort-AV: E=Sophos;i="5.04,504,1406563200"; 
   d="scan'208";a="35792882"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: [PATCH v5 5/7] kvm, mem-hotplug: Reload L1's apic access page on migration when L2 is running.
Date: Thu, 11 Sep 2014 13:38:04 +0800
Message-ID: <1410413886-32213-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch only handle "L1 and L2 vm share one apic access page" situation.

When L1 vm is running, if the shared apic access page is migrated, mmu_notifier will
request all vcpus to exit to L0, and reload apic access page physical address for
all the vcpus' vmcs (which is done by patch 5/6). And when it enters L2 vm, L2's vmcs
will be updated in prepare_vmcs02() called by nested_vm_run(). So we need to do
nothing.

When L2 vm is running, if the shared apic access page is migrated, mmu_notifier will
request all vcpus to exit to L0, and reload apic access page physical address for
all L2 vmcs. And this patch requests apic access page reload in L2->L1 vmexit.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c  | 7 +++++++
 virt/kvm/kvm_main.c | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index da6d55d..e7704b2 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8796,6 +8796,13 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	}
 
 	/*
+	 * Do not call kvm_reload_apic_access_page() because we are now
+	 * running, mmu_notifier will force to reload the page's hpa for L2
+	 * vmcs. Need to reload it for L1 before entering L1.
+	 */
+	kvm_reload_apic_access_page(vcpu->kvm);
+
+	/*
 	 * Exiting from L2 to L1, we're now back to L1 which thinks it just
 	 * finished a VMLAUNCH or VMRESUME instruction, so we need to set the
 	 * success or failure flag accordingly.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d8280de..784127e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -214,6 +214,7 @@ void kvm_reload_apic_access_page(struct kvm *kvm)
 {
 	make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 }
+EXPORT_SYMBOL_GPL(kvm_reload_apic_access_page);
 
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
-- 
1.8.3.1

