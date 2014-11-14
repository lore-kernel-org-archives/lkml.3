Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349AbaKNLNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:13:09 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54864 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965132AbaKNLMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:12:37 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: yoshikawa_takuya_b1@lab.ntt.co.jp, imammedo@redhat.com
Subject: [PATCH 2/3] kvm: commonize allocation of the new memory slots
Date: Fri, 14 Nov 2014 12:12:01 +0100
Message-Id: <1415963522-5255-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two kmemdup invocations can be unified.  I find that the new
placement of the comment makes it easier to see what happens.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c8ff99cc0ccb..7bfc842b96d7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -865,11 +865,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			goto out_free;
 	}
 
+	slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
+			GFP_KERNEL);
+	if (!slots)
+		goto out_free;
+
 	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
-		slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
-				GFP_KERNEL);
-		if (!slots)
-			goto out_free;
 		slot = id_to_memslot(slots, mem->slot);
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
@@ -885,6 +886,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		 * 	- kvm_is_visible_gfn (mmu_check_roots)
 		 */
 		kvm_arch_flush_shadow_memslot(kvm, slot);
+
+		/*
+		 * We can re-use the old_memslots from above, the only difference
+		 * from the currently installed memslots is the invalid flag.  This
+		 * will get overwritten by update_memslots anyway.
+		 */
 		slots = old_memslots;
 	}
 
@@ -892,19 +899,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (r)
 		goto out_slots;
 
-	r = -ENOMEM;
-	/*
-	 * We can re-use the old_memslots from above, the only difference
-	 * from the currently installed memslots is the invalid flag.  This
-	 * will get overwritten by update_memslots anyway.
-	 */
-	if (!slots) {
-		slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
-				GFP_KERNEL);
-		if (!slots)
-			goto out_free;
-	}
-
 	/* actual memory is freed via old in kvm_free_physmem_slot below */
 	if (change == KVM_MR_DELETE) {
 		new.dirty_bitmap = NULL;
-- 
1.8.3.1


