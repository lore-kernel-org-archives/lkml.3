Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030593AbaGPHVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:21:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:1976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030551AbaGPHVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:21:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,670,1400050800"; 
   d="scan'208";a="573895398"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf tools: Allow deletion of a thread with no map groups
Date: Wed, 16 Jul 2014 10:19:43 +0300
Message-Id: <1405495184-20441-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405495184-20441-1-git-send-email-adrian.hunter@intel.com>
References: <20140714204310.GC18133@kernel.org>
 <1405495184-20441-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It needs to be possible to call thread__delete() on
a thread with no map groups.  This is needed for
a subsequent patch which deletes a thread on the
error path before map groups have been attached.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/thread.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 7a32f44..b9c36ef 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -60,8 +60,10 @@ void thread__delete(struct thread *thread)
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

