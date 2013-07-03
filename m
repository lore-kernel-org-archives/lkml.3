Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab3GCMf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:35:57 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52553 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab3GCMfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:53 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-ef-51d41aa448c8
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 06/12] tracing/kprobes: Move common functions to trace_probe.c
Date: Wed,  3 Jul 2013 21:35:40 +0900
Message-Id: <1372854946-17074-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The __get_data_size() and store_trace_args() will be used by uprobes
too.  Move them to a common location.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 48 ---------------------------------------------
 kernel/trace/trace_probe.c  | 46 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_probe.h  |  4 ++++
 3 files changed, 50 insertions(+), 48 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 28360bbbb0b0..5a85ab5007bb 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -892,54 +892,6 @@ const struct fetch_type kprobes_fetch_type_table[] = {
 	ASSIGN_FETCH_TYPE(s64, u64, 1),
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
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index c123a890c5b1..5e491d82b6ad 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -701,3 +701,49 @@ out:
 
 	return ret;
 }
+
+/* Sum up total data length for dynamic arraies (strings) */
+__kprobes int __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
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
+__kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
+				struct pt_regs *regs, u8 *data, int maxlen)
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
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 4563e0befa01..04768d2faf11 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -297,3 +297,7 @@ extern ssize_t traceprobe_probes_write(struct file *file,
 		int (*createfn)(int, char**));
 
 extern int traceprobe_command(const char *buf, int (*createfn)(int, char**));
+
+extern int __get_data_size(struct trace_probe *tp, struct pt_regs *regs);
+extern void store_trace_args(int ent_size, struct trace_probe *tp,
+			     struct pt_regs *regs, u8 *data, int maxlen);
-- 
1.7.11.7

