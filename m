Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3AZR2l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 12:28:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab3AZR20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 12:28:26 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 6/9] perf tools: Favor 'p' modifier before 'precise' term properly
Date: Sat, 26 Jan 2013 18:27:52 +0100
Message-Id: <1359221275-24254-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
References: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'p' event modifier is stronger than setting precise_ip
using the 'precise' term, like:

  'cpu/cycles,precise/'   - precise_ip = sysfs precise value
  'cpu/cycles,precise/p'  - precise_ip = 1

There's currently bug if the event modifier without 'p' is
specified the precise_ip is set to zero, like:

  'cpu/cycles,precise/u'  - precise_ip = 0

This patch makes sure that the precise_ip value is overwritten
only if any 'p' event modifier is specified, like:

  'cpu/cycles,precise/u'  - precise_ip = sysfs precise value

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/parse-events.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a92c403..83362f2 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -818,7 +818,14 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 		evsel->attr.exclude_user   = mod.eu;
 		evsel->attr.exclude_kernel = mod.ek;
 		evsel->attr.exclude_hv     = mod.eh;
-		evsel->attr.precise_ip     = mod.precise;
+
+		/*
+		 * Change precise only if it's defined, so we don't
+		 * overwrite 'precise' term if there's no 'p' modifier.
+		 */
+		if (mod.precise)
+			evsel->attr.precise_ip = mod.precise;
+
 		evsel->attr.exclude_host   = mod.eH;
 		evsel->attr.exclude_guest  = mod.eG;
 		evsel->exclude_GH          = mod.exclude_GH;
-- 
1.7.11.7

