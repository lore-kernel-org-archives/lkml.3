Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab3AYMVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:21:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42551 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3AYMVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:21:30 -0500
Date: Fri, 25 Jan 2013 04:21:13 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-4b18e27234adb05597e7ec1f0eacda048aed080f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1359040242-8269-8-git-send-email-eranian@google.com>
References: <1359040242-8269-8-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86] perf: Add generic memory sampling interface
Git-Commit-ID: 4b18e27234adb05597e7ec1f0eacda048aed080f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:21:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b18e27234adb05597e7ec1f0eacda048aed080f
Gitweb:     http://git.kernel.org/tip/4b18e27234adb05597e7ec1f0eacda048aed080f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 24 Jan 2013 16:10:31 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 10:19:03 +0100

perf: Add generic memory sampling interface

This patch adds PERF_SAMPLE_DATA_SRC.

PERF_SAMPLE_DATA_SRC collects the data source, i.e., where
did the data associated with the sampled instruction
come from. Information is stored in a perf_mem_data_src
structure. It contains opcode, mem level, tlb, snoop,
lock information, subject to availability in hardware.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: namhyung.kim@lge.com
Link: http://lkml.kernel.org/r/1359040242-8269-8-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h      |  2 ++
 include/uapi/linux/perf_event.h | 68 +++++++++++++++++++++++++++++++++++++++--
 kernel/events/core.c            |  6 ++++
 3 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bb2429d..dad68a3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -579,6 +579,7 @@ struct perf_sample_data {
 		u32	reserved;
 	}				cpu_entry;
 	u64				period;
+	union  perf_mem_data_src	data_src;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 	struct perf_branch_stack	*br_stack;
@@ -599,6 +600,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
 	data->weight = 0;
+	data->data_src.val = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 3e6c394..0c46659 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -133,9 +133,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_REGS_USER			= 1U << 12,
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
 	PERF_SAMPLE_WEIGHT			= 1U << 14,
+	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 
-	PERF_SAMPLE_MAX = 1U << 15,		/* non-ABI */
-
+	PERF_SAMPLE_MAX = 1U << 16,		/* non-ABI */
 };
 
 /*
@@ -591,6 +591,7 @@ enum perf_event_type {
 	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
+	 *	{ u64			data_src;     } && PERF_SAMPLE_DATA_SRC
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
@@ -616,4 +617,67 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 
+union perf_mem_data_src {
+	__u64 val;
+	struct {
+		__u64   mem_op:5,	/* type of opcode */
+			mem_lvl:14,	/* memory hierarchy level */
+			mem_snoop:5,	/* snoop mode */
+			mem_lock:2,	/* lock instr */
+			mem_dtlb:7,	/* tlb access */
+			mem_rsvd:31;
+	};
+};
+
+/* type of opcode (load/store/prefetch,code) */
+#define PERF_MEM_OP_NA		0x01 /* not available */
+#define PERF_MEM_OP_LOAD	0x02 /* load instruction */
+#define PERF_MEM_OP_STORE	0x04 /* store instruction */
+#define PERF_MEM_OP_PFETCH	0x08 /* prefetch */
+#define PERF_MEM_OP_EXEC	0x10 /* code (execution) */
+#define PERF_MEM_OP_SHIFT	0
+
+/* memory hierarchy (memory level, hit or miss) */
+#define PERF_MEM_LVL_NA		0x01  /* not available */
+#define PERF_MEM_LVL_HIT	0x02  /* hit level */
+#define PERF_MEM_LVL_MISS	0x04  /* miss level  */
+#define PERF_MEM_LVL_L1		0x08  /* L1 */
+#define PERF_MEM_LVL_LFB	0x10  /* Line Fill Buffer */
+#define PERF_MEM_LVL_L2		0x20  /* L2 hit */
+#define PERF_MEM_LVL_L3		0x40  /* L3 hit */
+#define PERF_MEM_LVL_LOC_RAM	0x80  /* Local DRAM */
+#define PERF_MEM_LVL_REM_RAM1	0x100 /* Remote DRAM (1 hop) */
+#define PERF_MEM_LVL_REM_RAM2	0x200 /* Remote DRAM (2 hops) */
+#define PERF_MEM_LVL_REM_CCE1	0x400 /* Remote Cache (1 hop) */
+#define PERF_MEM_LVL_REM_CCE2	0x800 /* Remote Cache (2 hops) */
+#define PERF_MEM_LVL_IO		0x1000 /* I/O memory */
+#define PERF_MEM_LVL_UNC	0x2000 /* Uncached memory */
+#define PERF_MEM_LVL_SHIFT	5
+
+/* snoop mode */
+#define PERF_MEM_SNOOP_NA	0x01 /* not available */
+#define PERF_MEM_SNOOP_NONE	0x02 /* no snoop */
+#define PERF_MEM_SNOOP_HIT	0x04 /* snoop hit */
+#define PERF_MEM_SNOOP_MISS	0x08 /* snoop miss */
+#define PERF_MEM_SNOOP_HITM	0x10 /* snoop hit modified */
+#define PERF_MEM_SNOOP_SHIFT	19
+
+/* locked instruction */
+#define PERF_MEM_LOCK_NA	0x01 /* not available */
+#define PERF_MEM_LOCK_LOCKED	0x02 /* locked transaction */
+#define PERF_MEM_LOCK_SHIFT	24
+
+/* TLB access */
+#define PERF_MEM_TLB_NA		0x01 /* not available */
+#define PERF_MEM_TLB_HIT	0x02 /* hit level */
+#define PERF_MEM_TLB_MISS	0x04 /* miss level */
+#define PERF_MEM_TLB_L1		0x08 /* L1 */
+#define PERF_MEM_TLB_L2		0x10 /* L2 */
+#define PERF_MEM_TLB_WK		0x20 /* Hardware Walker*/
+#define PERF_MEM_TLB_OS		0x40 /* OS fault handler */
+#define PERF_MEM_TLB_SHIFT	26
+
+#define PERF_MEM_S(a, s) \
+	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
+
 #endif /* _UAPI_LINUX_PERF_EVENT_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 749bdf4..4661009 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -958,6 +958,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_READ)
 		size += event->read_size;
 
+	if (sample_type & PERF_SAMPLE_DATA_SRC)
+		size += sizeof(data->data_src.val);
+
 	event->header_size = size;
 }
 
@@ -4175,6 +4178,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 
 	if (sample_type & PERF_SAMPLE_WEIGHT)
 		perf_output_put(handle, data->weight);
+
+	if (sample_type & PERF_SAMPLE_DATA_SRC)
+		perf_output_put(handle, data->data_src.val);
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
