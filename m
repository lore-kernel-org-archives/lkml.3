Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3ILLLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:11:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3ILLLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:11:17 -0400
Date: Thu, 12 Sep 2013 04:10:35 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-733cd2fe197a0c696c54916f7395451c0da9b867@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1378496412-2424-2-git-send-email-adrian.hunter@intel.com>
References: <1378496412-2424-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Fix id pos in perf_evlist__open()
Git-Commit-ID: 733cd2fe197a0c696c54916f7395451c0da9b867
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 04:10:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  733cd2fe197a0c696c54916f7395451c0da9b867
Gitweb:     http://git.kernel.org/tip/733cd2fe197a0c696c54916f7395451c0da9b867
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 6 Sep 2013 22:40:11 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Sep 2013 15:51:44 -0300

perf evlist: Fix id pos in perf_evlist__open()

Ensure the id_pos is correct when perf_evlist__open() is used.

This fixes a problem introduced in 7556257 that broke 'perf kvm stat
live' in that this tool wasn't updated to use the sample_type bits
setting helpers.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1378496412-2424-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7101283..f9f77be 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -64,6 +64,16 @@ void perf_evlist__set_id_pos(struct perf_evlist *evlist)
 	evlist->is_pos = first->is_pos;
 }
 
+static void perf_evlist__update_id_pos(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node)
+		perf_evsel__calc_id_pos(evsel);
+
+	perf_evlist__set_id_pos(evlist);
+}
+
 static void perf_evlist__purge(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos, *n;
@@ -920,6 +930,8 @@ int perf_evlist__open(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 	int err;
 
+	perf_evlist__update_id_pos(evlist);
+
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
 		if (err < 0)
