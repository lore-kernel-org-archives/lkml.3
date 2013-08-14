Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab3HNMmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:42:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:33982 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab3HNMmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:42:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,876,1367996400"; 
   d="scan'208";a="346237366"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V11 01/15] perf tools: re-implement debug print function for linking python/perf.so
Date: Wed, 14 Aug 2013 15:48:23 +0300
Message-Id: <1376484517-5339-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376484517-5339-1-git-send-email-adrian.hunter@intel.com>
References: <1376484517-5339-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

python/perf.so links a subset of objects.  Re-implement 'verbose'
and 'eprintf' so they (and consequently 'pr_debug') can be used
in objects linked into pythin/perf.so.  Note 'eprintf' must be
re-implemented because the full version links the browser ui.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/python.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 925e0c3..381f4fd 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -8,6 +8,26 @@
 #include "cpumap.h"
 #include "thread_map.h"
 
+/*
+ * Support debug printing even though util/debug.c is not linked.  That means
+ * implementing 'verbose' and 'eprintf'.
+ */
+int verbose;
+
+int eprintf(int level, const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (verbose >= level) {
+		va_start(args, fmt);
+		ret = vfprintf(stderr, fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
 /* Define PyVarObject_HEAD_INIT for python 2.5 */
 #ifndef PyVarObject_HEAD_INIT
 # define PyVarObject_HEAD_INIT(type, size) PyObject_HEAD_INIT(type) size,
-- 
1.7.11.7

