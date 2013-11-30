Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3K3Mxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:53:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59775 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3K3Mxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:53:48 -0500
Date: Sat, 30 Nov 2013 04:53:27 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-449867e346bfd52c5df6bba5b706a795c35e78d4@git.kernel.org>
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
In-Reply-To: <1385471964-4037-1-git-send-email-adrian.hunter@intel.com>
References: <1385471964-4037-1-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Fix not finding kcore in buildid cache
Git-Commit-ID: 449867e346bfd52c5df6bba5b706a795c35e78d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:53:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  449867e346bfd52c5df6bba5b706a795c35e78d4
Gitweb:     http://git.kernel.org/tip/449867e346bfd52c5df6bba5b706a795c35e78d4
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 26 Nov 2013 15:19:24 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:38 -0300

perf symbols: Fix not finding kcore in buildid cache

The logic was not looking in the buildid cache for kcore if the host
kernel buildid did not match the recorded kernel buildid.

This affects the non-live case i.e. the kernel has changed and we are
looking at a special copy of kcore that we placed in the buildid cache
(using "perf buildid-cache -v -k /proc/kcore") when the data was
recorded.

After this fix kernel symbols get resolved/annotated correctly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1385471964-4037-1-git-send-email-adrian.hunter@intel.com
[ Added further explanation extracted from conversation between Ingo & Adrian on lkml ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ce9ce10..360eefe 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1526,14 +1526,15 @@ static char *dso__find_kallsyms(struct dso *dso, struct map *map)
 
 	build_id__sprintf(dso->build_id, sizeof(dso->build_id), sbuild_id);
 
+	scnprintf(path, sizeof(path), "%s/[kernel.kcore]/%s", buildid_dir,
+		  sbuild_id);
+
 	/* Use /proc/kallsyms if possible */
 	if (is_host) {
 		DIR *d;
 		int fd;
 
 		/* If no cached kcore go with /proc/kallsyms */
-		scnprintf(path, sizeof(path), "%s/[kernel.kcore]/%s",
-			  buildid_dir, sbuild_id);
 		d = opendir(path);
 		if (!d)
 			goto proc_kallsyms;
@@ -1558,6 +1559,10 @@ static char *dso__find_kallsyms(struct dso *dso, struct map *map)
 		goto proc_kallsyms;
 	}
 
+	/* Find kallsyms in build-id cache with kcore */
+	if (!find_matching_kcore(map, path, sizeof(path)))
+		return strdup(path);
+
 	scnprintf(path, sizeof(path), "%s/[kernel.kallsyms]/%s",
 		  buildid_dir, sbuild_id);
 
