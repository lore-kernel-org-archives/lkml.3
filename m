Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaHMFRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:17:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaHMFRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:17:47 -0400
Date: Tue, 12 Aug 2014 22:17:30 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-64c40908938953d7afa90e9363327875286349e5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1406872771-23933-1-git-send-email-namhyung@kernel.org>
References: <1406872771-23933-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kmem: Do not ignore mmap events
Git-Commit-ID: 64c40908938953d7afa90e9363327875286349e5
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

Commit-ID:  64c40908938953d7afa90e9363327875286349e5
Gitweb:     http://git.kernel.org/tip/64c40908938953d7afa90e9363327875286349e5
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 1 Aug 2014 14:59:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:03 -0300

perf kmem: Do not ignore mmap events

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
---
 tools/perf/builtin-kmem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index b572111..84b8239 100644
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
 
