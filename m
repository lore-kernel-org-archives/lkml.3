Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3BRMna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 07:43:30 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51137 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab3BRMnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 07:43:24 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v6 21/46] block: Use get/put_online_cpus_atomic() to prevent
 CPU offline
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        walken@google.com, vincent.guittot@linaro.org
Date: Mon, 18 Feb 2013 18:11:10 +0530
Message-ID: <20130218124109.26245.27817.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021812-8878-0000-0000-000005EFBACD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able to
depend on preempt_disable() or local_irq_disable() to prevent CPUs from
going offline from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going offline,
while invoking from atomic context.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 block/blk-softirq.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 467c8de..448f9a9 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -58,6 +58,8 @@ static void trigger_softirq(void *data)
  */
 static int raise_blk_irq(int cpu, struct request *rq)
 {
+	get_online_cpus_atomic();
+
 	if (cpu_online(cpu)) {
 		struct call_single_data *data = &rq->csd;
 
@@ -66,9 +68,11 @@ static int raise_blk_irq(int cpu, struct request *rq)
 		data->flags = 0;
 
 		__smp_call_function_single(cpu, data, 0);
+		put_online_cpus_atomic();
 		return 0;
 	}
 
+	put_online_cpus_atomic();
 	return 1;
 }
 #else /* CONFIG_SMP && CONFIG_USE_GENERIC_SMP_HELPERS */

