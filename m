Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaCJUeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:34:24 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:60531 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaCJUeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:34:19 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 01/52] CPU hotplug: Add lockdep annotations to
 get/put_online_cpus()
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        srivatsa.bhat@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 02:04:03 +0530
Message-ID: <20140310203402.10746.59486.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031020-5490-0000-0000-000005222503
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R. Shenoy <ego@linux.vnet.ibm.com>

Add lockdep annotations for get/put_online_cpus() and
cpu_hotplug_begin()/cpu_hotplug_end().

Cc: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpu.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index deff2e6..33caf5e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/suspend.h>
+#include <linux/lockdep.h>
 
 #include "smpboot.h"
 
@@ -57,17 +58,30 @@ static struct {
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
 } cpu_hotplug = {
 	.active_writer = NULL,
 	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
 	.refcount = 0,
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	.dep_map = {.name = "cpu_hotplug.lock" },
+#endif
 };
 
+/* Lockdep annotations for get/put_online_cpus() and cpu_hotplug_begin/end() */
+#define cpuhp_lock_acquire_read() lock_map_acquire_read(&cpu_hotplug.dep_map)
+#define cpuhp_lock_acquire()      lock_map_acquire(&cpu_hotplug.dep_map)
+#define cpuhp_lock_release()      lock_map_release(&cpu_hotplug.dep_map)
+
 void get_online_cpus(void)
 {
 	might_sleep();
 	if (cpu_hotplug.active_writer == current)
 		return;
+	cpuhp_lock_acquire_read();
 	mutex_lock(&cpu_hotplug.lock);
 	cpu_hotplug.refcount++;
 	mutex_unlock(&cpu_hotplug.lock);
@@ -87,6 +101,7 @@ void put_online_cpus(void)
 	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
 		wake_up_process(cpu_hotplug.active_writer);
 	mutex_unlock(&cpu_hotplug.lock);
+	cpuhp_lock_release();
 
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
@@ -117,6 +132,7 @@ void cpu_hotplug_begin(void)
 {
 	cpu_hotplug.active_writer = current;
 
+	cpuhp_lock_acquire();
 	for (;;) {
 		mutex_lock(&cpu_hotplug.lock);
 		if (likely(!cpu_hotplug.refcount))
@@ -131,6 +147,7 @@ void cpu_hotplug_done(void)
 {
 	cpu_hotplug.active_writer = NULL;
 	mutex_unlock(&cpu_hotplug.lock);
+	cpuhp_lock_release();
 }
 
 /*

