Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbaKSQES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:04:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:51388 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbaKSQEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:04:15 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/16] perf tools: Fix annotation with kcore
Date: Wed, 19 Nov 2014 13:03:25 -0300
Message-Id: <1416413016-19110-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Patch "perf tools: Fix build-id matching on vmlinux" breaks annotation
with kcore.  The problem is that symbol__annotate() first gets the
filename based on the build-id which was previously not set.

This patch provides a quick fix, however there should probably be only
one way to determine the filename. e.g.  symbol__annotate() should use
the same way as dso__data_fd().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415700294-30816-1-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7dabde14ea54..873c8778db20 100644
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
1.9.3

