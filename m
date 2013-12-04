Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab3LDUQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:16:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59324 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab3LDUHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/38] perf target: Move the checking of which map function to call into function.
Date: Wed,  4 Dec 2013 17:06:31 -0300
Message-Id: <1386187622-2928-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Check for cpu_map__dummy_new() or cpu_map__new() to be called in
perf_evlist__create_maps() is more complicated.

This patch moves the checking work into target.h, combining two
conditions and making perf_evlist__create_maps() more readable.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/b8c41f1fd2c4f0df71eb7b19aea74fb64d46cdda.1386197481.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |  8 +-------
 tools/perf/util/target.h | 13 +++++++++++++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 76fa76431329..7bb6ee1ca19f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -819,13 +819,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target->default_per_cpu)
-		evlist->cpus = target->per_thread ?
-					cpu_map__dummy_new() :
-					cpu_map__new(target->cpu_list);
-	else if (target__has_task(target))
-		evlist->cpus = cpu_map__dummy_new();
-	else if (!target__has_cpu(target) && !target->uses_mmap)
+	if (target__uses_dummy_map(target))
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index 31dd2e9a27d0..7381b1ca4041 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -63,4 +63,17 @@ static inline bool target__none(struct target *target)
 	return !target__has_task(target) && !target__has_cpu(target);
 }
 
+static inline bool target__uses_dummy_map(struct target *target)
+{
+	bool use_dummy = false;
+
+	if (target->default_per_cpu)
+		use_dummy = target->per_thread ? true : false;
+	else if (target__has_task(target) ||
+	         (!target__has_cpu(target) && !target->uses_mmap))
+		use_dummy = true;
+
+	return use_dummy;
+}
+
 #endif /* _PERF_TARGET_H */
-- 
1.8.1.4

