Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3HTRj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:39:28 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:33035 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab3HTRj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:39:26 -0400
From: Andy King <acking@vmware.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: gregkh@linuxfoundation.org, pv-drivers@vmware.com,
        Andy King <acking@vmware.com>
Subject: [PATCH 2/2] VMCI: Add support for virtual IOMMU
Date: Tue, 20 Aug 2013 10:30:03 -0700
Message-Id: <1377019803-1490-3-git-send-email-acking@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1377019803-1490-1-git-send-email-acking@vmware.com>
References: <1377019803-1490-1-git-send-email-acking@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we use vmalloc()/alloc_page() for our guest queuepair pages
and then do a virt_to_phys() before passing them down to the device.
That's not going to work if DMA remapping is enabled, since the IOMMU
has no idea about the mappings.  Switch to pci_alloc_consistent()
instead.  We still allocate each page individually, since there's no
guarantee that we'll get a contiguous block of physical for an entire
queuepair (especially since we allow up to 128 MiB!).

Also made the split between guest and host in the kernelIf struct much
clearer.  Now it's obvious which fields are which.

Acked-by: George Zhang <georgezhang@vmware.com>
Acked-by: Aditya Sarwade <asarwade@vmware.com>
Signed-off-by: Andy King <acking@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_driver.c     |    2 +-
 drivers/misc/vmw_vmci/vmci_driver.h     |    7 ++
 drivers/misc/vmw_vmci/vmci_guest.c      |   21 +++-
 drivers/misc/vmw_vmci/vmci_queue_pair.c |  179 ++++++++++++++++++-------------
 4 files changed, 126 insertions(+), 83 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_driver.c b/drivers/misc/vmw_vmci/vmci_driver.c
index 7b3fce2..3dee7ae 100644
--- a/drivers/misc/vmw_vmci/vmci_driver.c
+++ b/drivers/misc/vmw_vmci/vmci_driver.c
@@ -113,5 +113,5 @@ module_exit(vmci_drv_exit);
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Virtual Machine Communication Interface.");
-MODULE_VERSION("1.0.0.0-k");
+MODULE_VERSION("1.1.0.0-k");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/misc/vmw_vmci/vmci_driver.h b/drivers/misc/vmw_vmci/vmci_driver.h
index f69156a..cee9e97 100644
--- a/drivers/misc/vmw_vmci/vmci_driver.h
+++ b/drivers/misc/vmw_vmci/vmci_driver.h
@@ -35,6 +35,13 @@ struct vmci_obj {
 	enum vmci_obj_type type;
 };
 
+/*
+ * Needed by other components of this module.  It's okay to have one global
+ * instance of this because there can only ever be one VMCI device.  Our
+ * virtual hardware enforces this.
+ */
+extern struct pci_dev *vmci_pdev;
+
 u32 vmci_get_context_id(void);
 int vmci_send_datagram(struct vmci_datagram *dg);
 
diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index 60c0199..2485c02 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -65,9 +65,11 @@ struct vmci_guest_device {
 
 	void *data_buffer;
 	void *notification_bitmap;
+	dma_addr_t notification_base;
 };
 
 /* vmci_dev singleton device and supporting data*/
+struct pci_dev *vmci_pdev;
 static struct vmci_guest_device *vmci_dev_g;
 static DEFINE_SPINLOCK(vmci_dev_spinlock);
 
@@ -528,7 +530,8 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	 * well.
 	 */
 	if (capabilities & VMCI_CAPS_NOTIFICATIONS) {
-		vmci_dev->notification_bitmap = vmalloc(PAGE_SIZE);
+		vmci_dev->notification_bitmap = pci_alloc_consistent(
+			pdev, PAGE_SIZE, &vmci_dev->notification_base);
 		if (!vmci_dev->notification_bitmap) {
 			dev_warn(&pdev->dev,
 				 "Unable to allocate notification bitmap\n");
@@ -546,6 +549,7 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	/* Set up global device so that we can start sending datagrams */
 	spin_lock_irq(&vmci_dev_spinlock);
 	vmci_dev_g = vmci_dev;
+	vmci_pdev = pdev;
 	spin_unlock_irq(&vmci_dev_spinlock);
 
 	/*
@@ -553,9 +557,8 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	 * used.
 	 */
 	if (capabilities & VMCI_CAPS_NOTIFICATIONS) {
-		struct page *page =
-			vmalloc_to_page(vmci_dev->notification_bitmap);
-		unsigned long bitmap_ppn = page_to_pfn(page);
+		unsigned long bitmap_ppn =
+			vmci_dev->notification_base >> PAGE_SHIFT;
 		if (!vmci_dbell_register_notification_bitmap(bitmap_ppn)) {
 			dev_warn(&pdev->dev,
 				 "VMCI device unable to register notification bitmap with PPN 0x%x\n",
@@ -665,11 +668,14 @@ err_remove_bitmap:
 	if (vmci_dev->notification_bitmap) {
 		iowrite32(VMCI_CONTROL_RESET,
 			  vmci_dev->iobase + VMCI_CONTROL_ADDR);
-		vfree(vmci_dev->notification_bitmap);
+		pci_free_consistent(pdev, PAGE_SIZE,
+				    vmci_dev->notification_bitmap,
+				    vmci_dev->notification_base);
 	}
 
 err_remove_vmci_dev_g:
 	spin_lock_irq(&vmci_dev_spinlock);
+	vmci_pdev = NULL;
 	vmci_dev_g = NULL;
 	spin_unlock_irq(&vmci_dev_spinlock);
 
@@ -699,6 +705,7 @@ static void vmci_guest_remove_device(struct pci_dev *pdev)
 
 	spin_lock_irq(&vmci_dev_spinlock);
 	vmci_dev_g = NULL;
+	vmci_pdev = NULL;
 	spin_unlock_irq(&vmci_dev_spinlock);
 
 	dev_dbg(&pdev->dev, "Resetting vmci device\n");
@@ -727,7 +734,9 @@ static void vmci_guest_remove_device(struct pci_dev *pdev)
 		 * device, so we can safely free it here.
 		 */
 
-		vfree(vmci_dev->notification_bitmap);
+		pci_free_consistent(pdev, PAGE_SIZE,
+				    vmci_dev->notification_bitmap,
+				    vmci_dev->notification_base);
 	}
 
 	vfree(vmci_dev->data_buffer);
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 8698e0c..e27734a 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
+#include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/uio.h>
@@ -146,12 +147,20 @@ typedef int vmci_memcpy_from_queue_func(void *dest, size_t dest_offset,
 
 /* The Kernel specific component of the struct vmci_queue structure. */
 struct vmci_queue_kern_if {
-	struct page **page;
-	struct page **header_page;
 	struct mutex __mutex;	/* Protects the queue. */
 	struct mutex *mutex;	/* Shared by producer and consumer queues. */
-	bool host;
-	size_t num_pages;
+	size_t num_pages;	/* Number of pages incl. header. */
+	bool host;		/* Host or guest? */
+	union {
+		struct {
+			dma_addr_t *pas;
+			void **vas;
+		} g;		/* Used by the guest. */
+		struct {
+			struct page **page;
+			struct page **header_page;
+		} h;		/* Used by the host. */
+	} u;
 };
 
 /*
@@ -263,59 +272,64 @@ static void qp_free_queue(void *q, u64 size)
 	struct vmci_queue *queue = q;
 
 	if (queue) {
-		u64 i = DIV_ROUND_UP(size, PAGE_SIZE);
+		u64 i;
 
-		while (i)
-			__free_page(queue->kernel_if->page[--i]);
+		/* Given size does not include header, so add in a page here. */
+		for (i = 0; i < DIV_ROUND_UP(size, PAGE_SIZE) + 1; i++) {
+			pci_free_consistent(vmci_pdev, PAGE_SIZE,
+				queue->kernel_if->u.g.vas[i],
+				queue->kernel_if->u.g.pas[i]);
+		}
 
-		vfree(queue->q_header);
+		vfree(queue);
 	}
 }
 
 /*
- * Allocates kernel VA space of specified size, plus space for the
- * queue structure/kernel interface and the queue header.  Allocates
- * physical pages for the queue data pages.
- *
- * PAGE m:      struct vmci_queue_header (struct vmci_queue->q_header)
- * PAGE m+1:    struct vmci_queue
- * PAGE m+1+q:  struct vmci_queue_kern_if (struct vmci_queue->kernel_if)
- * PAGE n-size: Data pages (struct vmci_queue->kernel_if->page[])
+ * Allocates kernel queue pages of specified size with IOMMU mappings,
+ * plus space for the queue structure/kernel interface and the queue
+ * header.
  */
 static void *qp_alloc_queue(u64 size, u32 flags)
 {
 	u64 i;
 	struct vmci_queue *queue;
-	struct vmci_queue_header *q_header;
-	const u64 num_data_pages = DIV_ROUND_UP(size, PAGE_SIZE);
-	const uint queue_size =
-	    PAGE_SIZE +
-	    sizeof(*queue) + sizeof(*(queue->kernel_if)) +
-	    num_data_pages * sizeof(*(queue->kernel_if->page));
-
-	q_header = vmalloc(queue_size);
-	if (!q_header)
+	const size_t num_pages = DIV_ROUND_UP(size, PAGE_SIZE) + 1;
+	const size_t pas_size = num_pages * sizeof(*queue->kernel_if->u.g.pas);
+	const size_t vas_size = num_pages * sizeof(*queue->kernel_if->u.g.vas);
+	const size_t queue_size =
+		sizeof(*queue) + sizeof(*queue->kernel_if) +
+		pas_size + vas_size;
+
+	queue = vmalloc(queue_size);
+	if (!queue)
 		return NULL;
 
-	queue = (void *)q_header + PAGE_SIZE;
-	queue->q_header = q_header;
+	queue->q_header = NULL;
 	queue->saved_header = NULL;
 	queue->kernel_if = (struct vmci_queue_kern_if *)(queue + 1);
-	queue->kernel_if->header_page = NULL;	/* Unused in guest. */
-	queue->kernel_if->page = (struct page **)(queue->kernel_if + 1);
+	queue->kernel_if->mutex = NULL;
+	queue->kernel_if->num_pages = num_pages;
+	queue->kernel_if->u.g.pas = (dma_addr_t *)(queue->kernel_if + 1);
+	queue->kernel_if->u.g.vas =
+		(void **)((u8 *)queue->kernel_if->u.g.pas + pas_size);
 	queue->kernel_if->host = false;
 
-	for (i = 0; i < num_data_pages; i++) {
-		queue->kernel_if->page[i] = alloc_pages(GFP_KERNEL, 0);
-		if (!queue->kernel_if->page[i])
-			goto fail;
+	for (i = 0; i < num_pages; i++) {
+		queue->kernel_if->u.g.vas[i] =
+			pci_alloc_consistent(vmci_pdev, PAGE_SIZE,
+					     &queue->kernel_if->u.g.pas[i]);
+		if (!queue->kernel_if->u.g.vas[i]) {
+			/* Size excl. the header. */
+			qp_free_queue(queue, i * PAGE_SIZE);
+			return NULL;
+		}
 	}
 
-	return (void *)queue;
+	/* Queue header is the first page. */
+	queue->q_header = queue->kernel_if->u.g.vas[0];
 
- fail:
-	qp_free_queue(queue, i * PAGE_SIZE);
-	return NULL;
+	return (void *)queue;
 }
 
 /*
@@ -334,13 +348,18 @@ static int __qp_memcpy_to_queue(struct vmci_queue *queue,
 	size_t bytes_copied = 0;
 
 	while (bytes_copied < size) {
-		u64 page_index = (queue_offset + bytes_copied) / PAGE_SIZE;
-		size_t page_offset =
+		const u64 page_index =
+			(queue_offset + bytes_copied) / PAGE_SIZE;
+		const size_t page_offset =
 		    (queue_offset + bytes_copied) & (PAGE_SIZE - 1);
 		void *va;
 		size_t to_copy;
 
-		va = kmap(kernel_if->page[page_index]);
+		if (kernel_if->host)
+			va = kmap(kernel_if->u.h.page[page_index]);
+		else
+			va = kernel_if->u.g.vas[page_index + 1];
+			/* Skip header. */
 
 		if (size - bytes_copied > PAGE_SIZE - page_offset)
 			/* Enough payload to fill up from this page. */
@@ -356,7 +375,8 @@ static int __qp_memcpy_to_queue(struct vmci_queue *queue,
 			err = memcpy_fromiovec((u8 *)va + page_offset,
 					       iov, to_copy);
 			if (err != 0) {
-				kunmap(kernel_if->page[page_index]);
+				if (kernel_if->host)
+					kunmap(kernel_if->u.h.page[page_index]);
 				return VMCI_ERROR_INVALID_ARGS;
 			}
 		} else {
@@ -365,7 +385,8 @@ static int __qp_memcpy_to_queue(struct vmci_queue *queue,
 		}
 
 		bytes_copied += to_copy;
-		kunmap(kernel_if->page[page_index]);
+		if (kernel_if->host)
+			kunmap(kernel_if->u.h.page[page_index]);
 	}
 
 	return VMCI_SUCCESS;
@@ -387,13 +408,18 @@ static int __qp_memcpy_from_queue(void *dest,
 	size_t bytes_copied = 0;
 
 	while (bytes_copied < size) {
-		u64 page_index = (queue_offset + bytes_copied) / PAGE_SIZE;
-		size_t page_offset =
+		const u64 page_index =
+			(queue_offset + bytes_copied) / PAGE_SIZE;
+		const size_t page_offset =
 		    (queue_offset + bytes_copied) & (PAGE_SIZE - 1);
 		void *va;
 		size_t to_copy;
 
-		va = kmap(kernel_if->page[page_index]);
+		if (kernel_if->host)
+			va = kmap(kernel_if->u.h.page[page_index]);
+		else
+			va = kernel_if->u.g.vas[page_index + 1];
+			/* Skip header. */
 
 		if (size - bytes_copied > PAGE_SIZE - page_offset)
 			/* Enough payload to fill up this page. */
@@ -409,7 +435,8 @@ static int __qp_memcpy_from_queue(void *dest,
 			err = memcpy_toiovec(iov, (u8 *)va + page_offset,
 					     to_copy);
 			if (err != 0) {
-				kunmap(kernel_if->page[page_index]);
+				if (kernel_if->host)
+					kunmap(kernel_if->u.h.page[page_index]);
 				return VMCI_ERROR_INVALID_ARGS;
 			}
 		} else {
@@ -418,7 +445,8 @@ static int __qp_memcpy_from_queue(void *dest,
 		}
 
 		bytes_copied += to_copy;
-		kunmap(kernel_if->page[page_index]);
+		if (kernel_if->host)
+			kunmap(kernel_if->u.h.page[page_index]);
 	}
 
 	return VMCI_SUCCESS;
@@ -460,12 +488,11 @@ static int qp_alloc_ppn_set(void *prod_q,
 		return VMCI_ERROR_NO_MEM;
 	}
 
-	produce_ppns[0] = page_to_pfn(vmalloc_to_page(produce_q->q_header));
-	for (i = 1; i < num_produce_pages; i++) {
+	for (i = 0; i < num_produce_pages; i++) {
 		unsigned long pfn;
 
 		produce_ppns[i] =
-		    page_to_pfn(produce_q->kernel_if->page[i - 1]);
+			produce_q->kernel_if->u.g.pas[i] >> PAGE_SHIFT;
 		pfn = produce_ppns[i];
 
 		/* Fail allocation if PFN isn't supported by hypervisor. */
@@ -474,12 +501,11 @@ static int qp_alloc_ppn_set(void *prod_q,
 			goto ppn_error;
 	}
 
-	consume_ppns[0] = page_to_pfn(vmalloc_to_page(consume_q->q_header));
-	for (i = 1; i < num_consume_pages; i++) {
+	for (i = 0; i < num_consume_pages; i++) {
 		unsigned long pfn;
 
 		consume_ppns[i] =
-		    page_to_pfn(consume_q->kernel_if->page[i - 1]);
+			consume_q->kernel_if->u.g.pas[i] >> PAGE_SHIFT;
 		pfn = consume_ppns[i];
 
 		/* Fail allocation if PFN isn't supported by hypervisor. */
@@ -590,21 +616,20 @@ static struct vmci_queue *qp_host_alloc_queue(u64 size)
 	const size_t num_pages = DIV_ROUND_UP(size, PAGE_SIZE) + 1;
 	const size_t queue_size = sizeof(*queue) + sizeof(*(queue->kernel_if));
 	const size_t queue_page_size =
-	    num_pages * sizeof(*queue->kernel_if->page);
+	    num_pages * sizeof(*queue->kernel_if->u.h.page);
 
 	queue = kzalloc(queue_size + queue_page_size, GFP_KERNEL);
 	if (queue) {
 		queue->q_header = NULL;
 		queue->saved_header = NULL;
-		queue->kernel_if =
-		    (struct vmci_queue_kern_if *)((u8 *)queue +
-						  sizeof(*queue));
+		queue->kernel_if = (struct vmci_queue_kern_if *)(queue + 1);
 		queue->kernel_if->host = true;
 		queue->kernel_if->mutex = NULL;
 		queue->kernel_if->num_pages = num_pages;
-		queue->kernel_if->header_page =
+		queue->kernel_if->u.h.header_page =
 		    (struct page **)((u8 *)queue + queue_size);
-		queue->kernel_if->page = &queue->kernel_if->header_page[1];
+		queue->kernel_if->u.h.page =
+			&queue->kernel_if->u.h.header_page[1];
 	}
 
 	return queue;
@@ -711,11 +736,12 @@ static int qp_host_get_user_memory(u64 produce_uva,
 				current->mm,
 				(uintptr_t) produce_uva,
 				produce_q->kernel_if->num_pages,
-				1, 0, produce_q->kernel_if->header_page, NULL);
+				1, 0,
+				produce_q->kernel_if->u.h.header_page, NULL);
 	if (retval < produce_q->kernel_if->num_pages) {
 		pr_warn("get_user_pages(produce) failed (retval=%d)", retval);
-		qp_release_pages(produce_q->kernel_if->header_page, retval,
-				 false);
+		qp_release_pages(produce_q->kernel_if->u.h.header_page,
+				 retval, false);
 		err = VMCI_ERROR_NO_MEM;
 		goto out;
 	}
@@ -724,12 +750,13 @@ static int qp_host_get_user_memory(u64 produce_uva,
 				current->mm,
 				(uintptr_t) consume_uva,
 				consume_q->kernel_if->num_pages,
-				1, 0, consume_q->kernel_if->header_page, NULL);
+				1, 0,
+				consume_q->kernel_if->u.h.header_page, NULL);
 	if (retval < consume_q->kernel_if->num_pages) {
 		pr_warn("get_user_pages(consume) failed (retval=%d)", retval);
-		qp_release_pages(consume_q->kernel_if->header_page, retval,
-				 false);
-		qp_release_pages(produce_q->kernel_if->header_page,
+		qp_release_pages(consume_q->kernel_if->u.h.header_page,
+				 retval, false);
+		qp_release_pages(produce_q->kernel_if->u.h.header_page,
 				 produce_q->kernel_if->num_pages, false);
 		err = VMCI_ERROR_NO_MEM;
 	}
@@ -772,15 +799,15 @@ static int qp_host_register_user_memory(struct vmci_qp_page_store *page_store,
 static void qp_host_unregister_user_memory(struct vmci_queue *produce_q,
 					   struct vmci_queue *consume_q)
 {
-	qp_release_pages(produce_q->kernel_if->header_page,
+	qp_release_pages(produce_q->kernel_if->u.h.header_page,
 			 produce_q->kernel_if->num_pages, true);
-	memset(produce_q->kernel_if->header_page, 0,
-	       sizeof(*produce_q->kernel_if->header_page) *
+	memset(produce_q->kernel_if->u.h.header_page, 0,
+	       sizeof(*produce_q->kernel_if->u.h.header_page) *
 	       produce_q->kernel_if->num_pages);
-	qp_release_pages(consume_q->kernel_if->header_page,
+	qp_release_pages(consume_q->kernel_if->u.h.header_page,
 			 consume_q->kernel_if->num_pages, true);
-	memset(consume_q->kernel_if->header_page, 0,
-	       sizeof(*consume_q->kernel_if->header_page) *
+	memset(consume_q->kernel_if->u.h.header_page, 0,
+	       sizeof(*consume_q->kernel_if->u.h.header_page) *
 	       consume_q->kernel_if->num_pages);
 }
 
@@ -803,12 +830,12 @@ static int qp_host_map_queues(struct vmci_queue *produce_q,
 		if (produce_q->q_header != consume_q->q_header)
 			return VMCI_ERROR_QUEUEPAIR_MISMATCH;
 
-		if (produce_q->kernel_if->header_page == NULL ||
-		    *produce_q->kernel_if->header_page == NULL)
+		if (produce_q->kernel_if->u.h.header_page == NULL ||
+		    *produce_q->kernel_if->u.h.header_page == NULL)
 			return VMCI_ERROR_UNAVAILABLE;
 
-		headers[0] = *produce_q->kernel_if->header_page;
-		headers[1] = *consume_q->kernel_if->header_page;
+		headers[0] = *produce_q->kernel_if->u.h.header_page;
+		headers[1] = *consume_q->kernel_if->u.h.header_page;
 
 		produce_q->q_header = vmap(headers, 2, VM_MAP, PAGE_KERNEL);
 		if (produce_q->q_header != NULL) {
-- 
1.7.4.1

