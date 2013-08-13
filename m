Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3HMFwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:52:49 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:64378 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab3HMFwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:52:47 -0400
MIME-Version: 1.0
Date: Tue, 13 Aug 2013 15:52:46 +1000
Message-ID: <CAKjOGEpYSOVzV+xF0Cv3CVbEr7u9jkRPjYYEcFnZ25PBWzw4Fg@mail.gmail.com>
Subject: [RFC][PATCH 1/1] kfifo: add macros for direct buffer read access
From: Matthew Hollingworth <mdholling@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kfifo_out_prepare and kfifo_out_finish macros. These allow direct
access to the fifo buffer for reading.

These macros do not make sense for data-record fifos and would not
apply in that context.

Equivalent macros could be added for fifo direct write operations.

Signed-off-by: Matthew Hollingworth <mdholling@gmail.com>
---
 include/linux/kfifo.h |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 10308c6..24f6024 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -787,6 +787,54 @@ __kfifo_uint_must_check_helper( \
 }) \
 )

+/**
+ * kfifo_out_prepare - setup a pointer for direct output buffer access
+ * @fifo: address of the fifo to be used
+ * @pbuf: address of buffer pointer to be initialized
+ *
+ * This macro sets the provided buffer pointer to the address of the
+ * current fifo output location.
+ * It returns the maximum number of contiguous elements which can be read
+ * out from this location. A zero means there is no data in the fifo.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macros.
+ */
+#define kfifo_out_prepare(fifo, pbuf) \
+__kfifo_uint_must_check_helper( \
+({ \
+	typeof((fifo) + 1) __tmp = (fifo);  \
+	typeof((*pbuf) + 1) * __pbuf = (pbuf); \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	unsigned int size = __kfifo->mask + 1; \
+	unsigned int off = __kfifo->out & __kfifo->mask; \
+	*__pbuf = (__is_kfifo_ptr(__tmp) ? \
+		((typeof(__tmp->type))__kfifo->data) : \
+		(__tmp->buf)) + off; \
+	min(size - off, __kfifo->in - __kfifo->out); \
+}) \
+)
+
+/**
+ * kfifo_out_finish - finish a direct output buffer access operation
+ * @fifo: address of the fifo to be used
+ * @len: number of elements which were read out
+ *
+ * This macro finishes a direct output buffer access operation. The out
+ * counter will be updated by the len parameter. No error checking will
+ * be done.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these macros.
+ */
+#define kfifo_out_finish(fifo, len) \
+(void)({ \
+	typeof((fifo) + 1) __tmp = (fifo);  \
+	struct __kfifo *__kfifo = &__tmp->kfifo; \
+	unsigned int __len = (len); \
+	__kfifo->out += __len; \
+})
+
 extern int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
 	size_t esize, gfp_t gfp_mask);

--
