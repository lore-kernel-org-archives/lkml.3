Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaA2OO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:14:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:53968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbaA2ONT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:13:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,742,1384329600"; 
   d="scan'208";a="466608397"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 6/9] perf tools: Prevent the use of kcore if the kernel has moved
Date: Wed, 29 Jan 2014 16:14:41 +0200
Message-Id: <1391004884-10334-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of kcore is predicated upon it matching
the recorded data.  If the kernel has been
relocated at boot time (i.e. since the data
was recorded) then do not use kcore.

Note that it is possible to make a copy
of kcore at the time the data is recorded
using 'perf buildid-cache'.  Then perf tools
will use the copy because it does match the
data.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/symbol.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 39ce9ad..4ac1f87 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -976,6 +976,23 @@ static int validate_kcore_modules(const char *kallsyms_filename,
 	return 0;
 }
 
+static int validate_kcore_addresses(const char *kallsyms_filename,
+				    struct map *map)
+{
+	struct kmap *kmap = map__kmap(map);
+
+	if (kmap->ref_reloc_sym && kmap->ref_reloc_sym->name) {
+		u64 start;
+
+		start = kallsyms__get_function_start(kallsyms_filename,
+						     kmap->ref_reloc_sym->name);
+		if (start != kmap->ref_reloc_sym->addr)
+			return -EINVAL;
+	}
+
+	return validate_kcore_modules(kallsyms_filename, map);
+}
+
 struct kcore_mapfn_data {
 	struct dso *dso;
 	enum map_type type;
@@ -1019,8 +1036,8 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 					     kallsyms_filename))
 		return -EINVAL;
 
-	/* All modules must be present at their original addresses */
-	if (validate_kcore_modules(kallsyms_filename, map))
+	/* Modules and kernel must be present at their original addresses */
+	if (validate_kcore_addresses(kallsyms_filename, map))
 		return -EINVAL;
 
 	md.dso = dso;
@@ -1424,7 +1441,7 @@ static int find_matching_kcore(struct map *map, char *dir, size_t dir_sz)
 			continue;
 		scnprintf(kallsyms_filename, sizeof(kallsyms_filename),
 			  "%s/%s/kallsyms", dir, dent->d_name);
-		if (!validate_kcore_modules(kallsyms_filename, map)) {
+		if (!validate_kcore_addresses(kallsyms_filename, map)) {
 			strlcpy(dir, kallsyms_filename, dir_sz);
 			ret = 0;
 			break;
@@ -1479,7 +1496,7 @@ static char *dso__find_kallsyms(struct dso *dso, struct map *map)
 		if (fd != -1) {
 			close(fd);
 			/* If module maps match go with /proc/kallsyms */
-			if (!validate_kcore_modules("/proc/kallsyms", map))
+			if (!validate_kcore_addresses("/proc/kallsyms", map))
 				goto proc_kallsyms;
 		}
 
-- 
1.7.11.7

