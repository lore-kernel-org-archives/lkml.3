Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3BAKhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:37:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51727 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3BAKhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:37:16 -0500
Date: Fri, 1 Feb 2013 02:36:55 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-gnb1gms0k8wictmtm2umpr8u@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Delete maps on exit
Git-Commit-ID: 0de233b9c4f8c83b2cb655bfdbec306c8da81199
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:37:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0de233b9c4f8c83b2cb655bfdbec306c8da81199
Gitweb:     http://git.kernel.org/tip/0de233b9c4f8c83b2cb655bfdbec306c8da81199
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 30 Jan 2013 14:01:20 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:43 -0300

perf top: Delete maps on exit

Removing one more memory leak found with valgrind.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-gnb1gms0k8wictmtm2umpr8u@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 903e4f4..f561757 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1164,7 +1164,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!top.evlist->nr_entries &&
 	    perf_evlist__add_default(top.evlist) < 0) {
 		ui__error("Not enough memory for event selector list\n");
-		return -ENOMEM;
+		goto out_delete_maps;
 	}
 
 	symbol_conf.nr_events = top.evlist->nr_entries;
@@ -1187,7 +1187,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	} else {
 		ui__error("frequency and count are zero, aborting\n");
 		status = -EINVAL;
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	top.sym_evsel = perf_evlist__first(top.evlist);
@@ -1220,6 +1220,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	status = __cmd_top(&top);
 
+out_delete_maps:
+	perf_evlist__delete_maps(top.evlist);
 out_delete_evlist:
 	perf_evlist__delete(top.evlist);
 
