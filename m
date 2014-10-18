Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaJRHHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 03:07:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaJRHHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 03:07:48 -0400
Date: Sat, 18 Oct 2014 00:06:37 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-n1w68pfe9m2vkhm4sqs8y1en@git.kernel.org>
Cc: hpa@zytor.com, jean.pihet@linaro.org, efault@gmx.de, acme@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, dsahern@gmail.com,
        peterz@infradead.org, adrian.hunter@intel.com, eranian@google.com,
        dzickus@redhat.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        bp@suse.de, namhyung@kernel.org, jolsa@redhat.com, paulus@samba.org
Reply-To: paulus@samba.org, mingo@kernel.org, bp@suse.de, jolsa@redhat.com,
        namhyung@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        adrian.hunter@intel.com, eranian@google.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, dzickus@redhat.com, hpa@zytor.com,
        efault@gmx.de, jean.pihet@linaro.org, acme@redhat.com,
        fweisbec@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel:
  Move exit stuff from __delete to __exit
Git-Commit-ID: 597e48c138632d1f55409dcfa5bee4e1152e7d4f
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

Commit-ID:  597e48c138632d1f55409dcfa5bee4e1152e7d4f
Gitweb:     http://git.kernel.org/tip/597e48c138632d1f55409dcfa5bee4e1152e7d4f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 16 Oct 2014 13:25:01 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Oct 2014 11:14:15 -0300

perf evsel: Move exit stuff from __delete to __exit

So that when an evsel is embedded into other struct it can free up
resources calling perf_evsel__exit().

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-n1w68pfe9m2vkhm4sqs8y1en@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d1ecde0..786ea55 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -850,17 +850,17 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	assert(list_empty(&evsel->node));
 	perf_evsel__free_fd(evsel);
 	perf_evsel__free_id(evsel);
+	close_cgroup(evsel->cgrp);
+	zfree(&evsel->group_name);
+	if (evsel->tp_format)
+		pevent_free_format(evsel->tp_format);
+	zfree(&evsel->name);
 	perf_evsel__object.fini(evsel);
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	perf_evsel__exit(evsel);
-	close_cgroup(evsel->cgrp);
-	zfree(&evsel->group_name);
-	if (evsel->tp_format)
-		pevent_free_format(evsel->tp_format);
-	zfree(&evsel->name);
 	free(evsel);
 }
 
