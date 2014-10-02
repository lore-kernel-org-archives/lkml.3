Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaJBDJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 23:09:00 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35278 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaJBDI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 23:08:58 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] perf trace: Use thread_{,_set}_priv helpers
Date: Thu,  2 Oct 2014 12:08:55 +0900
Message-Id: <1412219335-17417-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412219335-17417-1-git-send-email-namhyung@kernel.org>
References: <1412219335-17417-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mechanical changes only for accounting access to thread->priv
properly in the source level.

Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-trace.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 09bcf2393910..fb126459b134 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1189,13 +1189,13 @@ static struct thread_trace *thread__trace(struct thread *thread, FILE *fp)
 	if (thread == NULL)
 		goto fail;
 
-	if (thread->priv == NULL)
-		thread->priv = thread_trace__new();
+	if (thread__priv(thread) == NULL)
+		thread__set_priv(thread, thread_trace__new());
 		
-	if (thread->priv == NULL)
+	if (thread__priv(thread) == NULL)
 		goto fail;
 
-	ttrace = thread->priv;
+	ttrace = thread__priv(thread);
 	++ttrace->nr_events;
 
 	return ttrace;
@@ -1248,7 +1248,7 @@ struct trace {
 
 static int trace__set_fd_pathname(struct thread *thread, int fd, const char *pathname)
 {
-	struct thread_trace *ttrace = thread->priv;
+	struct thread_trace *ttrace = thread__priv(thread);
 
 	if (fd > ttrace->paths.max) {
 		char **npath = realloc(ttrace->paths.table, (fd + 1) * sizeof(char *));
@@ -1301,7 +1301,7 @@ static int thread__read_fd_path(struct thread *thread, int fd)
 static const char *thread__fd_path(struct thread *thread, int fd,
 				   struct trace *trace)
 {
-	struct thread_trace *ttrace = thread->priv;
+	struct thread_trace *ttrace = thread__priv(thread);
 
 	if (ttrace == NULL)
 		return NULL;
@@ -1338,7 +1338,7 @@ static size_t syscall_arg__scnprintf_close_fd(char *bf, size_t size,
 {
 	int fd = arg->val;
 	size_t printed = syscall_arg__scnprintf_fd(bf, size, arg);
-	struct thread_trace *ttrace = arg->thread->priv;
+	struct thread_trace *ttrace = thread__priv(arg->thread);
 
 	if (ttrace && fd >= 0 && fd <= ttrace->paths.max)
 		zfree(&ttrace->paths.table[fd]);
@@ -2381,7 +2381,7 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	FILE *fp = data->fp;
 	size_t printed = data->printed;
 	struct trace *trace = data->trace;
-	struct thread_trace *ttrace = thread->priv;
+	struct thread_trace *ttrace = thread__priv(thread);
 	double ratio;
 
 	if (ttrace == NULL)
-- 
2.1.0

