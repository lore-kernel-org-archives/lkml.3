Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaLAR3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:29:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbaLAR3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:29:38 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 3/5] kvm: search_memslots: add simple LRU memslot caching
Date: Mon,  1 Dec 2014 17:29:25 +0000
Message-Id: <1417454967-4465-4-git-send-email-imammedo@redhat.com>
In-Reply-To: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
References: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In typical guest boot workload only 2-3 memslots are used
extensively, and at that it's mostly the same memslot
lookup operation.

Adding LRU cache improves average lookup time from
46 to 28 cycles (~40%) for this workload.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 include/linux/kvm_host.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 231dd94..1a37144 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -353,6 +353,7 @@ struct kvm_memslots {
 	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
 	/* The mapping table from slot id to the index in memslots[]. */
 	short id_to_index[KVM_MEM_SLOTS_NUM];
+	atomic_t lru_slot;
 };
 
 struct kvm {
@@ -790,12 +791,19 @@ static inline void kvm_guest_exit(void)
 static inline struct kvm_memory_slot *
 search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 {
-	struct kvm_memory_slot *memslot;
+	int slot = atomic_read(&slots->lru_slot);
+	struct kvm_memory_slot *memslot = &slots->memslots[slot];
+
+	if (gfn >= memslot->base_gfn &&
+	    gfn < memslot->base_gfn + memslot->npages)
+		return memslot;
 
 	kvm_for_each_memslot(memslot, slots)
 		if (gfn >= memslot->base_gfn &&
-		      gfn < memslot->base_gfn + memslot->npages)
+		      gfn < memslot->base_gfn + memslot->npages) {
+			atomic_set(&slots->lru_slot, memslot - slots->memslots);
 			return memslot;
+		}
 
 	return NULL;
 }
-- 
1.8.3.1

