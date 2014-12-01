Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbaLATHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:07:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbaLATHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:07:44 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7/8] perf buildid-cache: Fix kallsyms removal
Date: Mon,  1 Dec 2014 20:06:28 +0100
Message-Id: <1417460789-13874-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to remove '[kernel.kallsyms]' file. Currently
the removal fails because buildid read fails (obviously on
kallsyms file).

However the file name itself holds the buildid which is
used in the .build-id link. Adding check to detect the
'[kernel.kallsyms]' removal and using the filename as
the buildid.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-buildid-cache.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 7a3504a1b494..5e076b8d5164 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -207,6 +207,25 @@ static int build_id_cache__add_file(const char *filename, const char *debugdir)
 	return err;
 }
 
+/*
+ * Takes basename from @filename argument and
+ * copy that into @buf.
+ */
+static int scnprintf_base(char *buf, int size, const char *filename)
+{
+	char *base = strrchr(filename, '/');
+
+	if (!base++)
+		return -1;
+
+	return scnprintf(buf, size, base, strlen(base));
+}
+
+static bool is_kallsyms_file(const char *filename)
+{
+	return strstr(filename, "kernel.kallsyms");
+}
+
 static int build_id_cache__remove_file(const char *filename,
 				       const char *debugdir)
 {
@@ -217,10 +236,21 @@ static int build_id_cache__remove_file(const char *filename,
 
 	if (filename__read_build_id(filename, &build_id, sizeof(build_id)) < 0) {
 		pr_debug("Couldn't read a build-id in %s\n", filename);
-		return -1;
+
+		if (!is_kallsyms_file(filename))
+			return -1;
+
+		pr_debug("Detected [kernel.kallsyms] file, trying basename as buildid.\n");
+
+		if (scnprintf_base(sbuild_id, sizeof(sbuild_id),
+					     filename) < 0) {
+			pr_debug("failed to get build-id\n");
+			return -1;
+		}
+	} else {
+		build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
 	}
 
-	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
 	err = build_id_cache__remove_s(sbuild_id, debugdir);
 	if (verbose)
 		pr_info("Removing %s %s: %s\n", sbuild_id, filename,
-- 
1.9.3

