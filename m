Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaBBI5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:57:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaBBI47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:56:59 -0500
Date: Sun, 2 Feb 2014 00:56:39 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-d3b70220292c40d3b499797fd2f33f608fc35edb@git.kernel.org>
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
In-Reply-To: <1391004884-10334-10-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-10-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf buildid-cache:
  Check relocation when checking for existing kcore
Git-Commit-ID: d3b70220292c40d3b499797fd2f33f608fc35edb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:56:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3b70220292c40d3b499797fd2f33f608fc35edb
Gitweb:     http://git.kernel.org/tip/d3b70220292c40d3b499797fd2f33f608fc35edb
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 29 Jan 2014 16:14:44 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 31 Jan 2014 17:21:54 -0300

perf buildid-cache: Check relocation when checking for existing kcore

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
