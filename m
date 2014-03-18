Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbaCRVeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:34:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44418 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096AbaCRV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/13] perf tools: Fix memory leak when synthesizing thread records
Date: Tue, 18 Mar 2014 18:25:59 -0300
Message-Id: <1395177965-8879-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Checking default guest machine should be done before allocating event
structures otherwise it'll leak memory.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Link: http://lkml.kernel.org/r/87ob15tx6a.fsf@sejong.aot.lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index ebb48a623407..9d12aa6dd485 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -446,6 +446,9 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	union perf_event *comm_event, *mmap_event, *fork_event;
 	int err = -1;
 
+	if (machine__is_default_guest(machine))
+		return 0;
+
 	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
 		goto out;
@@ -458,9 +461,6 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	if (fork_event == NULL)
 		goto out_free_mmap;
 
-	if (machine__is_default_guest(machine))
-		return 0;
-
 	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
 	proc = opendir(proc_path);
 
-- 
1.8.1.4

