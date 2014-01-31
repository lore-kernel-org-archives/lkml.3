Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbaAaUaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:30:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55434 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbaAaU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:27:59 -0500
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
Subject: [PATCH 09/12] perf symbols: Prevent the use of kcore if the kernel has moved
Date: Fri, 31 Jan 2014 17:27:32 -0300
Message-Id: <1391200055-18250-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391200055-18250-1-git-send-email-acme@infradead.org>
References: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Use of kcore is predicated upon it matching the recorded data.  If the
kernel has been relocated at boot time (i.e. since the data was
recorded) then do not use kcore.

Note that it is possible to make a copy of kcore at the time the data is
recorded using 'perf buildid-cache'.  Then the perf tools will use the
copy because it does match the data.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1391004884-10334-7-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 39ce9adbaaf0..4ac1f871ec27 100644
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
1.8.1.4

