Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab3IDUeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759718Ab3IDUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:34:12 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/2] kvm: free resources after canceling async_pf
Date: Wed,  4 Sep 2013 22:32:23 +0200
Message-Id: <1378326744-24434-2-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1378326744-24434-1-git-send-email-rkrcmar@redhat.com>
References: <1378326744-24434-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we cancel 'async_pf_execute()', we should behave as if the work was
never scheduled in 'kvm_setup_async_pf()'.
Fixes a bug when we can't unload module because the vm wasn't destroyed.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 virt/kvm/async_pf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index b44cea0..f30aa1c 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -102,8 +102,11 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 				   typeof(*work), queue);
 		cancel_work_sync(&work->work);
 		list_del(&work->queue);
-		if (!work->done) /* work was canceled */
+		if (!work->done) { /* work was canceled */
+			mmdrop(work->mm);
+			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
 			kmem_cache_free(async_pf_cache, work);
+		}
 	}
 
 	spin_lock(&vcpu->async_pf.lock);
-- 
1.8.3.1

