Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbaGVWLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:11:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:26886 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbaGVWJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:09:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,712,1400050800"; 
   d="scan'208";a="547426942"
Subject: [PATCH v5 3/7] crypto: SHA1 multibuffer crypto opportunistic flush
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tadeusz Struk <tadeusz.struk@intel.com>, tkhai@yandex.ru,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <cover.1406033477.git.tim.c.chen@linux.intel.com>
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jul 2014 15:09:35 -0700
Message-ID: <1406066975.2970.805.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The crypto daemon can take advantage of available cpu
cycles to flush any unfinished jobs if it is the
only task running on the cpu, and there are no more crypto
jobs to process.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/mcryptd.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index 622d6b4..dbc20d1 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -116,9 +116,40 @@ static int mcryptd_enqueue_request(struct mcryptd_queue *queue,
 	return err;
 }
 
-/* Called in workqueue context, do one real cryption work (via
+/*
+ * Try to opportunisticlly flush the partially completed jobs if
+ * crypto daemon is the only task running.
+ */
+static void mcryptd_opportunistic_flush(void)
+{
+	struct mcryptd_flush_list *flist;
+	struct mcryptd_alg_cstate *cstate;
+
+	flist = per_cpu_ptr(mcryptd_flist, smp_processor_id());
+	while (single_task_running()) {
+		mutex_lock(&flist->lock);
+		if (list_empty(&flist->list)) {
+			mutex_unlock(&flist->lock);
+			return;
+		}
+		cstate = list_entry(flist->list.next,
+				struct mcryptd_alg_cstate, flush_list);
+		if (!cstate->flusher_engaged) {
+			mutex_unlock(&flist->lock);
+			return;
+		}
+		list_del(&cstate->flush_list);
+		cstate->flusher_engaged = false;
+		mutex_unlock(&flist->lock);
+		cstate->alg_state->flusher(cstate);
+	}
+}
+
+/*
+ * Called in workqueue context, do one real cryption work (via
  * req->complete) and reschedule itself if there are more work to
- * do. */
+ * do.
+ */
 static void mcryptd_queue_worker(struct work_struct *work)
 {
 	struct mcryptd_cpu_queue *cpu_queue;
@@ -144,8 +175,10 @@ static void mcryptd_queue_worker(struct work_struct *work)
 		preempt_enable();
 		local_bh_enable();
 
-		if (!req)
+		if (!req) {
+			mcryptd_opportunistic_flush();
 			return;
+		}
 
 		if (backlog)
 			backlog->complete(backlog, -EINPROGRESS);
-- 
1.7.11.7



