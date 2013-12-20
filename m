Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3LTKIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:08:49 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59822 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab3LTKIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:08:44 -0500
Subject: [PATCH -tip 3/3] perf-probe: Use the actual address as a hint for
 uprobes
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Date: Fri, 20 Dec 2013 10:03:02 +0000
Message-ID: <20131220100302.7169.96318.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal>
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the actual address of tracepoint as a hint to find
different local symbols. Since sometimes there are local
symbols which have same name, it is impossible to determine
which symbol should be used. This saves the actual address
from debuginfo and use it as a hint later.

The reason why we don't use the address directly is that
the address stored in the debuginfo has some section offset.
Thus this just uses the last 12 bits of the address as a
hint when searching the symbol in the map.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c  |   16 +++++++++++++---
 tools/perf/util/probe-event.h  |    1 +
 tools/perf/util/probe-finder.c |    1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index e27cecb..e5fbda3 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -187,11 +187,18 @@ static int init_user_exec(void)
 }
 
 static const char *__target_symbol;
+static unsigned long __target_hint;
 static struct symbol *__result_sym;
+#define HINT_MASK	0xfff
 
 static int filter_target_symbol(struct map *map __maybe_unused,
 				struct symbol *sym)
 {
+	/* Check the last bits is same */
+	if (__target_hint)
+		if ((sym->start & HINT_MASK) != (__target_hint & HINT_MASK))
+			return 0;
+
 	if (strcmp(__target_symbol, sym->name) == 0) {
 		__result_sym = sym;
 		return 0;
@@ -201,7 +208,7 @@ static int filter_target_symbol(struct map *map __maybe_unused,
 
 /* Find the offset of the symbol in the executable binary */
 static int find_symbol_offset(const char *exec, const char *function,
-			      unsigned long *offs)
+			      unsigned long hint, unsigned long *offs)
 {
 	struct symbol *sym;
 	struct map *map = NULL;
@@ -218,6 +225,7 @@ static int find_symbol_offset(const char *exec, const char *function,
 	pr_debug("Search %s in %s\n", function, exec);
 	__target_symbol = function;
 	__result_sym = NULL;
+	__target_hint = hint;
 	if (map__load(map, filter_target_symbol)) {
 		pr_err("Failed to find %s in %s.\n", function, exec);
 		goto out;
@@ -357,8 +365,10 @@ static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
 		return 0;
 
 	for (i = 0; i < ntevs && ret >= 0; i++) {
+		offset = tevs[i].point.address - tevs[i].point.offset;
 		/* Get proper offset */
-		ret = find_symbol_offset(exec, tevs[i].point.symbol, &offset);
+		ret = find_symbol_offset(exec, tevs[i].point.symbol,
+					 offset, &offset);
 		if (ret < 0)
 			break;
 		offset += tevs[i].point.offset;
@@ -2418,7 +2428,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 		goto out;
 	}
 
-	ret = find_symbol_offset(exec, pp->function, &vaddr);
+	ret = find_symbol_offset(exec, pp->function, 0, &vaddr);
 	if (ret < 0)
 		goto out;
 
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index f9f3de8..d481c46 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -12,6 +12,7 @@ struct probe_trace_point {
 	char		*symbol;	/* Base symbol */
 	char		*module;	/* Module name */
 	unsigned long	offset;		/* Offset from symbol */
+	unsigned long	address;	/* Actual address of the trace point */
 	bool		retprobe;	/* Return probe flag */
 };
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index ffb657f..7db7e05 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -729,6 +729,7 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwfl_Module *mod,
 		return -ENOENT;
 	}
 	tp->offset = (unsigned long)(paddr - sym.st_value);
+	tp->address = (unsigned long)paddr;
 	tp->symbol = strdup(symbol);
 	if (!tp->symbol)
 		return -ENOMEM;


