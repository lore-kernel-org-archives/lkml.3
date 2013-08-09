Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057Ab3HIIpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 04:45:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48724 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3HIIpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 04:45:14 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-aa-5204ac183dd7
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Hyeoncheol Lee <cheol.lee@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 02/13] tracing/probes: Fix basic print type functions
Date: Fri,  9 Aug 2013 17:44:58 +0900
Message-Id: <1376037909-17797-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376037909-17797-1-git-send-email-namhyung@kernel.org>
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The print format of s32 type was "ld" and it's casted to "long".  So
it turned out to print 4294967295 for "-1" on 64-bit systems.  Not
sure whether it worked well on 32-bit systems.

Anyway, it'd be better if we have exact format and type cast for each
types on both of 32- and 64-bit systems.  In fact, the only difference
is on s64/u64 types.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_probe.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 412e959709b4..b571e4de0769 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -49,14 +49,19 @@ static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
 }									\
 static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
 
-DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
+DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "%x", unsigned char)
+DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned short)
+DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%x", unsigned int)
+DEFINE_BASIC_PRINT_TYPE_FUNC(s8,  "%d", signed char)
+DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", short)
+DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d", int)
+#if BITS_PER_LONG == 32
 DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
 DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
+#else /* BITS_PER_LONG == 64 */
+DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%lx", unsigned long)
+DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%ld", long)
+#endif
 
 static inline void *get_rloc_data(u32 *dl)
 {
-- 
1.7.11.7

