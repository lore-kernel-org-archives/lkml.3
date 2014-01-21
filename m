Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaAUUnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:43:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37244 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaAUUnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:43:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/8] perf session: Free cpu_map in perf_session__cpu_bitmap
Date: Tue, 21 Jan 2014 17:42:58 -0300
Message-Id: <1390336984-1553-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390336984-1553-1-git-send-email-acme@infradead.org>
References: <1390336984-1553-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

This method uses a temporary struct cpu_map to figure out the cpus
present in the received cpu list in string form, but it failed to free
it after returning. Fix it.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1390217980-22424-3-git-send-email-stfomichev@yandex-team.ru
[ Use goto + err = -1 to do the delete just once, in the normal exit path ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7acc03e8f3b2..0b39a48e5110 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1573,7 +1573,7 @@ next:
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap)
 {
-	int i;
+	int i, err = -1;
 	struct cpu_map *map;
 
 	for (i = 0; i < PERF_TYPE_MAX; ++i) {
@@ -1602,13 +1602,17 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 		if (cpu >= MAX_NR_CPUS) {
 			pr_err("Requested CPU %d too large. "
 			       "Consider raising MAX_NR_CPUS\n", cpu);
-			return -1;
+			goto out_delete_map;
 		}
 
 		set_bit(cpu, cpu_bitmap);
 	}
 
-	return 0;
+	err = 0;
+
+out_delete_map:
+	cpu_map__delete(map);
+	return err;
 }
 
 void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
-- 
1.8.1.4

