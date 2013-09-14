Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3INAvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 20:51:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37457 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3INAtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 20:49:25 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@ozlabs.org, Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 4/8][v4] powerpc/perf: Define big-endian version of perf_mem_data_src
Date: Fri, 13 Sep 2013 17:49:11 -0700
Message-Id: <1379119755-21025-5-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091400-9332-0000-0000-0000016A97FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_mem_data_src is an union that is initialized via the ->val field
and accessed via the bitmap fields. For this to work on big endian
platforms, we also need a big-endian represenation of perf_mem_data_src.

Cc: Stephane Eranian <eranian@google.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
Changelog [v2]:
	- [Vince Weaver, Michael Ellerman] No __KERNEL__ in uapi headers.

 include/uapi/linux/perf_event.h |   58 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 62c25a2..7a4f9bb 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -19,6 +19,50 @@
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
+#if defined(__BYTE_ORDER)
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define __PERF_BYTE_ORDER	__PERF_LE
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#define __PERF_BYTE_ORDER	__PERF_BE
+#endif
+
+#else /* __BYTE_ORDER */
+
+#if defined(__LITTLE_ENDIAN) && defined(__BIG_ENDIAN)
+#error "Cannot determine endianness"
+#elif defined(__LITTLE_ENDIAN)
+#define __PERF_BYTE_ORDER	__PERF_LE
+#elif defined(__BIG_ENDIAN)
+#define __PERF_BYTE_ORDER	__PERF_BE
+#endif
+
+
+#endif /* __BYTE_ORDER */
+
+/*
  * User-space ABI bits:
  */
 
@@ -659,6 +703,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
+#if __PERF_BYTE_ORDER == __PERF_LE
 union perf_mem_data_src {
 	__u64 val;
 	struct {
@@ -670,6 +715,19 @@ union perf_mem_data_src {
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
1.7.9.5

