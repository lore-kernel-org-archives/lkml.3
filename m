Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbaHVQxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:53:53 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:49960 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734AbaHVQxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:49 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/15] percpu: rename pcpu_reclaim_work to pcpu_balance_work
Date: Fri, 22 Aug 2014 12:53:18 -0400
Message-Id: <1408726399-4436-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_reclaim_work will also be used to populate chunks asynchronously.
Rename it to pcpu_balance_work in preparation.  pcpu_reclaim() is
renamed to pcpu_balance_workfn() and some of its local variables are
renamed too.

This is pure rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 7f076ed..ddb8f58 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -168,9 +168,9 @@ static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
  */
 static int pcpu_nr_empty_pop_pages;
 
-/* reclaim work to release fully free chunks, scheduled from free path */
-static void pcpu_reclaim(struct work_struct *work);
-static DECLARE_WORK(pcpu_reclaim_work, pcpu_reclaim);
+/* balance work is used to populate or destroy chunks asynchronously */
+static void pcpu_balance_workfn(struct work_struct *work);
+static DECLARE_WORK(pcpu_balance_work, pcpu_balance_workfn);
 
 static bool pcpu_addr_in_first_chunk(void *addr)
 {
@@ -1080,36 +1080,33 @@ void __percpu *__alloc_reserved_percpu(size_t size, size_t align)
 }
 
 /**
- * pcpu_reclaim - reclaim fully free chunks, workqueue function
+ * pcpu_balance_workfn - reclaim fully free chunks, workqueue function
  * @work: unused
  *
  * Reclaim all fully free chunks except for the first one.
- *
- * CONTEXT:
- * workqueue context.
  */
-static void pcpu_reclaim(struct work_struct *work)
+static void pcpu_balance_workfn(struct work_struct *work)
 {
-	LIST_HEAD(todo);
-	struct list_head *head = &pcpu_slot[pcpu_nr_slots - 1];
+	LIST_HEAD(to_free);
+	struct list_head *free_head = &pcpu_slot[pcpu_nr_slots - 1];
 	struct pcpu_chunk *chunk, *next;
 
 	mutex_lock(&pcpu_alloc_mutex);
 	spin_lock_irq(&pcpu_lock);
 
-	list_for_each_entry_safe(chunk, next, head, list) {
+	list_for_each_entry_safe(chunk, next, free_head, list) {
 		WARN_ON(chunk->immutable);
 
 		/* spare the first one */
-		if (chunk == list_first_entry(head, struct pcpu_chunk, list))
+		if (chunk == list_first_entry(free_head, struct pcpu_chunk, list))
 			continue;
 
-		list_move(&chunk->list, &todo);
+		list_move(&chunk->list, &to_free);
 	}
 
 	spin_unlock_irq(&pcpu_lock);
 
-	list_for_each_entry_safe(chunk, next, &todo, list) {
+	list_for_each_entry_safe(chunk, next, &to_free, list) {
 		int rs, re;
 
 		pcpu_for_each_pop_region(chunk, rs, re, 0, pcpu_unit_pages) {
@@ -1163,7 +1160,7 @@ void free_percpu(void __percpu *ptr)
 
 		list_for_each_entry(pos, &pcpu_slot[pcpu_nr_slots - 1], list)
 			if (pos != chunk) {
-				schedule_work(&pcpu_reclaim_work);
+				schedule_work(&pcpu_balance_work);
 				break;
 			}
 	}
-- 
1.9.3

