Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3IMIHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:07:15 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55359 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337Ab3IMIHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:07:09 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-66-5232c7aa7a85
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/4] perf tools: Compare hists comm by addresses
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
	<1379017783-27032-5-git-send-email-fweisbec@gmail.com>
Date: Fri, 13 Sep 2013 17:07:06 +0900
In-Reply-To: <1379017783-27032-5-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Thu, 12 Sep 2013 22:29:43 +0200")
Message-ID: <87txhpqh5h.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 12 Sep 2013 22:29:43 +0200, Frederic Weisbecker wrote:
> Now that comm strings are allocated only once and refcounted to be shared
> among threads, these can now be safely compared by addresses. This
> should remove most hists collapses on post processing.

[SNIP]

> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 26d8f11..3b307e7 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -79,7 +79,8 @@ struct sort_entry sort_thread = {
>  static int64_t
>  sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
>  {
> -	return right->thread->tid - left->thread->tid;
> +	/* Compare the addr that should be unique among comm */
> +	return thread__comm_curr(right->thread) - thread__comm_curr(left->thread);

I don't think this is enough.  A hist entry should reference the comm
itself at that time.  Saving thread can lead to referencing different
comm between insert and collapse time if thread changed the comm in the
meanwhile, right?

What about something like below:


>From 431fd9bfa844ddfe28ab1390959bc7de28804a9c Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 13 Sep 2013 16:28:57 +0900
Subject: [PATCH] perf tools: Get current comm instead of last one

At insert time, a hist entry should reference comm at the time
otherwise it can get a different comm later.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c   |  3 +++
 tools/perf/util/sort.c   |  9 +++++----
 tools/perf/util/sort.h   |  1 +
 tools/perf/util/thread.c | 10 ++--------
 tools/perf/util/thread.h |  2 ++
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1f5767f97dce..1fe90bd9dcb7 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -412,6 +412,7 @@ struct hist_entry *__hists__add_mem_entry(struct hists *self,
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
+		.comm = curr_comm(al->thread),
 		.ms = {
 			.map	= al->map,
 			.sym	= al->sym,
@@ -442,6 +443,7 @@ struct hist_entry *__hists__add_branch_entry(struct hists *self,
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
+		.comm = curr_comm(al->thread),
 		.ms = {
 			.map	= bi->to.map,
 			.sym	= bi->to.sym,
@@ -471,6 +473,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
+		.comm = curr_comm(al->thread),
 		.ms = {
 			.map	= al->map,
 			.sym	= al->sym,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 3b307e740d6e..840481859e4b 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,5 +1,6 @@
 #include "sort.h"
 #include "hist.h"
+#include "comm.h"
 #include "symbol.h"
 
 regex_t		parent_regex;
@@ -80,14 +81,14 @@ static int64_t
 sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	/* Compare the addr that should be unique among comm */
-	return thread__comm_curr(right->thread) - thread__comm_curr(left->thread);
+	return comm__str(right->comm) - comm__str(left->comm);
 }
 
 static int64_t
 sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 {
-	const char *comm_l = thread__comm_curr(left->thread);
-	const char *comm_r = thread__comm_curr(right->thread);
+	const char *comm_l = comm__str(left->comm);
+	const char *comm_r = comm__str(right->comm);
 
 	if (!comm_l || !comm_r)
 		return cmp_null(comm_l, comm_r);
@@ -98,7 +99,7 @@ sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
 				     size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*s", width, thread__comm_curr(self->thread));
+	return repsep_snprintf(bf, size, "%*s", width, comm__str(self->comm));
 }
 
 struct sort_entry sort_comm = {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 4e80dbd271e7..4d0153f83e3c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -84,6 +84,7 @@ struct hist_entry {
 	struct he_stat		stat;
 	struct map_symbol	ms;
 	struct thread		*thread;
+	struct comm		*comm;
 	u64			ip;
 	s32			cpu;
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index d3ca133329b2..e7c7fe6694e8 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -54,7 +54,7 @@ void thread__delete(struct thread *self)
 	free(self);
 }
 
-static struct comm *curr_comm(const struct thread *self)
+struct comm *curr_comm(const struct thread *self)
 {
 	if (list_empty(&self->comm_list))
 		return NULL;
@@ -65,13 +65,7 @@ static struct comm *curr_comm(const struct thread *self)
 /* CHECKME: time should always be 0 if event aren't ordered */
 int thread__set_comm(struct thread *self, const char *str, u64 timestamp)
 {
-	struct comm *new, *curr = curr_comm(self);
-
-	/* Override latest entry if it had no specific time coverage */
-	if (!curr->start) {
-		list_del(&curr->list);
-		comm__free(curr);
-	}
+	struct comm *new;
 
 	new = comm__new(str, timestamp);
 	if (!new)
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 1d9378abb515..cf8e31d0028b 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -26,6 +26,7 @@ struct thread {
 };
 
 struct machine;
+struct comm;
 
 struct thread *thread__new(pid_t pid, pid_t tid);
 void thread__delete(struct thread *self);
@@ -36,6 +37,7 @@ static inline void thread__exited(struct thread *thread)
 
 int thread__set_comm(struct thread *self, const char *comm, u64 timestamp);
 int thread__comm_len(struct thread *self);
+struct comm *curr_comm(const struct thread *self);
 const char *thread__comm_curr(const struct thread *self);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent, u64 timestamp);
-- 
1.7.11.7

