Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab3H2KI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:08:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35054 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3H2KI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:08:56 -0400
Date: Thu, 29 Aug 2013 03:07:41 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-8afb4c018e21c882c8fad196772ef74d494185e2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1376484517-5339-2-git-send-email-adrian.hunter@intel.com>
References: <1376484517-5339-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Re-implement debug print function for linking python/perf.so
Git-Commit-ID: 8afb4c018e21c882c8fad196772ef74d494185e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:07:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8afb4c018e21c882c8fad196772ef74d494185e2
Gitweb:     http://git.kernel.org/tip/8afb4c018e21c882c8fad196772ef74d494185e2
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 14 Aug 2013 15:48:23 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Aug 2013 17:17:58 -0300

perf tools: Re-implement debug print function for linking python/perf.so

The python/perf.so python binding links a subset of objects.

Re-implement 'verbose' and 'eprintf' so they (and consequently
'pr_debug') can be used in objects linked into pythin/perf.so.

Note 'eprintf' must be re-implemented because the full version links the
browser ui.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1376484517-5339-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
