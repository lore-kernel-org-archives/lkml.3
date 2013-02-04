Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3BDMfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:35:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab3BDMfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:35:11 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 04/11] perf tools: Use PERF_EVENT_IOC_ID perf ioctl to read event id
Date: Mon,  4 Feb 2013 13:32:58 +0100
Message-Id: <1359981185-16819-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
References: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the way we retrieve the event ID. Instead of parsing out
the ID out of the read data, using the PERF_EVENT_IOC_ID ioctl.

Keeping the old way in place to support kernels without
PERF_EVENT_IOC_ID ioctl support.

This will be useful for retrieving the event ID for events
with PERF_FORMAT_GROUP read format set, where it's impossible
to get correct event id out of the read call data.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index eddd5eb..51e21f9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -298,6 +298,17 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
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
@@ -308,7 +319,10 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
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
1.7.11.7

