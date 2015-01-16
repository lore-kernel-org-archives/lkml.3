Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbbAPEQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 23:16:30 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62473 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbbAPEQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 23:16:24 -0500
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH tip 3/9] tracing: allow eBPF programs to call ktime_get_ns()
Date: Thu, 15 Jan 2015 20:16:04 -0800
Message-Id: <1421381770-4866-4-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421381770-4866-1-git-send-email-ast@plumgrid.com>
References: <1421381770-4866-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bpf_ktime_get_ns() is used by programs to compue time delta between events
or as a timestamp

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 include/uapi/linux/bpf.h |    1 +
 kernel/trace/bpf_trace.c |   10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ef88e3f45b85..6075c4f4b67e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -171,6 +171,7 @@ enum bpf_func_id {
 	BPF_FUNC_memcmp,          /* int bpf_memcmp(void *unsafe_ptr, void *safe_ptr, int size) */
 	BPF_FUNC_dump_stack,      /* void bpf_dump_stack(void) */
 	BPF_FUNC_printk,          /* int bpf_printk(const char *fmt, int fmt_size, ...) */
+	BPF_FUNC_ktime_get_ns,    /* u64 bpf_ktime_get_ns(void) */
 	__BPF_FUNC_MAX_ID,
 };
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3825d7a3cbd1..14cfbbcec32e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -114,6 +114,11 @@ static u64 bpf_printk(u64 r1, u64 fmt_size, u64 r3, u64 r4, u64 r5)
 			      mod_l[2] ? r5 : (u32) r5);
 }
 
+static u64 bpf_ktime_get_ns(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5)
+{
+	return ktime_get_ns();
+}
+
 static struct bpf_func_proto tracing_filter_funcs[] = {
 #define FETCH(SIZE)				\
 	[BPF_FUNC_fetch_##SIZE] = {		\
@@ -147,6 +152,11 @@ static struct bpf_func_proto tracing_filter_funcs[] = {
 		.arg1_type = ARG_PTR_TO_STACK,
 		.arg2_type = ARG_CONST_STACK_SIZE,
 	},
+	[BPF_FUNC_ktime_get_ns] = {
+		.func = bpf_ktime_get_ns,
+		.gpl_only = true,
+		.ret_type = RET_INTEGER,
+	},
 };
 
 static const struct bpf_func_proto *tracing_filter_func_proto(enum bpf_func_id func_id)
-- 
1.7.9.5

