Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbaEKWi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 18:38:59 -0400
Received: from mail.eperm.de ([89.247.134.16]:56906 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbaEKWi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 18:38:56 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 2/2] Asynchronous and syncronous API for accessing kernel_pool
Date: Mon, 12 May 2014 00:38:37 +0200
Message-ID: <2953244.qIuTpXCXev@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.3-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1539435.TLjcZda65N@myon.chronox.de>
References: <1937020.H2HvEFgXrB@myon.chronox.de> <1539435.TLjcZda65N@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel_pool is intended to be the in-kernel equivalent to the
blocking_pool, i.e. requests for random data may be blocked if
insufficient entropy is present.

The added API calls provide a synchronous function call
get_blocking_random_bytes where the caller is blocked.

In addition, an asynchronous API call of get_blocking_random_bytes_cb
is provided which returns immediately to the caller after submitting
the request for random data. The caller-provided buffer that shall be
filled with random data is filled up as available entropy permits. The
caller may provide a callback function that is invoked once the
request is completed.

A third API call, get_blocking_random_bytes_cancel, is provided to
cancel the random number gathering operation.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c  | 113 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h |  16 +++++++
 2 files changed, 129 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 2b53023..2e78318 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -401,6 +401,7 @@ static struct poolinfo {
  */
 static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
+static DECLARE_WAIT_QUEUE_HEAD(random_kernel_wait);
 static struct fasync_struct *fasync;
 
 /**********************************************************************
@@ -682,6 +683,7 @@ retry:
 
 		/* should we wake readers? */
 		if (entropy_bits >= random_read_wakeup_bits) {
+			wake_up_interruptible(&random_kernel_wait);
 			wake_up_interruptible(&random_read_wait);
 			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}
@@ -1727,3 +1729,114 @@ randomize_range(unsigned long start, unsigned long end, unsigned long len)
 		return 0;
 	return PAGE_ALIGN(get_random_int() % range + start);
 }
+
+static bool get_blocking_random_bytes_term(bool *cancel)
+{
+	if (ENTROPY_BITS(&input_pool) >= random_read_wakeup_bits)
+		return true;
+	return *cancel;
+}
+
+/*
+ * Equivalent function to get_random_bytes with the difference that this
+ * function blocks the request in a similar fashion as random_read(),
+ * implementing a /dev/random device for in-kernel users.
+ *
+ * This function may sleep.
+ *
+ * @buf caller allocated buffer filled with random data
+ * @nbytes requested number of bytes -- buffer should be at least as big
+ * @cancel pointer to variable that can be used to cancel the collection
+ *	   operation. If this boolean is set to true, the collection operation
+ *	   is terminated immediately. When it is set to false during the
+ *	   collection loop, the collection is terminated immediately.
+ *
+ * return: positive value: obtained number of bytes on successful
+ *	   negative value: error code on error
+ */
+ssize_t get_blocking_random_bytes(void *buf, ssize_t nbytes, bool *cancel)
+{
+	ssize_t ret = 0;
+
+	if (nbytes <= 0)
+		return nbytes;
+	BUG_ON(NULL == buf);
+
+	while (ret < nbytes) {
+		ssize_t round = 0;
+		ssize_t pull = min_t(ssize_t, (nbytes - ret), SEC_XFER_SIZE);
+		if (*cancel)
+			return ret;
+		round = extract_entropy(&kernel_pool, (buf + ret), pull, 0, 0);
+		if (0 > round)
+			return round;
+		/* arch_random_refill could be added here */
+		if (0 == round)
+			wait_event_interruptible(random_kernel_wait,
+				get_blocking_random_bytes_term(cancel));
+		ret += round;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(get_blocking_random_bytes);
+
+/*
+ * Immediate canceling the collection operation for the random_work
+ */
+void get_blocking_random_bytes_cancel(struct random_work *rw)
+{
+	rw->cancel = true;
+	wake_up_interruptible(&random_kernel_wait);
+
+}
+EXPORT_SYMBOL(get_blocking_random_bytes_cancel);
+
+static void get_blocking_random_bytes_work(struct work_struct *work)
+{
+	struct random_work *rw = container_of(work, struct random_work,
+					      rw_work);
+	int ret;
+
+	ret = get_blocking_random_bytes(rw->rw_buf, rw->rw_len, &rw->cancel);
+	if (rw->rw_cb)
+		rw->rw_cb(rw->rw_buf, ret);
+}
+
+/*
+ * Asynchronous invocation of the blocking interface. The function
+ * queues the request in either the private work queue supplied with the
+ * wq argument or in the general work queue framework if wq is NULL.
+ * Once the request is completed or upon receiving an error, the callback
+ * function of cb is called, if not NULL, to inform the caller about the
+ * completion of its operation.
+ *
+ * If a caller wants to cancel the work (e.g. in the module_exit function),
+ * simply call
+ *	get_blocking_random_bytes_cancel(&my_random_work);
+ *	cancel_work_sync(&my_random_work.rw_work);
+ *
+ * @wq pointer to private work queue or NULL - input
+ * @rw handle to the work queue frame - output
+ * @buf allocated buffer where random numbers are to be stored
+ * @nbytes size of buf and implicitly number of bytes requested
+ * @cb callback function where
+ *	* buf holds the pointer to buf will be supplied
+ *	* buflen holds the length of the gathered random numbers or error code
+ *	  of the generation function.
+ */
+void get_blocking_random_bytes_cb(struct workqueue_struct *wq,
+				  struct random_work *rw,
+				  void *buf, ssize_t nbytes,
+				  void (*cb)(void *buf, ssize_t buflen))
+{
+	rw->rw_buf = buf;
+	rw->rw_len = nbytes;
+	rw->rw_cb = cb;
+	rw->cancel = false;
+	INIT_WORK(&rw->rw_work, get_blocking_random_bytes_work);
+	if (wq)
+		queue_work(wq, &rw->rw_work);
+	else
+		schedule_work(&rw->rw_work);
+}
+EXPORT_SYMBOL(get_blocking_random_bytes_cb);
diff --git a/include/linux/random.h b/include/linux/random.h
index 57fbbff..d0a1fff 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -7,6 +7,7 @@
 #define _LINUX_RANDOM_H
 
 #include <uapi/linux/random.h>
+#include <linux/workqueue.h>
 
 extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
@@ -112,4 +113,19 @@ static inline u32 next_pseudo_random32(u32 seed)
 	return seed * 1664525 + 1013904223;
 }
 
+struct random_work {
+	struct work_struct	rw_work;
+	void			*rw_buf;
+	ssize_t			rw_len;
+	void			(*rw_cb)(void *buf, ssize_t buflen);
+	bool			cancel;
+};
+
+ssize_t get_blocking_random_bytes(void *buf, ssize_t nbytes, bool *cancel);
+void get_blocking_random_bytes_cancel(struct random_work *rw);
+void get_blocking_random_bytes_cb(struct workqueue_struct *wq,
+				  struct random_work *rw,
+				  void *buf, ssize_t nbytes,
+				  void (*cb)(void *buf, ssize_t buflen));
+
 #endif /* _LINUX_RANDOM_H */
-- 
1.9.0


