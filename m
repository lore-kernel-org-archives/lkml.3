Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab3JOFbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:31:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3JOFbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:31:00 -0400
Date: Mon, 14 Oct 2013 22:30:43 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-35feee19f9fda7447f51073b5be3f6d082b508f5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1380395584-9025-2-git-send-email-dsahern@gmail.com>
References: <1380395584-9025-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine:
  Add method to loop over threads and invoke handler
Git-Commit-ID: 35feee19f9fda7447f51073b5be3f6d082b508f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:30:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35feee19f9fda7447f51073b5be3f6d082b508f5
Gitweb:     http://git.kernel.org/tip/35feee19f9fda7447f51073b5be3f6d082b508f5
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 28 Sep 2013 13:12:58 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:51 -0300

perf machine: Add method to loop over threads and invoke handler

Loop over all threads within a machine - including threads moved to the
dead threads list -- and invoked a function.

This allows commands to run some specific function on each thread (eg.,
dump statistics) yet hides how the threads are maintained within the
machine.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1380395584-9025-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 23 +++++++++++++++++++++++
 tools/perf/util/machine.h |  4 ++++
 2 files changed, 27 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index fc14f9b..901397a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1393,3 +1393,26 @@ int machine__resolve_callchain(struct machine *machine,
 				   sample);
 
 }
+
+int machine__for_each_thread(struct machine *machine,
+			     int (*fn)(struct thread *thread, void *p),
+			     void *priv)
+{
+	struct rb_node *nd;
+	struct thread *thread;
+	int rc = 0;
+
+	for (nd = rb_first(&machine->threads); nd; nd = rb_next(nd)) {
+		thread = rb_entry(nd, struct thread, rb_node);
+		rc = fn(thread, priv);
+		if (rc != 0)
+			return rc;
+	}
+
+	list_for_each_entry(thread, &machine->dead_threads, node) {
+		rc = fn(thread, priv);
+		if (rc != 0)
+			return rc;
+	}
+	return rc;
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 5150d5e..d44c09b 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -166,4 +166,8 @@ void machines__destroy_kernel_maps(struct machines *machines);
 
 size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
 
+int machine__for_each_thread(struct machine *machine,
+			     int (*fn)(struct thread *thread, void *p),
+			     void *priv);
+
 #endif /* __PERF_MACHINE_H */
