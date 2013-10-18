Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3JROoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:44:54 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:46593 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3JROow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:44:52 -0400
Subject: [PATCH v3 2/3] Support for perf to probe into SDT markers:
To: linux-kernel@vger.kernel.org
From: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com
Date: Fri, 18 Oct 2013 20:14:45 +0530
Message-ID: <20131018144406.10452.43317.stgit@hemant-fedora>
In-Reply-To: <20131018143714.10452.83494.stgit@hemant-fedora>
References: <20131018143714.10452.83494.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101814-5816-0000-0000-00000A6FA761
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows perf to probe into the sdt markers/notes present in
the libraries and executables. We try to find the associated location
and handle prelinking (since, stapsdt notes section is not allocated
during runtime). Prelinking is handled with the help of base
section which is allocated during runtime. This address can be compared
with the address retrieved from the notes' description. If its different,
we can take this difference and then add to the note's location.

We can use existing '-a/--add' option to add events for sdt markers.
Also, we can add multiple events at once using the same '-a' option.

Usage:
perf probe -x /lib64/libc.so.6 -a 'my_event=%libc:setjmp'

Output:
Added new event:
  libc:my_event        (on 0x35981)

You can now use it in all perf tools, such as:

    perf record -e libc:my_event -aR sleep 1


Signed-off-by: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
---
 tools/perf/builtin-probe.c    |    4 ++
 tools/perf/util/probe-event.c |   99 +++++++++++++++++++++++++++++++++++++----
 tools/perf/util/probe-event.h |    2 +
 tools/perf/util/symbol-elf.c  |   80 +++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h      |    3 +
 5 files changed, 178 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 2450613..8f0dd48 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -494,6 +494,10 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	if (params.nevents) {
+		if (params.events->sdt && !params.target && !params.exec) {
+			pr_err("SDT markers can be probed only with --exec.\n");
+			usage_with_options(probe_usage, options);
+		}
 		ret = add_perf_probe_events(params.events, params.nevents,
 					    params.max_probe_points,
 					    params.target,
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c228fe6..06665a8 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -816,6 +816,40 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 		pev->group = NULL;
 		arg = tmp;
 	}
+	/* Check for SDT marker */
+	if (*arg == '%') {
+		ptr = strchr(++arg, ':');
+		if (!ptr) {
+			semantic_error("Provider name must follow an event "
+				       "name\n");
+			return -EINVAL;
+		}
+		*ptr++ = '\0';
+		tmp = strdup(arg);
+		if (!tmp)
+			return -ENOMEM;
+
+		pev->point.note = (struct sdt_note *)
+			zalloc(sizeof(struct sdt_note));
+		if (!pev->point.note) {
+			free(tmp);
+			return -ENOMEM;
+		}
+		pev->point.note->provider = tmp;
+
+		tmp = strdup(ptr);
+		if (!tmp) {
+			free(pev->point.note->provider);
+			free(pev->point.note);
+			return -ENOMEM;
+		}
+		pev->point.note->name = tmp;
+		pev->group = pev->point.note->provider;
+		if (!pev->event)
+			pev->event = pev->point.note->name;
+		pev->sdt = true;
+		return 0;
+	}
 
 	ptr = strpbrk(arg, ";:+@%");
 	if (ptr) {
@@ -1238,6 +1272,7 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 	char *buf, *tmp;
 	char offs[32] = "", line[32] = "", file[32] = "";
 	int ret, len;
+	unsigned long long addr;
 
 	buf = zalloc(MAX_CMDLEN);
 	if (buf == NULL) {
@@ -1266,12 +1301,17 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 			goto error;
 	}
 
-	if (pp->function)
+	if (pp->function) {
 		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s%s%s%s", pp->function,
 				 offs, pp->retprobe ? "%return" : "", line,
 				 file);
-	else
+	} else if (pp->note) {
+		addr = pp->note->bit32 ? pp->note->addr.a32[0] :
+			pp->note->addr.a64[0];
+		ret = e_snprintf(buf, MAX_CMDLEN, "0x%llx", addr);
+	} else {
 		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s", file, line);
+	}
 	if (ret <= 0)
 		goto error;
 
@@ -1921,6 +1961,21 @@ static void cleanup_sdt_note_list(struct list_head *sdt_notes)
 	}
 }
 
+static int try_to_find_sdt_notes(struct perf_probe_event *pev,
+				 const char *target)
+{
+	int ret;
+	LIST_HEAD(sdt_notes);
+
+	ret = search_sdt_note(pev->point.note, &sdt_notes, target);
+	if (!list_empty(&sdt_notes))
+		cleanup_sdt_note_list(&sdt_notes);
+	/* Abssence of SDT markers is an error in this case */
+	else if (list_empty(&sdt_notes) && !ret)
+		ret = -ENOENT;
+	return ret;
+}
+
 static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 					  struct probe_trace_event **tevs,
 					  int max_tevs, const char *target)
@@ -1928,11 +1983,23 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 	struct symbol *sym;
 	int ret = 0, i;
 	struct probe_trace_event *tev;
+	char *buf;
+	unsigned long long addr;
 
-	/* Convert perf_probe_event with debuginfo */
-	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, target);
-	if (ret != 0)
-		return ret;	/* Found in debuginfo or got an error */
+	if (pev->sdt) {
+		ret = -EBADF;
+		if (pev->uprobes)
+			ret = try_to_find_sdt_notes(pev, target);
+		if (ret)
+			return ret;
+	} else {
+		/* Convert perf_probe_event with debuginfo */
+		ret = try_to_find_probe_trace_events(pev, tevs, max_tevs,
+						     target);
+		/* Found in debuginfo or got an error */
+		if (ret != 0)
+			return ret;
+	}
 
 	/* Allocate trace event buffer */
 	tev = *tevs = zalloc(sizeof(struct probe_trace_event));
@@ -1940,10 +2007,22 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		return -ENOMEM;
 
 	/* Copy parameters */
-	tev->point.symbol = strdup(pev->point.function);
-	if (tev->point.symbol == NULL) {
-		ret = -ENOMEM;
-		goto error;
+	if (pev->sdt) {
+		buf = (char *)zalloc(sizeof(char) * MAX_CMDLEN);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto error;
+		}
+		addr = pev->point.note->bit32 ? pev->point.note->addr.a32[0] :
+			pev->point.note->addr.a64[0];
+		sprintf(buf, "0x%llx", addr);
+		tev->point.symbol = buf;
+	} else {
+		tev->point.symbol = strdup(pev->point.function);
+		if (tev->point.symbol == NULL) {
+			ret = -ENOMEM;
+			goto error;
+		}
 	}
 
 	if (target) {
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 32de5a3..beb1b4a 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -47,6 +47,7 @@ struct perf_probe_point {
 	bool		retprobe;	/* Return probe flag */
 	char		*lazy_line;	/* Lazy matching pattern */
 	unsigned long	offset;		/* Offset from function entry */
+	struct sdt_note *note;
 };
 
 /* Perf probe probing argument field chain */
@@ -72,6 +73,7 @@ struct perf_probe_event {
 	struct perf_probe_point	point;	/* Probe point */
 	int			nargs;	/* Number of arguments */
 	bool			uprobes;
+	bool                    sdt;
 	struct perf_probe_arg	*args;	/* Arguments */
 };
 
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 828ecad..73b368c 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1824,6 +1824,86 @@ out_close:
 	return sdt_err(ret, target);
 }
 
+static void adjust_note_addr(struct sdt_note *tmp, struct sdt_note *key,
+			     Elf *elf)
+{
+	GElf_Ehdr ehdr;
+	GElf_Addr base_off = 0;
+	GElf_Shdr shdr;
+
+	if (!gelf_getehdr(elf, &ehdr)) {
+		pr_debug("%s : cannot get elf header.\n", __func__);
+		return;
+	}
+
+	/*
+	 * Find out the .stapsdt.base section.
+	 * This scn will help us to handle prelinking (if present).
+	 * Compare the retrieved file offset of the base section with the
+	 * base address in the description of the SDT note. If its different,
+	 * then accordingly, adjust the note location.
+	 */
+	if (elf_section_by_name(elf, &ehdr, &shdr, SDT_BASE_SCN, NULL))
+		base_off = shdr.sh_offset;
+	if (base_off) {
+		if (tmp->bit32)
+			key->addr.a32[0] = tmp->addr.a32[0] + base_off -
+				tmp->addr.a32[1];
+		else
+			key->addr.a64[0] = tmp->addr.a64[0] + base_off -
+				tmp->addr.a64[1];
+	}
+	key->bit32 = tmp->bit32;
+}
+
+int search_sdt_note(struct sdt_note *key, struct list_head *sdt_notes,
+		    const char *target)
+{
+	Elf *elf;
+	int fd, ret;
+	bool found = false;
+	struct sdt_note *pos = NULL;
+
+	fd = open(target, O_RDONLY);
+	if (fd < 0) {
+		pr_err("%s : %s\n", target, strerror(errno));
+		return -errno;
+	}
+
+	symbol__elf_init();
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (!elf) {
+		ret = -EBADF;
+		pr_debug("Can't read the elf of %s\n", target);
+		goto out_close;
+	}
+
+	ret = construct_sdt_notes_list(elf, sdt_notes);
+	if (ret)
+		goto out_end;
+
+	/* Iterate through the notes and retrieve the required note */
+	list_for_each_entry(pos, sdt_notes, note_list) {
+		if (!strcmp(key->name, pos->name) &&
+		    !strcmp(key->provider, pos->provider)) {
+			adjust_note_addr(pos, key, elf);
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		printf("%%%s:%s not found in %s!\n", key->provider, key->name,
+		       target);
+		return -ENOENT;
+	}
+
+out_end:
+	elf_end(elf);
+out_close:
+	close(fd);
+	return sdt_err(ret, target);
+}
+
 void symbol__elf_init(void)
 {
 	elf_version(EV_CURRENT);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b78397b..52b04e2 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -286,9 +286,12 @@ int compare_proc_modules(const char *from, const char *to);
 
 /* Specific to SDT notes */
 int get_sdt_note_list(struct list_head *head, const char *target);
+int search_sdt_note(struct sdt_note *key, struct list_head *head,
+		    const char *target);
 
 #define SDT_NOTE_TYPE 3
 #define SDT_NOTE_SCN ".note.stapsdt"
 #define SDT_NOTE_NAME "stapsdt"
+#define SDT_BASE_SCN ".stapsdt.base"
 
 #endif /* __PERF_SYMBOL */

