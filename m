Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaHCBbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 21:31:14 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:45456 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaHCBbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 21:31:13 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Cc: Christoph Lameter <cl@linux.com>
Subject: [PATCH v4 1/1] doc: this_cpu_ops.txt: clarify remote accesses of per cpu areas
Date: Sat,  2 Aug 2014 21:30:36 -0400
Message-Id: <1407029436-26671-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Christoph Lameter <cl@linux.com>
---
v4: more updates from Christoph Lameter
v3: clearly mention that remote write access is discouraged
v2: updated with comments from Christoph Lameter

 Documentation/this_cpu_ops.txt | 174 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 146 insertions(+), 28 deletions(-)

diff --git a/Documentation/this_cpu_ops.txt b/Documentation/this_cpu_ops.txt
index 1a4ce7e..a94c017 100644
--- a/Documentation/this_cpu_ops.txt
+++ b/Documentation/this_cpu_ops.txt
@@ -2,33 +2,62 @@ this_cpu operations
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
 synchronization is not necessary since we are dealing with per cpu
 data specific to the currently executing processor. Only the current
 processor should be accessing that variable and therefore there are no
-concurrency issues with other processors in the system.
+concurrency issues with other processors in the system. Please see the
+section "Remote access to per-CPU data" if you need remote access.
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
 
 On x86 the fs: or the gs: segment registers contain the base of the
 per cpu area. It is then possible to simply use the segment override
@@ -53,12 +82,11 @@ this_cpu_ops such sequence also required preempt disable/enable to
 prevent the kernel from moving the thread to a different processor
 while the calculation is performed.
 
-The main use of the this_cpu operations has been to optimize counter
-operations.
+Consider the following this_cpu operation
 
 	this_cpu_inc(x)
 
-results in the following single instruction (no lock prefix!)
+The above results in the following single instruction (no lock prefix!)
 
 	inc gs:[x]
 
@@ -100,11 +128,10 @@ Takes the offset of a per cpu variable (&x !) and returns the address
 of the per cpu variable that belongs to the currently executing
 processor.  this_cpu_ptr avoids multiple steps that the common
 get_cpu/put_cpu sequence requires. No processor number is
-available. Instead the offset of the local per cpu area is simply
+available. Instead, the offset of the local per cpu area is simply
 added to the percpu offset.
 
 
-
 Per cpu variables and offsets
 -----------------------------
 
@@ -118,15 +145,16 @@ Therefore the use of x or &x outside of the context of per cpu
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
@@ -152,7 +180,7 @@ If we have an offset to struct s:
 
 	struct s __percpu *ps = &p;
 
-	z = this_cpu_dec(ps->m);
+	this_cpu_dec(ps->m);
 
 	z = this_cpu_inc_return(ps->n);
 
@@ -172,16 +200,39 @@ if we do not make use of this_cpu ops later to manipulate fields:
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
@@ -189,7 +240,6 @@ address relocation and a Read-Modify-Write operation in the same
 instruction.
 
 
-
 &this_cpu_ptr(pp)->n vs this_cpu_ptr(&pp->n)
 --------------------------------------------
 
@@ -202,4 +252,72 @@ with (). The second form also is consistent with the way
 this_cpu_read() and friends are used.
 
 
+Remote access to per cpu data
+------------------------------
+
+Per cpu data structures are designed to be used by one cpu exclusively.
+If you use the variables as intended, this_cpu_ops() are guaranteed to
+be "atomic" as no other CPU has access to these data structures. In this
+context, a remote access means an access to a per cpu data structure
+from a CPU without using the this_cpu_* operations.
+
+There are special cases where you might need to access per cpu data
+structures remotely. One such case is to perform maintenance tasks of
+idle CPUs without having to wake them up using IPIs for power saving
+purposes. It is usually safe to do a remote read access and that is
+frequently done to summarize counters. Remote write access is the one
+which is problematic. Remote write accesses to per cpu data structures
+are highly discouraged until absolutely necessary. Please consider using
+an IPI to wake up the remote CPU and perform the update to its per cpu
+area.
+
+To access per-cpu data structure remotely, you need to convert the
+per-cpu offset to a pointer using this_cpu_ptr().
+
+	DEFINE_PER_CPU(struct data, datap);
+	struct data *p = per_cpu(&datap, cpu);
+
+p can now be passed to another CPU to be updated remotely.
+
+This makes it explicit that we are getting ready to access a percpu
+area.
+
+You can also do the following to convert the datap offset to an address
+
+	struct data *p = this_cpu_ptr(&datap);
+
+but, passing of pointers calculated via this_cpu_ptr to other cpus is
+unusual and should be avoided.
+
+Such remote accesses to per CPU data are not guaranteed to be "atomic"
+anymore. You will have to use atomic_t and rely on the standard atomic
+operations for these remote accesses to be atomic. An important thing to
+keep in mind while performing remote accesses is cache line sharing.
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
+You cannot update the field 'a' remotely from one processor and expect
+this_cpu ops to work on the field b from the local CPU with atomic
+semantics. Care should be taken that such simultaneous access to data
+within the same cache line is avoided. Also costly synchronization is
+necessary when you are unsure of such cases. IPI is generally recommeded
+in such scenarios instead of remote write to per cpu areas.
+
+Even in cases where the remote writes are rare, please bear in
+mind that a remote write will evict the cache line from the processor
+that most likely will access it. If the processor wakes up and finds a
+missing local cache line of a per cpu area, its performance and hence
+the wake up times will be affected.
+
+Given these drawbacks, it is adviced to seriously consider the option of
+not using per cpu areas when there are considerable remote writes.
+
 Christoph Lameter, April 3rd, 2013
+Pranith Kumar, Aug 2nd, 2014
-- 
1.9.1

