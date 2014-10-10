Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaJJVsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:48:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:24682 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbaJJVsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:48:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,695,1406617200"; 
   d="scan'208";a="586982390"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, rostedt@goodmis.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] x86: Add trace point for MSR accesses
Date: Fri, 10 Oct 2014 14:47:51 -0700
Message-Id: <1412977673-13500-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412977673-13500-1-git-send-email-andi@firstfloor.org>
References: <1412977673-13500-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For debugging low level code interacting with the CPU
it is often useful to trace the MSR read/writes. This gives
a concise summary of PMU and other operations.

perf has an ad-hoc way to do this using trace_printk,
but it's somewhat limited (and also now spews ugly
messages when enabled)

Instead define real trace points for all MSR accesses.

This adds two new trace point: read_msr and write_msr.
They also report if the access faulted (if *_safe is used)

This allows filtering and triggering on specific
MSR values, which allows various more advanced
debugging techniques.

All the values are well defined in the CPU documentation.

I only added it to native MSR accesses in C, not paravirtualized
or in entry*.S (which is not too interesting)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/lib/msr.c         | 14 ++++++++++++--
 include/trace/events/msr.h | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/msr.h

diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index dc857b8..eb49761 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -1,6 +1,8 @@
 #include <linux/module.h>
 #include <linux/preempt.h>
 #include <asm/msr.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/msr.h>
 
 struct msr *msrs_alloc(void)
 {
@@ -111,16 +113,20 @@ int msr_clear_bit(u32 msr, u8 bit)
 
 inline unsigned long long native_read_msr(unsigned int msr)
 {
+	unsigned long long lval;
 	DECLARE_ARGS(val, low, high);
 
 	asm volatile("rdmsr" : EAX_EDX_RET(val, low, high) : "c" (msr));
-	return EAX_EDX_VAL(val, low, high);
+	lval = EAX_EDX_VAL(val, low, high);
+	trace_read_msr(msr, lval, 0);
+	return lval;
 }
 EXPORT_SYMBOL(native_read_msr);
 
 inline unsigned long long native_read_msr_safe(unsigned int msr,
 						      int *err)
 {
+	unsigned long long lval;
 	DECLARE_ARGS(val, low, high);
 
 	asm volatile("2: rdmsr ; xor %[err],%[err]\n"
@@ -131,7 +137,9 @@ inline unsigned long long native_read_msr_safe(unsigned int msr,
 		     _ASM_EXTABLE(2b, 3b)
 		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
 		     : "c" (msr), [fault] "i" (-EIO));
-	return EAX_EDX_VAL(val, low, high);
+	lval = EAX_EDX_VAL(val, low, high);
+	trace_read_msr(msr, lval, *err);
+	return lval;
 }
 EXPORT_SYMBOL(native_read_msr_safe);
 
@@ -139,6 +147,7 @@ inline void native_write_msr(unsigned int msr,
 				    unsigned low, unsigned high)
 {
 	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high) : "memory");
+	trace_write_msr(msr, ((u64)high << 32 | low), 0);
 }
 EXPORT_SYMBOL(native_write_msr);
 
@@ -157,6 +166,7 @@ notrace inline int native_write_msr_safe(unsigned int msr,
 		     : "c" (msr), "0" (low), "d" (high),
 		       [fault] "i" (-EIO)
 		     : "memory");
+	trace_write_msr(msr, ((u64)high << 32 | low), err);
 	return err;
 }
 EXPORT_SYMBOL(native_write_msr_safe);
diff --git a/include/trace/events/msr.h b/include/trace/events/msr.h
new file mode 100644
index 0000000..e1677e8
--- /dev/null
+++ b/include/trace/events/msr.h
@@ -0,0 +1,46 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM msr
+
+#if !defined(_TRACE_MSR_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MSR_H
+
+#include <linux/tracepoint.h>
+
+/*
+ * Tracing for x86 model specific registers. Directly maps to the
+ * RDMSR/WRMSR instructions.
+ */
+
+DECLARE_EVENT_CLASS(msr_trace_class,
+	    TP_PROTO(unsigned msr, u64 val, int failed),
+	    TP_ARGS(msr, val, failed),
+	    TP_STRUCT__entry(
+		    __field(	unsigned,	msr )
+		    __field(    u64,		val )
+		    __field(    int,		failed )
+	    ),
+	    TP_fast_assign(
+		    __entry->msr = msr;
+		    __entry->val = val;
+		    __entry->failed = failed;
+	    ),
+	    TP_printk("%x, value %llx%s",
+		      __entry->msr,
+		      __entry->val,
+		      __entry->failed ? " #GP" : "")
+);
+
+DEFINE_EVENT(msr_trace_class, read_msr,
+	     TP_PROTO(unsigned msr, u64 val, int failed),
+	     TP_ARGS(msr, val, failed)
+);
+
+DEFINE_EVENT(msr_trace_class, write_msr,
+	     TP_PROTO(unsigned msr, u64 val, int failed),
+	     TP_ARGS(msr, val, failed)
+);
+
+#endif /* _TRACE_MSR_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.9.3

