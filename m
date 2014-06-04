Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaFDOhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:37:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbaFDOha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:37:30 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/13] perf tools: Add global count of opened dso objects
Date: Wed,  4 Jun 2014 16:36:54 +0200
Message-Id: <1401892622-30848-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401892622-30848-1-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding global count of opened dso objects so we could
properly limit the number of opened dso data file
descriptors.

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
 tools/perf/util/dso.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 5d7c7bc..76e5c13 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1,3 +1,4 @@
+#include <asm/bug.h>
 #include "symbol.h"
 #include "dso.h"
 #include "machine.h"
@@ -137,18 +138,23 @@ int dso__read_binary_type_filename(const struct dso *dso,
 }
 
 /*
- * Global list of open DSOs.
+ * Global list of open DSOs and the counter.
  */
 static LIST_HEAD(dso__data_open);
+static long dso__data_open_cnt;
 
 static void dso__list_add(struct dso *dso)
 {
 	list_add_tail(&dso->data.open_entry, &dso__data_open);
+	dso__data_open_cnt++;
 }
 
 static void dso__list_del(struct dso *dso)
 {
 	list_del(&dso->data.open_entry);
+	WARN_ONCE(dso__data_open_cnt <= 0,
+		  "DSO data fd counter out of bounds.");
+	dso__data_open_cnt--;
 }
 
 static int __open_dso(struct dso *dso, struct machine *machine)
-- 
1.8.3.1

