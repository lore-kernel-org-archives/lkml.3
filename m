Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbaKMQbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:31:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752AbaKMQbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:31:16 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Subject: [PATCH] kvm: memslots: replace heap sort with insertion sort
Date: Thu, 13 Nov 2014 16:31:07 +0000
Message-Id: <1415896267-2146-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <545BA09E.7040301@redhat.com>
References: <545BA09E.7040301@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memslots is a sorted array, when slot changes in it
with current heapsort it would take O(n log n) time
to update array, while using insertion sort like
algorithm on array with 1 item out of order will
take only O(n) time.

Replace current heapsort with custom sort that
takes advantage of memslots usage pattern and known
position of changed slot.

performance change of 128 memslots insersions with
gradually increasing size (the worst case):
      heap sort   custom sort
max:  249747      15654 cycles
min:  52536       5562 cycles
with custom sort alg taking 90% less then original
update time.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 virt/kvm/kvm_main.c | 54 +++++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25ffac9..5fcbc45 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -668,31 +668,43 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 	return 0;
 }
 
-static int cmp_memslot(const void *slot1, const void *slot2)
+static void swap_memslot(struct kvm_memory_slot *s1, struct kvm_memory_slot *s2)
 {
-	struct kvm_memory_slot *s1, *s2;
+	struct kvm_memory_slot tmp;
 
-	s1 = (struct kvm_memory_slot *)slot1;
-	s2 = (struct kvm_memory_slot *)slot2;
-
-	if (s1->npages < s2->npages)
-		return 1;
-	if (s1->npages > s2->npages)
-		return -1;
-
-	return 0;
+	tmp = *s2;
+	*s2 = *s1;
+	*s1 = tmp;
 }
 
 /*
- * Sort the memslots base on its size, so the larger slots
- * will get better fit.
+ * Insert memslot and re-sort memslots based on their size,
+ * so the larger slots will get better fit. Sorting algorithm
+ * takes advantage of having initially sorted array and
+ * known changed memslot position.
  */
-static void sort_memslots(struct kvm_memslots *slots)
+static void insert_memslot(struct kvm_memslots *slots,
+			   struct kvm_memory_slot *new)
 {
-	int i;
+	int i = slots->id_to_index[new->id];
+	struct kvm_memory_slot *old = id_to_memslot(slots, new->id);
+	struct kvm_memory_slot *mslots = slots->memslots;
 
-	sort(slots->memslots, KVM_MEM_SLOTS_NUM,
-	      sizeof(struct kvm_memory_slot), cmp_memslot, NULL);
+	if (new->npages == old->npages)
+		return;
+
+	*old = *new;
+	while (1) {
+		if (i < (KVM_MEM_SLOTS_NUM - 1) &&
+			mslots[i].npages < mslots[i + 1].npages) {
+			swap_memslot(&mslots[i], &mslots[i + 1]);
+			i++;
+		} else if (i > 0 && mslots[i].npages > mslots[i - 1].npages) {
+			swap_memslot(&mslots[i], &mslots[i - 1]);
+			i--;
+		} else
+			break;
+	}
 
 	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
 		slots->id_to_index[slots->memslots[i].id] = i;
@@ -702,13 +714,7 @@ static void update_memslots(struct kvm_memslots *slots,
 			    struct kvm_memory_slot *new)
 {
 	if (new) {
-		int id = new->id;
-		struct kvm_memory_slot *old = id_to_memslot(slots, id);
-		unsigned long npages = old->npages;
-
-		*old = *new;
-		if (new->npages != npages)
-			sort_memslots(slots);
+		insert_memslot(slots, new);
 	}
 }
 
-- 
1.8.3.1

