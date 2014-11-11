Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaKKKGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:06:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:43773 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaKKKGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:06:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414739709"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf tools: Fix annotation with kcore
Date: Tue, 11 Nov 2014 12:04:54 +0200
Message-Id: <1415700294-30816-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch "perf tools: Fix build-id matching on vmlinux"
breaks annotation with kcore.  The problem is that
symbol__annotate() first gets the filename based on
the build-id which was previously not set.
This patch provides a quick fix, however there should
probably be only one way to determine the filename. e.g.
symbol__annotate() should use the same way as
dso__data_fd().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/annotate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7dabde1..873c877 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -915,6 +915,8 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 			return -ENOMEM;
 		}
 		goto fallback;
+	} else if (dso__is_kcore(dso)) {
+		goto fallback;
 	} else if (readlink(symfs_filename, command, sizeof(command)) < 0 ||
 		   strstr(command, "[kernel.kallsyms]") ||
 		   access(symfs_filename, R_OK)) {
-- 
1.9.1

