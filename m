Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbaGPDjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:39:15 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:60245 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943AbaGPDjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:39:12 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Cc: Christoph Lameter <cl@linux.com>
Subject: [PATCH 1/1] doc: Add remote CPU access details to this_cpu_ops.txt
Date: Tue, 15 Jul 2014 23:39:35 -0400
Message-Id: <1405481975-23034-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more details from a recent kernel newbies mailing list discussion here:
http://www.spinics.net/lists/newbies/msg52747.html

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Christoph Lameter <cl@linux.com>
---
 Documentation/this_cpu_ops.txt | 107 +++++++++++++++++++++++++++++++++--------
 1 file changed, 87 insertions(+), 20 deletions(-)

diff --git a/Documentation/this_cpu_ops.txt b/Documentation/this_cpu_ops.txt
index 1a4ce7e..2381602 100644
--- a/Documentation/this_cpu_ops.txt
+++ b/Documentation/this_cpu_ops.txt
@@ -13,22 +13,53 @@ operating on the per cpu variable.
 
 This means there are no atomicity issues between the calculation of
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
+preemption.  Note that interrupts may still occur while an operation is
+in progress and if the interrupt too modifies the variable, then RMW
+actions may not be atomic.
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
@@ -53,12 +84,11 @@ this_cpu_ops such sequence also required preempt disable/enable to
 prevent the kernel from moving the thread to a different processor
 while the calculation is performed.
 
-The main use of the this_cpu operations has been to optimize counter
-operations.
+Consider the following this_cpu operation
 
 	this_cpu_inc(x)
 
-results in the following single instruction (no lock prefix!)
+The above results in the following single instruction (no lock prefix!)
 
 	inc gs:[x]
 
@@ -100,11 +130,10 @@ Takes the offset of a per cpu variable (&x !) and returns the address
 of the per cpu variable that belongs to the currently executing
 processor.  this_cpu_ptr avoids multiple steps that the common
 get_cpu/put_cpu sequence requires. No processor number is
-available. Instead the offset of the local per cpu area is simply
+available. Instead, the offset of the local per cpu area is simply
 added to the percpu offset.
 
 
-
 Per cpu variables and offsets
 -----------------------------
 
@@ -118,15 +147,15 @@ Therefore the use of x or &x outside of the context of per cpu
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
 
+&x and hence p is the *offset* a per cpu variable. this_cpu_ptr() takes
+the offset of a per cpu variable which makes this look a bit strange.
 
 
 Operations on a field of a per cpu structure
@@ -178,10 +207,26 @@ replaced by code that disables interrupts, then does the operations
 that are guaranteed to be atomic and then reenable interrupts. Doing
 so is expensive. If there are other reasons why the scheduler cannot
 change the processor we are executing on then there is no reason to
-disable interrupts. For that purpose the __this_cpu operations are
-provided. For example.
+disable interrupts. For that purpose the following __this_cpu operations
+are provided.
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
@@ -189,7 +234,6 @@ address relocation and a Read-Modify-Write operation in the same
 instruction.
 
 
-
 &this_cpu_ptr(pp)->n vs this_cpu_ptr(&pp->n)
 --------------------------------------------
 
@@ -202,4 +246,27 @@ with (). The second form also is consistent with the way
 this_cpu_read() and friends are used.
 
 
+Remote access to per-CPU data
+------------------------------
+
+Per cpu data structures are for the use of one cpu exclusively. If you
+use the variables as intended, this_cpu_ops() are guaranteed to be
+atomic as no other CPU has access to these data structures. But there are
+special cases where you might need to access per cpu data structures
+remotely. One such case is to perform maintenance tasks of idle CPUs
+without having to wake them up using IPIs for power saving purposes.
+This is not recommended unless absolutely necessary.
+
+To access per-cpu data structure remotely, you need to convert the
+per-cpu offset to a pointer using this_cpu_ptr().
+
+	DEFINE_PER_CPU(struct data, datap);
+	struct data *p = this_cpu_ptr(&datap);
+
+p can now be passed to another CPU to be updated remotely.
+
+Such remote accesses to per CPU data are not guaranteed to be atomic
+anymore. You will have to use atomic_t and rely on the standard atomic
+operations for these remote accesses to be atomic.
+
 Christoph Lameter, April 3rd, 2013
-- 
1.9.1

