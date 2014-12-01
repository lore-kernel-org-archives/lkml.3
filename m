Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaLARaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:30:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbaLAR3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:29:39 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 4/5] kvm: change memslot sorting rule from size to GFN
Date: Mon,  1 Dec 2014 17:29:26 +0000
Message-Id: <1417454967-4465-5-git-send-email-imammedo@redhat.com>
In-Reply-To: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
References: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it will allow to use binary search for GFN -> memslot
lookups, reducing lookup cost with large slots amount.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 virt/kvm/kvm_main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 278ed65..162817f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -666,10 +666,10 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 }
 
 /*
- * Insert memslot and re-sort memslots based on their size,
- * so the larger slots will get better fit. Sorting algorithm
- * takes advantage of having initially sorted array and
- * known changed memslot position.
+ * Insert memslot and re-sort memslots based on their GFN,
+ * so binary search could be used to lookup GFN.
+ * Sorting algorithm takes advantage of having initially
+ * sorted array and known changed memslot position.
  */
 static void update_memslots(struct kvm_memslots *slots,
 			    struct kvm_memory_slot *new)
@@ -679,14 +679,19 @@ static void update_memslots(struct kvm_memslots *slots,
 	struct kvm_memory_slot *mslots = slots->memslots;
 
 	WARN_ON(mslots[i].id != id);
+	if (!new->npages)
+		new->base_gfn = 0;
+
 	while (i < KVM_MEM_SLOTS_NUM - 1 &&
-	       new->npages < mslots[i + 1].npages) {
+	       new->base_gfn <= mslots[i + 1].base_gfn) {
+		if (!mslots[i + 1].npages)
+			break;
 		mslots[i] = mslots[i + 1];
 		slots->id_to_index[mslots[i].id] = i;
 		i++;
 	}
 	while (i > 0 &&
-	       new->npages > mslots[i - 1].npages) {
+	       new->base_gfn > mslots[i - 1].base_gfn) {
 		mslots[i] = mslots[i - 1];
 		slots->id_to_index[mslots[i].id] = i;
 		i--;
-- 
1.8.3.1

