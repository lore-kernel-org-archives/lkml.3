Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaL1JDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 04:03:30 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52571 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaL1JDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 04:03:25 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] kvm: warn on more invariant breakage
Date: Sun, 28 Dec 2014 10:03:15 +0100
Message-Id: <1419757395-11273-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modifying a non-existent slot is not allowed.  Also check that the
first loop doesn't move a deleted slot beyond the used part of
the mslots array.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 050974c051b5..1cc6e2e19982 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -671,6 +671,7 @@ static void update_memslots(struct kvm_memslots *slots,
 
 	WARN_ON(mslots[i].id != id);
 	if (!new->npages) {
+		WARN_ON(!mslots[i].npages);
 		new->base_gfn = 0;
 		if (mslots[i].npages)
 			slots->used_slots--;
@@ -704,7 +705,8 @@ static void update_memslots(struct kvm_memslots *slots,
 			slots->id_to_index[mslots[i].id] = i;
 			i--;
 		}
-	}
+	} else
+		WARN_ON_ONCE(i != slots->used_slots);
 
 	mslots[i] = *new;
 	slots->id_to_index[mslots[i].id] = i;
-- 
1.8.3.1

