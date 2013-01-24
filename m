Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3AXS7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:59:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3AXS7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:59:25 -0500
Date: Thu, 24 Jan 2013 10:58:50 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-6fuktuiyjn4jykxmt7c9f7xq@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, mjw@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, kdas@redhat.com, hpa@zytor.com, fche@redhat.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@gmail.com
Reply-To: linux-kernel@vger.kernel.org, paulus@samba.org, fche@redhat.com,
        hpa@zytor.com, mingo@kernel.org, acme@redhat.com, eranian@google.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, mjw@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, kdas@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf buildid-cache:
  Add option to show build ids that are missing in the cache
Git-Commit-ID: fbb6976c2f7a6ab2c4d8511181d686f5f2aaf476
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:58:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbb6976c2f7a6ab2c4d8511181d686f5f2aaf476
Gitweb:     http://git.kernel.org/tip/fbb6976c2f7a6ab2c4d8511181d686f5f2aaf476
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 7 Dec 2012 16:28:27 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:08 -0300

perf buildid-cache: Add option to show build ids that are missing in the cache

This will allow to connect with services being put in place by distros such as
Fedora, where one can retrieve DSOs by their build-id.

Example usage:

	for buildid in $(perf buildid-cache --missing perf.data | cut -d' ' -f1) ; do
		echo "trying to get $buildid"
		wget -q https://darkserver.fedoraproject.org/buildids/$buildid
		cat $buildid ; echo
		rm -f $buildid
	done

Now its just a matter of some porcelain to get the details provided by such a
service, retrieve the file and use 'perf buildid-cache --add $FILE' to insert
it in the cache, then use 'perf report' or 'annotate' that will find the
required files in the cache.

More information about the darkserver service at:

	https://darkserver.fedoraproject.org/

Cc: David Ahern <dsahern@gmail.com>
Cc: Frank Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kushal Das <kdas@redhat.com>
Cc: Mark Wielaard <mjw@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6fuktuiyjn4jykxmt7c9f7xq@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-cache.txt |  3 ++
 tools/perf/builtin-buildid-cache.c              | 48 +++++++++++++++++++++++--
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-buildid-cache.txt b/tools/perf/Documentation/perf-buildid-cache.txt
index c105770..8e798ba 100644
--- a/tools/perf/Documentation/perf-buildid-cache.txt
+++ b/tools/perf/Documentation/perf-buildid-cache.txt
@@ -24,6 +24,9 @@ OPTIONS
 -r::
 --remove=::
         Remove specified file from the cache.
+-M::
+--missing=:: 
+	List missing build ids in the cache for the specified file.
 -v::
 --verbose::
 	Be more verbose.
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index fae8b25..a336014 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -14,6 +14,7 @@
 #include "util/parse-options.h"
 #include "util/strlist.h"
 #include "util/build-id.h"
+#include "util/session.h"
 #include "util/symbol.h"
 
 static int build_id_cache__add_file(const char *filename, const char *debugdir)
@@ -58,19 +59,59 @@ static int build_id_cache__remove_file(const char *filename,
 	return err;
 }
 
+static bool dso__missing_buildid_cache(struct dso *dso, int parm __maybe_unused)
+{
+	char filename[PATH_MAX];
+	u8 build_id[BUILD_ID_SIZE];
+
+	if (dso__build_id_filename(dso, filename, sizeof(filename)) &&
+	    filename__read_build_id(filename, build_id,
+				    sizeof(build_id)) != sizeof(build_id)) {
+		if (errno == ENOENT)
+			return false;
+
+		pr_warning("Problems with %s file, consider removing it from the cache\n", 
+			   filename);
+	} else if (memcmp(dso->build_id, build_id, sizeof(dso->build_id))) {
+		pr_warning("Problems with %s file, consider removing it from the cache\n", 
+			   filename);
+	}
+
+	return true;
+}
+
+static int build_id_cache__fprintf_missing(const char *filename, bool force, FILE *fp)
+{
+	struct perf_session *session = perf_session__new(filename, O_RDONLY,
+							 force, false, NULL);
+	if (session == NULL)
+		return -1;
+
+	perf_session__fprintf_dsos_buildid(session, fp, dso__missing_buildid_cache, 0);
+	perf_session__delete(session);
+
+	return 0;
+}
+
 int cmd_buildid_cache(int argc, const char **argv,
 		      const char *prefix __maybe_unused)
 {
 	struct strlist *list;
 	struct str_node *pos;
+	int ret = 0;
+	bool force = false;
 	char debugdir[PATH_MAX];
 	char const *add_name_list_str = NULL,
-		   *remove_name_list_str = NULL;
+		   *remove_name_list_str = NULL,
+		   *missing_filename = NULL;
 	const struct option buildid_cache_options[] = {
 	OPT_STRING('a', "add", &add_name_list_str,
 		   "file list", "file(s) to add"),
 	OPT_STRING('r', "remove", &remove_name_list_str, "file list",
 		    "file(s) to remove"),
+	OPT_STRING('M', "missing", &missing_filename, "file",
+		   "to find missing build ids in the cache"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
 	OPT_END()
 	};
@@ -125,5 +166,8 @@ int cmd_buildid_cache(int argc, const char **argv,
 		}
 	}
 
-	return 0;
+	if (missing_filename)
+		ret = build_id_cache__fprintf_missing(missing_filename, force, stdout);
+
+	return ret;
 }
