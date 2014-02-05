Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaBEWS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:18:26 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59031 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbaBEWSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:18:21 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 46/51] trace,
 ring-buffer: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:42:58 +0530
Message-ID: <20140205221257.19080.88037.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-7014-0000-0000-00000448B6E4
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

	cpu_maps_update_begin();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	/* Note the use of the double underscored version of the API */
	__register_cpu_notifier(&foobar_cpu_notifier);

	cpu_maps_update_done();


Fix the tracing ring-buffer code by using this latter form of callback
registration.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/trace/ring_buffer.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 294b8a2..ca3eb61 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1301,7 +1301,7 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	 * In that off case, we need to allocate for all possible cpus.
 	 */
 #ifdef CONFIG_HOTPLUG_CPU
-	get_online_cpus();
+	cpu_maps_update_begin();
 	cpumask_copy(buffer->cpumask, cpu_online_mask);
 #else
 	cpumask_copy(buffer->cpumask, cpu_possible_mask);
@@ -1324,10 +1324,10 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 #ifdef CONFIG_HOTPLUG_CPU
 	buffer->cpu_notify.notifier_call = rb_cpu_notify;
 	buffer->cpu_notify.priority = 0;
-	register_cpu_notifier(&buffer->cpu_notify);
+	__register_cpu_notifier(&buffer->cpu_notify);
+	cpu_maps_update_done();
 #endif
 
-	put_online_cpus();
 	mutex_init(&buffer->mutex);
 
 	return buffer;
@@ -1341,7 +1341,9 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 
  fail_free_cpumask:
 	free_cpumask_var(buffer->cpumask);
-	put_online_cpus();
+#ifdef CONFIG_HOTPLUG_CPU
+	cpu_maps_update_done();
+#endif
 
  fail_free_buffer:
 	kfree(buffer);
@@ -1358,16 +1360,17 @@ ring_buffer_free(struct ring_buffer *buffer)
 {
 	int cpu;
 
-	get_online_cpus();
-
 #ifdef CONFIG_HOTPLUG_CPU
-	unregister_cpu_notifier(&buffer->cpu_notify);
+	cpu_maps_update_begin();
+	__unregister_cpu_notifier(&buffer->cpu_notify);
 #endif
 
 	for_each_buffer_cpu(buffer, cpu)
 		rb_free_cpu_buffer(buffer->buffers[cpu]);
 
-	put_online_cpus();
+#ifdef CONFIG_HOTPLUG_CPU
+	cpu_maps_update_done();
+#endif
 
 	kfree(buffer->buffers);
 	free_cpumask_var(buffer->cpumask);

