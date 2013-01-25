Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab3AYLNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:13:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41406 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab3AYLNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:13:42 -0500
Date: Fri, 25 Jan 2013 03:13:10 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-a6a3zx3afbrxo8p2zqm5mxo8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Simplify accessing the host machine
Git-Commit-ID: 34ba5122bf198c9cdfcbecc9b23eaa414244a3f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:13:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34ba5122bf198c9cdfcbecc9b23eaa414244a3f6
Gitweb:     http://git.kernel.org/tip/34ba5122bf198c9cdfcbecc9b23eaa414244a3f6
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 19 Dec 2012 09:04:24 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:13 -0300

perf machine: Simplify accessing the host machine

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
