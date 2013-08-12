Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3HLKRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:17:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab3HLKRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:17:31 -0400
Date: Mon, 12 Aug 2013 03:17:13 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-e93pgyj20rqx48qzw10vj4r4@git.kernel.org>
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
  Fix event ID retrieval for group format read case
Git-Commit-ID: c4861afe30aa3b00c95f9389f24cf6ede88416e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:17:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4861afe30aa3b00c95f9389f24cf6ede88416e4
Gitweb:     http://git.kernel.org/tip/c4861afe30aa3b00c95f9389f24cf6ede88416e4
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 12 Oct 2012 13:02:21 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:21 -0300

perf evlist: Fix event ID retrieval for group format read case

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
