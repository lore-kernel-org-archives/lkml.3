Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaFWNLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:11:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37172 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbaFWNFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 76/93] kvm: free resources after canceling async_pf
Date: Mon, 23 Jun 2014 14:02:55 +0100
Message-Id: <1403528592-2163-77-git-send-email-luis.henriques@canonical.com>
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

commit 28b441e24088081c1e213139d1303b451a34a4f4 upstream.

When we cancel 'async_pf_execute()', we should behave as if the work was
never scheduled in 'kvm_setup_async_pf()'.
Fixes a bug when we can't unload module because the vm wasn't destroyed.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 virt/kvm/async_pf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index ea475cd03511..8a39dda7a325 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -101,8 +101,11 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
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
1.9.1

