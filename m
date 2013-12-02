Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3LBAHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 19:07:22 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49797 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3LBAHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 19:07:18 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] perf probe: Allow user to specify address within executable
Date: Sun,  1 Dec 2013 17:07:07 -0700
Message-Id: <1385942827-11637-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1385942827-11637-1-git-send-email-dsahern@gmail.com>
References: <1385942827-11637-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow user to specify an address within an executable. This is useful, for
example, in probing local functions. If the function name begins with 0x
then try to convert the supplied name to an address. If succuessful then
treat the function name as the address within the executable to be probed.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-probe.txt |  2 +-
 tools/perf/util/probe-event.c           | 37 +++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index b715cb71592b..ed500b311176 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -123,7 +123,7 @@ Probe points are defined by following syntax.
 
 
 'EVENT' specifies the name of new event, if omitted, it will be set the name of the probed function. Currently, event group name is set as 'probe'.
-'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, ':RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. And ';PTN' means lazy matching pattern (see LAZY MATCHING). Note that ';PTN' must be the end of the probe point definition.  In addition, '@SRC' specifies a source file which has that function.
+'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, ':RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. And ';PTN' means lazy matching pattern (see LAZY MATCHING). Note that ';PTN' must be the end of the probe point definition.  In addition, '@SRC' specifies a source file which has that function. If 'FUNC' starts with 0x and the entire string converts to an unsigned long it is treated as an address.
 It is also possible to specify a probe point by the source line number or lazy matching by using 'SRC:ALN' or 'SRC;PTN' syntax, where 'SRC' is the source file path, ':ALN' is the line number and ';PTN' is the lazy matching pattern.
 'ARG' specifies the arguments of this probe point, (see PROBE ARGUMENT).
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 638071b7bdd2..000e535b3df2 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2208,6 +2208,9 @@ static struct strfilter *available_func_filter;
 static int filter_available_functions(struct map *map __maybe_unused,
 				      struct symbol *sym)
 {
+	if (available_func_filter == NULL)
+		return 0;
+
 	if (sym->binding == STB_GLOBAL &&
 	    strfilter__compare(available_func_filter, sym->name))
 		return 0;
@@ -2281,9 +2284,10 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 	struct perf_probe_point *pp = &pev->point;
 	struct symbol *sym;
 	struct map *map = NULL;
-	char *function = NULL, *name = NULL;
+	char *function = NULL, *name = NULL, *endptr;
 	int ret = -EINVAL;
 	unsigned long long vaddr = 0;
+	unsigned long fcn_addr = 0;
 
 	if (!pp->function) {
 		pr_warning("No function specified for uprobes");
@@ -2297,6 +2301,13 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 		goto out;
 	}
 
+	/* perhaps an address was given instead of a function name */
+	if (strncmp(function, "0x", 2) == 0) {
+		fcn_addr = strtoul(function, &endptr, 0);
+		if (endptr && *endptr != '\0')
+			fcn_addr = 0;
+	}
+
 	name = realpath(exec, NULL);
 	if (!name) {
 		pr_warning("Cannot find realpath for %s.\n", exec);
@@ -2307,22 +2318,30 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 		pr_warning("Cannot find appropriate DSO for %s.\n", exec);
 		goto out;
 	}
-	available_func_filter = strfilter__new(function, NULL);
+
+	if (fcn_addr == 0)
+		available_func_filter = strfilter__new(function, NULL);
+
 	if (map__load(map, filter_available_functions)) {
 		pr_err("Failed to find requested function in %s. Perhaps it is a local variable?\n",
 		       name);
 		goto out;
 	}
 
-	sym = map__find_symbol_by_name(map, function, NULL);
-	if (!sym) {
-		pr_warning("Cannot find %s in DSO %s\n", function, exec);
-		goto out;
+	if (fcn_addr) {
+		vaddr = fcn_addr + pp->offset + map->pgoff;
+	} else {
+		sym = map__find_symbol_by_name(map, function, NULL);
+		if (!sym) {
+			pr_warning("Cannot find %s in DSO %s\n", function, exec);
+			goto out;
+		}
+
+		if (map->start > sym->start)
+			vaddr = map->start;
+		vaddr += sym->start + pp->offset + map->pgoff;
 	}
 
-	if (map->start > sym->start)
-		vaddr = map->start;
-	vaddr += sym->start + pp->offset + map->pgoff;
 	pp->offset = 0;
 
 	if (!pev->event) {
-- 
1.8.3.4 (Apple Git-47)

