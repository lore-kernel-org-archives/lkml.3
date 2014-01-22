Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaAVVem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:34:42 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:31697 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaAVVej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:34:39 -0500
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v10 3/4] qrwlock, x86: Add char and short as atomic data type in x86
Date: Wed, 22 Jan 2014 16:33:57 -0500
Message-Id: <1390426438-31252-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1390426438-31252-1-git-send-email-Waiman.Long@hp.com>
References: <1390426438-31252-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic __native_word() macro defined in include/linux/compiler.h
only allows "int" and "long" data types to be treated as native and
atomic. The x86 architecture, however, allow the use of char and short
data types as atomic as well.

This patch extends the data type allowed in the __native_word() macro to
allow the use of char and short for the x86 architecture.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/barrier.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 04a4890..0149a66 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -24,6 +24,24 @@
 #define wmb()	asm volatile("sfence" ::: "memory")
 #endif
 
+/*
+ * Define x86 specific atomic types that can be used in read_acquire
+ * and store_release barriers.
+ */
+#define __arch_native_word(t)	(sizeof(t) == sizeof(char)  || \
+				 sizeof(t) == sizeof(short) || \
+				 sizeof(t) == sizeof(int)   || \
+				 sizeof(t) == sizeof(long))
+/*
+ * Due to cyclic header file dependency problem, the only way to modify
+ * the behavior of __native_word() macro within
+ * compiletime_assert_atomic_type() is to redefine it.
+ */
+#ifdef __native_word
+#undef __native_word
+#endif
+#define __native_word(t)	__arch_native_word(t)
+
 /**
  * read_barrier_depends - Flush all pending reads that subsequents reads
  * depend on.
-- 
1.7.1

