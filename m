Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaA2ONc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:13:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:53968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbaA2ON3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:13:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,742,1384329600"; 
   d="scan'208";a="466608459"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 9/9] perf buildid-cache: Check relocation when checking for existing kcore
Date: Wed, 29 Jan 2014 16:14:44 +0200
Message-Id: <1391004884-10334-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf buildid-cache does not make another
copy of kcore if the buildid and modules
match an existing copy.  That does not
take into account the possibility that
the kernel has been relocated.  Extend
the check to check if the reference
relocation symbol matches too, otherwise
do make a copy.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-buildid-cache.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index cfede86..b22dbb1 100644
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
1.7.11.7

