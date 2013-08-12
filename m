Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3HLKRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:17:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47667 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3HLKRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:17:16 -0400
Date: Mon, 12 Aug 2013 03:16:53 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-psgb4n7kte8e6tfenbe7nj2h@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Use PERF_EVENT_IOC_ID perf ioctl to read event id
Git-Commit-ID: e2b5abe0c82b45980b95ead22678861a2013c0df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:16:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2b5abe0c82b45980b95ead22678861a2013c0df
Gitweb:     http://git.kernel.org/tip/e2b5abe0c82b45980b95ead22678861a2013c0df
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 4 Apr 2012 19:32:27 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:20 -0300

perf evlist: Use PERF_EVENT_IOC_ID perf ioctl to read event id

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
 
