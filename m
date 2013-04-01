Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab3DAJ5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:57:22 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:46785 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab3DAJ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:57:18 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 6/6] KVM: MMU: init kvm generation close to mmio wrap-around value
Date: Mon,  1 Apr 2013 17:56:49 +0800
Message-Id: <1364810209-25954-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040109-2000-0000-0000-00000B90A924
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then it has chance to trigger mmio generation number wrap-around

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    8 ++++++++
 virt/kvm/kvm_main.c             |    6 ++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6c1e642..4e1f7cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -767,6 +767,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
 				     gfn_t gfn_offset, unsigned long mask);
 void kvm_mmu_zap_all(struct kvm *kvm);
+void kvm_arch_init_generation(struct kvm *kvm);
 void kvm_mmu_invalid_mmio_sptes(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d314e21..dcc059c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4279,6 +4279,14 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
+void kvm_arch_init_generation(struct kvm *kvm)
+{
+	mutex_lock(&kvm->slots_lock);
+	/* It is easier to trigger mmio generation-number wrap-around. */
+	kvm_memslots(kvm)->generation = MMIO_MAX_GEN - 13;
+	mutex_unlock(&kvm->slots_lock);
+}
+
 void kvm_mmu_invalid_mmio_sptes(struct kvm *kvm)
 {
 	/*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff71541..d21694a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -459,6 +459,10 @@ static void kvm_init_memslots_id(struct kvm *kvm)
 		slots->id_to_index[i] = slots->memslots[i].id = i;
 }
 
+void __attribute__((weak)) kvm_arch_init_generation(struct kvm *kvm)
+{
+}
+
 static struct kvm *kvm_create_vm(unsigned long type)
 {
 	int r, i;
@@ -505,6 +509,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->slots_lock);
 	atomic_set(&kvm->users_count, 1);
 
+	kvm_arch_init_generation(kvm);
+
 	r = kvm_init_mmu_notifier(kvm);
 	if (r)
 		goto out_err;
-- 
1.7.7.6

