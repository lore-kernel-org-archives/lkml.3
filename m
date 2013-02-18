Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3BRMm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 07:42:59 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51422 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3BRMmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 07:42:55 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v6 18/46] softirq: Use get/put_online_cpus_atomic() to prevent
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
Date: Mon, 18 Feb 2013 18:10:47 +0530
Message-ID: <20130218124047.26245.76718.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021812-5816-0000-0000-000006B9AFD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able to
depend on preempt_disable() or local_irq_disable() to prevent CPUs from
going offline from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going offline,
while invoking from atomic context.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/softirq.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index ed567ba..98c3e27 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -631,6 +631,7 @@ static void remote_softirq_receive(void *data)
 
 static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
 {
+	get_online_cpus_atomic();
 	if (cpu_online(cpu)) {
 		cp->func = remote_softirq_receive;
 		cp->info = cp;
@@ -638,8 +639,10 @@ static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softir
 		cp->priv = softirq;
 
 		__smp_call_function_single(cpu, cp, 0);
+		put_online_cpus_atomic();
 		return 0;
 	}
+	put_online_cpus_atomic();
 	return 1;
 }
 #else /* CONFIG_USE_GENERIC_SMP_HELPERS */

