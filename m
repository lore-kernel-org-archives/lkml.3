Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934599AbaGREZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:25:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaGREZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:25:39 -0400
Date: Thu, 17 Jul 2014 21:24:46 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-5173fbb8a11b2857aeec9e5f4e9568d4e1b84dbd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-15-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-15-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf buildid-cache:
  Apply force option to copying kcore
Git-Commit-ID: 5173fbb8a11b2857aeec9e5f4e9568d4e1b84dbd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5173fbb8a11b2857aeec9e5f4e9568d4e1b84dbd
Gitweb:     http://git.kernel.org/tip/5173fbb8a11b2857aeec9e5f4e9568d4e1b84dbd
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:38 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:35 -0300

perf buildid-cache: Apply force option to copying kcore

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
