Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbaLLP0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:26:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:6440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759876AbaLLP03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:26:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807599"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 22/26] KVM: Define a wakeup worker thread for vCPU
Date: Fri, 12 Dec 2014 23:14:56 +0800
Message-Id: <1418397300-10870-23-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a wakeup worker thread for a vCPU.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ca9a393..3d7242c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -249,6 +249,7 @@ struct kvm_vcpu {
 	int sigset_active;
 	sigset_t sigset;
 	struct kvm_vcpu_stat stat;
+	struct work_struct wakeup_worker;
 
 #ifdef CONFIG_HAS_IOMEM
 	int mmio_needed;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25ffac9..ba53fd6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -211,6 +211,13 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
 
+static void wakeup_thread(struct work_struct *work)
+{
+	struct kvm_vcpu *vcpu = container_of(work, struct kvm_vcpu,
+				wakeup_worker);
+	kvm_vcpu_kick(vcpu);
+}
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	struct page *page;
@@ -224,6 +231,8 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	init_waitqueue_head(&vcpu->wq);
 	kvm_async_pf_vcpu_init(vcpu);
 
+	INIT_WORK(&vcpu->wakeup_worker, wakeup_thread);
+
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page) {
 		r = -ENOMEM;
-- 
1.9.1

