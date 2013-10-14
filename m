Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3JNOZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:25:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10168 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab3JNOZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:25:21 -0400
X-IronPort-AV: E=Sophos;i="4.93,492,1378828800"; 
   d="scan'208";a="8752306"
From: chai wen <chaiw.fnst@cn.fujitsu.com>
To: gleb@redhat.com
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com, tangchen@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, chaiwen_0825@hotmail.com,
        chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: [PATCH RESEND] Drop-FOLL_GET-in-GUP-when-doing-async_pf-in-kvm
Date: Mon, 14 Oct 2013 22:22:33 +0800
Message-Id: <1381760553-11075-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/14 22:23:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/14 22:23:03,
	Serialize complete at 2013/10/14 22:23:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Gleb

I am sorry for my mistake before.
This new patch is based on 'git://git.kernel.org/pub/scm/virt/kvm/kvm.git'.
Page pinning is not mandatory in kvm async_pf processing and probably
should be dropped later. And we don't mind whether the GUP is failed or
not. What we need to do is to wake up guests process that is waitting on
a page. So drop the FOLL_GET flag in GUP, and do some simplifying in
async_pf check/clear processing.
To trigger the happening of async_pf, it needs some memory stress in system
for doing swap pressure. I simply run some big block dd processes in system
before. And it works as I see some async_pf happening and the vm works well.
But I do not know the exact occasion of the async_pf happening.
Thanks.

Suggested-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Gu zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c         |    4 ++--
 include/linux/kvm_host.h   |    2 +-
 include/trace/events/kvm.h |   10 ++++------
 virt/kvm/async_pf.c        |   17 +++++------------
 4 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c951c71..edf2a07 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7298,7 +7298,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	int r;
 
 	if ((vcpu->arch.mmu.direct_map != work->arch.direct_map) ||
-	      is_error_page(work->page))
+	      work->wakeup_all)
 		return;
 
 	r = kvm_mmu_reload(vcpu);
@@ -7408,7 +7408,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	struct x86_exception fault;
 
 	trace_kvm_async_pf_ready(work->arch.token, work->gva);
-	if (is_error_page(work->page))
+	if (work->wakeup_all)
 		work->arch.token = ~0; /* broadcast wakeup */
 	else
 		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7c961e1..5841e14 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -189,7 +189,7 @@ struct kvm_async_pf {
 	gva_t gva;
 	unsigned long addr;
 	struct kvm_arch_async_pf arch;
-	struct page *page;
+	bool   wakeup_all;
 };
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 7005d11..131a0bd 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -296,23 +296,21 @@ DEFINE_EVENT(kvm_async_pf_nopresent_ready, kvm_async_pf_ready,
 
 TRACE_EVENT(
 	kvm_async_pf_completed,
-	TP_PROTO(unsigned long address, struct page *page, u64 gva),
-	TP_ARGS(address, page, gva),
+	TP_PROTO(unsigned long address, u64 gva),
+	TP_ARGS(address, gva),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, address)
-		__field(pfn_t, pfn)
 		__field(u64, gva)
 		),
 
 	TP_fast_assign(
 		__entry->address = address;
-		__entry->pfn = page ? page_to_pfn(page) : 0;
 		__entry->gva = gva;
 		),
 
-	TP_printk("gva %#llx address %#lx pfn %#llx",  __entry->gva,
-		  __entry->address, __entry->pfn)
+	TP_printk("gva %#llx address %#lx",  __entry->gva,
+		  __entry->address)
 );
 
 #endif
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index b197950..8631d9c 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -56,7 +56,6 @@ void kvm_async_pf_vcpu_init(struct kvm_vcpu *vcpu)
 
 static void async_pf_execute(struct work_struct *work)
 {
-	struct page *page = NULL;
 	struct kvm_async_pf *apf =
 		container_of(work, struct kvm_async_pf, work);
 	struct mm_struct *mm = apf->mm;
@@ -68,13 +67,12 @@ static void async_pf_execute(struct work_struct *work)
 
 	use_mm(mm);
 	down_read(&mm->mmap_sem);
-	get_user_pages(current, mm, addr, 1, 1, 0, &page, NULL);
+	get_user_pages(current, mm, addr, 1, 1, 0, NULL, NULL);
 	up_read(&mm->mmap_sem);
 	unuse_mm(mm);
 
 	spin_lock(&vcpu->async_pf.lock);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
-	apf->page = page;
 	spin_unlock(&vcpu->async_pf.lock);
 
 	/*
@@ -82,7 +80,7 @@ static void async_pf_execute(struct work_struct *work)
 	 * this point
 	 */
 
-	trace_kvm_async_pf_completed(addr, page, gva);
+	trace_kvm_async_pf_completed(addr, gva);
 
 	if (waitqueue_active(&vcpu->wq))
 		wake_up_interruptible(&vcpu->wq);
@@ -112,8 +110,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 			list_entry(vcpu->async_pf.done.next,
 				   typeof(*work), link);
 		list_del(&work->link);
-		if (!is_error_page(work->page))
-			kvm_release_page_clean(work->page);
 		kmem_cache_free(async_pf_cache, work);
 	}
 	spin_unlock(&vcpu->async_pf.lock);
@@ -133,14 +129,11 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 		list_del(&work->link);
 		spin_unlock(&vcpu->async_pf.lock);
 
-		if (work->page)
-			kvm_arch_async_page_ready(vcpu, work);
+		kvm_arch_async_page_ready(vcpu, work);
 		kvm_arch_async_page_present(vcpu, work);
 
 		list_del(&work->queue);
 		vcpu->async_pf.queued--;
-		if (!is_error_page(work->page))
-			kvm_release_page_clean(work->page);
 		kmem_cache_free(async_pf_cache, work);
 	}
 }
@@ -163,7 +156,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	if (!work)
 		return 0;
 
-	work->page = NULL;
+	work->wakeup_all = false;
 	work->vcpu = vcpu;
 	work->gva = gva;
 	work->addr = gfn_to_hva(vcpu->kvm, gfn);
@@ -203,7 +196,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	if (!work)
 		return -ENOMEM;
 
-	work->page = KVM_ERR_PTR_BAD_PAGE;
+	work->wakeup_all = true;
 	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
 
 	spin_lock(&vcpu->async_pf.lock);
-- 
1.7.1

