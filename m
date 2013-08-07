Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab3HGVL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:11:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46954 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170Ab3HGVL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/47] perf evlist: Use PERF_EVENT_IOC_ID perf ioctl to read event id
Date: Wed,  7 Aug 2013 18:10:30 -0300
Message-Id: <1375909874-22073-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Changing the way we retrieve the event ID. Instead of parsing out
the ID out of the read data, using the PERF_EVENT_IOC_ID ioctl.

Keeping the old way in place to support kernels without
PERF_EVENT_IOC_ID ioctl support.

This will be useful for retrieving the event ID for events
with PERF_FORMAT_GROUP read format set, where it's impossible
to get correct event id out of the read call data.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-psgb4n7kte8e6tfenbe7nj2h@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 42ea4e9..0d3b739 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -302,6 +302,17 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 {
 	u64 read_data[4] = { 0, };
 	int id_idx = 1; /* The first entry is the counter value */
+	u64 id;
+	int ret;
+
+	ret = ioctl(fd, PERF_EVENT_IOC_ID, &id);
+	if (!ret)
+		goto add;
+
+	if (errno != ENOTTY)
+		return -1;
+
+	/* Legacy way to get event id.. All hail to old kernels! */
 
 	if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
 	    read(fd, &read_data, sizeof(read_data)) == -1)
@@ -312,7 +323,10 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
 		++id_idx;
 
-	perf_evlist__id_add(evlist, evsel, cpu, thread, read_data[id_idx]);
+	id = read_data[id_idx];
+
+ add:
+	perf_evlist__id_add(evlist, evsel, cpu, thread, id);
 	return 0;
 }
 
-- 
1.8.1.4

