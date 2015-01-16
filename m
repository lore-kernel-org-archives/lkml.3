Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbbAPESt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 23:18:49 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49810 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbbAPEQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 23:16:23 -0500
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH tip 2/9] tracing: allow eBPF programs to call bpf_printk()
Date: Thu, 15 Jan 2015 20:16:03 -0800
Message-Id: <1421381770-4866-3-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421381770-4866-1-git-send-email-ast@plumgrid.com>
References: <1421381770-4866-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging of eBPF programs needs some form of printk from the program,
so let programs call limited trace_printk() with %d %u %x %p modifiers only.

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 include/uapi/linux/bpf.h    |    1 +
 kernel/trace/bpf_trace.c    |   61 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events.c |    8 ++++++
 3 files changed, 70 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 959538c50117..ef88e3f45b85 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_func_id {
 	BPF_FUNC_fetch_u8,        /* u8 bpf_fetch_u8(void *unsafe_ptr) */
 	BPF_FUNC_memcmp,          /* int bpf_memcmp(void *unsafe_ptr, void *safe_ptr, int size) */
 	BPF_FUNC_dump_stack,      /* void bpf_dump_stack(void) */
+	BPF_FUNC_printk,          /* int bpf_printk(const char *fmt, int fmt_size, ...) */
 	__BPF_FUNC_MAX_ID,
 };
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 639d3c25dead..3825d7a3cbd1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -60,6 +60,60 @@ static u64 bpf_dump_stack(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5)
 	return 0;
 }
 
+/* limited printk()
+ * only %d %u %x %ld %lu %lx %lld %llu %llx %p conversion specifiers allowed
+ */
+static u64 bpf_printk(u64 r1, u64 fmt_size, u64 r3, u64 r4, u64 r5)
+{
+	char *fmt = (char *) (long) r1;
+	int fmt_cnt = 0;
+	bool mod_l[3] = {};
+	int i;
+
+	/* bpf_check() guarantees that fmt points to bpf program stack and
+	 * fmt_size bytes of it were initialized by bpf program
+	 */
+	if (fmt[fmt_size - 1] != 0)
+		return -EINVAL;
+
+	/* check format string for allowed specifiers */
+	for (i = 0; i < fmt_size; i++)
+		if (fmt[i] == '%') {
+			if (fmt_cnt >= 3)
+				return -EINVAL;
+			i++;
+			if (i >= fmt_size)
+				return -EINVAL;
+
+			if (fmt[i] == 'l') {
+				mod_l[fmt_cnt] = true;
+				i++;
+				if (i >= fmt_size)
+					return -EINVAL;
+			} else if (fmt[i] == 'p') {
+				mod_l[fmt_cnt] = true;
+				fmt_cnt++;
+				continue;
+			}
+
+			if (fmt[i] == 'l') {
+				mod_l[fmt_cnt] = true;
+				i++;
+				if (i >= fmt_size)
+					return -EINVAL;
+			}
+
+			if (fmt[i] != 'd' && fmt[i] != 'u' && fmt[i] != 'x')
+				return -EINVAL;
+			fmt_cnt++;
+		}
+
+	return __trace_printk((unsigned long) __builtin_return_address(3), fmt,
+			      mod_l[0] ? r3 : (u32) r3,
+			      mod_l[1] ? r4 : (u32) r4,
+			      mod_l[2] ? r5 : (u32) r5);
+}
+
 static struct bpf_func_proto tracing_filter_funcs[] = {
 #define FETCH(SIZE)				\
 	[BPF_FUNC_fetch_##SIZE] = {		\
@@ -86,6 +140,13 @@ static struct bpf_func_proto tracing_filter_funcs[] = {
 		.gpl_only = false,
 		.ret_type = RET_VOID,
 	},
+	[BPF_FUNC_printk] = {
+		.func = bpf_printk,
+		.gpl_only = true,
+		.ret_type = RET_INTEGER,
+		.arg1_type = ARG_PTR_TO_STACK,
+		.arg2_type = ARG_CONST_STACK_SIZE,
+	},
 };
 
 static const struct bpf_func_proto *tracing_filter_func_proto(enum bpf_func_id func_id)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 189cc4d697b5..282ea5822480 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1141,6 +1141,14 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	mutex_unlock(&event_mutex);
 
+	if (file && file->flags & TRACE_EVENT_FL_BPF) {
+		/*
+		 * allocate per-cpu printk buffers, since programs
+		 * might be calling bpf_printk
+		 */
+		trace_printk_init_buffers();
+	}
+
 	free_page((unsigned long) buf);
 	if (err < 0)
 		return err;
-- 
1.7.9.5

