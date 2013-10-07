Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3JGSb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:31:57 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:10763 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755692Ab3JGSby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:31:54 -0400
Message-Id: <000001419430909f-da6a6e6c-103b-4c2e-9fa3-39e70a9b35a9-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 7 Oct 2013 18:31:53 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, linux-mm@kvack.org,
        Alex Shi <alex.shi@intel.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [raw v1 1/4] Use raw_cpu ops for determining current NUMA node
References: <20131007183226.334180014@linux.com>
X-SES-Outgoing: 199.255.194.110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the preempt check logic we will get false positives from
these locations. Before the use of __this_cpu ops there were
no checks for preemption present either and smp_raw_processor_id()
was used. See http://www.spinics.net/lists/linux-numa/msg00641.html

Use raw_cpu_read() to avoid preemption messages.

Note that this issue has been discussed in prior years.
If the process changes nodes after retrieving the current numa node then
that is acceptable since most uses of numa_node etc are for optimization
and not for correctness.

CC: linux-mm@kvack.org
Cc: Alex Shi <alex.shi@intel.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/topology.h
===================================================================
--- linux.orig/include/linux/topology.h	2013-09-24 11:29:51.000000000 -0500
+++ linux/include/linux/topology.h	2013-09-24 11:30:18.893831971 -0500
@@ -182,7 +182,7 @@ DECLARE_PER_CPU(int, numa_node);
 /* Returns the number of the current Node. */
 static inline int numa_node_id(void)
 {
-	return __this_cpu_read(numa_node);
+	return raw_cpu_read(numa_node);
 }
 #endif
 
@@ -239,7 +239,7 @@ static inline void set_numa_mem(int node
 /* Returns the number of the nearest Node with memory */
 static inline int numa_mem_id(void)
 {
-	return __this_cpu_read(_numa_mem_);
+	return raw_cpu_read(_numa_mem_);
 }
 #endif
 

