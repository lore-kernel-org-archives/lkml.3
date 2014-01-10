Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaAJMck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:32:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:34258 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983AbaAJMce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:32:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,638,1384329600"; 
   d="scan'208";a="456668299"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, eranian@google.com,
        jolsa@redhat.com, fweisbec@gmail.com, mingo@kernel.org,
        adrian.hunter@intel.com, dsahern@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] perf, tools: Enable printing the srcline in the history
Date: Fri, 10 Jan 2014 04:32:06 -0800
Message-Id: <1389357126-3003-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
References: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
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
 tools/perf/util/srcline.c      |  8 +++++++-
 5 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a440e03..5e0688b 100644
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
index c244cb5..eea2af2 100644
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
index 3d799f2..70bb29b 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -59,6 +59,7 @@ struct callchain_param {
 struct callchain_list {
 	u64			ip;
 	struct map_symbol	ms;
+	char 		       *srcline;
 	struct list_head	list;
 };
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 0fb4e9a..14437af 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1300,7 +1300,7 @@ static int add_callchain_ip(struct machine *machine,
 			return -EINVAL;
 	}
 
-	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
+	return callchain_cursor_append(&callchain_cursor, al.addr, al.map, al.sym);
 }
 
 #define CHASHSZ 127
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index d11aefb..65c402d 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -230,7 +230,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	size_t size;
 
 	if (!dso->has_srcline)
-		return SRCLINE_UNKNOWN;
+		goto out;
 
 	if (dso_name[0] == '[')
 		goto out;
@@ -255,6 +255,12 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 
 out:
 	dso->has_srcline = 0;
+	size = snprintf(NULL, 0, "%s[%lx]", dso->short_name, addr) + 1;
+	srcline = malloc(size);
+	if (srcline) { 
+		snprintf(srcline, size, "%s[%lx]", dso->short_name, addr);
+		return srcline;
+	}
 	return SRCLINE_UNKNOWN;
 }
 
-- 
1.8.3.1

