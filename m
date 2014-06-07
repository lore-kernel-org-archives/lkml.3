Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaFGBae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:30:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36126 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Gleb Natapov" <gleb@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.293842827@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 35/92] kvm: remove .done from struct kvm_async_pf
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Radim Krčmář <rkrcmar@redhat.com>

commit 98fda169290b3b28c0f2db2b8f02290c13da50ef upstream.

'.done' is used to mark the completion of 'async_pf_execute()', but
'cancel_work_sync()' returns true when the work was canceled, so we
use it instead.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/async_pf.c      | 5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -95,7 +95,6 @@ struct kvm_async_pf {
 	unsigned long addr;
 	struct kvm_arch_async_pf arch;
 	struct page *page;
-	bool done;
 };
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -75,7 +75,6 @@ static void async_pf_execute(struct work
 	spin_lock(&vcpu->async_pf.lock);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
 	apf->page = page;
-	apf->done = true;
 	spin_unlock(&vcpu->async_pf.lock);
 
 	/*
@@ -99,9 +98,8 @@ void kvm_clear_async_pf_completion_queue
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
@@ -166,7 +164,6 @@ int kvm_setup_async_pf(struct kvm_vcpu *
 		return 0;
 
 	work->page = NULL;
-	work->done = false;
 	work->vcpu = vcpu;
 	work->gva = gva;
 	work->addr = gfn_to_hva(vcpu->kvm, gfn);

