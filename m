Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab3K0GY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:24:29 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43557 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3K0GUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:08 -0500
X-AuditID: 9c930197-b7caaae000001cef-a7-52958f166a37
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
Subject: [PATCH 02/17] tracing/probes: Fix basic print type functions
Date: Wed, 27 Nov 2013 15:19:48 +0900
Message-Id: <1385533203-10014-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
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
index 412e959709b4..e1b975fb5d7c 100644
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
+DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "%#x")
+DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%#x")
+DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%#x")
+DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%#Lx")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s8,  "%d")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d")
+DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%Ld")
 
 static inline void *get_rloc_data(u32 *dl)
 {
-- 
1.7.11.7

