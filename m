Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab3LDUNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:13:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59339 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab3LDUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/38] perf tools: Use asprintf instead of malloc plus snprintf
Date: Wed,  4 Dec 2013 17:06:25 -0300
Message-Id: <1386187622-2928-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The asprintf library function is equivalent to malloc plus snprintf so
use it because it is simpler.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386055390-13757-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/srcline.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index d11aefbc4b8d..4c8e816a2191 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -227,7 +227,6 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	unsigned line = 0;
 	char *srcline;
 	char *dso_name = dso->long_name;
-	size_t size;
 
 	if (!dso->has_srcline)
 		return SRCLINE_UNKNOWN;
@@ -241,13 +240,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	if (!addr2line(dso_name, addr, &file, &line))
 		goto out;
 
-	/* just calculate actual length */
-	size = snprintf(NULL, 0, "%s:%u", file, line) + 1;
-
-	srcline = malloc(size);
-	if (srcline)
-		snprintf(srcline, size, "%s:%u", file, line);
-	else
+	if (asprintf(&srcline, "%s:%u", file, line) < 0)
 		srcline = SRCLINE_UNKNOWN;
 
 	free(file);
-- 
1.8.1.4

