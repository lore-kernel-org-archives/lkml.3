Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaALSju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:39:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46016 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaALSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:39:43 -0500
Date: Sun, 12 Jan 2014 10:39:23 -0800
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-fb7345bbf7fad9bf72ef63a19c707970b9685812@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, dave.long@linaro.org,
        hpa@zytor.com, mingo@kernel.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, dave.long@linaro.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, dsahern@gmail.com, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20131226054152.22364.47021.stgit@kbuild-fedora.novalocal>
References: <20131226054152.22364.47021.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Support basic dwarf-based operations on uprobe events
Git-Commit-ID: fb7345bbf7fad9bf72ef63a19c707970b9685812
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:39:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb7345bbf7fad9bf72ef63a19c707970b9685812
Gitweb:     http://git.kernel.org/tip/fb7345bbf7fad9bf72ef63a19c707970b9685812
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 26 Dec 2013 05:41:53 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 26 Dec 2013 11:22:01 -0300

perf probe: Support basic dwarf-based operations on uprobe events

Support basic dwarf(debuginfo) based operations for uprobe events.  With
this change, perf probe can analyze debuginfo of user application binary
to set up new uprobe event.

This allows perf-probe --add(with local variables, line numbers) and
--line works with -x option.  (Actually, --vars has already accepted -x
option)

For example, the following command shows the probe-able lines of a given
user space function. Something that so far was only available in the
'perf probe' tool for kernel space functions:

  # ./perf probe -x perf --line map__load
  <map__load@/home/fedora/ksrc/linux-2.6/tools/perf/util/map.c:0>
        0  int map__load(struct map *map, symbol_filter_t filter)
        1  {
        2         const char *name = map->dso->long_name;
                  int nr;

        5         if (dso__loaded(map->dso, map->type))
        6                 return 0;

        8         nr = dso__load(map->dso, map, filter);
        9         if (nr < 0) {
       10                 if (map->dso->has_build_id) {

And this shows the available variables at the given line of the
function.

  # ./perf probe -x perf --vars map__load:8
  Available variables at map__load:8
          @<map__load+96>
                  char*   name
                  struct map*     map
                  symbol_filter_t filter
          @<map__find_symbol+112>
                  char*   name
                  symbol_filter_t filter
          @<map__find_symbol_by_name+136>
                  char*   name
                  symbol_filter_t filter
          @<map_groups__find_symbol_by_name+176>
                  char*   name
                  struct map*     map
                  symbol_filter_t filter

And lastly, we can now define probe(s) with all available
variables on the given line:

  # ./perf probe -x perf --add 'map__load:8 $vars'

  Added new events:
    probe_perf:map__load (on map__load:8 with $vars)
    probe_perf:map__load_1 (on map__load:8 with $vars)
    probe_perf:map__load_2 (on map__load:8 with $vars)
    probe_perf:map__load_3 (on map__load:8 with $vars)

  You can now use it in all perf tools, such as:

          perf record -e probe_perf:map__load_3 -aR sleep 1

  Changes from previous version:
   - Add examples in the patch description.
   - Use .text section start address and dwarf symbol address
     for calculating the offset of given symbol, instead of
     searching the symbol in symtab again.
     With this change, we can safely handle multiple local
     function instances (e.g. scnprintf in perf).

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: David A. Long <dave.long@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: systemtap@sourceware.org
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20131226054152.22364.47021.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c     |   2 +-
 tools/perf/util/probe-event.c  | 151 ++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/probe-event.h  |   1 +
 tools/perf/util/probe-finder.c |   1 +
 4 files changed, 138 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 1792a3f..43ff33d 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -424,7 +424,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 #ifdef HAVE_DWARF_SUPPORT
-	if (params.show_lines && !params.uprobes) {
+	if (params.show_lines) {
 		if (params.mod_events) {
 			pr_err("  Error: Don't use --line with"
 			       " --add/--del.\n");
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 68013b9..72b56ae 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -172,6 +172,52 @@ const char *kernel_get_module_path(const char *module)
 	return (dso) ? dso->long_name : NULL;
 }
 
+/* Copied from unwind.c */
+static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
+				    GElf_Shdr *shp, const char *name)
+{
+	Elf_Scn *sec = NULL;
+
+	while ((sec = elf_nextscn(elf, sec)) != NULL) {
+		char *str;
+
+		gelf_getshdr(sec, shp);
+		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
+		if (!strcmp(name, str))
+			break;
+	}
+
+	return sec;
+}
+
+static int get_text_start_address(const char *exec, unsigned long *address)
+{
+	Elf *elf;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+	int fd, ret = -ENOENT;
+
+	fd = open(exec, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		return -EINVAL;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		goto out;
+
+	if (!elf_section_by_name(elf, &ehdr, &shdr, ".text"))
+		goto out;
+
+	*address = shdr.sh_addr - shdr.sh_offset;
+	ret = 0;
+out:
+	elf_end(elf);
+	return ret;
+}
+
 static int init_user_exec(void)
 {
 	int ret = 0;
@@ -186,6 +232,37 @@ static int init_user_exec(void)
 	return ret;
 }
 
+static int convert_exec_to_group(const char *exec, char **result)
+{
+	char *ptr1, *ptr2, *exec_copy;
+	char buf[64];
+	int ret;
+
+	exec_copy = strdup(exec);
+	if (!exec_copy)
+		return -ENOMEM;
+
+	ptr1 = basename(exec_copy);
+	if (!ptr1) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ptr2 = strpbrk(ptr1, "-._");
+	if (ptr2)
+		*ptr2 = '\0';
+	ret = e_snprintf(buf, 64, "%s_%s", PERFPROBE_GROUP, ptr1);
+	if (ret < 0)
+		goto out;
+
+	*result = strdup(buf);
+	ret = *result ? 0 : -ENOMEM;
+
+out:
+	free(exec_copy);
+	return ret;
+}
+
 static int convert_to_perf_probe_point(struct probe_trace_point *tp,
 					struct perf_probe_point *pp)
 {
@@ -261,6 +338,40 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 	return 0;
 }
 
+static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
+					  int ntevs, const char *exec)
+{
+	int i, ret = 0;
+	unsigned long offset, stext = 0;
+	char buf[32];
+
+	if (!exec)
+		return 0;
+
+	ret = get_text_start_address(exec, &stext);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < ntevs && ret >= 0; i++) {
+		offset = tevs[i].point.address - stext;
+		offset += tevs[i].point.offset;
+		tevs[i].point.offset = 0;
+		free(tevs[i].point.symbol);
+		ret = e_snprintf(buf, 32, "0x%lx", offset);
+		if (ret < 0)
+			break;
+		tevs[i].point.module = strdup(exec);
+		tevs[i].point.symbol = strdup(buf);
+		if (!tevs[i].point.symbol || !tevs[i].point.module) {
+			ret = -ENOMEM;
+			break;
+		}
+		tevs[i].uprobes = true;
+	}
+
+	return ret;
+}
+
 static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
 					    int ntevs, const char *module)
 {
@@ -305,15 +416,6 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 	struct debuginfo *dinfo;
 	int ntevs, ret = 0;
 
-	if (pev->uprobes) {
-		if (need_dwarf) {
-			pr_warning("Debuginfo-analysis is not yet supported"
-					" with -x/--exec option.\n");
-			return -ENOSYS;
-		}
-		return convert_name_to_addr(pev, target);
-	}
-
 	dinfo = open_debuginfo(target);
 
 	if (!dinfo) {
@@ -332,9 +434,14 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
 		pr_debug("find %d probe_trace_events.\n", ntevs);
-		if (target)
-			ret = add_module_to_probe_trace_events(*tevs, ntevs,
-							       target);
+		if (target) {
+			if (pev->uprobes)
+				ret = add_exec_to_probe_trace_events(*tevs,
+						 ntevs, target);
+			else
+				ret = add_module_to_probe_trace_events(*tevs,
+						 ntevs, target);
+		}
 		return ret < 0 ? ret : ntevs;
 	}
 
@@ -654,9 +761,6 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 		return -ENOSYS;
 	}
 
-	if (pev->uprobes)
-		return convert_name_to_addr(pev, target);
-
 	return 0;
 }
 
@@ -1913,14 +2017,29 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 					  int max_tevs, const char *target)
 {
 	struct symbol *sym;
-	int ret = 0, i;
+	int ret, i;
 	struct probe_trace_event *tev;
 
+	if (pev->uprobes && !pev->group) {
+		/* Replace group name if not given */
+		ret = convert_exec_to_group(target, &pev->group);
+		if (ret != 0) {
+			pr_warning("Failed to make a group name.\n");
+			return ret;
+		}
+	}
+
 	/* Convert perf_probe_event with debuginfo */
 	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
 	if (ret != 0)
 		return ret;	/* Found in debuginfo or got an error */
 
+	if (pev->uprobes) {
+		ret = convert_name_to_addr(pev, target);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* Allocate trace event buffer */
 	tev = *tevs = zalloc(sizeof(struct probe_trace_event));
 	if (tev == NULL)
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
