Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3CDDNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:13:05 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55092 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab3CDDNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:13:04 -0500
X-AuditID: 9c93016f-b7c56ae00000569b-64-5134113b16d9
From: Namhyung Kim <namhyung@kernel.org>
To: Roberto Vitillo <ravitillo@lbl.gov>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net, rostedt@goodmis.org
Subject: Re: [PATCH] perf: add callgrind conversion tool
References: <CA+BNSkX-2NhJmf0b26Bmf-bK_dFnGE_NOR-F9p2MDpZTuScHpg@mail.gmail.com>
Date: Mon, 04 Mar 2013 12:12:59 +0900
In-Reply-To: <CA+BNSkX-2NhJmf0b26Bmf-bK_dFnGE_NOR-F9p2MDpZTuScHpg@mail.gmail.com>
	(Roberto Vitillo's message of "Wed, 27 Feb 2013 00:26:33 +0100")
Message-ID: <878v63svr8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roberto,

On Wed, 27 Feb 2013 00:26:33 +0100, Roberto Vitillo wrote:
> The proposed patch adds the convert tool to perf which allows to convert a
> perf.data file to a callgrind data file which can subsequently be displayed
> with kcachegrind. Callgraphs are not supported.

I was thinking about a similar tool but a little bit more generic way -
it might support more formats (ctf, pprof, trace-cmd?) in both direction
(convert from/to) - without considering its feasibility ;-)

Anyway, nice work!

>
> In order to speed up the converter I am not piping to addr2line, this
> means that
> the code depends on libbfd. Considering that perf doesn't strictly depend on
> libbfd my question is if it would be feasible to add that requirement.
>
> Note that the code may trigger the following bug in libbfd:
> http://sourceware.org/bugzilla/show_bug.cgi?id=15106

Oh, I have to admit first that I don't know about the callgrind, bfd and
binutils.  Please feel free to ignore me if I go to wrong direction.

>
> Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
> ---
[SNIP]
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index a2108ca..55c35d5 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -399,6 +399,8 @@ LIB_H += util/intlist.h
>  LIB_H += util/perf_regs.h
>  LIB_H += util/unwind.h
>  LIB_H += util/vdso.h
> +LIB_H += util/cgcnv.h
> +LIB_H += util/a2l.h
>  LIB_H += ui/helpline.h
>  LIB_H += ui/progress.h
>  LIB_H += ui/util.h
> @@ -472,6 +474,8 @@ LIB_OBJS += $(OUTPUT)util/rblist.o
>  LIB_OBJS += $(OUTPUT)util/intlist.o
>  LIB_OBJS += $(OUTPUT)util/vdso.o
>  LIB_OBJS += $(OUTPUT)util/stat.o
> +LIB_OBJS += $(OUTPUT)util/cgcnv.o
> +LIB_OBJS += $(OUTPUT)util/a2l.o
>
>  LIB_OBJS += $(OUTPUT)ui/setup.o
>  LIB_OBJS += $(OUTPUT)ui/helpline.o
> @@ -528,6 +532,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
> +BUILTIN_OBJS += $(OUTPUT)builtin-convert.o

You can make these conditional after checking availibility of bfd.


>  BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
>
>  PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
> @@ -793,39 +798,35 @@ endif
>
>  ifdef NO_DEMANGLE
>  	BASIC_CFLAGS += -DNO_DEMANGLE
> -else
> -        ifdef HAVE_CPLUS_DEMANGLE
> +endif
> +
> +FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd -ldl

Shouldn't it be "perf" rather than 'perf'?  I know it doesn't matter
much but looks wierd to me.  Please see below:

  https://lkml.org/lkml/2012/9/25/453


> +has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
> +ifeq ($(has_bfd),y)
> +	EXTLIBS += -lbfd -ldl
> +
> +	ifdef HAVE_CPLUS_DEMANGLE
>  		EXTLIBS += -liberty
> -		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
> -        else
> -		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
> -		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
> -		ifeq ($(has_bfd),y)
> -			EXTLIBS += -lbfd
> +	endif
> +else
> +	FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
> +	has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY))
> +
> +	ifeq ($(has_bfd_iberty),y)
> +		EXTLIBS += -lbfd -ldl -liberty
> +	else
> +		FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
> +		has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z))
> +		ifeq ($(has_bfd_iberty_z),y)
> +			EXTLIBS += -lbfd -ldl -liberty -lz
>  		else
> -			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
> -			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
> -			ifeq ($(has_bfd_iberty),y)
> -				EXTLIBS += -lbfd -liberty
> -			else
> -				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
> -				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
> -				ifeq ($(has_bfd_iberty_z),y)
> -					EXTLIBS += -lbfd -liberty -lz
> -				else
> -					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
> -					has_cplus_demangle := $(call
> try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
> -					ifeq ($(has_cplus_demangle),y)
> -						EXTLIBS += -liberty
> -						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
> -					else
> -						msg := $(warning No bfd.h/libbfd found, install
> binutils-dev[el]/zlib-static to gain symbol demangling)
> -						BASIC_CFLAGS += -DNO_DEMANGLE
> -					endif
> -				endif
> -			endif
> +			msg := $(error No bfd.h/libbfd found, install binutils-dev[el]/zlib-static)

It should be a warning and proceed with disabling 'convert' tool.


>  		endif
>  	endif
> +
> +	ifndef NO_DEMANGLE
> +		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
> +	endif
>  endif
>
>  ifeq ($(NO_PERF_REGS),0)
> diff --git a/tools/perf/builtin-convert.c b/tools/perf/builtin-convert.c
> new file mode 100644
> index 0000000..9311b3a
> --- /dev/null
> +++ b/tools/perf/builtin-convert.c
> @@ -0,0 +1,217 @@
> +/*
> + * builtin-convert.c
> + *
> + * Builtin convert command: Convert a perf.data input file
> + * to a callgrind profile data file.
> + */
[SNIP]
> +static int process_sample_event(struct perf_tool *tool,
> +				union perf_event *event,
> +				struct perf_sample *sample,
> +				struct perf_evsel *evsel,
> +				struct machine *machine)
> +{
> +	struct perf_convert *cnv = container_of(tool, struct perf_convert, tool);
> +	struct addr_location al;
> +
> +	if (perf_event__preprocess_sample(event, machine, &al, sample,
> +					  symbol__annotate_init) < 0) {
> +		pr_warning("problem processing %d event, skipping it.\n",
> +			   event->header.type);
> +		return -1;
> +	}
> +
> +	if (cnv->cpu_list && !test_bit(sample->cpu, cnv->cpu_bitmap))
> +		return 0;
> +
> +	if (!al.filtered && cg_cnv_sample(evsel, sample, &al)) {

AFAICS this cg_cnv_sample() does nothing with converting.  Why did you
move the code to a different file rather than keeping it together?


> +		pr_warning("problem incrementing symbol count, skipping event\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void hists__find_annotations(struct hists *self, int evidx,
> +				    struct perf_convert *cnv)

The name of the function doesn't look good to me.  Maybe hists__convert_symbols?


> +{
> +	struct rb_node *nd = rb_first(&self->entries);
> +	int key = K_RIGHT;

For the purpose of this tool, I guess using input/collapsed tree (i.e. 
->entries_in or ->entries_collpased) instead of output tree (->entries)
is more appropriate since it'll collect related dsos and symbols together.


> +
> +	while (nd) {
> +		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
> +		struct annotation *notes;
> +
> +		if (he->ms.sym == NULL || he->ms.map->dso->annotate_warned) {
> +			cg_cnv_unresolved(cnv->output_file, evidx, he);
> +			goto find_next;
> +		}
> +
> +		notes = symbol__annotation(he->ms.sym);
> +
> +		if (notes->src == NULL) {
> +find_next:
> +			if (key == K_LEFT)
> +				nd = rb_prev(nd);
> +			else
> +				nd = rb_next(nd);
> +			continue;
> +		}
> +
> +		cg_cnv_symbol(cnv->output_file, he->ms.sym, he->ms.map);
> +
> +		free(notes->src);
> +		notes->src = NULL;
> +	}
> +}

The traversal of the hist_entry looks strange.  How about this?

	while (nd) {
		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
		struct annotation *notes;

		nd = rb_next(nd);

		if (he->ms.sym == NULL || he->ms.map->dso->annotate_warned) {
			cg_cnv_unresolved(cnv->output_file, evidx, he);
			continue;
		}

		notes = symbol__annotation(he->ms.sym);
		if (notes->src == NULL)
			continue;

		cg_cnv_symbol(cnv->output_file, he->ms.sym, he->ms.map);

		free(notes->src);
		notes->src = NULL;
	}


[SNIP]
> diff --git a/tools/perf/util/a2l.c b/tools/perf/util/a2l.c
> new file mode 100644
> index 0000000..82f1023
> --- /dev/null
> +++ b/tools/perf/util/a2l.c
> @@ -0,0 +1,136 @@
> +/* Based on addr2line. */
> +
> +#include "a2l.h"
> +
> +#define PACKAGE 'perf'

Please see my comment above.

> +
> +#include <bfd.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +
> +#include <linux/kernel.h>
> +
> +static const char *filename;
> +static const char *functionname;
> +static unsigned int line;
> +static asymbol **syms;
> +static bfd_vma pc;
> +static bfd_boolean found;
> +static bfd *abfd;
[SNIP]
> +static void find_address_in_section(bfd *self, asection *section,
> +				    void *data ATTRIBUTE_UNUSED)
> +{
> +	bfd_vma vma;
> +	bfd_size_type size;
> +
> +	if (found)
> +		return;
> +
> +	if ((bfd_get_section_flags(abfd, section) & SEC_ALLOC) == 0)
> +		return;

In this function, abfd == self, right?  If so, please keep using just
one of them for consistency.

> +
> +	vma = bfd_get_section_vma(abfd, section);

Ditto.

> +	if (pc < vma)
> +		return;
> +
> +	size = bfd_get_section_size(section);
> +	if (pc >= vma + size)
> +		return;
> +
> +	found = bfd_find_nearest_line(self, section, syms, pc - vma,

Ditto.

> +			&filename, &functionname, &line);
> +}
> +
> +int addr2line_init(const char *file_name)
> +{
> +	abfd = bfd_openr(file_name, NULL);
> +	if (abfd == NULL)
> +		return -1;
> +
> +	if (!bfd_check_format(abfd, bfd_object))
> +		return bfd_fatal(bfd_get_filename(abfd));
> +
> +	return slurp_symtab();
> +
> +}
> +
> +void addr2line_cleanup(void)
> +{
> +	if (syms != NULL) {
> +		free(syms);
> +		syms = NULL;
> +	}
> +
> +	bfd_close(abfd);
> +	line = found = 0;
> +}
> +
> +int addr2line_inline(const char **file, unsigned *line_nr)
> +{
> +
> +	found = bfd_find_inliner_info(abfd, &filename, &functionname, &line);
> +	*file = filename;
> +	*line_nr = line;

Why not using 'file' and 'line_nr' directly?

> +
> +	return found;
> +}
> +
> +int addr2line(unsigned long addr, const char **file, unsigned *line_nr)
> +{
> +	found = 0;
> +	pc = addr;
> +	bfd_map_over_sections(abfd, find_address_in_section, NULL);
> +
> +	*file = filename;
> +	*line_nr = line;
> +
> +	return found;
> +}
[SNIP]
> diff --git a/tools/perf/util/cgcnv.c b/tools/perf/util/cgcnv.c
> new file mode 100644
> index 0000000..02fcfa5
> --- /dev/null
> +++ b/tools/perf/util/cgcnv.c
> @@ -0,0 +1,188 @@
> +#include "cgcnv.h"
> +#include "a2l.h"
> +#include "parse-events.h"
> +#include "symbol.h"
> +#include "map.h"
> +#include "util.h"
> +#include "annotate.h"
> +
> +#include <linux/list.h>
> +#include <linux/rbtree.h>
> +
> +static const char *last_source_name;
> +static unsigned last_line;
> +static u64 last_off;
> +
> +int cg_cnv_header(FILE *output, struct perf_session *session)
> +{
> +	struct perf_evsel *pos;
> +
> +	fprintf(output, "positions: instr line\nevents:");
> +	list_for_each_entry(pos, &session->evlist->entries, node) {
> +		const char *evname = NULL;
> +		struct hists *hists = &pos->hists;
> +		u32 nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
> +
> +		if (nr_samples > 0) {
> +			evname = perf_evsel__name(pos);
> +			fprintf(output, " %s", evname);
> +		}

This will skip events with no samples, but later codes simply output
all events.


> +	}
> +	fprintf(output, "\n");
> +
> +	return 0;
> +}
> +
> +int cg_cnv_sample(struct perf_evsel *evsel, struct perf_sample *sample,
> +		  struct addr_location *al)
> +{
> +	struct hist_entry *he;
> +	int ret = 0;
> +
> +	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
> +	if (he == NULL)
> +		return -ENOMEM;
> +
> +	ret = 0;
> +	if (he->ms.sym != NULL) {
> +		struct annotation *notes = symbol__annotation(he->ms.sym);
> +		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
> +			return -ENOMEM;
> +
> +		ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
> +	}
> +
> +	evsel->hists.stats.total_period += sample->period;
> +	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
> +	return ret;
> +}
> +
> +static void cg_sym_header_printf(FILE *output, struct symbol *sym,
> +				 struct map *map, struct annotation *notes,
> +				 u64 offset)
> +{
> +	int idx, ret, ret_callee, ret_caller = 0;
> +	u64 address = map__rip_2objdump(map, sym->start) + offset;
> +	unsigned caller_line;
> +	const char *caller_name;
> +
> +	ret_callee = addr2line(address, &last_source_name, &last_line);
> +	while ((ret = addr2line_inline(&caller_name, &caller_line)))
> +		ret_caller = ret;
> +
> +	/* Needed to display correctly the inlining relationship in kcachegrind */
> +	if (ret_caller && caller_line)
> +		fprintf(output, "fl=%s\n0 0\n", caller_name);
> +
> +	if (ret_callee && last_line)
> +		fprintf(output, "fl=%s\n", last_source_name);
> +	else
> +		fprintf(output, "fl=\n");

Could you explain why this empty fl line is needed?

> +
> +	fprintf(output, "%#" PRIx64 " %u", address, last_line);
> +	for (idx = 0; idx < notes->src->nr_histograms; idx++)
> +		fprintf(output, " %" PRIu64,
> +			annotation__histogram(notes, idx)->addr[offset]);
> +
> +	fprintf(output, "\n");
> +	last_off = offset;
> +}
> +
> +static void cg_sym_events_printf(FILE *output, struct symbol *sym,
> +				 struct map *map, struct annotation *notes,
> +				 u64 offset)
> +{
> +	int ret, idx;
> +	unsigned line;
> +	const char *filename;
> +
> +	ret = addr2line(map__rip_2objdump(map, sym->start) + offset,
> +			&filename, &line);
> +	if (filename && last_source_name && strcmp(filename, last_source_name)) {
> +		fprintf(output, "fl=%s\n", filename);
> +		last_source_name = filename;

In this case the 'ret' is always 0?  Otherwise, I'm not sure the 'last_line'
still has valid line number.

Thanks,
Namhyung


> +	}
> +
> +	if (ret)
> +		fprintf(output, "+%" PRIu64 " %+d", offset - last_off,
> +			(int)(line - last_line));
> +	else
> +		fprintf(output, "+%" PRIu64 " %u", offset - last_off, line);
> +
> +	for (idx = 0; idx < notes->src->nr_histograms; idx++) {
> +		u64 cnt = annotation__histogram(notes, idx)->addr[offset];
> +		fprintf(output, " %" PRIu64, cnt);
> +	}
> +
> +	fprintf(output, "\n");
> +	last_off = offset;
> +	last_line = line;
> +}
