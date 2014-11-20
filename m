Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbaKTHkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:40:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbaKTHke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:40:34 -0500
Date: Wed, 19 Nov 2014 23:40:01 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-f90d194a867a5a1db51789b8c4e99bcd196be6bb@git.kernel.org>
Cc: dsahern@gmail.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        peterz@infradead.org, namhyung@gmail.com, mingo@kernel.org,
        fweisbec@gmail.com, hpa@zytor.com, jolsa@redhat.com,
        tglx@linutronix.de, adrian.hunter@intel.com, acme@redhat.com,
        eranian@google.com
Reply-To: adrian.hunter@intel.com, eranian@google.com, acme@redhat.com,
        jolsa@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, peterz@infradead.org, paulus@samba.org,
        mingo@kernel.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com
In-Reply-To: <1415715423-15563-2-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Do not poll events that use the system_wide flag
Git-Commit-ID: f90d194a867a5a1db51789b8c4e99bcd196be6bb
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

Commit-ID:  f90d194a867a5a1db51789b8c4e99bcd196be6bb
Gitweb:     http://git.kernel.org/tip/f90d194a867a5a1db51789b8c4e99bcd196be6bb
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 11 Nov 2014 16:16:39 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:48 -0300

perf evlist: Do not poll events that use the system_wide flag

The system_wide flag causes a selected event to be opened always without
a pid.

Consequently it will never get a POLLHUP, but it is used for tracking in
combination with other events, so it should not need to be polled
anyway.

Therefore don't add it for polling.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415715423-15563-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7e23dae..cfbe2b9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -816,7 +816,15 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 			perf_evlist__mmap_get(evlist, idx);
 		}
 
-		if (__perf_evlist__add_pollfd(evlist, fd, idx) < 0) {
+		/*
+		 * The system_wide flag causes a selected event to be opened
+		 * always without a pid.  Consequently it will never get a
+		 * POLLHUP, but it is used for tracking in combination with
+		 * other events, so it should not need to be polled anyway.
+		 * Therefore don't add it for polling.
+		 */
+		if (!evsel->system_wide &&
+		    __perf_evlist__add_pollfd(evlist, fd, idx) < 0) {
 			perf_evlist__mmap_put(evlist, idx);
 			return -1;
 		}
