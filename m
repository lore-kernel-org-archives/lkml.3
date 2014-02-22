Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaBVRzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:55:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaBVRzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:55:42 -0500
Date: Sat, 22 Feb 2014 09:55:09 -0800
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-88fee52e58ca14d8465b614774ed0bf08e1a7790@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, chad.paradis@umit.maine.edu,
        namhyung@kernel.org, vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        chad.paradis@umit.maine.edu, namhyung@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf list:
  Fix checking for supported events on older kernels
Git-Commit-ID: 88fee52e58ca14d8465b614774ed0bf08e1a7790
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

Commit-ID:  88fee52e58ca14d8465b614774ed0bf08e1a7790
Gitweb:     http://git.kernel.org/tip/88fee52e58ca14d8465b614774ed0bf08e1a7790
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Mon, 30 Dec 2013 15:39:45 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Feb 2014 11:34:31 -0300

perf list: Fix checking for supported events on older kernels

"perf list" listing of hardware events doesn't work on older ARM devices.
The change enabling event detection:

 commit b41f1cec91c37eeea6fdb15effbfa24ea0a5536b
 Author: Namhyung Kim <namhyung.kim@lge.com>
 Date:   Tue Aug 27 11:41:53 2013 +0900

     perf list: Skip unsupported events

uses the following code in tools/perf/util/parse-events.c:

        struct perf_event_attr attr = {
                .type = type,
                .config = config,
                .disabled = 1,
                .exclude_kernel = 1,
        };

On ARM machines pre-dating the Cortex-A15 this doesn't work, as these
machines don't support .exclude_kernel.  So starting with 3.12 "perf
list" does not report any hardware events at all on older machines (seen
on Rasp-Pi, Pandaboard, Beagleboard, etc).

This version of the patch makes changes suggested by Namhyung Kim to
check for EACCESS and retry (instead of just dropping the
exclude_kernel) so we can properly handle machines where
/proc/sys/kernel/perf_event_paranoid is set to 2.

Reported-by: Chad Paradis <chad.paradis@umit.maine.edu>
Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Chad Paradis <chad.paradis@umit.maine.edu>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d248fca..1e15df1 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1091,12 +1091,12 @@ int is_valid_tracepoint(const char *event_string)
 static bool is_event_supported(u8 type, unsigned config)
 {
 	bool ret = true;
+	int open_return;
 	struct perf_evsel *evsel;
 	struct perf_event_attr attr = {
 		.type = type,
 		.config = config,
 		.disabled = 1,
-		.exclude_kernel = 1,
 	};
 	struct {
 		struct thread_map map;
@@ -1108,7 +1108,20 @@ static bool is_event_supported(u8 type, unsigned config)
 
 	evsel = perf_evsel__new(&attr);
 	if (evsel) {
-		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
+		open_return = perf_evsel__open(evsel, NULL, &tmap.map);
+		ret = open_return >= 0;
+
+		if (open_return == -EACCES) {
+			/*
+			 * This happens if the paranoid value
+			 * /proc/sys/kernel/perf_event_paranoid is set to 2
+			 * Re-run with exclude_kernel set; we don't do that
+			 * by default as some ARM machines do not support it.
+			 *
+			 */
+			evsel->attr.exclude_kernel = 1;
+			ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
+		}
 		perf_evsel__delete(evsel);
 	}
 
