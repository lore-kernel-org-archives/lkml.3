Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422660AbaIZUUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:20:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:52853 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422640AbaIZUUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:20:33 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/10] perf tools: Fix line number in the config file error message
Date: Fri, 26 Sep 2014 17:19:47 -0300
Message-Id: <1411762787-26113-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411762787-26113-1-git-send-email-acme@kernel.org>
References: <1411762787-26113-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
index 953512ed72ba..57ff826f150b 100644
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
-- 
1.9.3

