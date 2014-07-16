Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030578AbaGPHVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:21:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:1976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030564AbaGPHVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:21:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,670,1400050800"; 
   d="scan'208";a="573895419"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/2] perf tools: Fix leak of 'struct thread' on error path
Date: Wed, 16 Jul 2014 10:19:44 +0300
Message-Id: <1405495184-20441-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405495184-20441-1-git-send-email-adrian.hunter@intel.com>
References: <20140714204310.GC18133@kernel.org>
 <1405495184-20441-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__machine__findnew_thread() creates a 'struct thread'
but does not free it on the error path.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 5b80877..b75af25 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -325,8 +325,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
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
-- 
1.8.3.2

