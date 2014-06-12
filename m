Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbaFLMCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:02:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaFLMCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:02:10 -0400
Date: Thu, 12 Jun 2014 05:01:54 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e646fe730a324098a718f1c9b2f349efb99d5457@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tzanussi@gmail.com, namhyung@kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tzanussi@gmail.com, jolsa@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1401338695-18837-1-git-send-email-namhyung@kernel.org>
References: <1401338695-18837-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script/python:
  Print array argument as string
Git-Commit-ID: e646fe730a324098a718f1c9b2f349efb99d5457
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

Commit-ID:  e646fe730a324098a718f1c9b2f349efb99d5457
Gitweb:     http://git.kernel.org/tip/e646fe730a324098a718f1c9b2f349efb99d5457
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 29 May 2014 13:44:55 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 9 Jun 2014 12:21:03 +0200

perf script/python: Print array argument as string

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
