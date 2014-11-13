Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaKMCFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:05:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:60944 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbaKMCFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:05:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,372,1413270000"; 
   d="scan'208";a="636113987"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/10] perf, tools: Enable printing the srcline in the history
Date: Wed, 12 Nov 2014 18:05:24 -0800
Message-Id: <1415844328-4884-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For lbr-as-callgraph we need to see the line number in the history,
because many LBR entries can be in a single function, and just
showing the same function name many times is not useful.

When the history code is configured to sort by address, also try to
resolve the address to a file:srcline and display this in the browser.
If that doesn't work still display the address.

This can be also useful without LBRs for understanding which call in a large
function (or in which inlined function) called something else.

Contains fixes from Namhyung Kim

v2: Refactor code into common function
v3: Fix GTK build
v4: Rebase
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/callchain.c | 11 ++++++++++-
 tools/perf/util/callchain.h |  1 +
 tools/perf/util/srcline.c   |  6 ++++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 10870c9..8046eb9 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -819,7 +819,16 @@ char *callchain_list__sym_name(struct callchain_list *cl,
 	int printed;
 
 	if (cl->ms.sym) {
-		printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
+		if (callchain_param.key == CCKEY_ADDRESS &&
+		    cl->ms.map && !cl->srcline)
+			cl->srcline = get_srcline(cl->ms.map->dso,
+						  map__rip_2objdump(cl->ms.map,
+								    cl->ip));
+		if (cl->srcline)
+			printed = scnprintf(bf, bfsize, "%s %s",
+					cl->ms.sym->name, cl->srcline);
+		else
+			printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
 	} else
 		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 5d5200c..dbc08cf 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -71,6 +71,7 @@ extern struct callchain_param callchain_param;
 struct callchain_list {
 	u64			ip;
 	struct map_symbol	ms;
+	char		       *srcline;
 	struct list_head	list;
 };
 
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index f3e4bc5..c6a7cdc 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -258,7 +258,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	const char *dso_name;
 
 	if (!dso->has_srcline)
-		return SRCLINE_UNKNOWN;
+		goto out;
 
 	if (dso->symsrc_filename)
 		dso_name = dso->symsrc_filename;
@@ -289,7 +289,9 @@ out:
 		dso->has_srcline = 0;
 		dso__free_a2l(dso);
 	}
-	return SRCLINE_UNKNOWN;
+	if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
+		return SRCLINE_UNKNOWN;
+	return srcline;
 }
 
 void free_srcline(char *srcline)
-- 
1.9.3

