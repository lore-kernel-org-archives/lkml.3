Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaHRI1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:27:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51622 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaHRIYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:24:52 -0400
Date: Mon, 18 Aug 2014 01:24:03 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-942a91ed3ffff0267944ed3161ae292d0960fd44@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140814022241.3545.97543.stgit@kbuild-fedora.novalocal>
References: <20140814022241.3545.97543.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Use strerror_r instead of strerror
Git-Commit-ID: 942a91ed3ffff0267944ed3161ae292d0960fd44
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

Commit-ID:  942a91ed3ffff0267944ed3161ae292d0960fd44
Gitweb:     http://git.kernel.org/tip/942a91ed3ffff0267944ed3161ae292d0960fd44
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Aug 2014 02:22:41 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 13:06:28 -0300

perf trace: Use strerror_r instead of strerror

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
index d080b9c..a9e96ff 100644
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
 
