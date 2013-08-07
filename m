Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab3HGVW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:22:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47019 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377Ab3HGVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/47] perf evlist: Fix event ID retrieval for group format read case
Date: Wed,  7 Aug 2013 18:10:32 -0300
Message-Id: <1375909874-22073-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

We need to fail the event ID retrieval in case both following conditions
are true:

  - we are on kernel with no PERF_EVENT_IOC_ID support
  - PERF_FORMAT_GROUP read format is set

The PERF_FORMAT_GROUP read format bit is the killer for retrieving event
ID out of the read syscall, because we have no guarantee of the event
placement within leader kernel sibling list.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-e93pgyj20rqx48qzw10vj4r4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index df77a44..10fcc03 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -314,6 +314,13 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 
 	/* Legacy way to get event id.. All hail to old kernels! */
 
+	/*
+	 * This way does not work with group format read, so bail
+	 * out in that case.
+	 */
+	if (perf_evlist__read_format(evlist) & PERF_FORMAT_GROUP)
+		return -1;
+
 	if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
 	    read(fd, &read_data, sizeof(read_data)) == -1)
 		return -1;
-- 
1.8.1.4

