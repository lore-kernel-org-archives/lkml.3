Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3INIdL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 04:33:11 -0400
Received: from 1wt.eu ([62.212.114.60]:38600 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab3INIdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 04:33:07 -0400
Date: Sat, 14 Sep 2013 10:32:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tools/perf: add new option --ignore-vmlinux for perf top
Message-ID: <20130914083259.GA3418@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running "perf top" on a machine with possibly invalid or non-matching
vmlinux at the various places results in no symbol resolving despite
/proc/kallsyms being present and valid.

Add a new option --ignore-vmlinux to explicitly indicate that we do
not want to use these kernels and just use what we have (kallsyms).

Signed-off-by: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---

Hey guys, I found that I'm still regularly rebasing this patch
on new kernels. It would be nice if it could be merged, as it
causes some burden on some production machines which have old
vmlinux files at several places that we don't always want to
risk removing just for running perf top.

 tools/perf/builtin-top.c | 2 ++
 tools/perf/util/symbol.c | 4 ++--
 tools/perf/util/symbol.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e06c4f8..6e7fef7 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1067,6 +1067,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "list of cpus to monitor"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
+	OPT_BOOLEAN(0, "ignore-vmlinux", &symbol_conf.ignore_vmlinux,
+		    "don't load vmlinux even if found"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &top.hide_kernel_symbols,
 		    "hide kernel symbols"),
 	OPT_UINTEGER('m', "mmap-pages", &opts->mmap_pages,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d5528e1..7eab65a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -968,7 +968,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 		goto do_kallsyms;
 	}
 
-	if (symbol_conf.vmlinux_name != NULL) {
+	if (!symbol_conf.ignore_vmlinux && symbol_conf.vmlinux_name != NULL) {
 		err = dso__load_vmlinux(dso, map,
 					symbol_conf.vmlinux_name, filter);
 		if (err > 0) {
@@ -980,7 +980,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 		return err;
 	}
 
-	if (vmlinux_path != NULL) {
+	if (!symbol_conf.ignore_vmlinux && vmlinux_path != NULL) {
 		err = dso__load_vmlinux_path(dso, map, filter);
 		if (err > 0)
 			goto out_fixup;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5f720dc..3346d09 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -85,6 +85,7 @@ struct symbol_conf {
 	unsigned short	priv_size;
 	unsigned short	nr_events;
 	bool		try_vmlinux_path,
+			ignore_vmlinux,
 			show_kernel_path,
 			use_modules,
 			sort_by_name,
-- 
1.7.12.2.21.g234cd45.dirty

