Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab3IBJBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:01:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540Ab3IBIzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Peschke <mpeschke@linux.vnet.ibm.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 45/58] [SCSI] zfcp: fix lock imbalance by reworking request queue locking
Date: Mon,  2 Sep 2013 09:54:30 +0100
Message-Id: <1378112083-9475-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

commit d79ff142624e1be080ad8d09101f7004d79c36e1 upstream.

This patch adds wait_event_interruptible_lock_irq_timeout(), which is a
straight-forward descendant of wait_event_interruptible_timeout() and
wait_event_interruptible_lock_irq().

The zfcp driver used to call wait_event_interruptible_timeout()
in combination with some intricate and error-prone locking. Using
wait_event_interruptible_lock_irq_timeout() as a replacement
nicely cleans up that locking.

This rework removes a situation that resulted in a locking imbalance
in zfcp_qdio_sbal_get():

BUG: workqueue leaked lock or atomic: events/1/0xffffff00/10
    last function: zfcp_fc_wka_port_offline+0x0/0xa0 [zfcp]

It was introduced by commit c2af7545aaff3495d9bf9a7608c52f0af86fb194
"[SCSI] zfcp: Do not wait for SBALs on stopped queue", which had a new
code path related to ZFCP_STATUS_ADAPTER_QDIOUP that took an early exit
without a required lock being held. The problem occured when a
special, non-SCSI I/O request was being submitted in process context,
when the adapter's queues had been torn down. In this case the bug
surfaced when the Fibre Channel port connection for a well-known address
was closed during a concurrent adapter shut-down procedure, which is a
rare constellation.

This patch also fixes these warnings from the sparse tool (make C=1):

drivers/s390/scsi/zfcp_qdio.c:224:12: warning: context imbalance in
 'zfcp_qdio_sbal_check' - wrong count at exit
drivers/s390/scsi/zfcp_qdio.c:244:5: warning: context imbalance in
 'zfcp_qdio_sbal_get' - unexpected unlock

Last but not least, we get rid of that crappy lock-unlock-lock
sequence at the beginning of the critical section.

It is okay to call zfcp_erp_adapter_reopen() with req_q_lock held.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/scsi/zfcp_qdio.c |  8 ++----
 include/linux/wait.h          | 58 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index e76d003..52c6b59 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -224,11 +224,9 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
 
 static int zfcp_qdio_sbal_check(struct zfcp_qdio *qdio)
 {
-	spin_lock_irq(&qdio->req_q_lock);
 	if (atomic_read(&qdio->req_q_free) ||
 	    !(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return 1;
-	spin_unlock_irq(&qdio->req_q_lock);
 	return 0;
 }
 
@@ -246,9 +244,8 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
 {
 	long ret;
 
-	spin_unlock_irq(&qdio->req_q_lock);
-	ret = wait_event_interruptible_timeout(qdio->req_q_wq,
-			       zfcp_qdio_sbal_check(qdio), 5 * HZ);
+	ret = wait_event_interruptible_lock_irq_timeout(qdio->req_q_wq,
+		       zfcp_qdio_sbal_check(qdio), qdio->req_q_lock, 5 * HZ);
 
 	if (!(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return -EIO;
@@ -262,7 +259,6 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
 		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdsbg_1");
 	}
 
-	spin_lock_irq(&qdio->req_q_lock);
 	return -EIO;
 }
 
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6c6c20e..d331566 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -572,6 +572,64 @@ do {									\
 	__ret;								\
 })
 
+#define __wait_event_interruptible_lock_irq_timeout(wq, condition,	\
+						    lock, ret)		\
+do {									\
+	DEFINE_WAIT(__wait);						\
+									\
+	for (;;) {							\
+		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		spin_unlock_irq(&lock);					\
+		ret = schedule_timeout(ret);				\
+		spin_lock_irq(&lock);					\
+		if (!ret)						\
+			break;						\
+	}								\
+	finish_wait(&wq, &__wait);					\
+} while (0)
+
+/**
+ * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets true or a timeout elapses.
+ *		The condition is checked under the lock. This is expected
+ *		to be called with the lock taken.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @lock: a locked spinlock_t, which will be released before schedule()
+ *	  and reacquired afterwards.
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or signal is received. The @condition is
+ * checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * This is supposed to be called while holding the lock. The lock is
+ * dropped before going to sleep and is reacquired afterwards.
+ *
+ * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
+ * was interrupted by a signal, and the remaining jiffies otherwise
+ * if the condition evaluated to true before the timeout elapsed.
+ */
+#define wait_event_interruptible_lock_irq_timeout(wq, condition, lock,	\
+						  timeout)		\
+({									\
+	int __ret = timeout;						\
+									\
+	if (!(condition))						\
+		__wait_event_interruptible_lock_irq_timeout(		\
+					wq, condition, lock, __ret);	\
+	__ret;								\
+})
+
+
 /*
  * These are the old interfaces to sleep waiting for an event.
  * They are racy.  DO NOT use them, use the wait_event* interfaces above.
-- 
1.8.3.2

