Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab3HJRwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:52:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36743 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab3HJRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:52:22 -0400
Date: Sat, 10 Aug 2013 10:51:54 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Stephane Eranian <eranian@google.com>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 5/7] powerpc/perf: Define big-endian version of
 perf_mem_data_src
Message-ID: <20130810175153.GF15551@us.ibm.com>
References: <20130810174831.GA15551@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130810174831.GA15551@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081017-3620-0000-0000-000003E3DBB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 5/7] powerpc/perf: Define big-endian version of perf_mem_data_src

perf_mem_data_src is an union that is initialized via the ->val field
and accessed via the bitmap fields. For this to work on big endian
platforms, we also need a big-endian represenation of perf_mem_data_src.

Cc: Stephane Eranian <eranian@google.com>
Cc: Paul Mckerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---

Thanks to input from Stephane Eranian and Michael Ellerman.

 include/uapi/linux/perf_event.h |   55 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 62c25a2..8497c51 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -19,6 +19,47 @@
 #include <asm/byteorder.h>
 
 /*
+ * Kernel and userspace check for endianness in incompatible ways.
+ * In user space, <endian.h> defines both __BIG_ENDIAN and __LITTLE_ENDIAN
+ * but sets __BYTE_ORDER to one or the other. So user space uses checks are:
+ *
+ *	#if __BYTE_ORDER == __LITTLE_ENDIAN
+ *
+ * In the kernel, __BYTE_ORDER is undefined, so using the above check doesn't
+ * work. Further, kernel code assumes that exactly one of __BIG_ENDIAN and
+ * __LITTLE_ENDIAN is defined.  So the kernel checks are like:
+ *
+ *	#if defined(__LITTLE_ENDIAN)
+ *
+ * But we can't use that check in user space since __LITTLE_ENDIAN (and
+ * __BIG_ENDIAN) are always defined.
+ *
+ * Since some perf data structures depend on endianness _and_ are shared
+ * between kernel and user, perf needs its own notion of endian macros (at
+ * least until user and kernel endian checks converge).
+ */
+#define __PERF_LE	1234
+#define __PERF_BE	4321
+
+#if defined(__KERNEL__)
+
+#if defined(__LITTLE_ENDIAN)
+#define __PERF_BYTE_ORDER	__PERF_LE
+#elif defined(__BIG_ENDIAN)
+#define __PERF_BYTE_ORDER	__PERF_BE
+#endif
+
+#else /* __KERNEL__ */
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define __PERF_BYTE_ORDER	__PERF_LE
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#define __PERF_BYTE_ORDER	__PERF_BE
+#endif
+
+#endif /* __KERNEL__ */
+
+/*
  * User-space ABI bits:
  */
 
@@ -659,6 +700,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
+#if __PERF_BYTE_ORDER == __PERF_LE
 union perf_mem_data_src {
 	__u64 val;
 	struct {
@@ -670,6 +712,19 @@ union perf_mem_data_src {
 			mem_rsvd:31;
 	};
 };
+#elif __PERF_BYTE_ORDER == __PERF_BE
+union perf_mem_data_src {
+	__u64 val;
+	struct {
+		__u64	mem_rsvd:31,
+			mem_dtlb:7,	/* tlb access */
+			mem_lock:2,	/* lock instr */
+			mem_snoop:5,	/* snoop mode */
+			mem_lvl:14,	/* memory hierarchy level */
+			mem_op:5;	/* type of opcode */
+	};
+};
+#endif
 
 /* type of opcode (load/store/prefetch,code) */
 #define PERF_MEM_OP_NA		0x01 /* not available */
-- 
1.7.1

