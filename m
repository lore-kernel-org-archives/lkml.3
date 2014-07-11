Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaGKUde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:33:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:53143 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbaGKUdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,644,1400050800"; 
   d="scan'208";a="542196894"
Subject: [PATCH v4 7/7] crypto: SHA1 multibuffer - flush the jobs early if
 cpu becomes idle
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <cover.1405074379.git.tim.c.chen@linux.intel.com>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jul 2014 13:33:08 -0700
Message-ID: <1405110788.2970.656.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a notifier to the SHA1 multi-buffer algorithm
when CPU is giong idle, so it can take advantage of the available
CPU power to flush out any partially completed jobs.  This
will eliminate possible extended latency in the multi-buffer
algorithm.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha-mb/sha1_mb.c | 61 ++++++++++++++++++++++++++++++++++++++++
 include/crypto/mcryptd.h         |  1 +
 2 files changed, 62 insertions(+)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
index 9c5feae..fd9b219 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb.c
@@ -69,6 +69,7 @@
 #include <asm/xcr.h>
 #include <asm/xsave.h>
 #include <linux/hardirq.h>
+#include <linux/sched.h>
 #include <asm/fpu-internal.h>
 #include "sha_mb_ctx.h"
 
@@ -820,6 +821,60 @@ static struct ahash_alg sha1_mb_async_alg = {
 	},
 };
 
+void sha1_mb_force_flush(struct mcryptd_alg_cstate *cstate)
+{
+	struct mcryptd_hash_request_ctx *rctx;
+	struct sha1_hash_ctx *sha_ctx;
+
+	/* force flush uncompleted jobs in all data lanes before cpu becomes idle */
+	while (!list_empty(&cstate->work_list)) {
+		/* turn off flusher as we are flushing here */
+		if (cstate->flusher_engaged)
+			cstate->flusher_engaged = false;
+
+		kernel_fpu_begin();
+		sha_ctx = (struct sha1_hash_ctx *) sha1_ctx_mgr_flush(cstate->mgr);
+		kernel_fpu_end();
+		if (!sha_ctx) {
+			pr_err("sha1_mb error: nothing got flushed for non-empty list\n");
+			break;
+		}
+		rctx = cast_hash_to_mcryptd_ctx(sha_ctx);
+		sha_finish_walk(&rctx, cstate, true);
+		sha_complete_job(rctx, cstate, 0);
+	}
+
+	return;
+}
+
+void sha1_mb_earlyflush(struct work_struct *__work)
+{
+	struct mcryptd_alg_cstate *alg_cpu_state;
+
+	/* do not do early flush if other tasks are running */
+	if (nr_running_cpu(smp_processor_id()) > 1)
+		return;
+
+	alg_cpu_state = container_of(__work, struct mcryptd_alg_cstate, early_flush);
+	sha1_mb_force_flush(alg_cpu_state);
+}
+
+static int sha1_mb_idle_notifier(struct notifier_block *nb, unsigned long val,
+				 void *data)
+{
+	struct mcryptd_alg_cstate *cstate =
+				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
+
+	if (val == IDLE_START && cstate->flusher_engaged)
+		queue_work_on(smp_processor_id(), kcrypto_wq, &cstate->early_flush);
+
+	return 0;
+}
+
+static struct notifier_block sha1_mb_idle_nb = {
+	.notifier_call = sha1_mb_idle_notifier,
+};
+
 unsigned long sha1_mb_flusher(struct mcryptd_alg_cstate *cstate)
 {
 	struct mcryptd_hash_request_ctx *rctx;
@@ -830,6 +885,9 @@ unsigned long sha1_mb_flusher(struct mcryptd_alg_cstate *cstate)
 
 	cur_time = jiffies;
 
+	if (!cstate->flusher_engaged)
+		return 0;
+
 	while (!list_empty(&cstate->work_list)) {
 		rctx = list_entry(cstate->work_list.next,
 				struct mcryptd_hash_request_ctx, waiter);
@@ -889,6 +947,7 @@ static int __init sha1_mb_mod_init(void)
 		cpu_state->next_seq_num = 0;
 		cpu_state->flusher_engaged = false;
 		INIT_DELAYED_WORK(&cpu_state->flush, mcryptd_flusher);
+		INIT_WORK(&cpu_state->early_flush, sha1_mb_earlyflush);
 		cpu_state->cpu = cpu;
 		cpu_state->alg_state = &sha1_mb_alg_state;
 		cpu_state->mgr = (struct sha1_ctx_mgr *) kzalloc(sizeof(struct sha1_ctx_mgr), GFP_KERNEL);
@@ -907,6 +966,7 @@ static int __init sha1_mb_mod_init(void)
 	if (err)
 		goto err1;
 
+	idle_notifier_register(&sha1_mb_idle_nb);
 
 	return 0;
 err1:
@@ -925,6 +985,7 @@ static void __exit sha1_mb_mod_fini(void)
 	int cpu;
 	struct mcryptd_alg_cstate *cpu_state;
 
+	idle_notifier_unregister(&sha1_mb_idle_nb);
 	crypto_unregister_ahash(&sha1_mb_async_alg);
 	crypto_unregister_shash(&sha1_mb_shash_alg);
 	for_each_possible_cpu(cpu) {
diff --git a/include/crypto/mcryptd.h b/include/crypto/mcryptd.h
index b2b9055..2ef1824 100644
--- a/include/crypto/mcryptd.h
+++ b/include/crypto/mcryptd.h
@@ -82,6 +82,7 @@ struct mcryptd_alg_cstate {
 	unsigned next_seq_num;
 	bool	flusher_engaged;
 	struct  delayed_work flush;
+	struct  work_struct early_flush;
 	int	cpu;
 	struct  mcryptd_alg_state *alg_state;
 	void	*mgr;
-- 
1.7.11.7


