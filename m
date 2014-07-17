Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506AbaGQQOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:14:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:52377 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964806AbaGQQN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:13:58 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/33] perf buildid-cache: Apply force option to copying kcore
Date: Thu, 17 Jul 2014 13:12:17 -0300
Message-Id: <1405613555-23380-16-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Currently a copy of kcore is not made if there is one already with the
same modules at the same addresses.

Change this to make a copy anyway if the force (-f) option is also used.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-15-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index b22dbb16f877..2a2c78f80876 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -125,7 +125,8 @@ static int build_id_cache__kcore_existing(const char *from_dir, char *to_dir,
 	return ret;
 }
 
-static int build_id_cache__add_kcore(const char *filename, const char *debugdir)
+static int build_id_cache__add_kcore(const char *filename, const char *debugdir,
+				     bool force)
 {
 	char dir[32], sbuildid[BUILD_ID_SIZE * 2 + 1];
 	char from_dir[PATH_MAX], to_dir[PATH_MAX];
@@ -144,7 +145,8 @@ static int build_id_cache__add_kcore(const char *filename, const char *debugdir)
 	scnprintf(to_dir, sizeof(to_dir), "%s/[kernel.kcore]/%s",
 		  debugdir, sbuildid);
 
-	if (!build_id_cache__kcore_existing(from_dir, to_dir, sizeof(to_dir))) {
+	if (!force &&
+	    !build_id_cache__kcore_existing(from_dir, to_dir, sizeof(to_dir))) {
 		pr_debug("same kcore found in %s\n", to_dir);
 		return 0;
 	}
@@ -389,7 +391,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 	}
 
 	if (kcore_filename &&
-	    build_id_cache__add_kcore(kcore_filename, debugdir))
+	    build_id_cache__add_kcore(kcore_filename, debugdir, force))
 		pr_warning("Couldn't add %s\n", kcore_filename);
 
 	return ret;
-- 
1.9.3

