Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3JEDxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 23:53:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53671 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3JEDxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 23:53:43 -0400
Date: Fri, 4 Oct 2013 20:53:22 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9][v5] powerpc/perf: Define big-endian version of
 perf_mem_data_src
Message-ID: <20131005035322.GA32354@us.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1380672911-12812-7-git-send-email-sukadev@linux.vnet.ibm.com>
 <20131003053944.GD17237@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003053944.GD17237@concordia>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100503-5806-0000-0000-000022F6A7FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman [michael@ellerman.id.au] wrote:
| On Tue, Oct 01, 2013 at 05:15:07PM -0700, Sukadev Bhattiprolu wrote:
| > perf_mem_data_src is an union that is initialized via the ->val field
| > and accessed via the bitmap fields. For this to work on big endian
| > platforms, we also need a big-endian represenation of perf_mem_data_src.
| > 
| > diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
| > index ca1d90b..846f399 100644
| > --- a/include/uapi/linux/perf_event.h
| > +++ b/include/uapi/linux/perf_event.h
| > @@ -19,6 +19,50 @@
| >  #include <asm/byteorder.h>
| >  
| >  /*
| > + * Kernel and userspace check for endianness in incompatible ways.
| > + * In user space, <endian.h> defines both __BIG_ENDIAN and __LITTLE_ENDIAN
| > + * but sets __BYTE_ORDER to one or the other. So user space uses checks are:
| 
| 
| Why can't you use __BIG_ENDIAN_BITFIELD ?


So, the perf tool overrides the <asm/byteorder.h> with a local version.

And since this local version is arch neutral, we can't excplicitly include
the endian headers like <asm/byteorder.h> does.

How about we do something like this (both kernel and tool seem to build
on both x86 and power).

Sukadev.

---
 include/uapi/linux/perf_event.h         |   16 ++++++++++++++++
 tools/perf/util/include/asm/byteorder.h |   27 +++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index ca1d90b..dcfa74f 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -695,6 +695,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
+#if defined (__LITTLE_ENDIAN_BITFIELD)
 union perf_mem_data_src {
 	__u64 val;
 	struct {
@@ -706,6 +707,21 @@ union perf_mem_data_src {
 			mem_rsvd:31;
 	};
 };
+#elif defined(__BIG_ENDIAN_BITFIELD)
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
+#else
+#error "Unknown endianness"
+#endif
 
 /* type of opcode (load/store/prefetch,code) */
 #define PERF_MEM_OP_NA		0x01 /* not available */
diff --git a/tools/perf/util/include/asm/byteorder.h b/tools/perf/util/include/asm/byteorder.h
index 2a9bdc0..521a382 100644
--- a/tools/perf/util/include/asm/byteorder.h
+++ b/tools/perf/util/include/asm/byteorder.h
@@ -1,2 +1,29 @@
 #include <asm/types.h>
 #include "../../../../include/uapi/linux/swab.h"
+#include <endian.h>
+
+/*
+ * __LITTLE_ENDIAN_BITFIELD and __BIG_ENDIAN_BITFIELD are normally picked
+ * from <byteorder.h>. Since we override the default <byteorder.h>, define
+ * them explicitly here
+ */
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+
+#ifndef __LITTLE_ENDIAN_BITFIELD
+#define __LITTLE_ENDIAN_BITFIELD
+#endif
+
+#elif __BYTE_ORDER == __BIG_ENDIAN
+
+#ifndef __BIG_ENDIAN_BITFIELD
+#define __BIG_ENDIAN_BITFIELD
+#endif
+
+#else
+#error "Unknown endianness"
+#endif
+
+#if defined(__LITTLE_ENDIAN_BITFIELD) && defined(__BIG_ENDIAN_BITFIELD)
+#error 	Both __LITTLE_ENDIAN_BITFIELD and __BIG_ENDIAN_BITFIELD defined! \
+	Some perf data structures (eg: perf_mem_data_src) will be wrong.
+#endif
-- 
1.7.1

