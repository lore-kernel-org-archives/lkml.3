Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbaDBN22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:28:28 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:22779 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbaDBN2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:28:23 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v8 03/10] qspinlock: More optimized code for smaller NR_CPUS
Date: Wed,  2 Apr 2014 09:27:32 -0400
Message-Id: <1396445259-27670-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For architectures that support atomic operations on smaller 8 or
16 bits data types. It is possible to simplify the code and produce
slightly better optimized code at the expense of smaller number of
supported CPUs.

The qspinlock code can support up to a maximum of 4M-1 CPUs. With
less than 16K CPUs, it is possible to squeeze the queue code into a
2-byte short word which can be accessed directly as a 16-bit short
data type. This enables the simplification of the queue code exchange
portion of the slowpath code.

This patch introduces a new macro _ARCH_SUPPORTS_ATOMIC_8_16_BITS_OPS
which can now be defined in an architecture specific qspinlock.h header
file to indicate its support for smaller atomic operation data types.
This macro triggers the replacement of some of the generic functions
by more optimized versions.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/qspinlock.h      |   34 +++++++++++-
 include/asm-generic/qspinlock.h       |    8 ++-
 include/asm-generic/qspinlock_types.h |   20 ++++++-
 kernel/locking/qspinlock.c            |   95 +++++++++++++++++++++++++++++++++
 4 files changed, 151 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index 44cefee..f058b91 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -8,11 +8,23 @@
 #define _ARCH_SUPPORTS_ATOMIC_8_16_BITS_OPS
 
 /*
+ * As the qcode will be accessed as a 16-bit word, no offset is needed
+ */
+#define _QCODE_VAL_OFFSET	0
+
+/*
  * x86-64 specific queue spinlock union structure
+ * Besides the slock and lock fields, the other fields are only
+ * valid with less than 16K CPUs.
  */
 union arch_qspinlock {
 	struct qspinlock slock;
-	u8		 lock;	/* Lock bit	*/
+	struct {
+		u8  lock;	/* Lock bit	*/
+		u8  reserved;
+		u16 qcode;	/* Queue code	*/
+	};
+	u32 qlcode;		/* Complete lock word */
 };
 
 #define	queue_spin_unlock queue_spin_unlock
@@ -34,6 +46,26 @@ static inline void queue_spin_unlock(struct qspinlock *lock)
 	barrier();
 }
 
+#ifdef _QCODE_SHORT
+#define __queue_spin_trylock __queue_spin_trylock
+/**
+ * __queue_spin_trylock - acquire the lock by setting the lock bit
+ * @lock: Pointer to queue spinlock structure
+ * Return: Always return 1
+ *
+ * This routine should only be called when the caller is the only one
+ * entitled to acquire the lock. No lock stealing is allowed.
+ */
+static __always_inline int __queue_spin_trylock(struct qspinlock *lock)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	barrier();
+	ACCESS_ONCE(qlock->lock) = _QLOCK_LOCKED;
+	barrier();
+	return 1;
+}
+#endif /* _QCODE_SHORT */
 #endif /* !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE */
 
 #include <asm-generic/qspinlock.h>
diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index 8525931..f47d19e 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -32,17 +32,21 @@ extern void queue_spin_lock_slowpath(struct qspinlock *lock, int qsval);
  */
 static __always_inline int queue_spin_is_locked(struct qspinlock *lock)
 {
-	return atomic_read(&lock->qlcode) & _QLOCK_LOCK_MASK;
+	return atomic_read(&lock->qlcode);
 }
 
 /**
  * queue_spin_value_unlocked - is the spinlock structure unlocked?
  * @lock: queue spinlock structure
  * Return: 1 if it is unlocked, 0 otherwise
+ *
+ * N.B. Whenever there are tasks waiting for the lock, it is considered
+ *      locked wrt the lockref code to avoid lock stealing by the lockref
+ *      code and change things underneath the lock.
  */
 static __always_inline int queue_spin_value_unlocked(struct qspinlock lock)
 {
-	return !(atomic_read(&lock.qlcode) & _QLOCK_LOCK_MASK);
+	return !atomic_read(&lock.qlcode);
 }
 
 /**
diff --git a/include/asm-generic/qspinlock_types.h b/include/asm-generic/qspinlock_types.h
index fbfe898..5547aa7 100644
--- a/include/asm-generic/qspinlock_types.h
+++ b/include/asm-generic/qspinlock_types.h
@@ -33,17 +33,31 @@
 /*
  * The queue spinlock data structure - a 32-bit word
  *
- * The bits assignment are:
+ * For NR_CPUS >= 16K, the bits assignment are:
  *   Bit  0   : Set if locked
  *   Bits 1-7 : Not used
  *   Bits 8-31: Queue code
+ *
+ * For NR_CPUS < 16K, the bits assignment are:
+ *   Bit   0   : Set if locked
+ *   Bits  1-7 : Not used
+ *   Bits  8-15: Reserved for architecture specific optimization
+ *   Bits 16-31: Queue code
  */
 typedef struct qspinlock {
 	atomic_t	qlcode;	/* Lock + queue code */
 } arch_spinlock_t;
 
-#define _QCODE_OFFSET		8
+#if CONFIG_NR_CPUS >= (1 << 14)
+# define _QCODE_LONG		/* 24-bit queue code */
+# define _QCODE_OFFSET		8
+# define _QLOCK_LOCK_MASK	0xff
+#else
+# define _QCODE_SHORT		/* 16-bit queue code */
+# define _QCODE_OFFSET		16
+# define _QLOCK_LOCK_MASK	0xffff
+#endif
+
 #define _QLOCK_LOCKED		1U
-#define	_QLOCK_LOCK_MASK	0xff
 
 #endif /* __ASM_GENERIC_QSPINLOCK_TYPES_H */
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 92ed540..45c68a4 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -62,6 +62,10 @@
  * Bits 0-1 : queue node index (4 nodes)
  * Bits 2-23: CPU number + 1   (4M - 1 CPUs)
  *
+ * The 16-bit queue node code is divided into the following 2 fields:
+ * Bits 0-1 : queue node index (4 nodes)
+ * Bits 2-15: CPU number + 1   (16K - 1 CPUs)
+ *
  * A queue node code of 0 indicates that no one is waiting for the lock.
  * As the value 0 cannot be used as a valid CPU number. We need to add
  * 1 to it before putting it into the queue code.
@@ -104,6 +108,97 @@ static DEFINE_PER_CPU_ALIGNED(struct qnode_set, qnset) = { { { 0 } }, 0 };
 
 /*
  ************************************************************************
+ * The following optimized codes are for architectures that support:	*
+ *  1) Atomic byte and short data write					*
+ *  2) Byte and short data exchange and compare-exchange instructions	*
+ *									*
+ * For those architectures, their asm/qspinlock.h header file should	*
+ * define the followings in order to use the optimized codes.		*
+ *  1) The _ARCH_SUPPORTS_ATOMIC_8_16_BITS_OPS macro			*
+ *  2) A "union arch_qspinlock" structure that include the individual	*
+ *     fields of the qspinlock structure, including:			*
+ *      o slock     - the qspinlock structure				*
+ *      o lock      - the lock byte					*
+ *      o qcode     - the queue node code				*
+ *      o qlcode    - the 32-bit qspinlock word				*
+ *									*
+ ************************************************************************
+ */
+#ifdef _ARCH_SUPPORTS_ATOMIC_8_16_BITS_OPS
+#ifdef _QCODE_SHORT
+/*
+ * With less than 16K CPUs, the following optimizations are possible with
+ * architectures that allows atomic 8/16 bit operations:
+ *  1) The 16-bit queue code can be accessed or modified directly as a
+ *     16-bit short value without disturbing the first 2 bytes.
+ */
+#define queue_encode_qcode(cpu, idx)	(((cpu) + 1) << 2 | (idx))
+
+#define queue_code_xchg queue_code_xchg
+/**
+ * queue_code_xchg - exchange a queue code value
+ * @lock : Pointer to queue spinlock structure
+ * @ocode: Old queue code in the lock [OUT]
+ * @ncode: New queue code to be exchanged
+ * Return: NORMAL_EXIT is always returned
+ */
+static inline enum exitval
+queue_code_xchg(struct qspinlock *lock, u32 *ocode, u32 ncode)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	*ocode = xchg(&qlock->qcode, (u16)ncode);
+	return NORMAL_EXIT;
+}
+
+#define queue_spin_trylock_and_clr_qcode queue_spin_trylock_and_clr_qcode
+/**
+ * queue_spin_trylock_and_clr_qcode - Try to lock & clear qcode simultaneously
+ * @lock : Pointer to queue spinlock structure
+ * @qcode: The supposedly current qcode value
+ * Return: true if successful, false otherwise
+ */
+static inline int
+queue_spin_trylock_and_clr_qcode(struct qspinlock *lock, u32 qcode)
+{
+	qcode <<= _QCODE_OFFSET;
+	return atomic_cmpxchg(&lock->qlcode, qcode, _QLOCK_LOCKED) == qcode;
+}
+
+#define qsval_to_qcode qsval_to_qcode
+/**
+ * qsval_to_qcode - Convert a queue spinlock value to a queue code
+ * @qsval : Queue spinlock value
+ * Return : The corresponding queue code value
+ */
+static inline u32
+qsval_to_qcode(int qsval)
+{
+	return (u32)(qsval >> _QCODE_OFFSET);
+}
+#endif /* _QCODE_SHORT */
+
+#ifndef __queue_spin_trylock
+#define __queue_spin_trylock __queue_spin_trylock
+/**
+ * __queue_spin_trylock - try to acquire the lock by setting the lock bit
+ * @lock: Pointer to queue spinlock structure
+ * Return: 1 if lock bit set successfully, 0 if failed
+ *
+ * This is an unfair version of the trylock which should only be called
+ * by a caller who is entitled to acquire the lock.
+ */
+static __always_inline int __queue_spin_trylock(struct qspinlock *lock)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	return cmpxchg(&qlock->lock, 0, _QLOCK_LOCKED) == 0;
+}
+#endif
+#endif /*  _ARCH_SUPPORTS_ATOMIC_8_16_BITS_OPS  */
+
+/*
+ ************************************************************************
  * Inline functions used by the queue_spin_lock_slowpath() function	*
  * that may get superseded by a more optimized version.			*
  ************************************************************************
-- 
1.7.1

