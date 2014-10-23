Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaJWKsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:48:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:22417 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbaJWKrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:47:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="594446386"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/16] perf tools: Do not attempt to run perf-read-vdso32 if it wasn't built
Date: Thu, 23 Oct 2014 13:45:24 +0300
Message-Id: <1414061124-26830-17-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

popen() causes an error message to print if perf-read-vdso32
does not run.  Avoid that by not trying to run it if it was
not built.  Ditto perf-read-vdsox32.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/config/Makefile |  8 ++++++--
 tools/perf/util/vdso.c     | 10 ++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 3ba2382..71264e4 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -627,7 +627,9 @@ endif
 ifeq (${IS_64_BIT}, 1)
   ifndef NO_PERF_READ_VDSO32
     $(call feature_check,compile-32)
-    ifneq ($(feature-compile-32), 1)
+    ifeq ($(feature-compile-32), 1)
+      CFLAGS += -DHAVE_PERF_READ_VDSO32
+    else
       NO_PERF_READ_VDSO32 := 1
     endif
   endif
@@ -636,7 +638,9 @@ ifeq (${IS_64_BIT}, 1)
   endif
   ifndef NO_PERF_READ_VDSOX32
     $(call feature_check,compile-x32)
-    ifneq ($(feature-compile-x32), 1)
+    ifeq ($(feature-compile-x32), 1)
+      CFLAGS += -DHAVE_PERF_READ_VDSOX32
+    else
       NO_PERF_READ_VDSOX32 := 1
     endif
   endif
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 69daef6..5c7dd79 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -255,6 +255,16 @@ static int vdso__dso_findnew_compat(struct machine *machine,
 	enum dso_type dso_type;
 
 	dso_type = machine__thread_dso_type(machine, thread);
+
+#ifndef HAVE_PERF_READ_VDSO32
+	if (dso_type == DSO__TYPE_32BIT)
+		return 0;
+#endif
+#ifndef HAVE_PERF_READ_VDSOX32
+	if (dso_type == DSO__TYPE_X32BIT)
+		return 0;
+#endif
+
 	switch (dso_type) {
 	case DSO__TYPE_32BIT:
 		*dso = vdso__findnew_compat(machine, &vdso_info->vdso32);
-- 
1.9.1

