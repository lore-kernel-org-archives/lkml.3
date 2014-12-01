Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaLAR3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:29:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbaLAR3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:29:36 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 1/5] kvm: update_memslots: drop not needed check for the same number of pages
Date: Mon,  1 Dec 2014 17:29:23 +0000
Message-Id: <1417454967-4465-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
References: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if number of pages haven't changed sorting algorithm
will do nothing, so there is no need to do extra check
to avoid entering sorting logic.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 virt/kvm/kvm_main.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5b45330..407277b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -679,21 +679,19 @@ static void update_memslots(struct kvm_memslots *slots,
 	struct kvm_memory_slot *mslots = slots->memslots;
 
 	WARN_ON(mslots[i].id != id);
-	if (new->npages != mslots[i].npages) {
-		if (new->npages < mslots[i].npages) {
-			while (i < KVM_MEM_SLOTS_NUM - 1 &&
-			       new->npages < mslots[i + 1].npages) {
-				mslots[i] = mslots[i + 1];
-				slots->id_to_index[mslots[i].id] = i;
-				i++;
-			}
-		} else {
-			while (i > 0 &&
-			       new->npages > mslots[i - 1].npages) {
-				mslots[i] = mslots[i - 1];
-				slots->id_to_index[mslots[i].id] = i;
-				i--;
-			}
+	if (new->npages < mslots[i].npages) {
+		while (i < KVM_MEM_SLOTS_NUM - 1 &&
+		       new->npages < mslots[i + 1].npages) {
+			mslots[i] = mslots[i + 1];
+			slots->id_to_index[mslots[i].id] = i;
+			i++;
+		}
+	} else {
+		while (i > 0 &&
+		       new->npages > mslots[i - 1].npages) {
+			mslots[i] = mslots[i - 1];
+			slots->id_to_index[mslots[i].id] = i;
+			i--;
 		}
 	}
 
-- 
1.8.3.1

