Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaJPFYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:24:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaJPFYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:24:43 -0400
Date: Wed, 15 Oct 2014 22:24:26 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-89dceb22c098bd6afa9f3054aedddb9e1349392b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        acme@redhat.com, hpa@zytor.com, jolsa@kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, namhyung@kernel.org,
        tglx@linutronix.de, paulus@samba.org, mingo@kernel.org
Reply-To: tglx@linutronix.de, mingo@kernel.org, paulus@samba.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        a.p.zijlstra@chello.nl, hpa@zytor.com, jolsa@kernel.org,
        acme@redhat.com, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        namhyung.kim@lge.com
In-Reply-To: <1412556363-26229-6-git-send-email-namhyung@kernel.org>
References: <1412556363-26229-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace: Use thread_{,_set}_priv helpers
Git-Commit-ID: 89dceb22c098bd6afa9f3054aedddb9e1349392b
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

Commit-ID:  89dceb22c098bd6afa9f3054aedddb9e1349392b
Gitweb:     http://git.kernel.org/tip/89dceb22c098bd6afa9f3054aedddb9e1349392b
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 6 Oct 2014 09:46:03 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 17:39:02 -0300

perf trace: Use thread_{,_set}_priv helpers

This is mechanical changes only for accounting access to thread->priv
properly in the source level.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412556363-26229-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 09bcf23..fb12645 100644
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
