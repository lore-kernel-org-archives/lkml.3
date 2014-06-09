Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaFIUGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:06:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbaFIUDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:03:04 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 07/15] perf script/python: Print array argument as string
Date: Mon,  9 Jun 2014 22:02:22 +0200
Message-Id: <1402344150-14860-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: http://lkml.kernel.org/r/1401338695-18837-1-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/scripting-engines/trace-event-python.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index c3de097..1c41932 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -623,6 +623,7 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
 			fprintf(ofp, "%s=", f->name);
 			if (f->flags & FIELD_IS_STRING ||
 			    f->flags & FIELD_IS_FLAG ||
+			    f->flags & FIELD_IS_ARRAY ||
 			    f->flags & FIELD_IS_SYMBOLIC)
 				fprintf(ofp, "%%s");
 			else if (f->flags & FIELD_IS_SIGNED)
-- 
1.8.3.1

