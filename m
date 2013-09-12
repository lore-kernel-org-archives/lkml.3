Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab3ILSMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:12:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:63548 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab3ILSMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:12:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,892,1371106800"; 
   d="scan'208";a="359655562"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] perf tools: fix buildid cache handling of kallsyms with kcore
Date: Thu, 12 Sep 2013 21:19:19 +0300
Message-Id: <1379009959-28046-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kallsyms is used with kcore the dso long_name becomes
the kcore file name.  That prevents the buildid cache from
caching kallsyms.  (There is no support at present for
caching kcore).  Fix by changing it so that the kallsyms
name is used in that case instead.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/header.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a33197a..37ebaf3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -199,9 +199,11 @@ static int write_buildid(char *name, size_t name_len, u8 *build_id,
 	return write_padded(fd, name, name_len + 1, len);
 }
 
-static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
-				u16 misc, int fd)
+static int __dsos__write_buildid_table(struct machine *machine,
+				       struct list_head *head, pid_t pid,
+				       u16 misc, int fd)
 {
+	char nm[PATH_MAX];
 	struct dso *pos;
 
 	dsos__for_each_with_build_id(pos, head) {
@@ -215,6 +217,10 @@ static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
 		if (is_vdso_map(pos->short_name)) {
 			name = (char *) VDSO__MAP_NAME;
 			name_len = sizeof(VDSO__MAP_NAME) + 1;
+		} else if (dso__is_kcore(pos)) {
+			machine__mmap_name(machine, nm, sizeof(nm));
+			name = nm;
+			name_len = strlen(nm) + 1;
 		} else {
 			name = pos->long_name;
 			name_len = pos->long_name_len + 1;
@@ -240,10 +246,10 @@ static int machine__write_buildid_table(struct machine *machine, int fd)
 		umisc = PERF_RECORD_MISC_GUEST_USER;
 	}
 
-	err = __dsos__write_buildid_table(&machine->kernel_dsos, machine->pid,
-					  kmisc, fd);
+	err = __dsos__write_buildid_table(machine, &machine->kernel_dsos,
+					  machine->pid, kmisc, fd);
 	if (err == 0)
-		err = __dsos__write_buildid_table(&machine->user_dsos,
+		err = __dsos__write_buildid_table(machine, &machine->user_dsos,
 						  machine->pid, umisc, fd);
 	return err;
 }
@@ -375,32 +381,42 @@ out_free:
 	return err;
 }
 
-static int dso__cache_build_id(struct dso *dso, const char *debugdir)
+static int dso__cache_build_id(struct machine *machine, struct dso *dso,
+			       const char *debugdir)
 {
 	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
 	bool is_vdso = is_vdso_map(dso->short_name);
+	char *name = dso->long_name;
+	char nm[PATH_MAX];
 
-	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id),
-				     dso->long_name, debugdir,
-				     is_kallsyms, is_vdso);
+	if (dso__is_kcore(dso)) {
+		is_kallsyms = true;
+		machine__mmap_name(machine, nm, sizeof(nm));
+		name = nm;
+	}
+	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id), name,
+				     debugdir, is_kallsyms, is_vdso);
 }
 
-static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
+static int __dsos__cache_build_ids(struct machine *machine,
+				   struct list_head *head, const char *debugdir)
 {
 	struct dso *pos;
 	int err = 0;
 
 	dsos__for_each_with_build_id(pos, head)
-		if (dso__cache_build_id(pos, debugdir))
+		if (dso__cache_build_id(machine, pos, debugdir))
 			err = -1;
 
 	return err;
 }
 
-static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
+static int machine__cache_build_ids(struct machine *machine,
+				    const char *debugdir)
 {
-	int ret = __dsos__cache_build_ids(&machine->kernel_dsos, debugdir);
-	ret |= __dsos__cache_build_ids(&machine->user_dsos, debugdir);
+	int ret = __dsos__cache_build_ids(machine, &machine->kernel_dsos,
+					  debugdir);
+	ret |= __dsos__cache_build_ids(machine, &machine->user_dsos, debugdir);
 	return ret;
 }
 
-- 
1.7.11.7

