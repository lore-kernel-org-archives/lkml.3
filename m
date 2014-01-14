Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaANBEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:04:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:62451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbaANBEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:04:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,656,1384329600"; 
   d="scan'208";a="466147305"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: jolsa@redhat.com, namhyung@kernel.org, mingo@kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/6] perf, tools: Enable printing the srcline in the history
Date: Mon, 13 Jan 2014 17:04:19 -0800
Message-Id: <1389661461-18996-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
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

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/ui/browsers/hists.c | 15 ++++++++++++---
 tools/perf/ui/stdio/hist.c     | 16 +++++++++++++---
 tools/perf/util/callchain.h    |  1 +
 tools/perf/util/machine.c      |  2 +-
 tools/perf/util/srcline.c      |  6 ++++--
 5 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b720b92..060fffc 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -399,9 +399,18 @@ static char *callchain_list__sym_name(struct callchain_list *cl,
 {
 	int printed;
 
-	if (cl->ms.sym)
-		printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
-	else
+	if (cl->ms.sym) {
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
+	} else
 		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
 
 	if (show_dso)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 831fbb7..a494eed 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -56,9 +56,19 @@ static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 		} else
 			ret += fprintf(fp, "%s", "          ");
 	}
-	if (chain->ms.sym)
-		ret += fprintf(fp, "%s\n", chain->ms.sym->name);
-	else
+	if (chain->ms.sym) {
+		if (callchain_param.key == CCKEY_ADDRESS &&
+		    chain->ms.map)
+			chain->srcline = get_srcline(chain->ms.map->dso,
+						  map__rip_2objdump(
+							  chain->ms.map,
+							  chain->ip));
+		if (chain->srcline)
+			ret += fprintf(fp, "%s %s\n",
+				       chain->ms.sym->name, chain->srcline);
+		else
+			ret += fprintf(fp, "%s\n", chain->ms.sym->name);
+	} else
 		ret += fprintf(fp, "0x%0" PRIx64 "\n", chain->ip);
 
 	return ret;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index a1a298a..7e74c1d 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -59,6 +59,7 @@ struct callchain_param {
 struct callchain_list {
 	u64			ip;
 	struct map_symbol	ms;
+	char		       *srcline;
 	struct list_head	list;
 };
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 084c80c..f839e6f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1294,7 +1294,7 @@ static int add_callchain_ip(struct machine *machine,
 			return -EINVAL;
 	}
 
-	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
+	return callchain_cursor_append(&callchain_cursor, al.addr, al.map, al.sym);
 }
 
 #define CHASHSZ 127
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 7e67879..680c02b 100644
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
1.8.3.1

