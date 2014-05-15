Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaEORY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbaEORYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:24:19 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/14] perf tests: Add test interface for dso data fd limit
Date: Thu, 15 May 2014 19:23:33 +0200
Message-Id: <1400174615-2121-13-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a way to setup test dso limit by global variable
test_dso_data__fd_limit. It'll be used in the dso data
cache tests.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c | 5 +++++
 tools/perf/util/dso.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 80b54e7..9310369 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -7,6 +7,8 @@
 #include "util.h"
 #include "debug.h"
 
+rlim_t test_dso_data__fd_limit;
+
 char dso__symtab_origin(const struct dso *dso)
 {
 	static const char origin[] = {
@@ -262,6 +264,9 @@ static bool may_cache_fd(void)
 	if (!limit)
 		limit = get_fd_limit();
 
+	if (unlikely(test_dso_data__fd_limit))
+		limit = test_dso_data__fd_limit;
+
 	if (limit == RLIM_INFINITY)
 		return true;
 
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index d713184..3807014 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -1,6 +1,7 @@
 #ifndef __PERF_DSO
 #define __PERF_DSO
 
+#include <sys/resource.h>
 #include <linux/types.h>
 #include <linux/rbtree.h>
 #include <stdbool.h>
@@ -8,6 +9,8 @@
 #include "map.h"
 #include "build-id.h"
 
+extern rlim_t test_dso_data__fd_limit;
+
 enum dso_binary_type {
 	DSO_BINARY_TYPE__KALLSYMS = 0,
 	DSO_BINARY_TYPE__GUEST_KALLSYMS,
-- 
1.8.3.1

