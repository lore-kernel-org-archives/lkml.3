Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872Ab3IDUeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab3IDUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:34:12 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/2] kvm: remove .done from struct kvm_async_pf
Date: Wed,  4 Sep 2013 22:32:24 +0200
Message-Id: <1378326744-24434-3-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1378326744-24434-1-git-send-email-rkrcmar@redhat.com>
References: <1378326744-24434-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'.done' is used to mark the completion of 'async_pf_execute()', but
'cancel_work_sync()' returns true when the work was canceled, so we
use it instead.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/async_pf.c      | 5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ca645a0..c7a5e08 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -190,7 +190,6 @@ struct kvm_async_pf {
 	unsigned long addr;
 	struct kvm_arch_async_pf arch;
 	struct page *page;
-	bool done;
 };
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index f30aa1c..89acf41 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -76,7 +76,6 @@ static void async_pf_execute(struct work_struct *work)
 	spin_lock(&vcpu->async_pf.lock);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
 	apf->page = page;
-	apf->done = true;
 	spin_unlock(&vcpu->async_pf.lock);
 
 	/*
@@ -100,9 +99,8 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 		struct kvm_async_pf *work =
 			list_entry(vcpu->async_pf.queue.next,
 				   typeof(*work), queue);
-		cancel_work_sync(&work->work);
 		list_del(&work->queue);
-		if (!work->done) { /* work was canceled */
+		if (cancel_work_sync(&work->work)) {
 			mmdrop(work->mm);
 			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
 			kmem_cache_free(async_pf_cache, work);
@@ -167,7 +165,6 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 		return 0;
 
 	work->page = NULL;
-	work->done = false;
 	work->vcpu = vcpu;
 	work->gva = gva;
 	work->addr = gfn_to_hva(vcpu->kvm, gfn);
-- 
1.8.3.1

