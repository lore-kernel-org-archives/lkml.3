Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3J0VtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:49:09 -0400
Received: from www84.your-server.de ([213.133.104.84]:39707 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab3J0VtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:49:07 -0400
From: Stefani Seibold <stefani@seibold.net>
To: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: stefani@seibold.net
Subject: [PATCH] kfifo API type safety
Date: Sun, 27 Oct 2013 22:48:53 +0100
Message-Id: <1382910533-8936-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.4
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances the type safety for the kfifo API. It is now safe to put
const data into a non const FIFO and the API will now generate a compiler
warning when reading from the fifo where the destination address is pointing to
a const variable.

As a side effect the kfifo_put() does now expect the value of an element
instead a pointer to the element. This was suggested Russel King. It make the
handling of the kfifo_put easier since there is no need to create a
helper variable for getting the address of a pointer or to pass integers
of different sizes.

IMHO the API break is okay, since there are currently only six users of
kfifo_put().

The code is also cleaner by kicking out the "if (0)" expressions.

The patch is against 3.12.0-rc6

- Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/gpu/drm/drm_flip_work.c         |  2 +-
 drivers/iio/industrialio-event.c        |  2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c |  2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |  2 +-
 drivers/pci/pcie/aer/aerdrv_core.c      |  2 +-
 include/linux/kfifo.h                   | 47 ++++++++++-----------------------
 mm/memory-failure.c                     |  2 +-
 samples/kfifo/bytestream-example.c      |  4 +--
 samples/kfifo/dma-example.c             |  2 +-
 samples/kfifo/inttype-example.c         |  4 +--
 10 files changed, 25 insertions(+), 44 deletions(-)

diff --git a/drivers/gpu/drm/drm_flip_work.c b/drivers/gpu/drm/drm_flip_work.c
index e788882..f9c7fa3 100644
--- a/drivers/gpu/drm/drm_flip_work.c
+++ b/drivers/gpu/drm/drm_flip_work.c
@@ -34,7 +34,7 @@
  */
 void drm_flip_work_queue(struct drm_flip_work *work, void *val)
 {
-	if (kfifo_put(&work->fifo, (const void **)&val)) {
+	if (kfifo_put(&work->fifo, val)) {
 		atomic_inc(&work->pending);
 	} else {
 		DRM_ERROR("%s fifo full!\n", work->name);
diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index 6be65ef..3431443 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -56,7 +56,7 @@ int iio_push_event(struct iio_dev *indio_dev, u64 ev_code, s64 timestamp)
 		ev.id = ev_code;
 		ev.timestamp = timestamp;
 
-		copied = kfifo_put(&ev_int->det_events, &ev);
+		copied = kfifo_put(&ev_int->det_events, ev);
 		if (copied != 0)
 			wake_up_locked_poll(&ev_int->wait, POLLIN);
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index f8f2abb..fce25ee 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1025,7 +1025,7 @@ static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
 			break;
 
-		if (!kfifo_put(&rt2x00dev->txstatus_fifo, &status)) {
+		if (!kfifo_put(&rt2x00dev->txstatus_fifo, status)) {
 			rt2x00_warn(rt2x00dev, "TX status FIFO overrun, drop tx status report\n");
 			break;
 		}
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 96961b9..52eae82 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -162,7 +162,7 @@ static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 
 	valid = rt2x00_get_field32(tx_status, TX_STA_FIFO_VALID);
 	if (valid) {
-		if (!kfifo_put(&rt2x00dev->txstatus_fifo, &tx_status))
+		if (!kfifo_put(&rt2x00dev->txstatus_fifo, tx_status))
 			rt2x00_warn(rt2x00dev, "TX status FIFO overrun\n");
 
 		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 85ca36f..6b3a958 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -574,7 +574,7 @@ void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
 	};
 
 	spin_lock_irqsave(&aer_recover_ring_lock, flags);
-	if (kfifo_put(&aer_recover_ring, &entry))
+	if (kfifo_put(&aer_recover_ring, entry))
 		schedule_work(&aer_recover_work);
 	else
 		pr_err("AER recover: Buffer overflow when recovering AER for %04x:%02x:%02x:%x\n",
diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 10308c6..b358d9a 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -1,7 +1,7 @@
 /*
  * A generic kernel FIFO implementation
  *
- * Copyright (C) 2009/2010 Stefani Seibold <stefani@seibold.net>
+ * Copyright (C) 2013 Stefani Seibold <stefani@seibold.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -67,9 +67,10 @@ struct __kfifo {
 	union { \
 		struct __kfifo	kfifo; \
 		datatype	*type; \
+		const datatype	*const_type; \
 		char		(*rectype)[recsize]; \
 		ptrtype		*ptr; \
-		const ptrtype	*ptr_const; \
+		ptrtype const	*ptr_const; \
 	}
 
 #define __STRUCT_KFIFO(type, size, recsize, ptrtype) \
@@ -386,16 +387,12 @@ __kfifo_int_must_check_helper( \
 #define	kfifo_put(fifo, val) \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
-	typeof((val) + 1) __val = (val); \
+	typeof(*__tmp->const_type) __val = (val); \
 	unsigned int __ret; \
-	const size_t __recsize = sizeof(*__tmp->rectype); \
+	size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
-		__dummy = (typeof(__val))NULL; \
-	} \
 	if (__recsize) \
-		__ret = __kfifo_in_r(__kfifo, __val, sizeof(*__val), \
+		__ret = __kfifo_in_r(__kfifo, &__val, sizeof(__val), \
 			__recsize); \
 	else { \
 		__ret = !kfifo_is_full(__tmp); \
@@ -404,7 +401,7 @@ __kfifo_int_must_check_helper( \
 			((typeof(__tmp->type))__kfifo->data) : \
 			(__tmp->buf) \
 			)[__kfifo->in & __tmp->kfifo.mask] = \
-				*(typeof(__tmp->type))__val; \
+				(typeof(*__tmp->type))__val; \
 			smp_wmb(); \
 			__kfifo->in++; \
 		} \
@@ -415,7 +412,7 @@ __kfifo_int_must_check_helper( \
 /**
  * kfifo_get - get data from the fifo
  * @fifo: address of the fifo to be used
- * @val: the var where to store the data to be added
+ * @val: address where to store the data
  *
  * This macro reads the data from the fifo.
  * It returns 0 if the fifo was empty. Otherwise it returns the number
@@ -428,12 +425,10 @@ __kfifo_int_must_check_helper( \
 __kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
-	typeof((val) + 1) __val = (val); \
+	typeof(__tmp->ptr) __val = (val); \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) \
-		__val = (typeof(__tmp->ptr))0; \
 	if (__recsize) \
 		__ret = __kfifo_out_r(__kfifo, __val, sizeof(*__val), \
 			__recsize); \
@@ -456,7 +451,7 @@ __kfifo_uint_must_check_helper( \
 /**
  * kfifo_peek - get data from the fifo without removing
  * @fifo: address of the fifo to be used
- * @val: the var where to store the data to be added
+ * @val: address where to store the data
  *
  * This reads the data from the fifo without removing it from the fifo.
  * It returns 0 if the fifo was empty. Otherwise it returns the number
@@ -469,12 +464,10 @@ __kfifo_uint_must_check_helper( \
 __kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
-	typeof((val) + 1) __val = (val); \
+	typeof(__tmp->ptr) __val = (val); \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) \
-		__val = (typeof(__tmp->ptr))NULL; \
 	if (__recsize) \
 		__ret = __kfifo_out_peek_r(__kfifo, __val, sizeof(*__val), \
 			__recsize); \
@@ -508,14 +501,10 @@ __kfifo_uint_must_check_helper( \
 #define	kfifo_in(fifo, buf, n) \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
-	typeof((buf) + 1) __buf = (buf); \
+ 	typeof(__tmp->ptr_const) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
-		__dummy = (typeof(__buf))NULL; \
-	} \
 	(__recsize) ?\
 	__kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_in(__kfifo, __buf, __n); \
@@ -561,14 +550,10 @@ __kfifo_uint_must_check_helper( \
 __kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
-	typeof((buf) + 1) __buf = (buf); \
+	typeof(__tmp->ptr) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr) __dummy = NULL; \
-		__buf = __dummy; \
-	} \
 	(__recsize) ?\
 	__kfifo_out_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_out(__kfifo, __buf, __n); \
@@ -773,14 +758,10 @@ __kfifo_uint_must_check_helper( \
 __kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
-	typeof((buf) + 1) __buf = (buf); \
+	typeof(__tmp->ptr) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr) __dummy __attribute__ ((unused)) = NULL; \
-		__buf = __dummy; \
-	} \
 	(__recsize) ? \
 	__kfifo_out_peek_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_out_peek(__kfifo, __buf, __n); \
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index bf3351b..5f4414b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1269,7 +1269,7 @@ void memory_failure_queue(unsigned long pfn, int trapno, int flags)
 
 	mf_cpu = &get_cpu_var(memory_failure_cpu);
 	spin_lock_irqsave(&mf_cpu->lock, proc_flags);
-	if (kfifo_put(&mf_cpu->fifo, &entry))
+	if (kfifo_put(&mf_cpu->fifo, entry))
 		schedule_work_on(smp_processor_id(), &mf_cpu->work);
 	else
 		pr_err("Memory failure: buffer overflow when queuing memory failure at %#lx\n",
diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
index cfe40ad..2fca916 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -64,7 +64,7 @@ static int __init testfunc(void)
 
 	/* put values into the fifo */
 	for (i = 0; i != 10; i++)
-		kfifo_put(&test, &i);
+		kfifo_put(&test, i);
 
 	/* show the number of used elements */
 	printk(KERN_INFO "fifo len: %u\n", kfifo_len(&test));
@@ -85,7 +85,7 @@ static int __init testfunc(void)
 	kfifo_skip(&test);
 
 	/* put values into the fifo until is full */
-	for (i = 20; kfifo_put(&test, &i); i++)
+	for (i = 20; kfifo_put(&test, i); i++)
 		;
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&test));
diff --git a/samples/kfifo/dma-example.c b/samples/kfifo/dma-example.c
index 0647379..aa243db 100644
--- a/samples/kfifo/dma-example.c
+++ b/samples/kfifo/dma-example.c
@@ -39,7 +39,7 @@ static int __init example_init(void)
 	kfifo_in(&fifo, "test", 4);
 
 	for (i = 0; i != 9; i++)
-		kfifo_put(&fifo, &i);
+		kfifo_put(&fifo, i);
 
 	/* kick away first byte */
 	kfifo_skip(&fifo);
diff --git a/samples/kfifo/inttype-example.c b/samples/kfifo/inttype-example.c
index 6f8e79e..8dc3c2e 100644
--- a/samples/kfifo/inttype-example.c
+++ b/samples/kfifo/inttype-example.c
@@ -61,7 +61,7 @@ static int __init testfunc(void)
 
 	/* put values into the fifo */
 	for (i = 0; i != 10; i++)
-		kfifo_put(&test, &i);
+		kfifo_put(&test, i);
 
 	/* show the number of used elements */
 	printk(KERN_INFO "fifo len: %u\n", kfifo_len(&test));
@@ -78,7 +78,7 @@ static int __init testfunc(void)
 	kfifo_skip(&test);
 
 	/* put values into the fifo until is full */
-	for (i = 20; kfifo_put(&test, &i); i++)
+	for (i = 20; kfifo_put(&test, i); i++)
 		;
 
 	printk(KERN_INFO "queue len: %u\n", kfifo_len(&test));
-- 
1.8.4

