Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaHOQvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:51:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:44782 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbaHOQvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:51:00 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Naohiro Aota <naota@elisp.net>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/18] perf trace: Use strerror_r instead of strerror
Date: Fri, 15 Aug 2014 13:49:56 -0300
Message-Id: <1408121403-11919-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Use strerror_r instead of strerror in error message for thead-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022241.3545.97543.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index d080b9cf0354..a9e96ff49c7f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1750,7 +1750,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 signed_print:
 		fprintf(trace->output, ") = %d", ret);
 	} else if (ret < 0 && sc->fmt->errmsg) {
-		char bf[256];
+		char bf[STRERR_BUFSIZE];
 		const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
 			   *e = audit_errno_to_name(-ret);
 
@@ -2044,6 +2044,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	int err = -1, i;
 	unsigned long before;
 	const bool forks = argc > 0;
+	char sbuf[STRERR_BUFSIZE];
 
 	trace->live = true;
 
@@ -2105,7 +2106,8 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
 	if (err < 0) {
-		fprintf(trace->output, "Couldn't mmap the events: %s\n", strerror(errno));
+		fprintf(trace->output, "Couldn't mmap the events: %s\n",
+			strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out_delete_evlist;
 	}
 
-- 
1.9.3

