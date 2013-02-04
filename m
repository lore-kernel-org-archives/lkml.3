Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3BDMdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:33:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3BDMdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:33:33 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 06/11] perf tools: Fix event ID retrieval for group format read case
Date: Mon,  4 Feb 2013 13:33:00 +0100
Message-Id: <1359981185-16819-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
References: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jolsa@redhat.com" <jolsa@redhat.com>

We need to fail the event ID retrieval in case both following
conditions are true:
  - we are on kernel with no PERF_EVENT_IOC_ID support
  - PERF_FORMAT_GROUP read format is set

The PERF_FORMAT_GROUP read format bit is the killer for
retrieving event ID out of the read syscall, because we
have no guarantee of the event placement within leader
kernel sibling list.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5ba5509..8789adf 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -310,6 +310,15 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 
 	/* Legacy way to get event id.. All hail to old kernels! */
 
+	/*
+	 * This way does not work with group format read, so bail
+	 * out in that case.
+	 */
+	if (perf_evlist__read_format(evlist) & PERF_FORMAT_GROUP) {
+		pr_err("No kernel support for ':S' group modifier\n");
+		return -1;
+	}
+
 	if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
 	    read(fd, &read_data, sizeof(read_data)) == -1)
 		return -1;
-- 
1.7.11.7

