Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaJOKC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:02:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaJOKCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:02:23 -0400
Date: Wed, 15 Oct 2014 03:02:01 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-23aadb1fcda27e79a134ec35a7fb68f243269bcb@git.kernel.org>
Cc: jolsa@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, fweisbec@gmail.com, acme@redhat.com,
        cjashfor@linux.vnet.ibm.com, tglx@linutronix.de, mail@milianw.de,
        a.p.zijlstra@chello.nl, mingo@kernel.org, namhyung@kernel.org,
        dsahern@gmail.com, paulus@samba.org
Reply-To: namhyung@kernel.org, dsahern@gmail.com, a.p.zijlstra@chello.nl,
        mingo@kernel.org, paulus@samba.org, mail@milianw.de,
        adrian.hunter@intel.com, cjashfor@linux.vnet.ibm.com,
        tglx@linutronix.de, acme@redhat.com, fweisbec@gmail.com, hpa@zytor.com,
        jolsa@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1412179229-19466-2-git-send-email-jolsa@kernel.org>
References: <1412179229-19466-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf callchain:
  Move callchain_param to util object in to fix python test
Git-Commit-ID: 23aadb1fcda27e79a134ec35a7fb68f243269bcb
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

Commit-ID:  23aadb1fcda27e79a134ec35a7fb68f243269bcb
Gitweb:     http://git.kernel.org/tip/23aadb1fcda27e79a134ec35a7fb68f243269bcb
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 1 Oct 2014 18:00:26 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 3 Oct 2014 09:39:48 -0300

perf callchain: Move callchain_param to util object in to fix python test

In following commit we changed the location of callchains data:

  72a128aa083a7f4cc4f800718aaae05d9c698e26
  perf tools: Move callchain config from record_opts to callchain_param

Now all callchains stuff stays in callchain_param struct, which adds its
dependency for evsel.c object and breaks python perf.so usage
(unresolved callchain_param).

Moving callchain_param into callchain.c and adding it into
python-ext-sources unleash just another dependency hell, so I ended up
adding callchain_param into util.c for now.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Milian Wolff <mail@milianw.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412179229-19466-2-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 7 -------
 tools/perf/util/util.c | 8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 86569fa..b475956 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -14,13 +14,6 @@ static bool hists__filter_entry_by_thread(struct hists *hists,
 static bool hists__filter_entry_by_symbol(struct hists *hists,
 					  struct hist_entry *he);
 
-struct callchain_param	callchain_param = {
-	.mode	= CHAIN_GRAPH_REL,
-	.min_percent = 0.5,
-	.order  = ORDER_CALLEE,
-	.key	= CCKEY_FUNCTION
-};
-
 u16 hists__col_len(struct hists *hists, enum hist_column col)
 {
 	return hists->col_len[col];
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 24e8d87..d5eab3f 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -14,6 +14,14 @@
 #include <byteswap.h>
 #include <linux/kernel.h>
 #include <unistd.h>
+#include "callchain.h"
+
+struct callchain_param	callchain_param = {
+	.mode	= CHAIN_GRAPH_REL,
+	.min_percent = 0.5,
+	.order  = ORDER_CALLEE,
+	.key	= CCKEY_FUNCTION
+};
 
 /*
  * XXX We need to find a better place for these things...
