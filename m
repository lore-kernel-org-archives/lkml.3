Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420Ab3BMQjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:39:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:59975 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934352Ab3BMQj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:39:28 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 14/16] slub: only IPI CPUs that have per cpu obj to flush
Date: Wed, 13 Feb 2013 17:12:09 +0100
Message-Id: <1360771932-27150-15-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

flush_all() is called for each kmem_cache_destroy().  So every cache being
destroyed dynamically ends up sending an IPI to each CPU in the system,
regardless if the cache has ever been used there.

For example, if you close the Infinband ipath driver char device file, the
close file ops calls kmem_cache_destroy().  So running some infiniband
config tool on one a single CPU dedicated to system tasks might interrupt
the rest of the 127 CPUs dedicated to some CPU intensive or latency
sensitive task.

I suspect there is a good chance that every line in the output of "git
grep kmem_cache_destroy linux/ | grep '\->'" has a similar scenario.

This patch attempts to rectify this issue by sending an IPI to flush the
per cpu objects back to the free lists only to CPUs that seem to have such
objects.

The check which CPU to IPI is racy but we don't care since asking a CPU
without per cpu objects to flush does no damage and as far as I can tell
the flush_all by itself is racy against allocs on remote CPUs anyway, so
if you required the flush_all to be determinstic, you had to arrange for
locking regardless.

Without this patch the following artificial test case:

$ cd /sys/kernel/slab
$ for DIR in *; do cat $DIR/alloc_calls > /dev/null; done

produces 166 IPIs on an cpuset isolated CPU. With it it produces none.

The code path of memory allocation failure for CPUMASK_OFFSTACK=y
config was tested using fault injection framework.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Avi Kivity <avi@redhat.com>
Cc: Michal Nazarewicz <mina86@mina86.org>
Cc: Kosaki Motohiro <kosaki.motohiro@gmail.com>
Cc: Milton Miller <miltonm@bga.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 mm/slub.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index d9ba33d..2a250f4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2030,9 +2030,17 @@ static void flush_cpu_slab(void *d)
 	__flush_cpu_slab(s, smp_processor_id());
 }
 
+static bool has_cpu_slab(int cpu, void *info)
+{
+	struct kmem_cache *s = info;
+	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+
+	return !!(c->page);
+}
+
 static void flush_all(struct kmem_cache *s)
 {
-	on_each_cpu(flush_cpu_slab, s, 1);
+	on_each_cpu_cond(has_cpu_slab, flush_cpu_slab, s, 1, GFP_ATOMIC);
 }
 
 /*
-- 
1.7.10.4

