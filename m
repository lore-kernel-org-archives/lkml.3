Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbaJ3GrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:47:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38141 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657AbaJ3GrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:47:08 -0400
Date: Wed, 29 Oct 2014 23:46:14 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-46b1fa85ff5a2e03423770b3931b97266e8ac6cf@git.kernel.org>
Cc: peterz@infradead.org, eranian@google.com, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, hpa@zytor.com, fweisbec@gmail.com, mingo@kernel.org,
        paulus@samba.org, namhyung@gmail.com, tglx@linutronix.de,
        acme@redhat.com, dsahern@gmail.com, adrian.hunter@intel.com
Reply-To: fweisbec@gmail.com, hpa@zytor.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, eranian@google.com, peterz@infradead.org,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        acme@redhat.com, namhyung@gmail.com, paulus@samba.org,
        mingo@kernel.org
In-Reply-To: <1414061124-26830-17-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-17-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Do not attempt to run perf-read-vdso32 if it wasn't built
Git-Commit-ID: 46b1fa85ff5a2e03423770b3931b97266e8ac6cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46b1fa85ff5a2e03423770b3931b97266e8ac6cf
Gitweb:     http://git.kernel.org/tip/46b1fa85ff5a2e03423770b3931b97266e8ac6cf
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 23 Oct 2014 13:45:24 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:48 -0200

perf tools: Do not attempt to run perf-read-vdso32 if it wasn't built

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
