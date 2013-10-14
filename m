Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab3JNUSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:18:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab3JNUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 125/161] perf machine: Add method to loop over threads and invoke handler
Date: Mon, 14 Oct 2013 17:01:54 -0300
Message-Id: <1381780950-25642-126-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
index fc14f9bf82c8..901397ae82be 100644
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
index 5150d5e1db67..d44c09bdc45e 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -166,4 +166,8 @@ void machines__destroy_kernel_maps(struct machines *machines);
 
 size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
 
+int machine__for_each_thread(struct machine *machine,
+			     int (*fn)(struct thread *thread, void *p),
+			     void *priv);
+
 #endif /* __PERF_MACHINE_H */
-- 
1.8.1.4

