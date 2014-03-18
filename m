Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbaCRP4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbaCRP4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:56:38 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 5/6] perf tools: Share process map groups within process threads
Date: Tue, 18 Mar 2014 15:46:55 +0100
Message-Id: <1395154016-26709-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
References: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sharing map groups within all process threads. This way
there's only one copy of mmap info and it's reachable
from any thread within the process.

Adding reference counting for struct map_groups and
changing the thread map groups get/put interface.

Adding reference counter 'refcnt' into struct map_groups.

Function thread__map_groups_get now:
  - lookup (&create) thread leader and returns its mg,
    allocates one if needed
  - increments reference counter for each copy

Function thread__map_groups_put now:
  - decrease map groups reference counter and sets
    its pointer to NULL
  - frees map groups data if it was last copy

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/util/map.h    |  2 ++
 tools/perf/util/thread.c | 40 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 99a6488..472a686 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -59,6 +59,8 @@ struct map_groups {
 	struct rb_root	 maps[MAP__NR_TYPES];
 	struct list_head removed_maps[MAP__NR_TYPES];
 	struct machine	 *machine;
+	/* Used for thread sharing. */
+	int		  refcnt;
 };
 
 static inline struct kmap *map__kmap(struct map *map)
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index cbe451a..f34fda1 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -130,6 +130,13 @@ int thread__insert_map(struct thread *thread, struct map *map)
 	return 0;
 }
 
+static struct thread *thread__get_leader(struct thread *thread)
+{
+	pid_t pid = thread->pid_;
+
+	return machine__findnew_thread(thread->machine, pid, pid);
+}
+
 static struct map_groups *thread__map_groups_alloc(struct thread *thread)
 {
 	struct map_groups *mg = zalloc(sizeof(*mg));
@@ -137,6 +144,7 @@ static struct map_groups *thread__map_groups_alloc(struct thread *thread)
 	if (mg) {
 		map_groups__init(mg);
 		thread->mg = mg;
+		mg->refcnt = 1;
 	}
 
 	return mg;
@@ -146,17 +154,39 @@ struct map_groups *thread__map_groups_get(struct thread *thread)
 {
 	struct map_groups *mg = thread->mg;
 
-	if (!mg)
-		mg = thread__map_groups_alloc(thread);
+	if (!mg) {
+		struct thread *leader = thread__get_leader(thread);
+
+		if (!leader)
+			return NULL;
+
+		if (leader->mg)
+			mg = leader->mg;
+		else
+			mg = thread__map_groups_alloc(leader);
+
+		if (leader != thread) {
+			thread->mg = mg;
+			mg->refcnt++;
+		}
+	}
 
 	return mg;
 }
 
 void thread__map_groups_put(struct thread *thread)
 {
-	if (thread->mg) {
-		map_groups__exit(thread->mg);
-		zfree(&thread->mg);
+	struct map_groups *mg = thread->mg;
+
+	if (mg) {
+		BUG_ON(!mg->refcnt);
+
+		if (!--mg->refcnt) {
+			map_groups__exit(thread->mg);
+			free(thread->mg);
+		}
+
+		thread->mg = NULL;
 	}
 }
 
-- 
1.8.3.1

