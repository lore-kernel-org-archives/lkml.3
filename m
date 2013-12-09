Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab3LIGZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:25:22 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44535 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760551Ab3LIGUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:20:15 -0500
X-AuditID: 9c930197-b7bdbae000000e78-34-52a5611c9c72
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 02/17] tracing/probes: Fix basic print type functions
Date: Mon,  9 Dec 2013 15:19:50 +0900
Message-Id: <1386570005-3368-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386570005-3368-1-git-send-email-namhyung@kernel.org>
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The print format of s32 type was "ld" and it's casted to "long".  So
it turned out to print 4294967295 for "-1" on 64-bit systems.  Not
sure whether it worked well on 32-bit systems.

Anyway, it doesn't need to have cast argument at all since it already
casted using type pointer - just get rid of it.  Thanks to Oleg for
pointing that out.

And print 0x prefix for unsigned type as it shows hex numbers.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_probe.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 412e959709b4..430505b08a6f 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -40,23 +40,23 @@ const char *reserved_field_names[] = {
 #define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
 
 /* Printing  in basic type function template */
-#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
+#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt)				\
 static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
 						const char *name,	\
-						void *data, void *ent)\
+						void *data, void *ent)	\
 {									\
-	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
+	return trace_seq_printf(s, " %s=" fmt, name, *(type *)data);	\
 }									\
 static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
 
-DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
+DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "0x%x")
+DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "0x%x")
+DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "0x%x")
+DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "0x%Lx")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s8,  "%d")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%Ld")
 
 static inline void *get_rloc_data(u32 *dl)
 {
-- 
1.7.11.7

