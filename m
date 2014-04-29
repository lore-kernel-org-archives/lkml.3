Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaD2GrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:47:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaD2GrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:47:00 -0400
Date: Mon, 28 Apr 2014 23:46:27 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-a26ca6716a6c683f40bd676cea7e89704653b98d@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, acme@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, dzickus@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, acme@redhat.com, eranian@google.com,
        jolsa@kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        acme@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, dzickus@redhat.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, adrian.hunter@intel.com
In-Reply-To: <1397490723-1992-4-git-send-email-jolsa@redhat.com>
References: <1397490723-1992-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Reference count map_groups objects
Git-Commit-ID: a26ca6716a6c683f40bd676cea7e89704653b98d
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

Commit-ID:  a26ca6716a6c683f40bd676cea7e89704653b98d
Gitweb:     http://git.kernel.org/tip/a26ca6716a6c683f40bd676cea7e89704653b98d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 25 Mar 2014 15:26:44 -0300
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 28 Apr 2014 13:43:26 +0200

perf tools: Reference count map_groups objects

We will share it among threads in the same process.
Adding map_groups__get/map_groups__put interface for that.

Signed-off-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1397490723-1992-4-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/map.c    | 7 +++++++
 tools/perf/util/map.h    | 9 +++++++++
 tools/perf/util/thread.c | 2 +-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ae4c5e1..ba5f5c0c 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -323,6 +323,7 @@ void map_groups__init(struct map_groups *mg)
 		INIT_LIST_HEAD(&mg->removed_maps[i]);
 	}
 	mg->machine = NULL;
+	mg->refcnt = 1;
 }
 
 static void maps__delete(struct rb_root *maps)
@@ -374,6 +375,12 @@ void map_groups__delete(struct map_groups *mg)
 	free(mg);
 }
 
+void map_groups__put(struct map_groups *mg)
+{
+	if (--mg->refcnt == 0)
+		map_groups__delete(mg);
+}
+
 void map_groups__flush(struct map_groups *mg)
 {
 	int type;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 1073e2d..d6445b2 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -59,11 +59,20 @@ struct map_groups {
 	struct rb_root	 maps[MAP__NR_TYPES];
 	struct list_head removed_maps[MAP__NR_TYPES];
 	struct machine	 *machine;
+	int		 refcnt;
 };
 
 struct map_groups *map_groups__new(void);
 void map_groups__delete(struct map_groups *mg);
 
+static inline struct map_groups *map_groups__get(struct map_groups *mg)
+{
+	++mg->refcnt;
+	return mg;
+}
+
+void map_groups__put(struct map_groups *mg);
+
 static inline struct kmap *map__kmap(struct map *map)
 {
 	return (struct kmap *)(map + 1);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index dc51d16..b501848 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -50,7 +50,7 @@ void thread__delete(struct thread *thread)
 {
 	struct comm *comm, *tmp;
 
-	map_groups__delete(thread->mg);
+	map_groups__put(thread->mg);
 	thread->mg = NULL;
 	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
 		list_del(&comm->list);
