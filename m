Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbaFLN4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:56:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58729 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaFLN4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:56:34 -0400
Date: Thu, 12 Jun 2014 09:56:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] percpu: add data dependency barrier in percpu accessors
 and operations
Message-ID: <20140612135630.GA23606@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2ff90ab638d50d6191ba3a3564b53fccb78bd4cd Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 11 Jun 2014 20:47:02 -0400

percpu areas are zeroed on allocation and, by its nature, accessed
from multiple cpus.  Consider the following scenario.

 p = NULL;

	CPU-1				CPU-2
 p = alloc_percpu()		if (p)
					WARN_ON(this_cpu_read(*p));

As all percpu areas are zeroed on allocation, CPU-2 should never
trigger the WARN; however, there's no barrier between zeroing of the
percpu regions and the assignment of @p or between testing of @p and
dereferencing it and CPU-2 may see garbage value from before the
clearing and trigger the warning.

Note that this may happen even on archs which don't require data
dependency barriers.  While CPU-2 woudln't reorder percpu area access
above the testing of @p, nothing prevents CPU-1 from scheduling
zeroing after the assignment of @p.

This patch fixes the issue by adding a smp_wmb() before a newly
allocated percpu pointer is returned and a smp_read_barrier_depends()
in __verify_pcpu_ptr() which is guaranteed to be invoked at least once
before every percpu access.  It currently may be invoked multiple
times per operation which isn't optimal.  Future patches will update
the definitions so that the macro is invoked only once per access.

It can be argued that smp_read_barrier_depends() is the responsibility
of the caller; however, discerning local and remote accesses gets very
confusing with percpu areas (initialized remotely but local to this
cpu and vice-versa) and data dependency barrier is free on all archs
except for alpha, so I think it's better to include it as part of
percpu accessors and operations.

I wonder whether we also need a smp_wmb() for other __GFP_ZERO
allocations.  There isn't one and requiring the users to perform
smp_wmb() to ensure the propagation of zeroing seems too subtle.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/percpu-defs.h | 15 ++++++++++++---
 mm/percpu.c                 |  9 +++++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index a5fc7d0..b91bb37 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_PERCPU_DEFS_H
 #define _LINUX_PERCPU_DEFS_H
 
+#include <asm/barrier.h>
+
 /*
  * Base implementations of per-CPU variable declarations and definitions, where
  * the section in which the variable is to be placed is provided by the
@@ -19,9 +21,15 @@
 	__attribute__((section(".discard"), unused))
 
 /*
- * Macro which verifies @ptr is a percpu pointer without evaluating
- * @ptr.  This is to be used in percpu accessors to verify that the
- * input parameter is a percpu pointer.
+ * This macro serves two purposes.  It verifies @ptr is a percpu pointer
+ * without evaluating @ptr and provides the data dependency barrier paired
+ * with smp_wmb() at the end of the allocation path so that the memory
+ * clearing in the allocation path is visible to all percpu accsses.
+ *
+ * The existence of the data dependency barrier is guaranteed and percpu
+ * users can take advantage of it - e.g. percpu area updates followed by
+ * smp_wmb() and then a percpu pointer assignment are guaranteed to be
+ * visible to accessors which access through the assigned percpu pointer.
  *
  * + 0 is required in order to convert the pointer type from a
  * potential array type to a pointer to a single item of the array.
@@ -29,6 +37,7 @@
 #define __verify_pcpu_ptr(ptr)	do {					\
 	const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;	\
 	(void)__vpp_verify;						\
+	smp_read_barrier_depends();					\
 } while (0)
 
 /*
diff --git a/mm/percpu.c b/mm/percpu.c
index 2ddf9a9..bd3cab8 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -816,6 +816,15 @@ area_found:
 	/* return address relative to base address */
 	ptr = __addr_to_pcpu_ptr(chunk->base_addr + off);
 	kmemleak_alloc_percpu(ptr, size);
+
+	/*
+	 * The following wmb is paired with the data dependency barrier in
+	 * the percpu accessors and guarantees that the zeroing of the
+	 * percpu areas in pcpu_populate_chunk() is visible to all percpu
+	 * accesses through the returned percpu pointer.  The accessors get
+	 * their data dependency barrier from __verify_pcpu_ptr().
+	 */
+	smp_wmb();
 	return ptr;
 
 fail_unlock:
-- 
1.9.3
