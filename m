Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaBJKx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:53:59 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59696 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaBJKx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:53:57 -0500
Date: Mon, 10 Feb 2014 16:21:30 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: ego@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>, paulus@samba.org,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of
	callback registration functions
Message-ID: <20140210105130.GA14693@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
 <20140206184103.GA31410@redhat.com>
 <20140207191125.GA8098@in.ibm.com>
 <52F898CB.6030900@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F898CB.6030900@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021010-7164-0000-0000-000005D9D71C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:45:55PM +0530, Srivatsa S. Bhat wrote:
> Hi Gautham,
> 
> On 02/08/2014 12:41 AM, Gautham R Shenoy wrote:
> > On Thu, Feb 06, 2014 at 07:41:03PM +0100, Oleg Nesterov wrote:
> >> On 02/06, Srivatsa S. Bhat wrote:
> >>>
> >>> The following method of CPU hotplug callback registration is not safe
> >>> due to the possibility of an ABBA deadlock involving the cpu_add_remove_lock
> >>> and the cpu_hotplug.lock.
> >>
> >> Off-topic, but perhaps it also makes sense to add the lockdep annotations
> >> later, to catch other similar problems. Currently get_online_cpus() acquires
> >> nothing from lockdep pov.
> > 
> > Well, both get/put_online_cpus() as well as cpu_hotplug_begin/end()
> > take the cpu_hotplug.lock mutex. So ideally the lockdep annotations of
> > mutex_lock/unlock() should have worked.
> 
> The reason lockdep doesn't catch the lock-inversion (ABBA) deadlock between
> cpu_hotplug.lock (from get_online_cpus) and cpu_add_remove_lock (from
> cpu_maps_update_begin) is because, in the following path, the
> cpu_add_remove_lock is acquired after *releasing* the cpu_hotplug.lock mutex.
>

Right. I get it now! 
 
> get_online_cpus();  // acquire mutex; update counter; release mutex
> 
> register_cpu_notifier(); // acquire cpu_add_remove_lock ...
> 
> put_online_cpus();
> 
> > If it hasn't, then the
> > following lockdep annotations to cpu-hotplug locking should do the
> > trick.
> > 
> 
> This patch looks good to me. I have a couple of suggestions though..
> 

Thanks. I have incorporated the suggestions. Could you check if the
following looks good ?

---
 Add lockdep annotations for get/put_online_cpus() and
 cpu_hotplug_begin()/cpu_hotplug_end().

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srivatsa Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
---
 kernel/cpu.c | 17 +++++++++++++++++
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
-- 
1.8.3.1

