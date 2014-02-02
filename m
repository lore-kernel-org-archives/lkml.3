Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaBBI4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:56:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41398 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaBBI40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:56:26 -0500
Date: Sun, 2 Feb 2014 00:56:05 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-a00d28cb72d3629c6481fe21ba6c6b4f96caed49@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1391004884-10334-7-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-7-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols:
  Prevent the use of kcore if the kernel has moved
Git-Commit-ID: a00d28cb72d3629c6481fe21ba6c6b4f96caed49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:56:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a00d28cb72d3629c6481fe21ba6c6b4f96caed49
Gitweb:     http://git.kernel.org/tip/a00d28cb72d3629c6481fe21ba6c6b4f96caed49
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 29 Jan 2014 16:14:41 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 31 Jan 2014 17:21:51 -0300

perf symbols: Prevent the use of kcore if the kernel has moved

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
 
