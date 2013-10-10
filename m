Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3JJNVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:21:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab3JJNVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:21:34 -0400
X-IronPort-AV: E=Sophos;i="4.93,466,1378828800"; 
   d="scan'208";a="8715070"
From: chai wen <chaiw.fnst@cn.fujitsu.com>
To: gleb@redhat.com
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com, tangchen@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com,
        guijianfeng@cn.fujitsu.com, chaiwen_0825@hotmail.com,
        chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: [RFC][PATCH] Drop FOLL_GET in GUP when doing async_pf in kvm
Date: Thu, 10 Oct 2013 21:20:15 +0800
Message-Id: <1381411215-23830-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/10 21:19:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/10 21:19:23,
	Serialize complete at 2013/10/10 21:19:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb

Thanks for you explanation about async_pf in kvm.
Page pinning is not mandatory in kvm async_pf processing and probably should
be dropped later.this patch drops the FOLL_GET flag when doing GUP in async_pf
and uses a bool (marking result of GUP) to replace the *page in kvm_async_pf
structure to simplify some following async_pf check/clear processing.
Thanks.

Suggested-by:  gleb@redhat.com
Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c       |    5 ++---
 include/linux/kvm_host.h |    2 +-
 virt/kvm/async_pf.c      |   16 ++++++----------
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5ca72a..0ff7d02 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7282,8 +7282,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
-	if ((vcpu->arch.mmu.direct_map != work->arch.direct_map) ||
-	      is_error_page(work->page))
+	if ((vcpu->arch.mmu.direct_map != work->arch.direct_map))
 		return;
 
 	r = kvm_mmu_reload(vcpu);
@@ -7393,7 +7392,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	struct x86_exception fault;
 
 	trace_kvm_async_pf_ready(work->arch.token, work->gva);
-	if (is_error_page(work->page))
+	if (!work->got_page)
 		work->arch.token = ~0; /* broadcast wakeup */
 	else
 		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0fbbc7a..232a7d0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -189,7 +189,7 @@ struct kvm_async_pf {
 	gva_t gva;
 	unsigned long addr;
 	struct kvm_arch_async_pf arch;
-	struct page *page;
+	bool got_page;
 	bool done;
 };
 
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 8a39dda..0cafdc7 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -56,7 +56,7 @@ void kvm_async_pf_vcpu_init(struct kvm_vcpu *vcpu)
 
 static void async_pf_execute(struct work_struct *work)
 {
-	struct page *page = NULL;
+	long nrpages = 0;
 	struct kvm_async_pf *apf =
 		container_of(work, struct kvm_async_pf, work);
 	struct mm_struct *mm = apf->mm;
@@ -68,13 +68,13 @@ static void async_pf_execute(struct work_struct *work)
 
 	use_mm(mm);
 	down_read(&mm->mmap_sem);
-	get_user_pages(current, mm, addr, 1, 1, 0, &page, NULL);
+	nrpages = get_user_pages(current, mm, addr, 1, 1, 0, NULL, NULL);
 	up_read(&mm->mmap_sem);
 	unuse_mm(mm);
 
 	spin_lock(&vcpu->async_pf.lock);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
-	apf->page = page;
+	apf->got_page = (1==nrpages);
 	apf->done = true;
 	spin_unlock(&vcpu->async_pf.lock);
 
@@ -114,8 +114,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 			list_entry(vcpu->async_pf.done.next,
 				   typeof(*work), link);
 		list_del(&work->link);
-		if (!is_error_page(work->page))
-			kvm_release_page_clean(work->page);
 		kmem_cache_free(async_pf_cache, work);
 	}
 	spin_unlock(&vcpu->async_pf.lock);
@@ -135,14 +133,12 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 		list_del(&work->link);
 		spin_unlock(&vcpu->async_pf.lock);
 
-		if (work->page)
+		if (work->got_page)
 			kvm_arch_async_page_ready(vcpu, work);
 		kvm_arch_async_page_present(vcpu, work);
 
 		list_del(&work->queue);
 		vcpu->async_pf.queued--;
-		if (!is_error_page(work->page))
-			kvm_release_page_clean(work->page);
 		kmem_cache_free(async_pf_cache, work);
 	}
 }
@@ -165,7 +161,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	if (!work)
 		return 0;
 
-	work->page = NULL;
+	work->got_page = false;
 	work->done = false;
 	work->vcpu = vcpu;
 	work->gva = gva;
@@ -206,7 +202,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	if (!work)
 		return -ENOMEM;
 
-	work->page = KVM_ERR_PTR_BAD_PAGE;
+	work->got_page = false;
 	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
 
 	spin_lock(&vcpu->async_pf.lock);
-- 
1.7.1

