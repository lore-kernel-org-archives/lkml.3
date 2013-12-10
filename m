Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3LJUbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:31:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34296 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3LJUbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:31:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 29/34] perf symbols: Set freed members to NULL in dso destructor
Date: Tue, 10 Dec 2013 17:31:11 -0300
Message-Id: <1386707476-12370-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386707476-12370-1-git-send-email-acme@infradead.org>
References: <1386707476-12370-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To help in debugging use after free bugs.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3ckwsob2g1q23s77nuhexrq7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 2c7e1899a735..19babb0d365d 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -475,13 +475,23 @@ void dso__delete(struct dso *dso)
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
 		symbols__delete(&dso->symbols[i]);
-	if (dso->short_name_allocated)
+
+	if (dso->short_name_allocated) {
 		free((char *)dso->short_name);
-	if (dso->long_name_allocated)
+		dso->short_name		  = NULL;
+		dso->short_name_allocated = false;
+	}
+
+	if (dso->long_name_allocated) {
 		free((char *)dso->long_name);
+		dso->long_name		 = NULL;
+		dso->long_name_allocated = false;
+	}
+
 	dso_cache__free(&dso->cache);
 	dso__free_a2l(dso);
 	free(dso->symsrc_filename);
+	dso->symsrc_filename = NULL;
 	free(dso);
 }
 
-- 
1.8.1.4

