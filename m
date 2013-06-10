Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3FJMED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:04:03 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:47428 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3FJMD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:03:59 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 3/4] PF: Additional flag for direct page fault inject
Date: Mon, 10 Jun 2013 14:03:47 +0200
Message-Id: <1370865828-2053-4-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.6
In-Reply-To: <1370865828-2053-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1370865828-2053-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061012-4966-0000-0000-000005F9C587
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some architectures, as on s390x we may want to be able to directly inject
notifications to the guest in case of a swapped in page. Also on s390x
there is no need to go from gfn to hva as by calling gmap_fault we already
have the needed address.

Due to a possible race, we now always have to insert the page to the queue.
So if we are not able to schedule the async page, we have to remove it from
the list again. As this is only when we also have to page in synchronously,
the overhead is not really important.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c       |  2 +-
 include/linux/kvm_host.h |  3 ++-
 virt/kvm/async_pf.c      | 33 +++++++++++++++++++++++++++------
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 956ca35..02a49a9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3223,7 +3223,7 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
 	arch.direct_map = vcpu->arch.mmu.direct_map;
 	arch.cr3 = vcpu->arch.mmu.get_cr3(vcpu);
 
-	return kvm_setup_async_pf(vcpu, gva, gfn, &arch);
+	return kvm_setup_async_pf(vcpu, gva, gfn, &arch, false);
 }
 
 static bool can_do_async_pf(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9bd29ef..a798deb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -165,12 +165,13 @@ struct kvm_async_pf {
 	struct kvm_arch_async_pf arch;
 	struct page *page;
 	bool done;
+	bool direct_inject;
 };
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
 int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
-		       struct kvm_arch_async_pf *arch);
+		       struct kvm_arch_async_pf *arch, bool is_direct);
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index ea475cd..a4a6483 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -73,9 +73,17 @@ static void async_pf_execute(struct work_struct *work)
 	unuse_mm(mm);
 
 	spin_lock(&vcpu->async_pf.lock);
-	list_add_tail(&apf->link, &vcpu->async_pf.done);
 	apf->page = page;
 	apf->done = true;
+	if (apf->direct_inject) {
+		kvm_arch_async_page_present(vcpu, apf);
+		list_del(&apf->queue);
+		vcpu->async_pf.queued--;
+		kvm_release_page_clean(apf->page);
+		kmem_cache_free(async_pf_cache, apf);
+	} else {
+		list_add_tail(&apf->link, &vcpu->async_pf.done);
+	}
 	spin_unlock(&vcpu->async_pf.lock);
 
 	/*
@@ -145,7 +153,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 }
 
 int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
-		       struct kvm_arch_async_pf *arch)
+		       struct kvm_arch_async_pf *arch, bool is_direct)
 {
 	struct kvm_async_pf *work;
 
@@ -165,13 +173,24 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	work->page = NULL;
 	work->done = false;
 	work->vcpu = vcpu;
-	work->gva = gva;
-	work->addr = gfn_to_hva(vcpu->kvm, gfn);
+	if (gfn == -1) {
+		work->gva = -1;
+		work->addr = gva;
+	} else {
+		work->gva = gva;
+		work->addr = gfn_to_hva(vcpu->kvm, gfn);
+	}
+	work->direct_inject = is_direct;
 	work->arch = *arch;
 	work->mm = current->mm;
 	atomic_inc(&work->mm->mm_count);
 	kvm_get_kvm(work->vcpu->kvm);
 
+	spin_lock(&vcpu->async_pf.lock);
+	list_add_tail(&work->queue, &vcpu->async_pf.queue);
+	vcpu->async_pf.queued++;
+	spin_unlock(&vcpu->async_pf.lock);
+
 	/* this can't really happen otherwise gfn_to_pfn_async
 	   would succeed */
 	if (unlikely(kvm_is_error_hva(work->addr)))
@@ -181,11 +200,13 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	if (!schedule_work(&work->work))
 		goto retry_sync;
 
-	list_add_tail(&work->queue, &vcpu->async_pf.queue);
-	vcpu->async_pf.queued++;
 	kvm_arch_async_page_not_present(vcpu, work);
 	return 1;
 retry_sync:
+	spin_lock(&vcpu->async_pf.lock);
+	list_del(&work->queue);
+	vcpu->async_pf.queued--;
+	spin_unlock(&vcpu->async_pf.lock);
 	kvm_put_kvm(work->vcpu->kvm);
 	mmdrop(work->mm);
 	kmem_cache_free(async_pf_cache, work);
-- 
1.8.1.6

