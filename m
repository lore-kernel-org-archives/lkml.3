Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935456Ab3E3QR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:17:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50676 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934237Ab3E3QCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 32/66] perf  tools: Save parent pid in thread struct
Date: Thu, 30 May 2013 19:01:05 +0300
Message-Id: <1369929699-8724-33-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Information is available, so why not save it in case some command wants
to use it.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369543631-5106-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c | 4 ++++
 tools/perf/util/thread.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 632e40e..40399cb 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -14,6 +14,7 @@ struct thread *thread__new(pid_t pid)
 	if (self != NULL) {
 		map_groups__init(&self->mg);
 		self->pid = pid;
+		self->ppid = -1;
 		self->comm = malloc(32);
 		if (self->comm)
 			snprintf(self->comm, 32, ":%d", self->pid);
@@ -82,5 +83,8 @@ int thread__fork(struct thread *self, struct thread *parent)
 	for (i = 0; i < MAP__NR_TYPES; ++i)
 		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
 			return -ENOMEM;
+
+	self->ppid = parent->pid;
+
 	return 0;
 }
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 5ad2664..eeb7ac6 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -13,6 +13,7 @@ struct thread {
 	};
 	struct map_groups	mg;
 	pid_t			pid;
+	pid_t			ppid;
 	char			shortname[3];
 	bool			comm_set;
 	char			*comm;
-- 
1.8.1.4

