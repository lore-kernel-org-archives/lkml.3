Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaFWNFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:05:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37180 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaFWNFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 77/93] kvm: remove .done from struct kvm_async_pf
Date: Mon, 23 Jun 2014 14:02:56 +0100
Message-Id: <1403528592-2163-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>

commit 98fda169290b3b28c0f2db2b8f02290c13da50ef upstream.

'.done' is used to mark the completion of 'async_pf_execute()', but
'cancel_work_sync()' returns true when the work was canceled, so we
use it instead.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/async_pf.c      | 5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a63d83ebd151..e5ab7ec6ce93 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -178,7 +178,6 @@ struct kvm_async_pf {
 	unsigned long addr;
 	struct kvm_arch_async_pf arch;
 	struct page *page;
-	bool done;
 };
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 8a39dda7a325..b197950ac4d5 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -75,7 +75,6 @@ static void async_pf_execute(struct work_struct *work)
 	spin_lock(&vcpu->async_pf.lock);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
 	apf->page = page;
-	apf->done = true;
 	spin_unlock(&vcpu->async_pf.lock);
 
 	/*
@@ -99,9 +98,8 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
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
@@ -166,7 +164,6 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 		return 0;
 
 	work->page = NULL;
-	work->done = false;
 	work->vcpu = vcpu;
 	work->gva = gva;
 	work->addr = gfn_to_hva(vcpu->kvm, gfn);
-- 
1.9.1

