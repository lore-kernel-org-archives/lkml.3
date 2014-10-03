Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbaJCXI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:08:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbaJCWOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.14 200/238] IB/qib: Correct reference counting in debugfs qp_stats
Date: Fri,  3 Oct 2014 14:31:55 -0700
Message-Id: <20141003212920.056077491@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 85cbb7c728bf39c45a9789b88c9471c0d7a58b0e upstream.

This particular reference count is not needed with the rcu protection,
and the current code leaks a reference count, causing a hang in
qib_qp_destroy().

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/qib/qib_debugfs.c |    3 ++-
 drivers/infiniband/hw/qib/qib_qp.c      |    8 --------
 2 files changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_debugfs.c
+++ b/drivers/infiniband/hw/qib/qib_debugfs.c
@@ -193,6 +193,7 @@ static void *_qp_stats_seq_start(struct
 	struct qib_qp_iter *iter;
 	loff_t n = *pos;
 
+	rcu_read_lock();
 	iter = qib_qp_iter_init(s->private);
 	if (!iter)
 		return NULL;
@@ -224,7 +225,7 @@ static void *_qp_stats_seq_next(struct s
 
 static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
 {
-	/* nothing for now */
+	rcu_read_unlock();
 }
 
 static int _qp_stats_seq_show(struct seq_file *s, void *iter_ptr)
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -1324,7 +1324,6 @@ int qib_qp_iter_next(struct qib_qp_iter
 	struct qib_qp *pqp = iter->qp;
 	struct qib_qp *qp;
 
-	rcu_read_lock();
 	for (; n < dev->qp_table_size; n++) {
 		if (pqp)
 			qp = rcu_dereference(pqp->next);
@@ -1332,18 +1331,11 @@ int qib_qp_iter_next(struct qib_qp_iter
 			qp = rcu_dereference(dev->qp_table[n]);
 		pqp = qp;
 		if (qp) {
-			if (iter->qp)
-				atomic_dec(&iter->qp->refcount);
-			atomic_inc(&qp->refcount);
-			rcu_read_unlock();
 			iter->qp = qp;
 			iter->n = n;
 			return 0;
 		}
 	}
-	rcu_read_unlock();
-	if (iter->qp)
-		atomic_dec(&iter->qp->refcount);
 	return ret;
 }
 


