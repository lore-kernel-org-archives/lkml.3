Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3KZNMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:12:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:3263 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab3KZNL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:11:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,774,1378882800"; 
   d="scan'208";a="442213706"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf tools: Fix not finding kcore in buildid cache
Date: Tue, 26 Nov 2013 15:19:24 +0200
Message-Id: <1385471964-4037-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic was not looking in the buildid cache for kcore
if the host kernel buildid did not match the recorded
kernel buildid.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/symbol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ce9ce10..360eefe 100644
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
1.7.11.7

