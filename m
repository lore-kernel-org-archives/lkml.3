Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3H0Iye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:54:34 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47370 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3H0ItA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:49:00 -0400
X-AuditID: 9c930197-b7b44ae00000347f-44-521c67fa615d
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
Date: Tue, 27 Aug 2013 17:48:45 +0900
Message-Id: <1377593336-16828-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
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

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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

