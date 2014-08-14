Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaHNCWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:22:50 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40783 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaHNCWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:22:46 -0400
X-AuditID: 85900ec0-d1d29b9000001514-b8-53ec1d734b60
Subject: [PATCH 07/13] perf record: Use strerror_r instead of strerror
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 14 Aug 2014 02:22:43 +0000
Message-ID: <20140814022243.3545.7411.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
References: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strerror_r instead of strerror in error messages
for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-record.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4db670d..87e28a4 100644
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

