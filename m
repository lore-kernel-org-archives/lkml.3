Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbaAaUak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:30:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55431 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077AbaAaU17 (ORCPT
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
Subject: [PATCH 12/12] perf buildid-cache: Check relocation when checking for existing kcore
Date: Fri, 31 Jan 2014 17:27:35 -0300
Message-Id: <1391200055-18250-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391200055-18250-1-git-send-email-acme@infradead.org>
References: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

perf buildid-cache does not make another copy of kcore if the buildid
and modules match an existing copy.

That does not take into account the possibility that the kernel has been
relocated.

Extend the check to check if the reference relocation symbol matches
too, otherwise do make a copy.

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
Link: http://lkml.kernel.org/r/1391004884-10334-10-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index cfede86161d8..b22dbb16f877 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -63,11 +63,35 @@ static int build_id_cache__kcore_dir(char *dir, size_t sz)
 	return 0;
 }
 
+static bool same_kallsyms_reloc(const char *from_dir, char *to_dir)
+{
+	char from[PATH_MAX];
+	char to[PATH_MAX];
+	const char *name;
+	u64 addr1 = 0, addr2 = 0;
+	int i;
+
+	scnprintf(from, sizeof(from), "%s/kallsyms", from_dir);
+	scnprintf(to, sizeof(to), "%s/kallsyms", to_dir);
+
+	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
+		addr1 = kallsyms__get_function_start(from, name);
+		if (addr1)
+			break;
+	}
+
+	if (name)
+		addr2 = kallsyms__get_function_start(to, name);
+
+	return addr1 == addr2;
+}
+
 static int build_id_cache__kcore_existing(const char *from_dir, char *to_dir,
 					  size_t to_dir_sz)
 {
 	char from[PATH_MAX];
 	char to[PATH_MAX];
+	char to_subdir[PATH_MAX];
 	struct dirent *dent;
 	int ret = -1;
 	DIR *d;
@@ -86,10 +110,11 @@ static int build_id_cache__kcore_existing(const char *from_dir, char *to_dir,
 			continue;
 		scnprintf(to, sizeof(to), "%s/%s/modules", to_dir,
 			  dent->d_name);
-		if (!compare_proc_modules(from, to)) {
-			scnprintf(to, sizeof(to), "%s/%s", to_dir,
-				  dent->d_name);
-			strlcpy(to_dir, to, to_dir_sz);
+		scnprintf(to_subdir, sizeof(to_subdir), "%s/%s",
+			  to_dir, dent->d_name);
+		if (!compare_proc_modules(from, to) &&
+		    same_kallsyms_reloc(from_dir, to_subdir)) {
+			strlcpy(to_dir, to_subdir, to_dir_sz);
 			ret = 0;
 			break;
 		}
-- 
1.8.1.4

