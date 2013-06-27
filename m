Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3F0UAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:00:05 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:32844 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab3F0T76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:59:58 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 22/45] block: Use get/put_online_cpus_atomic() to prevent
 CPU offline
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com,
        David.Laight@aculab.com
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, sbw@mit.edu, fweisbec@gmail.com,
        zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 28 Jun 2013 01:26:35 +0530
Message-ID: <20130627195634.29830.41449.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
References: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062719-3864-0000-0000-000008D5E65C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able
to depend on disabling preemption to prevent CPUs from going offline
from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going
offline, while invoking from atomic context.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 block/blk-softirq.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 467c8de..bbab3d3 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -58,6 +58,7 @@ static void trigger_softirq(void *data)
  */
 static int raise_blk_irq(int cpu, struct request *rq)
 {
+	get_online_cpus_atomic();
 	if (cpu_online(cpu)) {
 		struct call_single_data *data = &rq->csd;
 
@@ -66,8 +67,10 @@ static int raise_blk_irq(int cpu, struct request *rq)
 		data->flags = 0;
 
 		__smp_call_function_single(cpu, data, 0);
+		put_online_cpus_atomic();
 		return 0;
 	}
+	put_online_cpus_atomic();
 
 	return 1;
 }

