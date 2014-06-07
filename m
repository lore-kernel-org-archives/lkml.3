Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaFGBco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36116 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paolo Bonzini" <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>,
        "Gleb Natapov" <gleb@redhat.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.231467087@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 34/92] kvm: free resources after canceling async_pf
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

commit 28b441e24088081c1e213139d1303b451a34a4f4 upstream.

When we cancel 'async_pf_execute()', we should behave as if the work was
never scheduled in 'kvm_setup_async_pf()'.
Fixes a bug when we can't unload module because the vm wasn't destroyed.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/async_pf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -101,8 +101,11 @@ void kvm_clear_async_pf_completion_queue
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

