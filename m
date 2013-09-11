Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3IKE4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:56:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3IKE4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:45 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=tlYhW6TmiNwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Brj7GONiN8sA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=FSSUwEcXmdnbNugGuxAA:9 a=jEp0ucaQiEUA:10 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042930.999432116@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Peschke <mpeschke@linux.vnet.ibm.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [233/251] zfcp: fix lock imbalance by reworking request queue locking
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0233-zfcp-fix-lock-imbalance-by-reworking-request-queue-l.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

[ Upstream commit d79ff142624e1be080ad8d09101f7004d79c36e1 ]

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
Cc: stable@vger.kernel.org #2.6.35+
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/s390/scsi/zfcp_qdio.c |    8 ++----
 include/linux/wait.h          |   57 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 50b5615..925fb1f 100644
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
index 6c6c20e..e4683e0 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -571,6 +571,63 @@ do {									\
 		__wait_event_killable(wq, condition, __ret);		\
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
 
 /*
  * These are the old interfaces to sleep waiting for an event.
-- 
1.7.10.4


