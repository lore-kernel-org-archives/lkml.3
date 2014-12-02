Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbaLBQ5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:57:53 -0500
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:51231 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932303AbaLBQ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:57:51 -0500
Date: Tue, 2 Dec 2014 10:57:50 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Final per cpu consistency patch for -next or late in 3.19 merge
 period
In-Reply-To: <20141202164024.GA10918@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1412021049580.13039@gentwo.org>
References: <alpine.DEB.2.11.1411281229350.11435@gentwo.org> <20141202164024.GA10918@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014, Tejun Heo wrote:

> Can you please update Documentation/local_ops.txt and comments which
> contain __get_cpu_var() and send the updated patch to Andrew?

Owww.... local_* ops are exotic operations that should no longer be
regularly used. This_cpu ops create less overhead and
are simpler to use. Lets merge the prior patch as is and then add this
documentation patch which may cause some additional discussion.




From: Christoph Lameter <cl@linux.com>
Subject: [PATCH] Update local_ops.txt to reflect this_cpu operations

Update the documentation to reflect changes due to the availability
of this_cpu operations.

Signed-off-by: Christoph Lameter <cl@linux.com>
---
 include/asm-generic/percpu.h | 5 -----
 1 file changed, 5 deletions(-)

Index: linux/Documentation/local_ops.txt
===================================================================
--- linux.orig/Documentation/local_ops.txt
+++ linux/Documentation/local_ops.txt
@@ -8,6 +8,11 @@ to implement them for any given architec
 properly. It also stresses on the precautions that must be taken when reading
 those local variables across CPUs when the order of memory writes matters.

+Note that local_t based operations are not recommended for general kernel use.
+Please use the this_cpu operations instead unless there is really a special purpose.
+Most uses of local_t in the kernel have been replaced by this_cpu operations.
+this_cpu operations combine the relocation with the local_t like semantics in
+a single instruction and yield more compact and faster executing code.


 * Purpose of local atomic operations
@@ -87,10 +92,10 @@ the per cpu variable. For instance :
 	local_inc(&get_cpu_var(counters));
 	put_cpu_var(counters);

-If you are already in a preemption-safe context, you can directly use
-__get_cpu_var() instead.
+If you are already in a preemption-safe context, you can use
+this_cpu_ptr() instead.

-	local_inc(&__get_cpu_var(counters));
+	local_inc(this_cpu_ptr(&counters));



@@ -134,7 +139,7 @@ static void test_each(void *info)
 {
 	/* Increment the counter from a non preemptible context */
 	printk("Increment on cpu %d\n", smp_processor_id());
-	local_inc(&__get_cpu_var(counters));
+	local_inc(this_cpu_ptr(&counters));

 	/* This is what incrementing the variable would look like within a
 	 * preemptible context (it disables preemption) :
