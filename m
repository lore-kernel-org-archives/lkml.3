Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaJ1NeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:34:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:51455 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbaJ1NeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:34:04 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/32] perf tools: Do not attempt to run perf-read-vdso32 if it wasn't built
Date: Tue, 28 Oct 2014 11:32:12 -0200
Message-Id: <1414503146-22789-19-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414503146-22789-1-git-send-email-acme@kernel.org>
References: <1414503146-22789-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

popen() causes an error message to print if perf-read-vdso32 does not
run.  Avoid that by not trying to run it if it was not built.  Ditto
perf-read-vdsox32.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414061124-26830-17-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile |  8 ++++++--
 tools/perf/util/vdso.c     | 10 ++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 3ba2382a5236..71264e41fa85 100644
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
index 69daef6a17d5..5c7dd796979d 100644
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
1.9.3

