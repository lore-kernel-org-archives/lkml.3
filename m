Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab3ILUaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:30:09 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65429 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab3ILU34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:29:56 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] perf tools: Compare hists comm by addresses
Date: Thu, 12 Sep 2013 22:29:43 +0200
Message-Id: <1379017783-27032-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that comm strings are allocated only once and refcounted to be shared
among threads, these can now be safely compared by addresses. This
should remove most hists collapses on post processing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/sort.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 26d8f11..3b307e7 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -79,7 +79,8 @@ struct sort_entry sort_thread = {
 static int64_t
 sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return right->thread->tid - left->thread->tid;
+	/* Compare the addr that should be unique among comm */
+	return thread__comm_curr(right->thread) - thread__comm_curr(left->thread);
 }
 
 static int64_t
-- 
1.7.5.4

