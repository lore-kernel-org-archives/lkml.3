Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3EaLxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:53:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3EaLxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:53:03 -0400
Date: Fri, 31 May 2013 04:52:29 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-70c57efb6118bff7426a6086026a4a8f3bd3c9e3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1369543631-5106-1-git-send-email-dsahern@gmail.com>
References: <1369543631-5106-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf  tools: Save parent pid in thread struct
Git-Commit-ID: 70c57efb6118bff7426a6086026a4a8f3bd3c9e3
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

Commit-ID:  70c57efb6118bff7426a6086026a4a8f3bd3c9e3
Gitweb:     http://git.kernel.org/tip/70c57efb6118bff7426a6086026a4a8f3bd3c9e3
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 25 May 2013 22:47:10 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:05 +0300

perf  tools: Save parent pid in thread struct

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
