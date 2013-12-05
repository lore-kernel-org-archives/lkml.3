Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3LERiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:38:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38388 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3LERh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 71/90] KVM: perform an invalid memslot step for gpa base change
Date: Thu,  5 Dec 2013 17:35:53 +0000
Message-Id: <1386264972-5399-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 12d6e7538e2d418c08f082b1b44ffa5fb7270ed8 upstream.

PPC must flush all translations before the new memory slot
is visible.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e32731c..9e97f68 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -770,7 +770,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		/* destroy any largepage mappings for dirty tracking */
 	}
 
-	if (!npages) {
+	if (!npages || base_gfn != old.base_gfn) {
 		struct kvm_memory_slot *slot;
 
 		r = -ENOMEM;
@@ -786,8 +786,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
-		/* From this point no new shadow pages pointing to a deleted
-		 * memslot will be created.
+		/* From this point no new shadow pages pointing to a deleted,
+		 * or moved, memslot will be created.
 		 *
 		 * validation of sp->gfn happens in:
 		 * 	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
-- 
1.8.3.2

