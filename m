Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaE2EpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:45:09 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45228 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813AbaE2EpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:45:05 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] perf script/python: Print array argument as string
Date: Thu, 29 May 2014 13:44:55 +0900
Message-Id: <1401338695-18837-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401207274-8170-2-git-send-email-bigeasy@linutronix.de>
References: <1401207274-8170-2-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the Sebastian's change of handling num array argument (of raw
syscall enter), the script still failed to work like this:

  $ perf record -e raw_syscalls:* sleep 1
  $ perf script -g python
  $ perf script -s perf-script.py
  ...
  Traceback (most recent call last):
    File "perf-script.py", line 42, in raw_syscalls__sys_enter
      (id, args),
  TypeError: %u format: a number is required, not list
  Fatal Python error: problem in Python trace event handler
  Aborted (core dumped)

This is because the generated script tries to print the array arg as
unsigned integer (%u).  Since the python seems to convert arguments to
strings by default, just using %s solved the problem for me.

Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/scripting-engines/trace-event-python.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 40a815a5360b..a22ab53788bf 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -649,6 +649,7 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
 			fprintf(ofp, "%s=", f->name);
 			if (f->flags & FIELD_IS_STRING ||
 			    f->flags & FIELD_IS_FLAG ||
+			    f->flags & FIELD_IS_ARRAY ||
 			    f->flags & FIELD_IS_SYMBOLIC)
 				fprintf(ofp, "%%s");
 			else if (f->flags & FIELD_IS_SIGNED)
-- 
1.9.2

