Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaFEObq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:31:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48088 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaFEObo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:31:44 -0400
Date: Thu, 5 Jun 2014 07:30:44 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-uxeunqetd0sgxyibusapen9a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@kernel.org,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        efault@gmx.de, peterz@infradead.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Warn the user when not available
Git-Commit-ID: 1b5726220fe16ac38eb2db43e7bc82e69f449fca
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

Commit-ID:  1b5726220fe16ac38eb2db43e7bc82e69f449fca
Gitweb:     http://git.kernel.org/tip/1b5726220fe16ac38eb2db43e7bc82e69f449fca
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 26 May 2014 16:02:29 -0300
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 3 Jun 2014 21:34:00 +0200

perf trace: Warn the user when not available

When the audit-libs devel package is not found at build time we disable
the 'trace' command, as we are not able to map syscall numbers to
strings, but then the message the user is presented is cryptic:

  [root@zoo linux]# trace ls
  perf: 'ls' is not a perf-command. See 'perf --help'.

Fix it by presenting a more helpful message:

  [root@zoo linux]# trace l
  trace command not available: missing audit-libs devel package at build time.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-uxeunqetd0sgxyibusapen9a@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 431798a..78f7b92 100644
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
