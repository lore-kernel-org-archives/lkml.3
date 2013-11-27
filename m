Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3K0GXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:23:52 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56223 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3K0GUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:09 -0500
X-AuditID: 9c930197-b7caaae000001cef-ab-52958f160b2e
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 05/17] tracing/kprobes: Move common functions to trace_probe.h
Date: Wed, 27 Nov 2013 15:19:51 +0900
Message-Id: <1385533203-10014-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The __get_data_size() and store_trace_args() will be used by uprobes
too.  Move them to a common location.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 48 ---------------------------------------------
 kernel/trace/trace_probe.h  | 48 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 72b76e1f2d34..bc85240a8e43 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -740,54 +740,6 @@ static const struct file_operations kprobe_profile_ops = {
 	.release        = seq_release,
 };
 
-/* Sum up total data length for dynamic arraies (strings) */
-static __kprobes int __get_data_size(struct trace_probe *tp,
-				     struct pt_regs *regs)
-{
-	int i, ret = 0;
-	u32 len;
-
-	for (i = 0; i < tp->nr_args; i++)
-		if (unlikely(tp->args[i].fetch_size.fn)) {
-			call_fetch(&tp->args[i].fetch_size, regs, &len);
-			ret += len;
-		}
-
-	return ret;
-}
-
-/* Store the value of each argument */
-static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
-				       struct pt_regs *regs,
-				       u8 *data, int maxlen)
-{
-	int i;
-	u32 end = tp->size;
-	u32 *dl;	/* Data (relative) location */
-
-	for (i = 0; i < tp->nr_args; i++) {
-		if (unlikely(tp->args[i].fetch_size.fn)) {
-			/*
-			 * First, we set the relative location and
-			 * maximum data length to *dl
-			 */
-			dl = (u32 *)(data + tp->args[i].offset);
-			*dl = make_data_rloc(maxlen, end - tp->args[i].offset);
-			/* Then try to fetch string or dynamic array data */
-			call_fetch(&tp->args[i].fetch, regs, dl);
-			/* Reduce maximum length */
-			end += get_rloc_len(*dl);
-			maxlen -= get_rloc_len(*dl);
-			/* Trick here, convert data_rloc to data_loc */
-			*dl = convert_rloc_to_loc(*dl,
-				 ent_size + tp->args[i].offset);
-		} else
-			/* Just fetching data normally */
-			call_fetch(&tp->args[i].fetch, regs,
-				   data + tp->args[i].offset);
-	}
-}
-
 /* Kprobe handler */
 static __kprobes void
 __kprobe_trace_func(struct trace_kprobe *tp, struct pt_regs *regs,
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 984e91ed8a44..d384fbd4025c 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -178,3 +178,51 @@ extern ssize_t traceprobe_probes_write(struct file *file,
 		int (*createfn)(int, char**));
 
 extern int traceprobe_command(const char *buf, int (*createfn)(int, char**));
+
+/* Sum up total data length for dynamic arraies (strings) */
+static inline __kprobes int
+__get_data_size(struct trace_probe *tp, struct pt_regs *regs)
+{
+	int i, ret = 0;
+	u32 len;
+
+	for (i = 0; i < tp->nr_args; i++)
+		if (unlikely(tp->args[i].fetch_size.fn)) {
+			call_fetch(&tp->args[i].fetch_size, regs, &len);
+			ret += len;
+		}
+
+	return ret;
+}
+
+/* Store the value of each argument */
+static inline __kprobes void
+store_trace_args(int ent_size, struct trace_probe *tp, struct pt_regs *regs,
+		 u8 *data, int maxlen)
+{
+	int i;
+	u32 end = tp->size;
+	u32 *dl;	/* Data (relative) location */
+
+	for (i = 0; i < tp->nr_args; i++) {
+		if (unlikely(tp->args[i].fetch_size.fn)) {
+			/*
+			 * First, we set the relative location and
+			 * maximum data length to *dl
+			 */
+			dl = (u32 *)(data + tp->args[i].offset);
+			*dl = make_data_rloc(maxlen, end - tp->args[i].offset);
+			/* Then try to fetch string or dynamic array data */
+			call_fetch(&tp->args[i].fetch, regs, dl);
+			/* Reduce maximum length */
+			end += get_rloc_len(*dl);
+			maxlen -= get_rloc_len(*dl);
+			/* Trick here, convert data_rloc to data_loc */
+			*dl = convert_rloc_to_loc(*dl,
+				 ent_size + tp->args[i].offset);
+		} else
+			/* Just fetching data normally */
+			call_fetch(&tp->args[i].fetch, regs,
+				   data + tp->args[i].offset);
+	}
+}
-- 
1.7.11.7

