Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaACCQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:16:23 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:44074 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751528AbaACCLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:46 -0500
Message-Id: <20140103021144.667522241@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 02/17] tracing/probes: Fix basic print type functions
References: <20140103021021.238772653@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-probes-Fix-basic-print-type-functions.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
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
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_probe.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 412e959..430505b 100644
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
1.8.4.3


