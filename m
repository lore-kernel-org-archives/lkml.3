Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaCJUe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:34:56 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:41389 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaCJUew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:34:52 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 04/52] CPU hotplug,
 perf: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 02:04:39 +0530
Message-ID: <20140310203438.10746.24505.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031020-8878-0000-0000-00000B4132B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsystems that want to register CPU hotplug callbacks, as well as perform
initialization for the CPUs that are already online, often do it as shown
below:

	get_online_cpus();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	register_cpu_notifier(&foobar_cpu_notifier);

	put_online_cpus();

This is wrong, since it is prone to ABBA deadlocks involving the
cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
with CPU hotplug operations).

Instead, the correct and race-free way of performing the callback
registration is:

	cpu_notifier_register_begin();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	/* Note the use of the double underscored version of the API */
	__register_cpu_notifier(&foobar_cpu_notifier);

	cpu_notifier_register_done();


Fix the perf subsystem's hotplug notifier by using this latter form of
callback registration.

Also provide a bare-bones version of perf_cpu_notifier() that doesn't
invoke the notifiers for the already online CPUs. This would be useful
for subsystems that need to perform a different set of initialization
for the already online CPUs, or don't need the initialization altogether.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/perf_event.h |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e56b07f..3356abc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -835,6 +835,8 @@ do {									\
 		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
 	unsigned long cpu = smp_processor_id();				\
 	unsigned long flags;						\
+									\
+	cpu_notifier_register_begin();					\
 	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
 		(void *)(unsigned long)cpu);				\
 	local_irq_save(flags);						\
@@ -843,9 +845,21 @@ do {									\
 	local_irq_restore(flags);					\
 	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
 		(void *)(unsigned long)cpu);				\
-	register_cpu_notifier(&fn##_nb);				\
+	__register_cpu_notifier(&fn##_nb);				\
+	cpu_notifier_register_done();					\
 } while (0)
 
+/*
+ * Bare-bones version of perf_cpu_notifier(), which doesn't invoke the
+ * callback for already online CPUs.
+ */
+#define __perf_cpu_notifier(fn)						\
+do {									\
+	static struct notifier_block fn##_nb =				\
+		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
+									\
+	__register_cpu_notifier(&fn##_nb);				\
+} while (0)
 
 struct perf_pmu_events_attr {
 	struct device_attribute attr;

