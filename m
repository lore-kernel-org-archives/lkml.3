Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaLAR3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:29:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaLAR3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:29:40 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 5/5] kvm: optimize GFN to memslot lookup with large slots amount
Date: Mon,  1 Dec 2014 17:29:27 +0000
Message-Id: <1417454967-4465-6-git-send-email-imammedo@redhat.com>
In-Reply-To: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
References: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current linear search doesn't scale well when
large amount of memslots is used and looked up slot
is not in the beginning memslots array.
Taking in account that memslots don't overlap, it's
possible to switch sorting order of memslots array from
'npages' to 'base_gfn' and use binary search for
memslot lookup by GFN.

As result of switching to binary search lookup times
are reduced with large amount of memslots.

Following is a table of search_memslot() cycles
during WS2008R2 guest boot.

                         boot,          boot + ~10 min
                         mostly same    of using it,
                         slot lookup    randomized lookup
                max      average        average
                cycles   cycles         cycles

13 slots      : 1450       28           30

13 slots      : 1400       30           40
binary search

117 slots     : 13000      30           460

117 slots     : 2000       35           180
binary search

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 include/linux/kvm_host.h | 34 ++++++++++++++++++++++------------
 virt/kvm/kvm_main.c      |  8 +++++++-
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1a37144..193bca6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -354,6 +354,7 @@ struct kvm_memslots {
 	/* The mapping table from slot id to the index in memslots[]. */
 	short id_to_index[KVM_MEM_SLOTS_NUM];
 	atomic_t lru_slot;
+	int used_slots;
 };
 
 struct kvm {
@@ -791,19 +792,28 @@ static inline void kvm_guest_exit(void)
 static inline struct kvm_memory_slot *
 search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 {
+	int start = 0, end = slots->used_slots;
 	int slot = atomic_read(&slots->lru_slot);
-	struct kvm_memory_slot *memslot = &slots->memslots[slot];
-
-	if (gfn >= memslot->base_gfn &&
-	    gfn < memslot->base_gfn + memslot->npages)
-		return memslot;
-
-	kvm_for_each_memslot(memslot, slots)
-		if (gfn >= memslot->base_gfn &&
-		      gfn < memslot->base_gfn + memslot->npages) {
-			atomic_set(&slots->lru_slot, memslot - slots->memslots);
-			return memslot;
-		}
+	struct kvm_memory_slot *memslots = slots->memslots;
+
+	if (gfn >= memslots[slot].base_gfn &&
+	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
+		return &memslots[slot];
+
+	while (start < end) {
+		slot = start + (end - start) / 2;
+
+		if (gfn >= memslots[slot].base_gfn)
+			end = slot;
+		else
+			start = slot + 1;
+	}
+
+	if (gfn >= memslots[start].base_gfn &&
+	    gfn < memslots[start].base_gfn + memslots[start].npages) {
+		atomic_set(&slots->lru_slot, start);
+		return &memslots[start];
+	}
 
 	return NULL;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 162817f..759af659 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -679,8 +679,14 @@ static void update_memslots(struct kvm_memslots *slots,
 	struct kvm_memory_slot *mslots = slots->memslots;
 
 	WARN_ON(mslots[i].id != id);
-	if (!new->npages)
+	if (!new->npages) {
 		new->base_gfn = 0;
+		if (mslots[i].npages)
+			slots->used_slots--;
+	} else {
+		if (!mslots[i].npages)
+			slots->used_slots++;
+	}
 
 	while (i < KVM_MEM_SLOTS_NUM - 1 &&
 	       new->base_gfn <= mslots[i + 1].base_gfn) {
-- 
1.8.3.1

