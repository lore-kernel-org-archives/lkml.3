Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3I1TNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:13:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63842 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3I1TNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:13:13 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/7] perf util: Add machine method to loop over threads and invoke handler
Date: Sat, 28 Sep 2013 13:12:58 -0600
Message-Id: <1380395584-9025-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
References: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loop over all threads within a machine - including threads moved to the
dead threads list -- and invoked a function. This allows commands to run
some specific function on each thread (eg., dump statistics) yet hides
how the threads are maintained within the machine and

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/machine.c |   23 +++++++++++++++++++++++
 tools/perf/util/machine.h |    4 ++++
 2 files changed, 27 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 40083df..d5055be 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1376,3 +1376,26 @@ int machine__resolve_callchain(struct machine *machine,
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
index 58a6be1..dc9c57e 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -165,4 +165,8 @@ void machines__destroy_kernel_maps(struct machines *machines);
 
 size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
 
+int machine__for_each_thread(struct machine *machine,
+			     int (*fn)(struct thread *thread, void *p),
+			     void *priv);
+
 #endif /* __PERF_MACHINE_H */
-- 
1.7.10.1

