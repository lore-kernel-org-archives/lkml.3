Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3AaRcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:32:14 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60064
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140Ab3AaRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/25] perf top: Delete maps on exit
Date: Thu, 31 Jan 2013 14:25:05 -0300
Message-Id: <1359653128-10433-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 
-- 
1.8.1.1.361.gec3ae6e

