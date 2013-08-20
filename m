Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3HTRkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:40:22 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:39059 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab3HTRkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:40:21 -0400
From: Andy King <acking@vmware.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: gregkh@linuxfoundation.org, pv-drivers@vmware.com,
        Andy King <acking@vmware.com>
Subject: [PATCH 1/2] VMCI: Remove non-blocking/pinned queuepair support
Date: Tue, 20 Aug 2013 10:30:02 -0700
Message-Id: <1377019803-1490-2-git-send-email-acking@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1377019803-1490-1-git-send-email-acking@vmware.com>
References: <1377019803-1490-1-git-send-email-acking@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We added this for a special case that doesn't exist on Linux.  Remove
the non-blocking/pinned queuepair code and simplify the driver in
preparation for adding virtual IOMMU support.

Acked-by: Aditya Sarwade <asarwade@vmware.com>
Signed-off-by: Andy King <acking@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c |  149 +++++--------------------------
 drivers/misc/vmw_vmci/vmci_queue_pair.h |   18 ----
 2 files changed, 22 insertions(+), 145 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 8ff2e5e..8698e0c 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -148,12 +148,10 @@ typedef int vmci_memcpy_from_queue_func(void *dest, size_t dest_offset,
 struct vmci_queue_kern_if {
 	struct page **page;
 	struct page **header_page;
-	void *va;
 	struct mutex __mutex;	/* Protects the queue. */
 	struct mutex *mutex;	/* Shared by producer and consumer queues. */
 	bool host;
 	size_t num_pages;
-	bool mapped;
 };
 
 /*
@@ -267,11 +265,6 @@ static void qp_free_queue(void *q, u64 size)
 	if (queue) {
 		u64 i = DIV_ROUND_UP(size, PAGE_SIZE);
 
-		if (queue->kernel_if->mapped) {
-			vunmap(queue->kernel_if->va);
-			queue->kernel_if->va = NULL;
-		}
-
 		while (i)
 			__free_page(queue->kernel_if->page[--i]);
 
@@ -311,8 +304,6 @@ static void *qp_alloc_queue(u64 size, u32 flags)
 	queue->kernel_if->header_page = NULL;	/* Unused in guest. */
 	queue->kernel_if->page = (struct page **)(queue->kernel_if + 1);
 	queue->kernel_if->host = false;
-	queue->kernel_if->va = NULL;
-	queue->kernel_if->mapped = false;
 
 	for (i = 0; i < num_data_pages; i++) {
 		queue->kernel_if->page[i] = alloc_pages(GFP_KERNEL, 0);
@@ -320,16 +311,6 @@ static void *qp_alloc_queue(u64 size, u32 flags)
 			goto fail;
 	}
 
-	if (vmci_qp_pinned(flags)) {
-		queue->kernel_if->va =
-		    vmap(queue->kernel_if->page, num_data_pages, VM_MAP,
-			 PAGE_KERNEL);
-		if (!queue->kernel_if->va)
-			goto fail;
-
-		queue->kernel_if->mapped = true;
-	}
-
 	return (void *)queue;
 
  fail:
@@ -359,11 +340,7 @@ static int __qp_memcpy_to_queue(struct vmci_queue *queue,
 		void *va;
 		size_t to_copy;
 
-		if (!kernel_if->mapped)
-			va = kmap(kernel_if->page[page_index]);
-		else
-			va = (void *)((u8 *)kernel_if->va +
-				      (page_index * PAGE_SIZE));
+		va = kmap(kernel_if->page[page_index]);
 
 		if (size - bytes_copied > PAGE_SIZE - page_offset)
 			/* Enough payload to fill up from this page. */
@@ -388,8 +365,7 @@ static int __qp_memcpy_to_queue(struct vmci_queue *queue,
 		}
 
 		bytes_copied += to_copy;
-		if (!kernel_if->mapped)
-			kunmap(kernel_if->page[page_index]);
+		kunmap(kernel_if->page[page_index]);
 	}
 
 	return VMCI_SUCCESS;
@@ -417,11 +393,7 @@ static int __qp_memcpy_from_queue(void *dest,
 		void *va;
 		size_t to_copy;
 
-		if (!kernel_if->mapped)
-			va = kmap(kernel_if->page[page_index]);
-		else
-			va = (void *)((u8 *)kernel_if->va +
-				      (page_index * PAGE_SIZE));
+		va = kmap(kernel_if->page[page_index]);
 
 		if (size - bytes_copied > PAGE_SIZE - page_offset)
 			/* Enough payload to fill up this page. */
@@ -446,8 +418,7 @@ static int __qp_memcpy_from_queue(void *dest,
 		}
 
 		bytes_copied += to_copy;
-		if (!kernel_if->mapped)
-			kunmap(kernel_if->page[page_index]);
+		kunmap(kernel_if->page[page_index]);
 	}
 
 	return VMCI_SUCCESS;
@@ -634,8 +605,6 @@ static struct vmci_queue *qp_host_alloc_queue(u64 size)
 		queue->kernel_if->header_page =
 		    (struct page **)((u8 *)queue + queue_size);
 		queue->kernel_if->page = &queue->kernel_if->header_page[1];
-		queue->kernel_if->va = NULL;
-		queue->kernel_if->mapped = false;
 	}
 
 	return queue;
@@ -1720,21 +1689,6 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
 			if (result < VMCI_SUCCESS)
 				return result;
 
-			/*
-			 * Preemptively load in the headers if non-blocking to
-			 * prevent blocking later.
-			 */
-			if (entry->qp.flags & VMCI_QPFLAG_NONBLOCK) {
-				result = qp_host_map_queues(entry->produce_q,
-							    entry->consume_q);
-				if (result < VMCI_SUCCESS) {
-					qp_host_unregister_user_memory(
-						entry->produce_q,
-						entry->consume_q);
-					return result;
-				}
-			}
-
 			entry->state = VMCIQPB_ATTACHED_MEM;
 		} else {
 			entry->state = VMCIQPB_ATTACHED_NO_MEM;
@@ -1749,24 +1703,6 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
 
 		return VMCI_ERROR_UNAVAILABLE;
 	} else {
-		/*
-		 * For non-blocking queue pairs, we cannot rely on
-		 * enqueue/dequeue to map in the pages on the
-		 * host-side, since it may block, so we make an
-		 * attempt here.
-		 */
-
-		if (flags & VMCI_QPFLAG_NONBLOCK) {
-			result =
-			    qp_host_map_queues(entry->produce_q,
-					       entry->consume_q);
-			if (result < VMCI_SUCCESS)
-				return result;
-
-			entry->qp.flags |= flags &
-			    (VMCI_QPFLAG_NONBLOCK | VMCI_QPFLAG_PINNED);
-		}
-
 		/* The host side has successfully attached to a queue pair. */
 		entry->state = VMCIQPB_ATTACHED_MEM;
 	}
@@ -2543,24 +2479,19 @@ void vmci_qp_guest_endpoints_exit(void)
  * Since non-blocking isn't yet implemented on the host personality we
  * have no reason to acquire a spin lock.  So to avoid the use of an
  * unnecessary lock only acquire the mutex if we can block.
- * Note: It is assumed that QPFLAG_PINNED implies QPFLAG_NONBLOCK.  Therefore
- * we can use the same locking function for access to both the queue
- * and the queue headers as it is the same logic.  Assert this behvior.
  */
 static void qp_lock(const struct vmci_qp *qpair)
 {
-	if (vmci_can_block(qpair->flags))
-		qp_acquire_queue_mutex(qpair->produce_q);
+	qp_acquire_queue_mutex(qpair->produce_q);
 }
 
 /*
  * Helper routine that unlocks the queue pair after calling
- * qp_lock.  Respects non-blocking and pinning flags.
+ * qp_lock.
  */
 static void qp_unlock(const struct vmci_qp *qpair)
 {
-	if (vmci_can_block(qpair->flags))
-		qp_release_queue_mutex(qpair->produce_q);
+	qp_release_queue_mutex(qpair->produce_q);
 }
 
 /*
@@ -2568,17 +2499,12 @@ static void qp_unlock(const struct vmci_qp *qpair)
  * currently not mapped, it will be attempted to do so.
  */
 static int qp_map_queue_headers(struct vmci_queue *produce_q,
-				struct vmci_queue *consume_q,
-				bool can_block)
+				struct vmci_queue *consume_q)
 {
 	int result;
 
 	if (NULL == produce_q->q_header || NULL == consume_q->q_header) {
-		if (can_block)
-			result = qp_host_map_queues(produce_q, consume_q);
-		else
-			result = VMCI_ERROR_QUEUEPAIR_NOT_READY;
-
+		result = qp_host_map_queues(produce_q, consume_q);
 		if (result < VMCI_SUCCESS)
 			return (produce_q->saved_header &&
 				consume_q->saved_header) ?
@@ -2601,8 +2527,7 @@ static int qp_get_queue_headers(const struct vmci_qp *qpair,
 {
 	int result;
 
-	result = qp_map_queue_headers(qpair->produce_q, qpair->consume_q,
-				      vmci_can_block(qpair->flags));
+	result = qp_map_queue_headers(qpair->produce_q, qpair->consume_q);
 	if (result == VMCI_SUCCESS) {
 		*produce_q_header = qpair->produce_q->q_header;
 		*consume_q_header = qpair->consume_q->q_header;
@@ -2645,9 +2570,6 @@ static bool qp_wait_for_ready_queue(struct vmci_qp *qpair)
 {
 	unsigned int generation;
 
-	if (qpair->flags & VMCI_QPFLAG_NONBLOCK)
-		return false;
-
 	qpair->blocked++;
 	generation = qpair->generation;
 	qp_unlock(qpair);
@@ -2674,15 +2596,14 @@ static ssize_t qp_enqueue_locked(struct vmci_queue *produce_q,
 				 const u64 produce_q_size,
 				 const void *buf,
 				 size_t buf_size,
-				 vmci_memcpy_to_queue_func memcpy_to_queue,
-				 bool can_block)
+				 vmci_memcpy_to_queue_func memcpy_to_queue)
 {
 	s64 free_space;
 	u64 tail;
 	size_t written;
 	ssize_t result;
 
-	result = qp_map_queue_headers(produce_q, consume_q, can_block);
+	result = qp_map_queue_headers(produce_q, consume_q);
 	if (unlikely(result != VMCI_SUCCESS))
 		return result;
 
@@ -2737,15 +2658,14 @@ static ssize_t qp_dequeue_locked(struct vmci_queue *produce_q,
 				 void *buf,
 				 size_t buf_size,
 				 vmci_memcpy_from_queue_func memcpy_from_queue,
-				 bool update_consumer,
-				 bool can_block)
+				 bool update_consumer)
 {
 	s64 buf_ready;
 	u64 head;
 	size_t read;
 	ssize_t result;
 
-	result = qp_map_queue_headers(produce_q, consume_q, can_block);
+	result = qp_map_queue_headers(produce_q, consume_q);
 	if (unlikely(result != VMCI_SUCCESS))
 		return result;
 
@@ -2842,32 +2762,11 @@ int vmci_qpair_alloc(struct vmci_qp **qpair,
 		route = vmci_guest_code_active() ?
 		    VMCI_ROUTE_AS_GUEST : VMCI_ROUTE_AS_HOST;
 
-	/* If NONBLOCK or PINNED is set, we better be the guest personality. */
-	if ((!vmci_can_block(flags) || vmci_qp_pinned(flags)) &&
-	    VMCI_ROUTE_AS_GUEST != route) {
-		pr_devel("Not guest personality w/ NONBLOCK OR PINNED set");
+	if (flags & (VMCI_QPFLAG_NONBLOCK | VMCI_QPFLAG_PINNED)) {
+		pr_devel("NONBLOCK OR PINNED set");
 		return VMCI_ERROR_INVALID_ARGS;
 	}
 
-	/*
-	 * Limit the size of pinned QPs and check sanity.
-	 *
-	 * Pinned pages implies non-blocking mode.  Mutexes aren't acquired
-	 * when the NONBLOCK flag is set in qpair code; and also should not be
-	 * acquired when the PINNED flagged is set.  Since pinning pages
-	 * implies we want speed, it makes no sense not to have NONBLOCK
-	 * set if PINNED is set.  Hence enforce this implication.
-	 */
-	if (vmci_qp_pinned(flags)) {
-		if (vmci_can_block(flags)) {
-			pr_err("Attempted to enable pinning w/o non-blocking");
-			return VMCI_ERROR_INVALID_ARGS;
-		}
-
-		if (produce_qsize + consume_qsize > VMCI_MAX_PINNED_QP_MEMORY)
-			return VMCI_ERROR_NO_RESOURCES;
-	}
-
 	my_qpair = kzalloc(sizeof(*my_qpair), GFP_KERNEL);
 	if (!my_qpair)
 		return VMCI_ERROR_NO_MEM;
@@ -3195,8 +3094,7 @@ ssize_t vmci_qpair_enqueue(struct vmci_qp *qpair,
 					   qpair->consume_q,
 					   qpair->produce_q_size,
 					   buf, buf_size,
-					   qp_memcpy_to_queue,
-					   vmci_can_block(qpair->flags));
+					   qp_memcpy_to_queue);
 
 		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
 		    !qp_wait_for_ready_queue(qpair))
@@ -3237,8 +3135,7 @@ ssize_t vmci_qpair_dequeue(struct vmci_qp *qpair,
 					   qpair->consume_q,
 					   qpair->consume_q_size,
 					   buf, buf_size,
-					   qp_memcpy_from_queue, true,
-					   vmci_can_block(qpair->flags));
+					   qp_memcpy_from_queue, true);
 
 		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
 		    !qp_wait_for_ready_queue(qpair))
@@ -3280,8 +3177,7 @@ ssize_t vmci_qpair_peek(struct vmci_qp *qpair,
 					   qpair->consume_q,
 					   qpair->consume_q_size,
 					   buf, buf_size,
-					   qp_memcpy_from_queue, false,
-					   vmci_can_block(qpair->flags));
+					   qp_memcpy_from_queue, false);
 
 		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
 		    !qp_wait_for_ready_queue(qpair))
@@ -3323,8 +3219,7 @@ ssize_t vmci_qpair_enquev(struct vmci_qp *qpair,
 					   qpair->consume_q,
 					   qpair->produce_q_size,
 					   iov, iov_size,
-					   qp_memcpy_to_queue_iov,
-					   vmci_can_block(qpair->flags));
+					   qp_memcpy_to_queue_iov);
 
 		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
 		    !qp_wait_for_ready_queue(qpair))
@@ -3367,7 +3262,7 @@ ssize_t vmci_qpair_dequev(struct vmci_qp *qpair,
 					   qpair->consume_q_size,
 					   iov, iov_size,
 					   qp_memcpy_from_queue_iov,
-					   true, vmci_can_block(qpair->flags));
+					   true);
 
 		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
 		    !qp_wait_for_ready_queue(qpair))
@@ -3411,7 +3306,7 @@ ssize_t vmci_qpair_peekv(struct vmci_qp *qpair,
 					   qpair->consume_q_size,
 					   iov, iov_size,
 					   qp_memcpy_from_queue_iov,
-					   false, vmci_can_block(qpair->flags));
+					   false);
 
 		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
 		    !qp_wait_for_ready_queue(qpair))
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.h b/drivers/misc/vmw_vmci/vmci_queue_pair.h
index 58c6959..ed177f0 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.h
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.h
@@ -146,24 +146,6 @@ VMCI_QP_PAGESTORE_IS_WELLFORMED(struct vmci_qp_page_store *page_store)
 	return page_store->len >= 2;
 }
 
-/*
- * Helper function to check if the non-blocking flag
- * is set for a given queue pair.
- */
-static inline bool vmci_can_block(u32 flags)
-{
-	return !(flags & VMCI_QPFLAG_NONBLOCK);
-}
-
-/*
- * Helper function to check if the queue pair is pinned
- * into memory.
- */
-static inline bool vmci_qp_pinned(u32 flags)
-{
-	return flags & VMCI_QPFLAG_PINNED;
-}
-
 void vmci_qp_broker_exit(void);
 int vmci_qp_broker_alloc(struct vmci_handle handle, u32 peer,
 			 u32 flags, u32 priv_flags,
-- 
1.7.4.1

