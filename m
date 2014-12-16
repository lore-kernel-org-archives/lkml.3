Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaLPQ7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:59:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:47126 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaLPQ66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:58:58 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/18] tools: Adopt roundup_pow_of_two
Date: Tue, 16 Dec 2014 13:57:18 -0300
Message-Id: <1418749040-31807-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To replace equivalent code used in the mmap_pages command line
parameter handling in tools/perf.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-i44zs02xt4zexfxywpklo7km@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/linux/log2.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/include/linux/log2.h b/tools/include/linux/log2.h
index 990b138362d6..41446668ccce 100644
--- a/tools/include/linux/log2.h
+++ b/tools/include/linux/log2.h
@@ -48,6 +48,15 @@ bool is_power_of_2(unsigned long n)
 }
 
 /*
+ * round up to nearest power of two
+ */
+static inline __attribute__((const))
+unsigned long __roundup_pow_of_two(unsigned long n)
+{
+	return 1UL << fls_long(n - 1);
+}
+
+/*
  * round down to nearest power of two
  */
 static inline __attribute__((const))
@@ -141,6 +150,22 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
 	__ilog2_u64(n)				\
  )
 
+/**
+ * roundup_pow_of_two - round the given value up to nearest power of two
+ * @n - parameter
+ *
+ * round the given value up to the nearest power of two
+ * - the result is undefined when n == 0
+ * - this can be used to initialise global variables from constant data
+ */
+#define roundup_pow_of_two(n)			\
+(						\
+	__builtin_constant_p(n) ? (		\
+		(n == 1) ? 1 :			\
+		(1UL << (ilog2((n) - 1) + 1))	\
+				   ) :		\
+	__roundup_pow_of_two(n)			\
+ )
 
 /**
  * rounddown_pow_of_two - round the given value down to nearest power of two
-- 
1.9.3

