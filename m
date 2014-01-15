Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaAOEod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:44:33 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:12282 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaAOEob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:44:31 -0500
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
Subject: [PATCH v9 3/5] qrwlock, x86 - Treat all data type not bigger than long as atomic in x86
Date: Tue, 14 Jan 2014 23:44:05 -0500
Message-Id: <1389761047-47566-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com>
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic __native_word() macro defined in include/linux/compiler.h
only allows "int" and "long" data types to be treated as native and
atomic. The x86 architecture, however, allow the use of char and short
data types as atomic as well.

This patch extends the data type allowed in the __native_word() macro to
allow the use of char and short.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/barrier.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 04a4890..4d3e30a 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -24,6 +24,14 @@
 #define wmb()	asm volatile("sfence" ::: "memory")
 #endif
 
+/*
+ * All data types <= long are atomic in x86
+ */
+#ifdef __native_word
+#undef __native_word
+#endif
+#define __native_word(t)	(sizeof(t) <= sizeof(long))
+
 /**
  * read_barrier_depends - Flush all pending reads that subsequents reads
  * depend on.
-- 
1.7.1

