Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3AJXlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:41:47 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55379 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421Ab3AJXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:41:44 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: [PATCH 2/6] VMCI: Remove dependency on BLOCK I/O
Date: Thu, 10 Jan 2013 15:41:39 -0800
Message-Id: <1357861303-25903-2-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357861303-25903-1-git-send-email-dtor@vmware.com>
References: <1357861303-25903-1-git-send-email-dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy King <acking@vmware.com>

No need to bring in dm-mapper.h and along with it a dependency on BLOCK I/O
just to use dm_div_up().  Just use the existing DIV_ROUND_UP().

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andy King <acking@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 1123111..da47e45 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -13,12 +13,16 @@
  * for more details.
  */
 
-#include <linux/device-mapper.h>
 #include <linux/vmw_vmci_defs.h>
 #include <linux/vmw_vmci_api.h>
+#include <linux/highmem.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/pagemap.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/socket.h>
 #include <linux/wait.h>
 
@@ -246,9 +250,9 @@ static struct qp_list qp_guest_endpoints = {
 };
 
 #define INVALID_VMCI_GUEST_MEM_ID  0
-#define QPE_NUM_PAGES(_QPE) ((u32)					 \
-			     (dm_div_up(_QPE.produce_size, PAGE_SIZE) +	 \
-			      dm_div_up(_QPE.consume_size, PAGE_SIZE) + 2))
+#define QPE_NUM_PAGES(_QPE) ((u32) \
+			     (DIV_ROUND_UP(_QPE.produce_size, PAGE_SIZE) + \
+			      DIV_ROUND_UP(_QPE.consume_size, PAGE_SIZE) + 2))
 
 
 /*
@@ -260,7 +264,7 @@ static void qp_free_queue(void *q, u64 size)
 	struct vmci_queue *queue = q;
 
 	if (queue) {
-		u64 i = dm_div_up(size, PAGE_SIZE);
+		u64 i = DIV_ROUND_UP(size, PAGE_SIZE);
 
 		if (queue->kernel_if->mapped) {
 			vunmap(queue->kernel_if->va);
@@ -289,7 +293,7 @@ static void *qp_alloc_queue(u64 size, u32 flags)
 	u64 i;
 	struct vmci_queue *queue;
 	struct vmci_queue_header *q_header;
-	const u64 num_data_pages = dm_div_up(size, PAGE_SIZE);
+	const u64 num_data_pages = DIV_ROUND_UP(size, PAGE_SIZE);
 	const uint queue_size =
 	    PAGE_SIZE +
 	    sizeof(*queue) + sizeof(*(queue->kernel_if)) +
@@ -611,7 +615,7 @@ static int qp_memcpy_from_queue_iov(void *dest,
 static struct vmci_queue *qp_host_alloc_queue(u64 size)
 {
 	struct vmci_queue *queue;
-	const size_t num_pages = dm_div_up(size, PAGE_SIZE) + 1;
+	const size_t num_pages = DIV_ROUND_UP(size, PAGE_SIZE) + 1;
 	const size_t queue_size = sizeof(*queue) + sizeof(*(queue->kernel_if));
 	const size_t queue_page_size =
 	    num_pages * sizeof(*queue->kernel_if->page);
@@ -963,8 +967,8 @@ qp_guest_endpoint_create(struct vmci_handle handle,
 	int result;
 	struct qp_guest_endpoint *entry;
 	/* One page each for the queue headers. */
-	const u64 num_ppns = dm_div_up(produce_size, PAGE_SIZE) +
-	    dm_div_up(consume_size, PAGE_SIZE) + 2;
+	const u64 num_ppns = DIV_ROUND_UP(produce_size, PAGE_SIZE) +
+	    DIV_ROUND_UP(consume_size, PAGE_SIZE) + 2;
 
 	if (vmci_handle_is_invalid(handle)) {
 		u32 context_id = vmci_get_context_id();
@@ -1175,9 +1179,9 @@ static int qp_alloc_guest_work(struct vmci_handle *handle,
 			       u32 priv_flags)
 {
 	const u64 num_produce_pages =
-	    dm_div_up(produce_size, PAGE_SIZE) + 1;
+	    DIV_ROUND_UP(produce_size, PAGE_SIZE) + 1;
 	const u64 num_consume_pages =
-	    dm_div_up(consume_size, PAGE_SIZE) + 1;
+	    DIV_ROUND_UP(consume_size, PAGE_SIZE) + 1;
 	void *my_produce_q = NULL;
 	void *my_consume_q = NULL;
 	int result;
@@ -1456,7 +1460,7 @@ static int qp_broker_create(struct vmci_handle handle,
 		entry->state = VMCIQPB_CREATED_MEM;
 		entry->produce_q->q_header = entry->local_mem;
 		tmp = (u8 *)entry->local_mem + PAGE_SIZE *
-		    (dm_div_up(entry->qp.produce_size, PAGE_SIZE) + 1);
+		    (DIV_ROUND_UP(entry->qp.produce_size, PAGE_SIZE) + 1);
 		entry->consume_q->q_header = (struct vmci_queue_header *)tmp;
 	} else if (page_store) {
 		/*
-- 
1.7.4.1

