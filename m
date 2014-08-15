Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaHOQvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:51:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:44797 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbaHOQvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:51:04 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Naohiro Aota <naota@elisp.net>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/18] perf record: Use strerror_r instead of strerror
Date: Fri, 15 Aug 2014 13:49:57 -0300
Message-Id: <1408121403-11919-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Use strerror_r instead of strerror in error messages for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022243.3545.7411.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4db670d4b8da..87e28a4e33ba 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -161,7 +161,7 @@ try_again:
 
 	if (perf_evlist__apply_filters(evlist)) {
 		error("failed to set filter with %d (%s)\n", errno,
-			strerror(errno));
+			strerror_r(errno, msg, sizeof(msg)));
 		rc = -1;
 		goto out;
 	}
@@ -175,7 +175,8 @@ try_again:
 			       "(current value: %u)\n", opts->mmap_pages);
 			rc = -errno;
 		} else {
-			pr_err("failed to mmap with %d (%s)\n", errno, strerror(errno));
+			pr_err("failed to mmap with %d (%s)\n", errno,
+				strerror_r(errno, msg, sizeof(msg)));
 			rc = -errno;
 		}
 		goto out;
@@ -480,7 +481,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	}
 
 	if (forks && workload_exec_errno) {
-		char msg[512];
+		char msg[STRERR_BUFSIZE];
 		const char *emsg = strerror_r(workload_exec_errno, msg, sizeof(msg));
 		pr_err("Workload failed: %s\n", emsg);
 		err = -1;
-- 
1.9.3

