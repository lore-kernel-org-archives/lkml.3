Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbaH0Cfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:35:43 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37286 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879AbaH0Caq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:30:46 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v7 net-next 18/28] tracing: allow eBPF programs call printk()
Date: Tue, 26 Aug 2014 19:29:32 -0700
Message-Id: <1409106582-10095-19-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
References: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

limited printk() with %d %u %x %p modifiers only

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 include/uapi/linux/bpf.h |    1 +
 kernel/trace/bpf_trace.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 55adff33083e..1ec3d293d14e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -430,6 +430,7 @@ enum bpf_func_id {
 	BPF_FUNC_fetch_u8,        /* u8 bpf_fetch_u8(void *unsafe_ptr) */
 	BPF_FUNC_memcmp,          /* int bpf_memcmp(void *unsafe_ptr, void *safe_ptr, int size) */
 	BPF_FUNC_dump_stack,      /* void bpf_dump_stack(void) */
+	BPF_FUNC_printk,          /* int bpf_printk(const char *fmt, int fmt_size, ...) */
 	__BPF_FUNC_MAX_ID,
 };
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b4751e2c0d52..ff98be5a24d6 100644
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
 	[BPF_FUNC_map_lookup_elem] = {
 		.func = bpf_map_lookup_elem,
 		.gpl_only = false,
-- 
1.7.9.5

