Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaFMGZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:25:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44133 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaFMGZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:25:57 -0400
Date: Thu, 12 Jun 2014 23:25:40 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-bda6ee4a94d1e1be0c1428d37bc0d3da2e5793ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401892622-30848-6-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-6-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add global count of opened dso objects
Git-Commit-ID: bda6ee4a94d1e1be0c1428d37bc0d3da2e5793ad
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

Commit-ID:  bda6ee4a94d1e1be0c1428d37bc0d3da2e5793ad
Gitweb:     http://git.kernel.org/tip/bda6ee4a94d1e1be0c1428d37bc0d3da2e5793ad
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 30 Apr 2014 15:25:10 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:20 +0200

perf tools: Add global count of opened dso objects

Adding global count of opened dso objects so we could
properly limit the number of opened dso data file
descriptors.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-6-git-send-email-jolsa@kernel.org
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
