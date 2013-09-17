Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3IQBqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 21:46:12 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58578 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3IQBqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 21:46:11 -0400
X-AuditID: 9c93017d-b7c9eae0000024ac-fa-5237b461283f
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
	<87txhpqh5h.fsf@sejong.aot.lge.com> <20130913135934.GD4844@somewhere>
Date: Tue, 17 Sep 2013 10:46:09 +0900
In-Reply-To: <20130913135934.GD4844@somewhere> (Frederic Weisbecker's message
	of "Fri, 13 Sep 2013 15:59:49 +0200")
Message-ID: <87pps8qkym.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Fri, 13 Sep 2013 15:59:49 +0200, Frederic Weisbecker wrote:
> On Fri, Sep 13, 2013 at 05:07:06PM +0900, Namhyung Kim wrote:

[SNIP]

>> --- a/tools/perf/util/sort.c
>> +++ b/tools/perf/util/sort.c
>> @@ -1,5 +1,6 @@
>>  #include "sort.h"
>>  #include "hist.h"
>> +#include "comm.h"
>>  #include "symbol.h"
>>  
>>  regex_t		parent_regex;
>> @@ -80,14 +81,14 @@ static int64_t
>>  sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
>>  {
>>  	/* Compare the addr that should be unique among comm */
>> -	return thread__comm_curr(right->thread) - thread__comm_curr(left->thread);
>> +	return comm__str(right->comm) - comm__str(left->comm);
>
>
> If comm and fork events don't have a timestamp, or they aren't time ordered, we should
> override the comm entry of a thread and forget the previous one.
>
> So perhaps what we should do instead is to compare "struct comm" addresses directly.
> But it means that on thread__set_comm(), if we override the old entry due to missing or
> unordered timestamps (in which case we need to force them to be 0), we shouldn't reallocate
> a new struct comm, nor should we keep the old one and queue a new. Instead we need to override
> list_first_entry(thread->comm)->comm_str pointer only to make it point to a new struct comm_str.

Okay.  Here's a revised patch:


>From 599221323f8fc0fd3327190900fece6c2aaa7309 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 13 Sep 2013 16:28:57 +0900
Subject: [PATCH] perf tools: Get current comm instead of last one

At insert time, a hist entry should reference comm at the time
otherwise it'll get the last comm anyway.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/comm.c   | 15 +++++++++++++++
 tools/perf/util/comm.h   |  1 +
 tools/perf/util/hist.c   |  3 +++
 tools/perf/util/sort.c   | 14 +++++---------
 tools/perf/util/sort.h   |  1 +
 tools/perf/util/thread.c |  6 +++---
 tools/perf/util/thread.h |  2 ++
 7 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
index 87f4a10e4a23..2d0f94f6593e 100644
--- a/tools/perf/util/comm.c
+++ b/tools/perf/util/comm.c
@@ -95,6 +95,21 @@ struct comm *comm__new(const char *str, u64 timestamp)
 	return self;
 }
 
+void comm__override(struct comm *comm, const char *str, u64 timestamp)
+{
+	struct comm_str *old = comm->comm_str;
+
+	comm->comm_str = comm_str_findnew(str, &comm_str_root);
+	if (!comm->comm_str) {
+		comm->comm_str = old;
+		return;
+	}
+
+	comm->start = timestamp;
+	comm_str_get(comm->comm_str);
+	comm_str_put(old);
+}
+
 void comm__free(struct comm *self)
 {
 	comm_str_put(self->comm_str);
diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
index 2e47fb7e27de..d37c2898e665 100644
--- a/tools/perf/util/comm.h
+++ b/tools/perf/util/comm.h
@@ -16,5 +16,6 @@ struct comm {
 void comm__free(struct comm *self);
 struct comm *comm__new(const char *str, u64 timestamp);
 const char *comm__str(struct comm *self);
+void comm__override(struct comm *self, const char *str, u64 timestamp);
 
 #endif  /* __PERF_COMM_H */
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
index 3b307e740d6e..65f10784d2dc 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,5 +1,6 @@
 #include "sort.h"
 #include "hist.h"
+#include "comm.h"
 #include "symbol.h"
 
 regex_t		parent_regex;
@@ -80,25 +81,20 @@ static int64_t
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
-
-	if (!comm_l || !comm_r)
-		return cmp_null(comm_l, comm_r);
-
-	return strcmp(comm_l, comm_r);
+	/* Compare the addr that should be unique among comm */
+	return comm__str(right->comm) - comm__str(left->comm);
 }
 
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
index d3ca133329b2..00caed1abb5f 100644
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
@@ -69,8 +69,8 @@ int thread__set_comm(struct thread *self, const char *str, u64 timestamp)
 
 	/* Override latest entry if it had no specific time coverage */
 	if (!curr->start) {
-		list_del(&curr->list);
-		comm__free(curr);
+		comm__override(curr, str, timestamp);
+		return 0;
 	}
 
 	new = comm__new(str, timestamp);
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

