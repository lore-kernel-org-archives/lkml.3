Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3JBAP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 20:15:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56735 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab3JBAPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 20:15:34 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 6/9][v5] powerpc/perf: Define big-endian version of perf_mem_data_src
Date: Tue,  1 Oct 2013 17:15:07 -0700
Message-Id: <1380672911-12812-7-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100200-7164-0000-0000-00000216B653
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_mem_data_src is an union that is initialized via the ->val field
and accessed via the bitmap fields. For this to work on big endian
platforms, we also need a big-endian represenation of perf_mem_data_src.

Cc: Stephane Eranian <eranian@google.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---

Changelog [v5]:
	- include <endian.h> in local byteorder.h

Changelog [v4]:
	- perf_event.h includes <byteorder.h> which pulls in the local
	  byteorder.h when building the perf tool. This local byteorder.h
	  leaves __LITTLE_ENDIAN and __BIG_ENDIAN undefined.
	  Include <endian.h> explicitly in the local byteorder.h.

Changelog [v2]:
	- [Vince Weaver, Michael Ellerman] No __KERNEL__ in uapi headers.

 include/uapi/linux/perf_event.h         |   58 +++++++++++++++++++++++++++++++
 tools/perf/util/include/asm/byteorder.h |    1 +
 2 files changed, 59 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index ca1d90b..846f399 100644
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
 
@@ -695,6 +739,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
+#if __PERF_BYTE_ORDER == __PERF_LE
 union perf_mem_data_src {
 	__u64 val;
 	struct {
@@ -706,6 +751,19 @@ union perf_mem_data_src {
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
diff --git a/tools/perf/util/include/asm/byteorder.h b/tools/perf/util/include/asm/byteorder.h
index 2a9bdc0..7112913 100644
--- a/tools/perf/util/include/asm/byteorder.h
+++ b/tools/perf/util/include/asm/byteorder.h
@@ -1,2 +1,3 @@
 #include <asm/types.h>
 #include "../../../../include/uapi/linux/swab.h"
+#include <endian.h>
-- 
1.7.9.5

