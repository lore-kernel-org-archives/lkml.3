Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3LCHRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 02:17:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:32350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab3LCHPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 02:15:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445838626"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/7] perf tools: Use asprintf instead of malloc plus snprintf
Date: Tue,  3 Dec 2013 09:23:06 +0200
Message-Id: <1386055390-13757-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asprintf is equivalent to malloc plus snprintf so
use it because it is simpler.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/srcline.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index d11aefb..4c8e816 100644
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
1.7.11.7

