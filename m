Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3GJNBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:01:24 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:54542 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3GJNAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:00:08 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Alexander Graf <agraf@suse.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 3/4] PF: Provide additional direct page notification
Date: Wed, 10 Jul 2013 14:59:54 +0200
Message-Id: <1373461195-27628-4-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1373461195-27628-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1373461195-27628-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071012-6892-0000-0000-000005A56F2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By setting a Kconfig option, the architecture can control when
guest notifications will be presented by the apf backend.
So there is the default batch mechanism, working as before, where the vcpu thread
should pull in this information. On the other hand there is now the direct
mechanism, this will directly push the information to the guest.
This way s390 can use an already existing architecture interface.

Still the vcpu thread should call check_completion to cleanup leftovers,
that leaves most of the common code untouched.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/x86/kvm/mmu.c       |  2 +-
 include/linux/kvm_host.h |  2 +-
 virt/kvm/Kconfig         |  4 ++++
 virt/kvm/async_pf.c      | 22 +++++++++++++++++++---
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0d094da..b8632e9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3343,7 +3343,7 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
 	arch.direct_map = vcpu->arch.mmu.direct_map;
 	arch.cr3 = vcpu->arch.mmu.get_cr3(vcpu);
 
-	return kvm_setup_async_pf(vcpu, gva, gfn, &arch);
+	return kvm_setup_async_pf(vcpu, gva, gfn_to_hva(vcpu->kvm, gfn), &arch);
 }
 
 static bool can_do_async_pf(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 92e8f64..fe87e46 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -191,7 +191,7 @@ struct kvm_async_pf {
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
-int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
+int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, unsigned long hva,
 		       struct kvm_arch_async_pf *arch);
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 779262f..0774495 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -22,6 +22,10 @@ config KVM_MMIO
 config KVM_ASYNC_PF
        bool
 
+# Toggle to switch between direct notification and batch job
+config KVM_ASYNC_PF_SYNC
+       bool
+
 config HAVE_KVM_MSI
        bool
 
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index ea475cd..cfa9366 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -28,6 +28,21 @@
 #include "async_pf.h"
 #include <trace/events/kvm.h>
 
+static inline void kvm_async_page_present_sync(struct kvm_vcpu *vcpu,
+					       struct kvm_async_pf *work)
+{
+#ifdef CONFIG_KVM_ASYNC_PF_SYNC
+	kvm_arch_async_page_present(vcpu, work);
+#endif
+}
+static inline void kvm_async_page_present_async(struct kvm_vcpu *vcpu,
+						struct kvm_async_pf *work)
+{
+#ifndef CONFIG_KVM_ASYNC_PF_SYNC
+	kvm_arch_async_page_present(vcpu, work);
+#endif
+}
+
 static struct kmem_cache *async_pf_cache;
 
 int kvm_async_pf_init(void)
@@ -70,6 +85,7 @@ static void async_pf_execute(struct work_struct *work)
 	down_read(&mm->mmap_sem);
 	get_user_pages(current, mm, addr, 1, 1, 0, &page, NULL);
 	up_read(&mm->mmap_sem);
+	kvm_async_page_present_sync(vcpu, apf);
 	unuse_mm(mm);
 
 	spin_lock(&vcpu->async_pf.lock);
@@ -134,7 +150,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 
 		if (work->page)
 			kvm_arch_async_page_ready(vcpu, work);
-		kvm_arch_async_page_present(vcpu, work);
+		kvm_async_page_present_async(vcpu, work);
 
 		list_del(&work->queue);
 		vcpu->async_pf.queued--;
@@ -144,7 +160,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 	}
 }
 
-int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
+int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, unsigned long hva,
 		       struct kvm_arch_async_pf *arch)
 {
 	struct kvm_async_pf *work;
@@ -166,7 +182,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	work->done = false;
 	work->vcpu = vcpu;
 	work->gva = gva;
-	work->addr = gfn_to_hva(vcpu->kvm, gfn);
+	work->addr = hva;
 	work->arch = *arch;
 	work->mm = current->mm;
 	atomic_inc(&work->mm->mm_count);
-- 
1.8.2.2

