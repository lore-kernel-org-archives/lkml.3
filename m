Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3LKLIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:08:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60432 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3LKLIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:08:41 -0500
Date: Wed, 11 Dec 2013 03:07:59 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-3ckwsob2g1q23s77nuhexrq7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Set freed members to NULL in dso destructor
Git-Commit-ID: ee021d42238daadc7ba49274bb0ba7dff219c6ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:08:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee021d42238daadc7ba49274bb0ba7dff219c6ab
Gitweb:     http://git.kernel.org/tip/ee021d42238daadc7ba49274bb0ba7dff219c6ab
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Dec 2013 15:26:55 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Dec 2013 16:51:10 -0300

perf symbols: Set freed members to NULL in dso destructor

To help in debugging use after free bugs.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3ckwsob2g1q23s77nuhexrq7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 2c7e189..19babb0 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -475,13 +475,23 @@ void dso__delete(struct dso *dso)
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
 		symbols__delete(&dso->symbols[i]);
-	if (dso->short_name_allocated)
+
+	if (dso->short_name_allocated) {
 		free((char *)dso->short_name);
-	if (dso->long_name_allocated)
+		dso->short_name		  = NULL;
+		dso->short_name_allocated = false;
+	}
+
+	if (dso->long_name_allocated) {
 		free((char *)dso->long_name);
+		dso->long_name		 = NULL;
+		dso->long_name_allocated = false;
+	}
+
 	dso_cache__free(&dso->cache);
 	dso__free_a2l(dso);
 	free(dso->symsrc_filename);
+	dso->symsrc_filename = NULL;
 	free(dso);
 }
 
