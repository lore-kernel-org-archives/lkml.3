Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbaAWCaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:30:10 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53994 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaAWCaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:30:04 -0500
Subject: [PATCH -tip 6/8] perf-probe: Show symbol+offset for address only
 kprobes
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 23 Jan 2014 02:29:59 +0000
Message-ID: <20140123022959.7206.75914.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show the symbol+offset information for address only kprobe
events when --list operation without debuginfo. Currently
those events are shown by the address itself. With this change
perf probe finds symbols on those addresses and shows it.

E.g. without this change (when debuginfo is not available);
# ./perf probe -l
  probe:t_show         (on 0xffffffff810d9720 with m v)
  probe:t_show_1       (on 0xffffffff810e2e40 with m v t)
  probe:t_show_2       (on 0xffffffff810ece30 with m v fmt)
  probe:t_show_3       (on 0xffffffff810f4ad0 with m v file)

With this change;
# ./perf probe -l
  probe:t_show         (on t_show with m v)
  probe:t_show_1       (on t_show with m v t)
  probe:t_show_2       (on t_show with m v fmt)
  probe:t_show_3       (on t_show with m v file)

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3470934..bf1d73b 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -118,6 +118,7 @@ static void exit_symbol_maps(void)
 	symbol__exit();
 }
 
+/* Caller must call init_symbol_maps before use this */
 static struct symbol *__find_kernel_function_by_name(const char *name,
 						     struct map **mapp)
 {
@@ -125,6 +126,12 @@ static struct symbol *__find_kernel_function_by_name(const char *name,
 						     NULL);
 }
 
+/* Caller must call init_symbol_maps before use this */
+static struct symbol *__find_kernel_function(u64 addr, struct map **mapp)
+{
+	return machine__find_kernel_function(host_machine, addr, mapp, NULL);
+}
+
 static struct map *kernel_get_module_map(const char *module)
 {
 	struct rb_node *nd;
@@ -222,17 +229,29 @@ static int convert_to_perf_probe_point(struct probe_trace_point *tp,
 {
 	char buf[128];
 	int ret;
-
-	if (tp->symbol) {
+	struct symbol *sym;
+	struct map *map;
+	u64 addr;
+
+	if (!tp->symbol) {
+		sym = __find_kernel_function(tp->address, &map);
+		if (sym) {
+			pp->function = strdup(sym->name);
+			addr = map->unmap_ip(map, sym->start);
+			pp->offset = tp->address - addr;
+		} else {
+			ret = e_snprintf(buf, 128, "0x%" PRIx64,
+					 (u64)tp->address);
+			if (ret < 0)
+				return ret;
+			pp->function = strdup(buf);
+			pp->offset = 0;
+		}
+	} else {
 		pp->function = strdup(tp->symbol);
 		pp->offset = tp->offset;
-	} else {
-		ret = e_snprintf(buf, 128, "0x%" PRIx64, (u64)tp->address);
-		if (ret < 0)
-			return ret;
-		pp->function = strdup(buf);
-		pp->offset = 0;
 	}
+
 	if (pp->function == NULL)
 		return -ENOMEM;
 


