Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaI0H1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 03:27:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaI0H1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 03:27:45 -0400
Date: Sat, 27 Sep 2014 00:26:46 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-49757c9cc7887bc79f742eb8aacf16e464ca5f0b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, mail@milianw.de, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, mail@milianw.de, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <20140923115656.GC2979@krava.brq.redhat.com>
References: <20140923115656.GC2979@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix line number in the config file error message
Git-Commit-ID: 49757c9cc7887bc79f742eb8aacf16e464ca5f0b
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

Commit-ID:  49757c9cc7887bc79f742eb8aacf16e464ca5f0b
Gitweb:     http://git.kernel.org/tip/49757c9cc7887bc79f742eb8aacf16e464ca5f0b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 23 Sep 2014 13:56:56 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Sep 2014 12:45:23 -0300

perf tools: Fix line number in the config file error message

If we fail to parse the config file within the callback function,
the line number counter 'could be' already on the next line.

This results in wrong line number report like:

  $ cat ~/.perfconfig
  [call-graph]
          sort-key = krava
  $ perf record ls
  Fatal: bad config file line 3 in /home/jolsa/.perfconfig

Fixing this by saving the current line number for this case.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Milian Wolff <mail@milianw.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140923115656.GC2979@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/config.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 953512e..57ff826 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -222,7 +222,8 @@ static int perf_parse_file(config_fn_t fn, void *data)
 	const unsigned char *bomptr = utf8_bom;
 
 	for (;;) {
-		int c = get_next_char();
+		int line, c = get_next_char();
+
 		if (bomptr && *bomptr) {
 			/* We are at the file beginning; skip UTF8-encoded BOM
 			 * if present. Sane editors won't put this in on their
@@ -261,8 +262,16 @@ static int perf_parse_file(config_fn_t fn, void *data)
 		if (!isalpha(c))
 			break;
 		var[baselen] = tolower(c);
-		if (get_value(fn, data, var, baselen+1) < 0)
+
+		/*
+		 * The get_value function might or might not reach the '\n',
+		 * so saving the current line number for error reporting.
+		 */
+		line = config_linenr;
+		if (get_value(fn, data, var, baselen+1) < 0) {
+			config_linenr = line;
 			break;
+		}
 	}
 	die("bad config file line %d in %s", config_linenr, config_file_name);
 }
