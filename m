Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3CNMXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:23:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41938 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab3CNMX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:23:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Vinson Lee <vlee@twitter.com>,
        Ingo Molnar <mingo@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/8] perf tools: Fix LIBNUMA build with glibc 2.12 and older.
Date: Thu, 14 Mar 2013 09:23:15 -0300
Message-Id: <1363263795-31485-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363263795-31485-1-git-send-email-acme@infradead.org>
References: <1363263795-31485-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinson Lee <vlee@twitter.com>

The tokens MADV_HUGEPAGE and MADV_NOHUGEPAGE are not available with
glibc 2.12 and older. Define these tokens if they are not already
defined.

This patch fixes these build errors with older versions of glibc.

    CC bench/numa.o
bench/numa.c: In function ‘alloc_data’:
bench/numa.c:334: error: ‘MADV_HUGEPAGE’ undeclared (first use in this function)
bench/numa.c:334: error: (Each undeclared identifier is reported only once
bench/numa.c:334: error: for each function it appears in.)
bench/numa.c:341: error: ‘MADV_NOHUGEPAGE’ undeclared (first use in this function)
make: *** [bench/numa.o] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363214064-4671-2-git-send-email-vlee@twitter.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/bench.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index a5223e6..0fdc852 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,6 +1,30 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+/*
+ * The madvise transparent hugepage constants were added in glibc
+ * 2.13. For compatibility with older versions of glibc, define these
+ * tokens if they are not already defined.
+ *
+ * PA-RISC uses different madvise values from other architectures and
+ * needs to be special-cased.
+ */
+#ifdef __hppa__
+# ifndef MADV_HUGEPAGE
+#  define MADV_HUGEPAGE		67
+# endif
+# ifndef MADV_NOHUGEPAGE
+#  define MADV_NOHUGEPAGE	68
+# endif
+#else
+# ifndef MADV_HUGEPAGE
+#  define MADV_HUGEPAGE		14
+# endif
+# ifndef MADV_NOHUGEPAGE
+#  define MADV_NOHUGEPAGE	15
+# endif
+#endif
+
 extern int bench_numa(int argc, const char **argv, const char *prefix);
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
-- 
1.7.1

