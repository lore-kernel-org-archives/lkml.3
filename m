Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaEZTCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:02:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:48022 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaEZTCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:02:54 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] trace: Warn the user when not available
Date: Mon, 26 May 2014 16:02:29 -0300
Message-Id: <1401130950-24879-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When the audit-libs devel package is not found at build time we disable
the 'trace' command, as we are not able to map syscall numbers to
strings, but then the message the user is presented is cryptic:

  [root@zoo linux]# trace ls
  perf: 'ls' is not a perf-command. See 'perf --help'.

Fix it by presenting a more helpful message:

  [root@zoo linux]# trace l
  trace command not available: missing audit-libs devel package at build time.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-uxeunqetd0sgxyibusapen9a@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 431798a4110d..78f7b920e548 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -481,14 +481,18 @@ int main(int argc, const char **argv)
 		fprintf(stderr, "cannot handle %s internally", cmd);
 		goto out;
 	}
-#ifdef HAVE_LIBAUDIT_SUPPORT
 	if (!prefixcmp(cmd, "trace")) {
+#ifdef HAVE_LIBAUDIT_SUPPORT
 		set_buildid_dir();
 		setup_path();
 		argv[0] = "trace";
 		return cmd_trace(argc, argv, NULL);
-	}
+#else
+		fprintf(stderr,
+			"trace command not available: missing audit-libs devel package at build time.\n");
+		goto out;
 #endif
+	}
 	/* Look for flags.. */
 	argv++;
 	argc--;
-- 
1.9.3

