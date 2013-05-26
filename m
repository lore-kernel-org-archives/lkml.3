Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab3EZEr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 00:47:26 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61699 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab3EZErW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 00:47:22 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf: save parent pid in thread struct
Date: Sat, 25 May 2013 22:47:10 -0600
Message-Id: <1369543631-5106-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Information is available, so why not save it in case some command wants
to use it.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/thread.c |    4 ++++
 tools/perf/util/thread.h |    1 +
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
index 735b343..bdec685 100644
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
1.7.10.1

