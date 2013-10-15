Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab3JOFfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:35:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab3JOFfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:35:34 -0400
Date: Mon, 14 Oct 2013 22:35:14 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-0544d4225c52ca31ab2a55b22ddce1392d8f45a4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1381747424-3557-7-git-send-email-adrian.hunter@intel.com>
References: <1381747424-3557-7-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Add ability to find kcore in build-id cache
Git-Commit-ID: 0544d4225c52ca31ab2a55b22ddce1392d8f45a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:35:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0544d4225c52ca31ab2a55b22ddce1392d8f45a4
Gitweb:     http://git.kernel.org/tip/0544d4225c52ca31ab2a55b22ddce1392d8f45a4
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Oct 2013 13:43:43 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 10:29:25 -0300

perf symbols: Add ability to find kcore in build-id cache

When no vmlinux is found, tools will use kallsyms and, if possible,
kcore.  Add the ability to find kcore in the build-id cache.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381747424-3557-7-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 147 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 103 insertions(+), 44 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b2f60dd..76a9e93 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1401,6 +1401,105 @@ out:
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
+		scnprintf(kallsyms_filename, sizeof(kallsyms_filename),
+			  "%s/%s/kallsyms", dir, dent->d_name);
+		if (!validate_kcore_modules(kallsyms_filename, map)) {
+			strlcpy(dir, kallsyms_filename, dir_sz);
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
+		int fd;
+
+		/* If no cached kcore go with /proc/kallsyms */
+		scnprintf(path, sizeof(path), "%s/[kernel.kcore]/%s",
+			  buildid_dir, sbuild_id);
+		d = opendir(path);
+		if (!d)
+			goto proc_kallsyms;
+		closedir(d);
+
+		/*
+		 * Do not check the build-id cache, until we know we cannot use
+		 * /proc/kcore.
+		 */
+		fd = open("/proc/kcore", O_RDONLY);
+		if (fd != -1) {
+			close(fd);
+			/* If module maps match go with /proc/kallsyms */
+			if (!validate_kcore_modules("/proc/kallsyms", map))
+				goto proc_kallsyms;
+		}
+
+		/* Find kallsyms in build-id cache with kcore */
+		if (!find_matching_kcore(map, path, sizeof(path)))
+			return strdup(path);
+
+		goto proc_kallsyms;
+	}
+
+	scnprintf(path, sizeof(path), "%s/[kernel.kallsyms]/%s",
+		  buildid_dir, sbuild_id);
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
@@ -1449,51 +1548,11 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
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
