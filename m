Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300AbaKNLMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:12:38 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52892 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965249AbaKNLMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:12:36 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: yoshikawa_takuya_b1@lab.ntt.co.jp, imammedo@redhat.com
Subject: [PATCH 1/3] kvm: memslots: track id_to_index changes during the insertion sort
Date: Fri, 14 Nov 2014 12:12:00 +0100
Message-Id: <1415963522-5255-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This completes the optimization from the previous patch, by
removing the KVM_MEM_SLOTS_NUM-iteration loop from insert_memslot.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c0c2202e6c4f..c8ff99cc0ccb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -677,31 +677,30 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 static void insert_memslot(struct kvm_memslots *slots,
 			   struct kvm_memory_slot *new)
 {
-	int i = slots->id_to_index[new->id];
-	struct kvm_memory_slot *old = id_to_memslot(slots, new->id);
+	int id = new->id;
+	int i = slots->id_to_index[id];
 	struct kvm_memory_slot *mslots = slots->memslots;
 
-	if (new->npages == old->npages) {
-		*old = *new;
-		return;
-	}
-
-	while (1) {
-		if (i < (KVM_MEM_SLOTS_NUM - 1) &&
-			new->npages < mslots[i + 1].npages) {
-			mslots[i] = mslots[i + 1];
-			i++;
-		} else if (i > 0 && new->npages > mslots[i - 1].npages) {
-			mslots[i] = mslots[i - 1];
-			i--;
-		} else {
-			mslots[i] = *new;
-			break;
+	WARN_ON(mslots[i].id != id);
+	if (new->npages != mslots[i].npages) {
+		while (1) {
+			if (i < (KVM_MEM_SLOTS_NUM - 1) &&
+    			    new->npages < mslots[i + 1].npages) {
+				mslots[i] = mslots[i + 1];
+				slots->id_to_index[mslots[i].id] = i;
+				i++;
+			} else if (i > 0 &&
+				   new->npages > mslots[i - 1].npages) {
+				mslots[i] = mslots[i - 1];
+				slots->id_to_index[mslots[i].id] = i;
+				i--;
+			} else
+				break;
 		}
 	}
 
-	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		slots->id_to_index[slots->memslots[i].id] = i;
+	mslots[i] = *new;
+	slots->id_to_index[mslots[i].id] = i;
 }
 
 static void update_memslots(struct kvm_memslots *slots,
-- 
1.8.3.1


