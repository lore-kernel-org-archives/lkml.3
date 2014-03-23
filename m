Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaCWSuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:50:11 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35500 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaCWSuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:50:09 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: [PATCH 30/47] kernel: Use RCU_INIT_POINTER(x, NULL) in events/core.c
Date: Mon, 24 Mar 2014 00:19:08 +0530
Message-Id: <1395600549-10314-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 kernel/events/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fa0b2d4..8c22758 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3247,7 +3247,7 @@ static void free_event(struct perf_event *event)
 		mutex_lock(&event->mmap_mutex);
 		rb = event->rb;
 		if (rb) {
-			rcu_assign_pointer(event->rb, NULL);
+			RCU_INIT_POINTER(event->rb, NULL);
 			ring_buffer_detach(event, rb);
 			ring_buffer_put(rb); /* could be last */
 		}
@@ -3938,7 +3938,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		return;
 
 	/* Detach current event from the buffer. */
-	rcu_assign_pointer(event->rb, NULL);
+	RCU_INIT_POINTER(event->rb, NULL);
 	ring_buffer_detach(event, rb);
 	mutex_unlock(&event->mmap_mutex);
 
@@ -3977,7 +3977,7 @@ again:
 		 * iterating the wrong list.
 		 */
 		if (event->rb == rb) {
-			rcu_assign_pointer(event->rb, NULL);
+			RCU_INIT_POINTER(event->rb, NULL);
 			ring_buffer_detach(event, rb);
 			ring_buffer_put(rb); /* can't be last, we still have one */
 		}
@@ -5690,7 +5690,7 @@ static void swevent_hlist_release(struct swevent_htable *swhash)
 	if (!hlist)
 		return;
 
-	rcu_assign_pointer(swhash->swevent_hlist, NULL);
+	RCU_INIT_POINTER(swhash->swevent_hlist, NULL);
 	kfree_rcu(hlist, rcu_head);
 }
 
-- 
1.7.9.5

