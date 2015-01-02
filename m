Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbbABPiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:38:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbbABPiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:38:06 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 30/30] perf tools: Disable test code
Date: Fri,  2 Jan 2015 16:36:12 +0100
Message-Id: <1420212972-21595-31-git-send-email-jolsa@kernel.org>
In-Reply-To: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: hack

Forcing test objects not to be compiled into perf code.
This saves almost 1MB of perf binary size on my setup:

  # standard perf binary
  $ ls -l perf
  -rwxrwxr-x 1 jolsa jolsa 10283684 Jan  1 15:52 perf

  # current perf binary
  $ ls -l perf
  -rwxrwxr-x 1 jolsa jolsa 9303174 Jan  1 15:58 perf

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-cmds.h | 2 +-
 tools/perf/config.default | 2 +-
 tools/perf/perf-sys.h     | 2 +-
 tools/perf/perf.c         | 4 ++++
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-cmds.h b/tools/perf/builtin-cmds.h
index 5ceb4b58cfdd..d0993b91932e 100644
--- a/tools/perf/builtin-cmds.h
+++ b/tools/perf/builtin-cmds.h
@@ -23,7 +23,7 @@
 #define CONFIG_BUILTIN_HELP
 #define CONFIG_BUILTIN_PROBE
 #define CONFIG_BUILTIN_MEM
-#define CONFIG_BUILTIN_TEST
+//#define CONFIG_BUILTIN_TEST
 
 #endif /* BUILTIN_CMDS_H */
 
diff --git a/tools/perf/config.default b/tools/perf/config.default
index 2781af21b70b..8a31a9d7b940 100644
--- a/tools/perf/config.default
+++ b/tools/perf/config.default
@@ -20,4 +20,4 @@ CONFIG_BUILTIN_INJECT        := y
 CONFIG_BUILTIN_MEM           := y
 CONFIG_BUILTIN_TRACE         := y
 CONFIG_BUILTIN_PROBE         := y
-CONFIG_BUILTIN_TEST          := y
+CONFIG_BUILTIN_TEST          := n
diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index a3b13d7dc1d4..48831388db1d 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -181,7 +181,7 @@ sys_perf_event_open(struct perf_event_attr *attr,
 	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
 		     group_fd, flags);
 
-#ifdef HAVE_ATTR_TEST
+#if defined(CONFIG_BUILTIN_TEST) && defined(HAVE_ATTR_TEST)
 	if (unlikely(test_attr__enabled))
 		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
 #endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 7c5ceff22d47..ef7c92cf9f25 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -57,7 +57,9 @@ static struct cmd_struct commands[] = {
 	{ "kmem",	cmd_kmem,	0 },
 	{ "lock",	cmd_lock,	0 },
 	{ "kvm",	cmd_kvm,	0 },
+#ifdef CONFIG_BUILTIN_TEST
 	{ "test",	cmd_test,	0 },
+#endif
 #ifdef HAVE_LIBAUDIT_SUPPORT
 	{ "trace",	cmd_trace,	0 },
 #endif
@@ -539,7 +541,9 @@ int main(int argc, const char **argv)
 	}
 	cmd = argv[0];
 
+#ifdef CONFIG_BUILTIN_TEST
 	test_attr__init();
+#endif
 
 	/*
 	 * We use PATH to find perf commands, but we prepend some higher
-- 
1.9.3

