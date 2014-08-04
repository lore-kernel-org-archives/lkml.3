Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaHDPdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:33:32 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:49178
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbaHDPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:30:29 -0400
Date: Mon, 4 Aug 2014 10:30:26 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] doc: this_cpu_ops.txt: clarify remote accesses
 of per cpu areas
In-Reply-To: <alpine.DEB.2.11.1408040952050.8248@gentwo.org>
Message-ID: <alpine.DEB.2.11.1408041029170.9511@gentwo.org>
References: <1407029436-26671-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1408040952050.8248@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I updated the descriptions a bit more. Here is a patch with additional
changes to merge.


Subject: doc: Update description of this_cpu_ops

Update the description for per cpu operations to clarify use cases
if this_cpu operations and add considerations for remote access.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/Documentation/this_cpu_ops.txt
===================================================================
--- linux.orig/Documentation/this_cpu_ops.txt	2014-08-04 10:03:30.669924060 -0500
+++ linux/Documentation/this_cpu_ops.txt	2014-08-04 10:29:08.860592601 -0500
@@ -2,26 +2,26 @@
 -------------------

 this_cpu operations are a way of optimizing access to per cpu
-variables associated with the *currently* executing processor through
-the use of segment registers (or a dedicated register where the cpu
-permanently stored the beginning of the per cpu area for a specific
-processor).
+variables associated with the *currently* executing processor. This is
+done through the use of segment registers (or a dedicated register where
+the cpu permanently stored the beginning of the per cpu	area for a
+specific processor).

-The this_cpu operations add a per cpu variable offset to the processor
+this_cpu operations add a per cpu variable offset to the processor
 specific percpu base and encode that operation in the instruction
 operating on the per cpu variable.

-This means there are no atomicity issues between the calculation of
+This means that there are no atomicity issues between the calculation of
 the offset and the operation on the data. Therefore it is not
-necessary to disable preempt or interrupts to ensure that the
+necessary to disable preemption or interrupts to ensure that the
 processor is not changed between the calculation of the address and
 the operation on the data.

 Read-modify-write operations are of particular interest. Frequently
 processors have special lower latency instructions that can operate
-without the typical synchronization overhead but still provide some
-sort of relaxed atomicity guarantee. The x86 for example can execute
-RMV (Read Modify Write) instructions like inc/dec/cmpxchg without the
+without the typical synchronization overhead, but still provide some
+sort of relaxed atomicity guarantees. The x86, for example, can execute
+RMW (Read Modify Write) instructions like inc/dec/cmpxchg without the
 lock prefix and the associated latency penalty.

 Access to the variable without the lock prefix is not synchronized but
@@ -30,6 +30,38 @@
 processor should be accessing that variable and therefore there are no
 concurrency issues with other processors in the system.

+Please note that accesses by remote processors to a per cpu area are
+exceptional situations and may impact performance and/or correctness
+(remote write operations) of local RMV operations via this_cpu_*.
+
+The main use of the this_cpu operations has been to optimize counter
+operations.
+
+The following this_cpu() operations with implied preemption protection
+are defined. These operations can be used without worrying about
+preemption and interrupts.
+
+	this_cpu_add()
+	this_cpu_read(pcp)
+	this_cpu_write(pcp, val)
+	this_cpu_add(pcp, val)
+	this_cpu_and(pcp, val)
+	this_cpu_or(pcp, val)
+	this_cpu_add_return(pcp, val)
+	this_cpu_xchg(pcp, nval)
+	this_cpu_cmpxchg(pcp, oval, nval)
+	this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+	this_cpu_sub(pcp, val)
+	this_cpu_inc(pcp)
+	this_cpu_dec(pcp)
+	this_cpu_sub_return(pcp, val)
+	this_cpu_inc_return(pcp)
+	this_cpu_dec_return(pcp)
+
+
+Inner working of this_cpu operations
+------------------------------------
+
 On x86 the fs: or the gs: segment registers contain the base of the
 per cpu area. It is then possible to simply use the segment override
 to relocate a per cpu relative address to the proper per cpu area for
@@ -53,17 +85,16 @@
 prevent the kernel from moving the thread to a different processor
 while the calculation is performed.

-The main use of the this_cpu operations has been to optimize counter
-operations.
+Consider the following this_cpu operation:

 	this_cpu_inc(x)

-results in the following single instruction (no lock prefix!)
+The above results in the following single instruction (no lock prefix!)

 	inc gs:[x]

 instead of the following operations required if there is no segment
-register.
+register:

 	int *y;
 	int cpu;
@@ -88,7 +119,7 @@
 the same code paths.  Since each processor has its own per cpu
 variables no concurrent cacheline updates take place. The price that
 has to be paid for this optimization is the need to add up the per cpu
-counters when the value of the counter is needed.
+counters when the value of a counter is needed.


 Special operations:
@@ -100,9 +131,14 @@
 of the per cpu variable that belongs to the currently executing
 processor.  this_cpu_ptr avoids multiple steps that the common
 get_cpu/put_cpu sequence requires. No processor number is
-available. Instead the offset of the local per cpu area is simply
+available. Instead, the offset of the local per cpu area is simply
 added to the percpu offset.

+Note that this operation is usually used in a code segment when
+preemption has been disabled. The pointer is then used to
+access local per cpu data in a critical section. When preemption
+is reenabled this pointer is usually no longer useful since it may
+no longer point to per cpu data of the current processor.


 Per cpu variables and offsets
@@ -118,15 +154,16 @@
 operations is invalid and will generally be treated like a NULL
 pointer dereference.

-In the context of per cpu operations
+	DEFINE_PER_CPU(int, x);

-	x is a per cpu variable. Most this_cpu operations take a cpu
-	variable.
+In the context of per cpu operations the above implies that x is a per
+cpu variable. Most this_cpu operations take a cpu variable.

-	&x is the *offset* a per cpu variable. this_cpu_ptr() takes
-	the offset of a per cpu variable which makes this look a bit
-	strange.
+	int __percpu *p = &x;

+&x and hence p is the *offset* of a per cpu variable. this_cpu_ptr()
+takes the offset of a per cpu variable which makes this look a bit
+strange.


 Operations on a field of a per cpu structure
@@ -152,7 +189,7 @@

 	struct s __percpu *ps = &p;

-	z = this_cpu_dec(ps->m);
+	this_cpu_dec(ps->m);

 	z = this_cpu_inc_return(ps->n);

@@ -172,16 +209,39 @@
 Variants of this_cpu ops
 -------------------------

-this_cpu ops are interrupt safe. Some architecture do not support
+this_cpu ops are interrupt safe. Some architectures do not support
 these per cpu local operations. In that case the operation must be
 replaced by code that disables interrupts, then does the operations
 that are guaranteed to be atomic and then reenable interrupts. Doing
 so is expensive. If there are other reasons why the scheduler cannot
 change the processor we are executing on then there is no reason to
-disable interrupts. For that purpose the __this_cpu operations are
-provided. For example.
+disable interrupts. For that purpose the following __this_cpu operations
+are provided.
+
+These operations have no guarantee against concurrent interrupts or
+preemption. If a per cpu variable is not used in an interrupt context
+and the scheduler cannot preempt, then they are safe. If any interrupts
+still occur while an operation is in progress and if the interrupt too
+modifies the variable, then RMW actions can not be guaranteed to be
+safe.
+
+	__this_cpu_add()
+	__this_cpu_read(pcp)
+	__this_cpu_write(pcp, val)
+	__this_cpu_add(pcp, val)
+	__this_cpu_and(pcp, val)
+	__this_cpu_or(pcp, val)
+	__this_cpu_add_return(pcp, val)
+	__this_cpu_xchg(pcp, nval)
+	__this_cpu_cmpxchg(pcp, oval, nval)
+	__this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+	__this_cpu_sub(pcp, val)
+	__this_cpu_inc(pcp)
+	__this_cpu_dec(pcp)
+	__this_cpu_sub_return(pcp, val)
+	__this_cpu_inc_return(pcp)
+	__this_cpu_dec_return(pcp)

-	__this_cpu_inc(x);

 Will increment x and will not fallback to code that disables
 interrupts on platforms that cannot accomplish atomicity through
@@ -189,12 +249,12 @@
 instruction.


-
 &this_cpu_ptr(pp)->n vs this_cpu_ptr(&pp->n)
 --------------------------------------------

 The first operation takes the offset and forms an address and then
-adds the offset of the n field.
+adds the offset of the n field. This may result in two add
+instructions emitted by the compiler.

 The second one first adds the two offsets and then does the
 relocation.  IMHO the second form looks cleaner and has an easier time
@@ -202,4 +262,73 @@
 this_cpu_read() and friends are used.


-Christoph Lameter, April 3rd, 2013
+Remote access to per cpu data
+------------------------------
+
+Per cpu data structures are designed to be used by one cpu exclusively.
+If you use the variables as intended, this_cpu_ops() are guaranteed to
+be "atomic" as no other CPU has access to these data structures.
+
+There are special cases where you might need to access per cpu data
+structures remotely. It is usually safe to do a remote read access
+and that is frequently done to summarize counters. Remote write access
+something which could be problematic because this_cpu ops do not
+have lock semantics. A remote write may interfere with a this_cpu
+RMV operation.
+
+Remote write accesses to percpu data structures are highly discouraged
+unless absolutely necessary. Please consider using an IPI to wake up
+the remote CPU and perform the update to its per cpu area.
+
+To access per-cpu data structure remotely, typically the per_cpu_ptr()
+function is used:
+
+
+	DEFINE_PER_CPU(struct data, datap);
+
+	struct data *p = per_cpu_ptr(&datap, cpu);
+
+This makes it explicit that we are getting ready to access a percpu
+area remotely.
+
+You can also do the following to convert the datap offset to an address
+
+	struct data *p = this_cpu_ptr(&datap);
+
+but, passing of pointers calculated via this_cpu_ptr to other cpus is
+unusual and should be avoided.
+
+Remote access are typically only for reading the status of another cpus
+per cppu data. Write accesses can cause unique problems due to the
+relaxed synchronization requirements for this_cpu operations.
+
+One example that illustrates some concerns with write operations is
+the following scenario that occurs because two per cpu variables
+share a cacheline but the relaxed synchronization is applied to
+only one process updating the cacheline.
+
+Consider the following example
+
+
+	struct test {
+		atomic_t a;
+		int b;
+	};
+
+	DEFINE_PER_CPU(struct test, onecacheline);
+
+There is some concern about what would happen if the field 'a' is updated
+remotely from one processor and the local processor would use this_cpu ops
+to update field b. Care should be taken that such simultaneous accesses to
+data within the same cache line are avoided. Also costly synchronization
+may be necessary. IPIs are generally recommeded in such scenarios instead
+of a remote write to the per cpu area of another processor.
+
+Even in cases where the remote writes are rare, please bear in
+mind that a remote write will evict the cache line from the processor
+that most likely will access it. If the processor wakes up and finds a
+missing local cache line of a per cpu area, its performance and hence
+the wake up times will be affected.
+
+Christoph Lameter, August 4th, 2014
+Pranith Kumar, Aug 2nd, 2014
