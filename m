Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab3JPCHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:07:21 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45968 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3JPCHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:07:17 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 08/10][v6] powerpc/perf: Define big-endian version of perf_mem_data_src
Date: Tue, 15 Oct 2013 19:06:40 -0700
Message-Id: <1381889202-16826-9-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101602-1344-0000-0000-0000027AD59F
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
Changelog [v6]
	- [Michael Ellerman] Use __BIG_ENDIAN_BITFIELD to simplify the
	  endian check.

Changelog [v5]:
	- perf_event.h includes <byteorder.h> which pulls in the local
	  byteorder.h when building the perf tool. This local byteorder.h
	  leaves __LITTLE_ENDIAN and __BIG_ENDIAN undefined.
	  Include <endian.h> explicitly in the local byteorder.h.

Changelog [v2]:
	- [Vince Weaver, Michael Ellerman] No __KERNEL__ in uapi headers.

 include/uapi/linux/perf_event.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index ca1d90b..383052b7 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -695,6 +695,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
+#if defined(__LITTLE_ENDIAN_BITFIELD)
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
-- 
1.7.9.5

