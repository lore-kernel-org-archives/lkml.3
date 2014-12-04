Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaLDGUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:20:15 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:54076 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLDGUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:20:13 -0500
Date: Wed, 3 Dec 2014 22:20:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, dvyukov@google.com, dave@stgolabs.net,
        mingo@kernel.org, peterz@infradead.org, torvalds@linux-foundation.org
Subject: [PATCH RFC] locking: Add volatile to arch_spinlock_t structures
Message-ID: <20141204062005.GA2553@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120406-0025-0000-0000-0000069D3078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More concern about compilers...

Most architectures mark the fields in their arch_spinlock_t structures
as volatile, which forces the compiler to respect the integrity of
those fields.  Without volatile markings, the compiler is within its
rights to overwrite these fields, for example, by using a wide store
to update an adjacent field as long as it fixes them up later.  This
sort of thing could come as a rather nasty surprise to any task attempting
to concurrently acquire that lock.

For example, on x86 for smallish NR_CPUS, arch_spinlock_t is 16 bits wide.
If there were three adjacent 16-bit fields in the structure containing
the arch_spinlock_t, a compiler might reasonably use 64-bit accesses
for those three fields.  After a 64-bit load, the arch_spinlock_t's
value would be available in a register, so that the compiler might use
a 64-bit store followed by a 16-bit fixup store to update the three
adjacent 16-bit fields.

This commit therefore adds volatile to the arch_spinlock_t and
arch_rwlock_t fields that don't already have them.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-arch@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/arm/include/asm/spinlock_types.h b/arch/arm/include/asm/spinlock_types.h
index 47663fcb10ad..7d3b6ecb5301 100644
--- a/arch/arm/include/asm/spinlock_types.h
+++ b/arch/arm/include/asm/spinlock_types.h
@@ -9,14 +9,14 @@
 
 typedef struct {
 	union {
-		u32 slock;
+		volatile u32 slock;
 		struct __raw_tickets {
 #ifdef __ARMEB__
-			u16 next;
-			u16 owner;
+			volatile u16 next;
+			volatile u16 owner;
 #else
-			u16 owner;
-			u16 next;
+			volatile u16 owner;
+			volatile u16 next;
 #endif
 		} tickets;
 	};
@@ -25,7 +25,7 @@ typedef struct {
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
 
 typedef struct {
-	u32 lock;
+	volatile u32 lock;
 } arch_rwlock_t;
 
 #define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
diff --git a/arch/arm64/include/asm/spinlock_types.h b/arch/arm64/include/asm/spinlock_types.h
index b8d383665f56..0f841378f0f3 100644
--- a/arch/arm64/include/asm/spinlock_types.h
+++ b/arch/arm64/include/asm/spinlock_types.h
@@ -24,11 +24,11 @@
 
 typedef struct {
 #ifdef __AARCH64EB__
-	u16 next;
-	u16 owner;
+	volatile u16 next;
+	volatile u16 owner;
 #else
-	u16 owner;
-	u16 next;
+	volatile u16 owner;
+	volatile u16 next;
 #endif
 } __aligned(4) arch_spinlock_t;
 
diff --git a/arch/mips/include/asm/spinlock_types.h b/arch/mips/include/asm/spinlock_types.h
index 9b2528e612c0..10f04a0482dd 100644
--- a/arch/mips/include/asm/spinlock_types.h
+++ b/arch/mips/include/asm/spinlock_types.h
@@ -14,14 +14,14 @@ typedef union {
 	 * bits	 0..15 : serving_now
 	 * bits 16..31 : ticket
 	 */
-	u32 lock;
+	volatile u32 lock;
 	struct {
 #ifdef __BIG_ENDIAN
-		u16 ticket;
-		u16 serving_now;
+		volatile u16 ticket;
+		volatile u16 serving_now;
 #else
-		u16 serving_now;
-		u16 ticket;
+		volatile u16 serving_now;
+		volatile u16 ticket;
 #endif
 	} h;
 } arch_spinlock_t;
diff --git a/arch/mn10300/include/asm/spinlock_types.h b/arch/mn10300/include/asm/spinlock_types.h
index 653dc519b405..04fd2c622f81 100644
--- a/arch/mn10300/include/asm/spinlock_types.h
+++ b/arch/mn10300/include/asm/spinlock_types.h
@@ -6,13 +6,13 @@
 #endif
 
 typedef struct arch_spinlock {
-	unsigned int slock;
+	volatile unsigned int slock;
 } arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
-	unsigned int lock;
+	volatile unsigned int lock;
 } arch_rwlock_t;
 
 #define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
diff --git a/arch/s390/include/asm/spinlock_types.h b/arch/s390/include/asm/spinlock_types.h
index d84b6939237c..0ccdda3b6842 100644
--- a/arch/s390/include/asm/spinlock_types.h
+++ b/arch/s390/include/asm/spinlock_types.h
@@ -6,14 +6,14 @@
 #endif
 
 typedef struct {
-	unsigned int lock;
+	volatile unsigned int lock;
 } __attribute__ ((aligned (4))) arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED { .lock = 0, }
 
 typedef struct {
-	unsigned int lock;
-	unsigned int owner;
+	volatile unsigned int lock;
+	volatile unsigned int owner;
 } arch_rwlock_t;
 
 #define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
diff --git a/arch/tile/include/asm/spinlock_types.h b/arch/tile/include/asm/spinlock_types.h
index a71f59b49c50..29f70a14b979 100644
--- a/arch/tile/include/asm/spinlock_types.h
+++ b/arch/tile/include/asm/spinlock_types.h
@@ -23,14 +23,14 @@
 
 /* Low 15 bits are "next"; high 15 bits are "current". */
 typedef struct arch_spinlock {
-	unsigned int lock;
+	volatile unsigned int lock;
 } arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
 /* High bit is "writer owns"; low 31 bits are a count of readers. */
 typedef struct arch_rwlock {
-	unsigned int lock;
+	volatile unsigned int lock;
 } arch_rwlock_t;
 
 #define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
@@ -39,9 +39,9 @@ typedef struct arch_rwlock {
 
 typedef struct arch_spinlock {
 	/* Next ticket number to hand out. */
-	int next_ticket;
+	volatile int next_ticket;
 	/* The ticket number that currently owns this lock. */
-	int current_ticket;
+	volatile int current_ticket;
 } arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ 0, 0 }
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 5f9d7572d82b..fead0ca82468 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -25,9 +25,9 @@ typedef u32 __ticketpair_t;
 
 typedef struct arch_spinlock {
 	union {
-		__ticketpair_t head_tail;
+		volatile __ticketpair_t head_tail;
 		struct __raw_tickets {
-			__ticket_t head, tail;
+			volatile __ticket_t head, tail;
 		} tickets;
 	};
 } arch_spinlock_t;

