Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3AXUKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:10:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50166 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab3AXUIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 22/74] perf machine: Simplify accessing the host machine
Date: Thu, 24 Jan 2013 17:07:31 -0300
Message-Id: <1359058103-31645-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It is always there, no sense in calling a function named
"perf_session__find_host_machine".

Also no sense in checking if that function return is NULL, so ditch
needless error handling.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-a6a3zx3afbrxo8p2zqm5mxo8@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c   | 7 +------
 tools/perf/builtin-record.c | 7 +------
 tools/perf/builtin-top.c    | 4 ++--
 tools/perf/util/session.c   | 2 +-
 tools/perf/util/session.h   | 6 ------
 5 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 0b4b796..9fddca7 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -340,7 +340,7 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 			   int n_lines, int is_caller)
 {
 	struct rb_node *next;
-	struct machine *machine;
+	struct machine *machine = &session->machines.host;
 
 	printf("%.102s\n", graph_dotted_line);
 	printf(" %-34s |",  is_caller ? "Callsite": "Alloc Ptr");
@@ -349,11 +349,6 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 
 	next = rb_first(root);
 
-	machine = perf_session__find_host_machine(session);
-	if (!machine) {
-		pr_err("__print_result: couldn't find kernel information\n");
-		return;
-	}
 	while (next && n_lines--) {
 		struct alloc_stat *data = rb_entry(next, struct alloc_stat,
 						   node);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a0b2427..2ac690c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -512,12 +512,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
 
-	machine = perf_session__find_host_machine(session);
-	if (!machine) {
-		pr_err("Couldn't find native kernel information.\n");
-		err = -1;
-		goto out_delete_session;
-	}
+	machine = &session->machines.host;
 
 	if (opts->pipe_output) {
 		err = perf_event__synthesize_attrs(tool, session,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e0ecebd..bc78812 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -847,13 +847,13 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			++top->us_samples;
 			if (top->hide_user_symbols)
 				continue;
-			machine = perf_session__find_host_machine(session);
+			machine = &session->machines.host;
 			break;
 		case PERF_RECORD_MISC_KERNEL:
 			++top->kernel_samples;
 			if (top->hide_kernel_symbols)
 				continue;
-			machine = perf_session__find_host_machine(session);
+			machine = &session->machines.host;
 			break;
 		case PERF_RECORD_MISC_GUEST_KERNEL:
 			++top->guest_kernel_samples;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 046b057..bd85280b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -821,7 +821,7 @@ static struct machine *
 		return perf_session__findnew_machine(session, pid);
 	}
 
-	return perf_session__find_host_machine(session);
+	return &session->machines.host;
 }
 
 static int perf_session_deliver_event(struct perf_session *session,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index de4e687..b5c0847 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -75,12 +75,6 @@ void perf_session__set_id_hdr_size(struct perf_session *session);
 void perf_session__remove_thread(struct perf_session *self, struct thread *th);
 
 static inline
-struct machine *perf_session__find_host_machine(struct perf_session *self)
-{
-	return &self->machines.host;
-}
-
-static inline
 struct machine *perf_session__find_machine(struct perf_session *self, pid_t pid)
 {
 	return machines__find(&self->machines, pid);
-- 
1.8.1.1.361.gec3ae6e

