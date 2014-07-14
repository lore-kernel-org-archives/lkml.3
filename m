Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaGNKRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:17:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:40395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbaGNKEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:04:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434235"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/41] perf tools: Fix leak of 'struct thread' on error path
Date: Mon, 14 Jul 2014 13:02:36 +0300
Message-Id: <1405332185-4050-13-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__machine__findnew_thread() creates a 'struct thread'
but does not free it on the error path.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 4 +++-
 tools/perf/util/thread.c  | 6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c1c5ca3..18eaf31 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -349,8 +349,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 		 * within thread__init_map_groups to find the thread
 		 * leader and that would screwed the rb tree.
 		 */
-		if (thread__init_map_groups(th, machine))
+		if (thread__init_map_groups(th, machine)) {
+			thread__delete(th);
 			return NULL;
+		}
 	}
 
 	return th;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 149e417..b9a3ee4 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -95,8 +95,10 @@ void thread__delete(struct thread *thread)
 {
 	struct comm *comm, *tmp;
 
-	map_groups__put(thread->mg);
-	thread->mg = NULL;
+	if (thread->mg) {
+		map_groups__put(thread->mg);
+		thread->mg = NULL;
+	}
 	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
 		list_del(&comm->list);
 		comm__free(comm);
-- 
1.8.3.2

