Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbbAHM5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:57:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:35459 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbbAHMzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:55:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="437999829"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V4 15/23] perf tools: Add member to struct dso for an instruction cache
Date: Thu,  8 Jan 2015 14:52:19 +0200
Message-Id: <1420721547-26470-16-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420721547-26470-1-git-send-email-adrian.hunter@intel.com>
References: <1420721547-26470-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a member to struct dso that can be used by Instruction
Trace implementations to hold a cache for decoded instructions.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c | 2 ++
 tools/perf/util/dso.h | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 45be944..73e28ca 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -4,6 +4,7 @@
 #include "symbol.h"
 #include "dso.h"
 #include "machine.h"
+#include "itrace.h"
 #include "util.h"
 #include "debug.h"
 
@@ -914,6 +915,7 @@ void dso__delete(struct dso *dso)
 	}
 
 	dso__data_close(dso);
+	itrace_cache__free(dso->itrace_cache);
 	dso_cache__free(&dso->data.cache);
 	dso__free_a2l(dso);
 	zfree(&dso->symsrc_filename);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 3782c82..c27c8fc 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -101,6 +101,8 @@ struct dsos {
 	struct rb_root	 root;	/* rbtree root sorted by long name */
 };
 
+struct itrace_cache;
+
 struct dso {
 	struct list_head node;
 	struct rb_node	 rb_node;	/* rbtree node sorted by long name */
@@ -130,6 +132,7 @@ struct dso {
 	u16		 long_name_len;
 	u16		 short_name_len;
 	void		*dwfl;			/* DWARF debug info */
+	struct itrace_cache *itrace_cache;
 
 	/* dso data file */
 	struct {
-- 
1.9.1

