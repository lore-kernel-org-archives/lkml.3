Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaHDQX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:23:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:39492 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbaHDQUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:20:47 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/33] perf kmem: Do not ignore mmap events
Date: Mon,  4 Aug 2014 13:17:34 -0300
Message-Id: <1407169064-25625-24-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The perf kmem command didn't process mmap events for some unknown reason
and it instead gets symbol info from a running kernel.  This is
problematic if perf kmem record was run on a different kernel.

This patch adds the mmap event handlers and reverts the commit
e727ca73f85d ("perf kmem: Resolve kernel symbols again").

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1406872771-23933-1-git-send-email-namhyung@kernel.org
[ Fixed up merge conflict with Jiri's ordered_events rename patch set ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index b5721116713b..84b82397a28e 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -256,6 +256,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool perf_kmem = {
 	.sample		 = process_sample_event,
 	.comm		 = perf_event__process_comm,
+	.mmap		 = perf_event__process_mmap,
+	.mmap2		 = perf_event__process_mmap2,
 	.ordered_events	 = true,
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
1.9.3

