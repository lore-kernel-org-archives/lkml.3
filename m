Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaHAF7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:59:35 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57554 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHAF7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:59:34 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf kmem: Do not ignore mmap events
Date: Fri,  1 Aug 2014 14:59:31 +0900
Message-Id: <1406872771-23933-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf kmem command didn't process mmap events for some unknown
reason and it instead gets symbol info from a running kernel.  This is
problematic if perf kmem record was run on a different kernel.

This patch adds the mmap event handlers and reverts the commit
e727ca73f85d ("perf kmem: Resolve kernel symbols again").

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-kmem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index bef3376bfaf3..baaaab52f94b 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -256,6 +256,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool perf_kmem = {
 	.sample		 = process_sample_event,
 	.comm		 = perf_event__process_comm,
+	.mmap		 = perf_event__process_mmap,
+	.mmap2		 = perf_event__process_mmap2,
 	.ordered_samples = true,
 };
 
@@ -424,9 +426,6 @@ static int __cmd_kmem(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (perf_session__create_kernel_maps(session) < 0)
-		goto out_delete;
-
 	if (!perf_session__has_traces(session, "kmem record"))
 		goto out_delete;
 
-- 
2.0.0

