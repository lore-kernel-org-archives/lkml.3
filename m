Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab3HNS1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:27:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34393 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760270Ab3HNSZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/21] perf tools: Improve robustness of topology parsing code
Date: Wed, 14 Aug 2013 15:25:14 -0300
Message-Id: <1376504715-28107-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch improves the robustness of the build_cpu_topo() routine by
allowing either the CPU parsing or the thread parsing to fail and yet
get perf to produce some topology data which could be useful for the
analysis.

Without this patch, if the cpu parsing fails, the thread parsing is not
attempted vice-versa.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130814100426.GA3444@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f558f83..a33197a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -716,18 +716,19 @@ static int build_cpu_topo(struct cpu_topo *tp, int cpu)
 	char filename[MAXPATHLEN];
 	char *buf = NULL, *p;
 	size_t len = 0;
+	ssize_t sret;
 	u32 i = 0;
 	int ret = -1;
 
 	sprintf(filename, CORE_SIB_FMT, cpu);
 	fp = fopen(filename, "r");
 	if (!fp)
-		return -1;
-
-	if (getline(&buf, &len, fp) <= 0)
-		goto done;
+		goto try_threads;
 
+	sret = getline(&buf, &len, fp);
 	fclose(fp);
+	if (sret <= 0)
+		goto try_threads;
 
 	p = strchr(buf, '\n');
 	if (p)
@@ -743,7 +744,9 @@ static int build_cpu_topo(struct cpu_topo *tp, int cpu)
 		buf = NULL;
 		len = 0;
 	}
+	ret = 0;
 
+try_threads:
 	sprintf(filename, THRD_SIB_FMT, cpu);
 	fp = fopen(filename, "r");
 	if (!fp)
-- 
1.8.1.4

