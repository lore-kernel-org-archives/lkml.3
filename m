Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab3K0USE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:18:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32882 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab3K0URH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 28/34] perf symbols: Fix not finding kcore in buildid cache
Date: Wed, 27 Nov 2013 17:16:28 -0300
Message-Id: <1385583394-3703-29-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The logic was not looking in the buildid cache for kcore if the host
kernel buildid did not match the recorded kernel buildid.

This affects the non-live case i.e. the kernel has changed and we are
looking at a special copy of kcore that we placed in the buildid cache
(using "perf buildid-cache -v -k /proc/kcore") when the data was
recorded.

After this fix kernel symbols get resolved/annotated correctly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1385471964-4037-1-git-send-email-adrian.hunter@intel.com
[ Added further explanation extracted from conversation between Ingo & Adrian on lkml ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ce9ce101adf4..360eefecb81d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1526,14 +1526,15 @@ static char *dso__find_kallsyms(struct dso *dso, struct map *map)
 
 	build_id__sprintf(dso->build_id, sizeof(dso->build_id), sbuild_id);
 
+	scnprintf(path, sizeof(path), "%s/[kernel.kcore]/%s", buildid_dir,
+		  sbuild_id);
+
 	/* Use /proc/kallsyms if possible */
 	if (is_host) {
 		DIR *d;
 		int fd;
 
 		/* If no cached kcore go with /proc/kallsyms */
-		scnprintf(path, sizeof(path), "%s/[kernel.kcore]/%s",
-			  buildid_dir, sbuild_id);
 		d = opendir(path);
 		if (!d)
 			goto proc_kallsyms;
@@ -1558,6 +1559,10 @@ static char *dso__find_kallsyms(struct dso *dso, struct map *map)
 		goto proc_kallsyms;
 	}
 
+	/* Find kallsyms in build-id cache with kcore */
+	if (!find_matching_kcore(map, path, sizeof(path)))
+		return strdup(path);
+
 	scnprintf(path, sizeof(path), "%s/[kernel.kallsyms]/%s",
 		  buildid_dir, sbuild_id);
 
-- 
1.8.1.4

