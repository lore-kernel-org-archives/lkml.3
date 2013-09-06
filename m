Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab3IFMOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:14:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3IFMO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:14:28 -0400
Date: Fri, 6 Sep 2013 05:14:03 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-98be6966ed7ed977881305aff5a1bfb305090f43@git.kernel.org>
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
In-Reply-To: <1378325897-3840-3-git-send-email-adrian.hunter@intel.com>
References: <1378325897-3840-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist:
  Fix parsing with no sample_id_all bit set
Git-Commit-ID: 98be6966ed7ed977881305aff5a1bfb305090f43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 06 Sep 2013 05:14:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98be6966ed7ed977881305aff5a1bfb305090f43
Gitweb:     http://git.kernel.org/tip/98be6966ed7ed977881305aff5a1bfb305090f43
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 4 Sep 2013 23:18:17 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Sep 2013 16:18:08 -0300

perf evlist: Fix parsing with no sample_id_all bit set

The perf_evlist__event2evsel() is changed to handle non-sample events
(such as mmap events) that have no id sample appended i.e. when
sample_id_all is not set.

Note that such events have a fixed format, so that the selected event
(evsel) they are associated with is immaterial.

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
Link: http://lkml.kernel.org/r/1378325897-3840-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b8727ae..7101283 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -446,20 +446,25 @@ static int perf_evlist__event2id(struct perf_evlist *evlist,
 static struct perf_evsel *perf_evlist__event2evsel(struct perf_evlist *evlist,
 						   union perf_event *event)
 {
+	struct perf_evsel *first = perf_evlist__first(evlist);
 	struct hlist_head *head;
 	struct perf_sample_id *sid;
 	int hash;
 	u64 id;
 
 	if (evlist->nr_entries == 1)
-		return perf_evlist__first(evlist);
+		return first;
+
+	if (!first->attr.sample_id_all &&
+	    event->header.type != PERF_RECORD_SAMPLE)
+		return first;
 
 	if (perf_evlist__event2id(evlist, event, &id))
 		return NULL;
 
 	/* Synthesized events have an id of zero */
 	if (!id)
-		return perf_evlist__first(evlist);
+		return first;
 
 	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
 	head = &evlist->heads[hash];
