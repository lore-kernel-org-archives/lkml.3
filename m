Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaGNKRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:17:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:22558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbaGNKEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:04:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434249"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/41] perf buildid-cache: Apply force option to copying kcore
Date: Mon, 14 Jul 2014 13:02:38 +0300
Message-Id: <1405332185-4050-15-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a copy of kcore is not made if there is one
already with the same modules at the same addresses.
Change this to make a copy anyway if the force (-f)
option is also used.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-buildid-cache.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index b22dbb1..2a2c78f 100644
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
1.8.3.2

