Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3IVKQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:16:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:37121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab3IVKQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:16:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,956,1371106800"; 
   d="scan'208";a="405354158"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 10/10] perf tools: add ability to find kcore in build-id cache
Date: Sun, 22 Sep 2013 13:22:18 +0300
Message-Id: <1379845338-29637-11-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
References: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When no vmlinux is found, tools will use kallsyms and,
if possible, kcore.  Add the ability to find kcore in
the build-id cache.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/symbol.c | 138 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 94 insertions(+), 44 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 43b2c85..d44073d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1440,6 +1440,96 @@ out:
 	return err;
 }
 
+static int find_matching_kcore(struct map *map, char *dir, size_t dir_sz)
+{
+	char kallsyms_filename[PATH_MAX];
+	struct dirent *dent;
+	int ret = -1;
+	DIR *d;
+
+	d = opendir(dir);
+	if (!d)
+		return -1;
+
+	while (1) {
+		dent = readdir(d);
+		if (!dent)
+			break;
+		if (dent->d_type != DT_DIR)
+			continue;
+		snprintf(kallsyms_filename, sizeof(kallsyms_filename),
+			 "%s/%s/kallsyms", dir, dent->d_name);
+		if (!validate_kcore_modules(kallsyms_filename, map)) {
+			strncpy(dir, kallsyms_filename, dir_sz);
+			ret = 0;
+			break;
+		}
+	}
+
+	closedir(d);
+
+	return ret;
+}
+
+static char *dso__find_kallsyms(struct dso *dso, struct map *map)
+{
+	u8 host_build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+	bool is_host = false;
+	char path[PATH_MAX];
+
+	if (!dso->has_build_id) {
+		/*
+		 * Last resort, if we don't have a build-id and couldn't find
+		 * any vmlinux file, try the running kernel kallsyms table.
+		 */
+		goto proc_kallsyms;
+	}
+
+	if (sysfs__read_build_id("/sys/kernel/notes", host_build_id,
+				 sizeof(host_build_id)) == 0)
+		is_host = dso__build_id_equal(dso, host_build_id);
+
+	build_id__sprintf(dso->build_id, sizeof(dso->build_id), sbuild_id);
+
+	/* Use /proc/kallsyms if possible */
+	if (is_host) {
+		DIR *d;
+
+		/* If no cached kcore go with /proc/kallsyms */
+		snprintf(path, sizeof(path), "%s/[kernel.kcore]/%s",
+			 buildid_dir, sbuild_id);
+		d = opendir(path);
+		if (!d)
+			goto proc_kallsyms;
+		closedir(d);
+
+		/* If module maps match go with /proc/kallsyms */
+		if (!validate_kcore_modules("/proc/kallsyms", map))
+			goto proc_kallsyms;
+
+		/* Find kallsyms in build-id cache with kcore */
+		if (!find_matching_kcore(map, path, sizeof(path)))
+			return strdup(path);
+
+		goto proc_kallsyms;
+	}
+
+	snprintf(path, sizeof(path), "%s/[kernel.kallsyms]/%s",
+		 buildid_dir, sbuild_id);
+
+	if (access(path, F_OK)) {
+		pr_err("No kallsyms or vmlinux with build-id %s was found\n",
+		       sbuild_id);
+		return NULL;
+	}
+
+	return strdup(path);
+
+proc_kallsyms:
+	return strdup("/proc/kallsyms");
+}
+
 static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				symbol_filter_t filter)
 {
@@ -1488,51 +1578,11 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 	if (symbol_conf.symfs[0] != 0)
 		return -1;
 
-	/*
-	 * Say the kernel DSO was created when processing the build-id header table,
-	 * we have a build-id, so check if it is the same as the running kernel,
-	 * using it if it is.
-	 */
-	if (dso->has_build_id) {
-		u8 kallsyms_build_id[BUILD_ID_SIZE];
-		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-		if (sysfs__read_build_id("/sys/kernel/notes", kallsyms_build_id,
-					 sizeof(kallsyms_build_id)) == 0) {
-			if (dso__build_id_equal(dso, kallsyms_build_id)) {
-				kallsyms_filename = "/proc/kallsyms";
-				goto do_kallsyms;
-			}
-		}
-		/*
-		 * Now look if we have it on the build-id cache in
-		 * $HOME/.debug/[kernel.kallsyms].
-		 */
-		build_id__sprintf(dso->build_id, sizeof(dso->build_id),
-				  sbuild_id);
-
-		if (asprintf(&kallsyms_allocated_filename,
-			     "%s/.debug/[kernel.kallsyms]/%s",
-			     getenv("HOME"), sbuild_id) == -1) {
-			pr_err("Not enough memory for kallsyms file lookup\n");
-			return -1;
-		}
-
-		kallsyms_filename = kallsyms_allocated_filename;
+	kallsyms_allocated_filename = dso__find_kallsyms(dso, map);
+	if (!kallsyms_allocated_filename)
+		return -1;
 
-		if (access(kallsyms_filename, F_OK)) {
-			pr_err("No kallsyms or vmlinux with build-id %s "
-			       "was found\n", sbuild_id);
-			free(kallsyms_allocated_filename);
-			return -1;
-		}
-	} else {
-		/*
-		 * Last resort, if we don't have a build-id and couldn't find
-		 * any vmlinux file, try the running kernel kallsyms table.
-		 */
-		kallsyms_filename = "/proc/kallsyms";
-	}
+	kallsyms_filename = kallsyms_allocated_filename;
 
 do_kallsyms:
 	err = dso__load_kallsyms(dso, kallsyms_filename, map, filter);
-- 
1.7.11.7

