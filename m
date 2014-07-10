Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaGJWBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:01:33 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60385 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbaGJV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:07 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 67/83] hsa/radeon: Removing hw pointer store module
Date: Fri, 11 Jul 2014 00:54:23 +0300
Message-Id: <1405029279-6894-39-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This module is unnecessary as we allocating read/write pointers
from userspace thunk layer

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/Makefile                    |   2 +-
 drivers/gpu/hsa/radeon/kfd_chardev.c               |  22 +--
 drivers/gpu/hsa/radeon/kfd_hw_pointer_store.c      | 149 ---------------------
 drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h      |  64 ---------
 drivers/gpu/hsa/radeon/kfd_priv.h                  |  10 +-
 drivers/gpu/hsa/radeon/kfd_process.c               |   1 -
 drivers/gpu/hsa/radeon/kfd_process_queue_manager.c |  62 ++-------
 7 files changed, 23 insertions(+), 287 deletions(-)
 delete mode 100644 drivers/gpu/hsa/radeon/kfd_hw_pointer_store.c
 delete mode 100644 drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h

diff --git a/drivers/gpu/hsa/radeon/Makefile b/drivers/gpu/hsa/radeon/Makefile
index 3409203..26ce0ae 100644
--- a/drivers/gpu/hsa/radeon/Makefile
+++ b/drivers/gpu/hsa/radeon/Makefile
@@ -6,7 +6,7 @@ radeon_kfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o \
 		kfd_pasid.o kfd_topology.o kfd_process.o \
 		kfd_doorbell.o kfd_sched_cik_static.o kfd_registers.o \
 		kfd_vidmem.o kfd_interrupt.o kfd_aperture.o \
-		kfd_queue.o kfd_hw_pointer_store.o kfd_mqd_manager.o \
+		kfd_queue.o kfd_mqd_manager.o \
 		kfd_kernel_queue.o kfd_packet_manager.o \
 		kfd_process_queue_manager.o kfd_device_queue_manager.o
 
diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index b39df68..51f790f 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -32,9 +32,9 @@
 #include <linux/time.h>
 #include "kfd_priv.h"
 #include <linux/mm.h>
+#include <linux/uaccess.h>
 #include <uapi/asm-generic/mman-common.h>
 #include <asm/processor.h>
-#include "kfd_hw_pointer_store.h"
 #include "kfd_device_queue_manager.h"
 
 static long kfd_ioctl(struct file *, unsigned int, unsigned long);
@@ -137,24 +137,32 @@ kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *a
 	if (copy_from_user(&args, arg, sizeof(args)))
 		return -EFAULT;
 
-	/* need to validate parameters */
+	if (!access_ok(VERIFY_WRITE, args.read_pointer_address, sizeof(qptr_t)))
+		return -EFAULT;
+
+	if (!access_ok(VERIFY_WRITE, args.write_pointer_address, sizeof(qptr_t)))
+		return -EFAULT;
 
 	q_properties.is_interop = false;
 	q_properties.queue_percent = args.queue_percentage;
 	q_properties.priority = args.queue_priority;
 	q_properties.queue_address = args.ring_base_address;
 	q_properties.queue_size = args.ring_size;
+	q_properties.read_ptr = args.read_pointer_address;
+	q_properties.write_ptr = args.write_pointer_address;
 
 
 	pr_debug("%s Arguments: Queue Percentage (%d, %d)\n"
 			"Queue Priority (%d, %d)\n"
 			"Queue Address (0x%llX, 0x%llX)\n"
 			"Queue Size (%llX, %u)\n",
+			"Queue r/w Pointers (%llX, %llX)\n",
 			__func__,
 			q_properties.queue_percent, args.queue_percentage,
 			q_properties.priority, args.queue_priority,
 			q_properties.queue_address, args.ring_base_address,
-			q_properties.queue_size, args.ring_size);
+			q_properties.queue_size, args.ring_size,
+			q_properties.read_ptr, q_properties.write_ptr);
 
 	dev = radeon_kfd_device_by_id(args.gpu_id);
 	if (dev == NULL)
@@ -177,8 +185,6 @@ kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *a
 		goto err_create_queue;
 
 	args.queue_id = queue_id;
-	args.read_pointer_address = (uint64_t)q_properties.read_ptr;
-	args.write_pointer_address = (uint64_t)q_properties.write_ptr;
 	args.doorbell_address = (uint64_t)q_properties.doorbell_ptr;
 
 	if (copy_to_user(arg, &args, sizeof(args))) {
@@ -515,11 +521,5 @@ kfd_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (pgoff >= KFD_MMAP_DOORBELL_START && pgoff < KFD_MMAP_DOORBELL_END)
 		return radeon_kfd_doorbell_mmap(process, vma);
 
-	if (pgoff >= KFD_MMAP_RPTR_START && pgoff < KFD_MMAP_RPTR_END)
-		return radeon_kfd_hw_pointer_store_mmap(&process->read_ptr, vma);
-
-	if (pgoff >= KFD_MMAP_WPTR_START && pgoff < KFD_MMAP_WPTR_END)
-		return radeon_kfd_hw_pointer_store_mmap(&process->write_ptr, vma);
-
 	return -EINVAL;
 }
diff --git a/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.c b/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.c
deleted file mode 100644
index 4e71f7d..0000000
--- a/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.c
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- * Copyright 2014 Advanced Micro Devices, Inc.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- * OTHER DEALINGS IN THE SOFTWARE.
- *
- */
-
-#include <linux/types.h>
-#include <linux/version.h>
-#include <linux/kernel.h>
-#include <linux/mutex.h>
-#include <linux/mm.h>
-#include <linux/mman.h>
-#include <linux/slab.h>
-#include <linux/io.h>
-#include "kfd_hw_pointer_store.h"
-#include "kfd_priv.h"
-
-/* do the same trick as in map_doorbells() */
-static int hw_pointer_store_map(struct hw_pointer_store_properties *ptr,
-		struct file *devkfd)
-{
-	qptr_t __user *user_address;
-
-	BUG_ON(!ptr || !devkfd);
-
-	if (!ptr->page_mapping) {
-		if (!ptr->page_address)
-			return -EINVAL;
-
-		user_address = (qptr_t __user *)vm_mmap(devkfd, 0, PAGE_SIZE,
-			PROT_WRITE | PROT_READ , MAP_SHARED, ptr->offset);
-
-		if (IS_ERR(user_address))
-			return PTR_ERR(user_address);
-
-		ptr->page_mapping = user_address;
-	}
-
-	return 0;
-}
-
-int hw_pointer_store_init(struct hw_pointer_store_properties *ptr,
-		enum hw_pointer_store_type type)
-{
-	unsigned long *addr;
-
-	BUG_ON(!ptr);
-
-	/* using the offset value as a hint for mmap to distinguish between page types */
-	if (type == KFD_HW_POINTER_STORE_TYPE_RPTR)
-		ptr->offset = KFD_MMAP_RPTR_START << PAGE_SHIFT;
-	else if (type == KFD_HW_POINTER_STORE_TYPE_WPTR)
-		ptr->offset = KFD_MMAP_WPTR_START << PAGE_SHIFT;
-	else
-		return -EINVAL;
-
-	addr = (unsigned long *)get_zeroed_page(GFP_KERNEL);
-	if (!addr) {
-		pr_debug("Error allocating page\n");
-		return -ENOMEM;
-	}
-
-	ptr->page_address = addr;
-	ptr->page_mapping = NULL;
-
-	return 0;
-}
-
-void hw_pointer_store_destroy(struct hw_pointer_store_properties *ptr)
-{
-	BUG_ON(!ptr);
-	pr_debug("kfd in func: %s\n", __func__);
-	if (ptr->page_address)
-		free_page((unsigned long)ptr->page_address);
-	if (ptr->page_mapping)
-		vm_munmap((uintptr_t)ptr->page_mapping, PAGE_SIZE);
-	ptr->page_address = NULL;
-	ptr->page_mapping = NULL;
-}
-
-qptr_t __user *
-hw_pointer_store_create_queue(struct hw_pointer_store_properties *ptr,
-		unsigned int queue_id, struct file *devkfd)
-{
-	BUG_ON(!ptr || queue_id >= MAX_PROCESS_QUEUES);
-
-	/* mapping value to user space*/
-	hw_pointer_store_map(ptr, devkfd);
-
-	/* User process address */
-	if (!ptr->page_mapping) {
-		pr_debug(KERN_ERR "kfd: hw pointer store doesn't mapped to user space\n");
-		return NULL;
-	}
-
-	ptr->page_mapping[queue_id] = 0;
-
-	return ptr->page_mapping + queue_id;
-}
-
-unsigned long *hw_pointer_store_get_address
-	(struct hw_pointer_store_properties *ptr, unsigned int queue_id)
-{
-	return ptr->page_address + queue_id;
-}
-
-int radeon_kfd_hw_pointer_store_mmap(struct hw_pointer_store_properties *ptr,
-		struct vm_area_struct *vma)
-{
-	BUG_ON(!ptr || !vma);
-
-	if (vma->vm_end - vma->vm_start != PAGE_SIZE) {
-		pr_debug("start address(0x%lx) - end address(0x%lx) != len(0x%lx)\n",
-				vma->vm_end, vma->vm_start, PAGE_SIZE);
-		return -EINVAL;
-	}
-
-	vma->vm_flags |= VM_IO | VM_DONTCOPY | VM_DONTEXPAND | VM_NORESERVE
-		       | VM_DONTDUMP | VM_PFNMAP;
-
-	pr_debug("kfd: mapping hw pointer page in radeon_kfd_hw_pointer_store_mmap\n"
-			 "     target user address == 0x%016llX\n"
-			 "     physical address    == 0x%016lX\n"
-			 "     vm_flags            == 0x%08lX\n"
-			 "     size                == 0x%08lX\n",
-			 (long long unsigned int) vma->vm_start,
-			 __pa(ptr->page_address), vma->vm_flags, PAGE_SIZE);
-
-	/* mapping the page to user process */
-	return remap_pfn_range(vma, vma->vm_start, __pa(ptr->page_address) >> PAGE_SHIFT, PAGE_SIZE, vma->vm_page_prot);
-}
-
diff --git a/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h b/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h
deleted file mode 100644
index 642703f..0000000
--- a/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Copyright 2014 Advanced Micro Devices, Inc.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- * OTHER DEALINGS IN THE SOFTWARE.
- *
- */
-
-#ifndef KFD_HW_POINTER_STORE_H_
-#define KFD_HW_POINTER_STORE_H_
-
-#include <linux/mutex.h>
-
-/* Type that represents a HW doorbell slot. and read/write HW pointers */
-typedef u32 qptr_t;
-
-/* Hw Pointer Store */
-enum hw_pointer_store_type {
-	KFD_HW_POINTER_STORE_TYPE_RPTR = 0,
-	KFD_HW_POINTER_STORE_TYPE_WPTR
-};
-
-struct hw_pointer_store_properties {
-	qptr_t __user		*page_mapping;
-	unsigned long		*page_address;
-	unsigned long		offset;
-};
-
-int
-hw_pointer_store_init(struct hw_pointer_store_properties *ptr,
-		enum hw_pointer_store_type type);
-
-void
-hw_pointer_store_destroy(struct hw_pointer_store_properties *ptr);
-
-qptr_t __user *
-hw_pointer_store_create_queue(struct hw_pointer_store_properties *ptr,
-		unsigned int queue_id, struct file *devkfd);
-
-unsigned long *
-hw_pointer_store_get_address(struct hw_pointer_store_properties *ptr,
-		unsigned int queue_id);
-
-int
-radeon_kfd_hw_pointer_store_mmap(struct hw_pointer_store_properties *ptr,
-		struct vm_area_struct *vma);
-
-
-#endif /* KFD_HW_POINTER_STORE_H_ */
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index e6d4993..97bf58a 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -31,7 +31,6 @@
 #include <linux/atomic.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
-#include "kfd_hw_pointer_store.h"
 
 struct kfd_scheduler_class;
 
@@ -50,10 +49,6 @@ struct kfd_scheduler_class;
 ** We figure out what type of memory the caller wanted by comparing the mmap page offset to known ranges. */
 #define KFD_MMAP_DOORBELL_START	(((1ULL << 32)*1) >> PAGE_SHIFT)
 #define KFD_MMAP_DOORBELL_END	(((1ULL << 32)*2) >> PAGE_SHIFT)
-#define KFD_MMAP_RPTR_START	KFD_MMAP_DOORBELL_END
-#define KFD_MMAP_RPTR_END	(((1ULL << 32)*3) >> PAGE_SHIFT)
-#define KFD_MMAP_WPTR_START	KFD_MMAP_RPTR_END
-#define KFD_MMAP_WPTR_END	(((1ULL << 32)*4) >> PAGE_SHIFT)
 
 /*
  * When working with cp scheduler we should assign the HIQ manually or via the radeon driver
@@ -85,6 +80,8 @@ typedef unsigned int pasid_t;
 
 /* Type that represents a HW doorbell slot. */
 typedef u32 doorbell_t;
+/* Type that represents queue pointer */
+typedef u32 qptr_t;
 
 enum cache_policy {
 	cache_policy_coherent,
@@ -350,9 +347,6 @@ struct kfd_process {
 	/* List of kfd_process_device structures, one for each device the process is using. */
 	struct list_head per_device_data;
 
-	struct hw_pointer_store_properties write_ptr;
-	struct hw_pointer_store_properties read_ptr;
-
 	struct process_queue_manager pqm;
 
 	/* The process's queues. */
diff --git a/drivers/gpu/hsa/radeon/kfd_process.c b/drivers/gpu/hsa/radeon/kfd_process.c
index 9bb5cab..eb30cb3 100644
--- a/drivers/gpu/hsa/radeon/kfd_process.c
+++ b/drivers/gpu/hsa/radeon/kfd_process.c
@@ -168,7 +168,6 @@ static struct kfd_process *create_process(const struct task_struct *thread)
 
 	INIT_LIST_HEAD(&process->per_device_data);
 
-	process->read_ptr.page_mapping = process->write_ptr.page_mapping = NULL;
 	err = pqm_init(&process->pqm, process);
 	if (err != 0)
 		goto err_process_pqm_init;
diff --git a/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
index 2034d2b..89461ab 100644
--- a/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
@@ -25,7 +25,6 @@
 #include <linux/list.h>
 #include "kfd_device_queue_manager.h"
 #include "kfd_priv.h"
-#include "kfd_hw_pointer_store.h"
 #include "kfd_kernel_queue.h"
 
 static inline struct process_queue_node *get_queue_by_qid(struct process_queue_manager *pqm, unsigned int qid)
@@ -44,46 +43,6 @@ static inline struct process_queue_node *get_queue_by_qid(struct process_queue_m
 	return NULL;
 }
 
-static int allocate_hw_pointers(struct process_queue_manager *pqm,
-				struct queue_properties *q_properties,
-				struct file *f, struct kfd_dev *dev,
-				unsigned int qid)
-{
-	int retval;
-
-	BUG_ON(!pqm || !q_properties);
-
-	retval = 0;
-
-	pr_debug("kfd: In func %s\n", __func__);
-
-	/* allocates r/w pointers in lazy mode */
-	if (pqm->process->read_ptr.page_mapping == NULL)
-		if (hw_pointer_store_init(&pqm->process->read_ptr, KFD_HW_POINTER_STORE_TYPE_RPTR) != 0)
-			return -EBUSY;
-	if (pqm->process->write_ptr.page_mapping == NULL)
-		if (hw_pointer_store_init(&pqm->process->write_ptr, KFD_HW_POINTER_STORE_TYPE_WPTR) != 0) {
-			hw_pointer_store_destroy(&pqm->process->read_ptr);
-			return -EBUSY;
-		}
-
-	q_properties->read_ptr = hw_pointer_store_create_queue(&pqm->process->read_ptr, qid, f);
-	if (!q_properties->read_ptr)
-		return -ENOMEM;
-
-	q_properties->write_ptr = hw_pointer_store_create_queue(&pqm->process->write_ptr, qid, f);
-	if (!q_properties->write_ptr)
-		return -ENOMEM;
-
-	q_properties->doorbell_ptr = radeon_kfd_get_doorbell(f, pqm->process, dev, qid);
-	if (!q_properties->doorbell_ptr)
-		return -ENOMEM;
-
-	q_properties->doorbell_off = radeon_kfd_queue_id_to_doorbell(dev, pqm->process, qid);
-
-	return retval;
-}
-
 static int find_available_queue_slot(struct process_queue_manager *pqm, unsigned int *qid)
 {
 	unsigned long found;
@@ -133,15 +92,13 @@ void pqm_uninit(struct process_queue_manager *pqm)
 				(pqn->q != NULL) ?
 					pqn->q->properties.queue_id :
 					pqn->kq->queue->properties.queue_id);
-		if (retval != 0)
+
+		if (retval != 0) {
+			pr_err("kfd: failed to destroy queue\n");
 			return;
+		}
 	}
 	kfree(pqm->queue_slot_bitmap);
-
-	if (pqm->process->read_ptr.page_mapping)
-		hw_pointer_store_destroy(&pqm->process->read_ptr);
-	if (pqm->process->write_ptr.page_mapping)
-		hw_pointer_store_destroy(&pqm->process->write_ptr);
 }
 
 static int create_cp_queue(struct process_queue_manager *pqm, struct kfd_dev *dev, struct queue **q,
@@ -151,11 +108,11 @@ static int create_cp_queue(struct process_queue_manager *pqm, struct kfd_dev *de
 
 	retval = 0;
 
-	/* allocate hw pointers */
-	if (allocate_hw_pointers(pqm, q_properties, f, dev, qid) != 0) {
-		retval = -ENOMEM;
-		goto err_allocate_hw_pointers;
-	}
+	q_properties->doorbell_ptr = radeon_kfd_get_doorbell(f, pqm->process, dev, qid);
+		if (!q_properties->doorbell_ptr)
+			return -ENOMEM;
+
+	q_properties->doorbell_off = radeon_kfd_queue_id_to_doorbell(dev, pqm->process, qid);
 
 	/* let DQM handle it*/
 	q_properties->vmid = 0;
@@ -174,7 +131,6 @@ static int create_cp_queue(struct process_queue_manager *pqm, struct kfd_dev *de
 	return retval;
 
 err_init_queue:
-err_allocate_hw_pointers:
 	return retval;
 }
 
-- 
1.9.1

