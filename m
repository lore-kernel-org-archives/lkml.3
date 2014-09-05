Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbaIEPQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:16:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:54153 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbaIEPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:16:48 -0400
Date: Fri, 5 Sep 2014 17:16:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Zheng <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
Message-ID: <20140905151640.GN19379@twins.programming.kicks-ass.net>
References: <20140901181808.GA6427@leverpostej>
 <20140901190534.GC5806@worktop.ger.corp.intel.com>
 <20140902185807.GA7434@leverpostej>
 <20140903115013.GA3127@leverpostej>
 <20140904104402.GS4783@worktop.ger.corp.intel.com>
 <20140904110740.GB32228@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904110740.GB32228@leverpostej>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 12:07:40PM +0100, Mark Rutland wrote:
> Thanks for taking a look. If you have any ideas I'm happy to try another
> approach.

How horrible is the below patch (performance wise). It does pretty much
the same thing except that percpu_rw_semaphore is a lot saner, its
read side performance should be minimal in the absence of writes.

---
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1573,6 +1573,7 @@ config PERF_EVENTS
 	depends on HAVE_PERF_EVENTS
 	select ANON_INODES
 	select IRQ_WORK
+	select PERCPU_RWSEM
 	help
 	  Enable kernel support for various performance events provided
 	  by software and hardware.
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -42,6 +42,7 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/compat.h>
+#include <linux/percpu-rwsem.h>
 
 #include "internal.h"
 
@@ -3418,12 +3419,14 @@ static void perf_remove_from_owner(struc
 	}
 }
 
+static struct percpu_rw_semaphore perf_rwsem;
+
 /*
  * Called when the last reference to the file is gone.
  */
 static void put_event(struct perf_event *event)
 {
-	struct perf_event_context *ctx = event->ctx;
+	struct perf_event_context *ctx;
 
 	if (!atomic_long_dec_and_test(&event->refcount))
 		return;
@@ -3431,6 +3434,9 @@ static void put_event(struct perf_event
 	if (!is_kernel_event(event))
 		perf_remove_from_owner(event);
 
+	percpu_down_read(&perf_rwsem);
+	ctx = event->ctx;
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	/*
 	 * There are two ways this annotation is useful:
@@ -3447,6 +3453,7 @@ static void put_event(struct perf_event
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
 	perf_remove_from_context(event, true);
 	mutex_unlock(&ctx->mutex);
+	percpu_up_read(&perf_rwsem);
 
 	_free_event(event);
 }
@@ -7534,6 +7541,8 @@ void perf_pmu_migrate_context(struct pmu
 	struct perf_event *event, *tmp;
 	LIST_HEAD(events);
 
+	percpu_down_write(&perf_rwsem);
+
 	src_ctx = &per_cpu_ptr(pmu->pmu_cpu_context, src_cpu)->ctx;
 	dst_ctx = &per_cpu_ptr(pmu->pmu_cpu_context, dst_cpu)->ctx;
 
@@ -7559,6 +7568,8 @@ void perf_pmu_migrate_context(struct pmu
 		get_ctx(dst_ctx);
 	}
 	mutex_unlock(&dst_ctx->mutex);
+
+	percpu_up_write(&perf_rwsem);
 }
 EXPORT_SYMBOL_GPL(perf_pmu_migrate_context);
 
@@ -8198,6 +8209,7 @@ void __init perf_event_init(void)
 
 	idr_init(&pmu_idr);
 
+	percpu_init_rwsem(&perf_rwsem);
 	perf_event_init_all_cpus();
 	init_srcu_struct(&pmus_srcu);
 	perf_pmu_register(&perf_swevent, "software", PERF_TYPE_SOFTWARE);
