Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022AbaKJFAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:00:45 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:38936 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaKJFAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:00:43 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: "Liang\, Kan" <kan.liang@intel.com>
Cc: "acme\@kernel.org" <acme@kernel.org>,
        "jolsa\@kernel.org" <jolsa@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi\@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH 1/1] perf tools: perf diff for different binaries
References: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
	<87tx2f5xpo.fsf@sejong.aot.lge.com>
	<37D7C6CF3E00A74B8858931C1DB2F07701653813@SHSMSX103.ccr.corp.intel.com>
	<87d292w41p.fsf@sejong.aot.lge.com>
	<37D7C6CF3E00A74B8858931C1DB2F07701654561@SHSMSX103.ccr.corp.intel.com>
	<CAM9d7cj2T4SrwsvZvCmZRh9xLBFvgeaUVqFtkUjakAD-WdL-JQ@mail.gmail.com>
	<37D7C6CF3E00A74B8858931C1DB2F077016549DB@SHSMSX103.ccr.corp.intel.com>
Date: Mon, 10 Nov 2014 14:00:41 +0900
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077016549DB@SHSMSX103.ccr.corp.intel.com>
	(Kan Liang's message of "Thu, 6 Nov 2014 14:16:23 +0000")
Message-ID: <87vbmnvedi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kan,

On Thu, 6 Nov 2014 14:16:23 +0000, Kan Liang wrote:
> The diff code doesn’t define event_op mmap2, so it fails to get the symbol.

Looks like a bug in perf diff code.  (It's too easy to miss... :-/ )


> You are right, it’s ip address. The meaning of symbol for diff and report should
> be same.

Agreed.


>
> But I still think the author intends to compare the ip address. Low granularity is
> still useful for debugging the scaling issue. So we'd better keep both of them,
> and give ip address sorting a proper key name. 
>
> "ip" means "IP address executed at the time of sample "
> "symbol" means "name of function executed at the time of sample"

I think the term 'IP address' is confusing since users might expect
network address.


>
> What about the attached patch?
>
> Thanks,
> Kan
>
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 25114c9..3063fbd 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -357,6 +357,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
>  static struct perf_tool tool = {
>         .sample = diff__process_sample_event,
>         .mmap   = perf_event__process_mmap,
> +       .mmap2  = perf_event__process_mmap2,
>         .comm   = perf_event__process_comm,
>         .exit   = perf_event__process_exit,
>         .fork   = perf_event__process_fork,

Please send it as a separate fix.


> @@ -743,7 +744,7 @@ static const struct option options[] = {
>         OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
>                    "only consider these symbols"),
>         OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
> -                  "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
> +                  "sort by key(s): pid, comm, dso, symbol, ip, parent, cpu, srcline, ..."

With this, you also need to update the documentation.


>                    " Please refer the man page for the complete list."),
>         OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
>                    "separator for columns, no spaces will be added between "
> @@ -1164,6 +1165,9 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
>         if (setup_sorting() < 0)
>                 usage_with_options(diff_usage, options);
>
> +       if (sort__has_ip)
> +               tool.mmap2 = NULL;
> +

I don't think this is the right thing to do.  And I guess you need to
identify symbols anyway.


>         setup_pager();
>
>         sort__setup_elide(NULL);
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 9402885..a59f389 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -20,6 +20,7 @@ int           have_ignore_callees = 0;
>  int            sort__need_collapse = 0;
>  int            sort__has_parent = 0;
>  int            sort__has_sym = 0;
> +int            sort__has_ip = 0;

Why is this needed?


>  int            sort__has_dso = 0;
>  enum sort_mode sort__mode = SORT_MODE__NORMAL;
>
> @@ -272,9 +273,32 @@ static int hist_entry__sym_snprintf(struct hist_entry *he, char *bf,
>                                          he->level, bf, size, width);
>  }
>
> +static int64_t
> +sort__sym_name_cmp(struct hist_entry *left, struct hist_entry *right)
> +{
> +       const char *sym_name_l, *sym_name_r;
> +
> +       if (!left->ms.sym || !right->ms.sym)
> +               return cmp_null(right->ms.sym, left->ms.sym);
> +
> +       sym_name_l = left->ms.sym->name;
> +       sym_name_r = right->ms.sym->name;
> +
> +       return strcmp(sym_name_l, sym_name_r);
> +}

Looks like doing same thing as sort__sym_sort().


> +
>  struct sort_entry sort_sym = {
>         .se_header      = "Symbol",
>         .se_cmp         = sort__sym_cmp,
> +       .se_collapse    = sort__sym_name_cmp,

This will change the behavior of perf report somewhat.


> +       .se_sort        = sort__sym_sort,
> +       .se_snprintf    = hist_entry__sym_snprintf,
> +       .se_width_idx   = HISTC_SYMBOL,
> +};
> +
> +struct sort_entry sort_ip = {
> +       .se_header      = "IP address",
> +       .se_cmp         = sort__sym_cmp,

I think what you need is "symbol+offset" comparison so the .se_cmp
should compare hist_entry->ip (ie. mapped addr) instead of sym->start.

But I'm still not sure how it's meaningful since a bit of change will
result in changing offsets so that it cannot find a match.

Thanks,
Namhyung


>         .se_sort        = sort__sym_sort,
>         .se_snprintf    = hist_entry__sym_snprintf,
>         .se_width_idx   = HISTC_SYMBOL,
> @@ -1170,6 +1194,7 @@ static struct sort_dimension common_sort_dimensions[] = {
>         DIM(SORT_COMM, "comm", sort_comm),
>         DIM(SORT_DSO, "dso", sort_dso),
>         DIM(SORT_SYM, "symbol", sort_sym),
> +       DIM(SORT_IP, "ip", sort_ip),
>         DIM(SORT_PARENT, "parent", sort_parent),
>         DIM(SORT_CPU, "cpu", sort_cpu),
>         DIM(SORT_SRCLINE, "srcline", sort_srcline),
> @@ -1430,6 +1455,8 @@ int sort_dimension__add(const char *tok)
>                         sort__has_parent = 1;
>                 } else if (sd->entry == &sort_sym) {
>                         sort__has_sym = 1;
> +               } else if (sd->entry == &sort_ip) {
> +                       sort__has_ip = 1;
>                 } else if (sd->entry == &sort_dso) {
>                         sort__has_dso = 1;
>                 }
> @@ -1809,6 +1836,7 @@ void reset_output_field(void)
>         sort__need_collapse = 0;
>         sort__has_parent = 0;
>         sort__has_sym = 0;
> +       sort__has_ip = 0;
>         sort__has_dso = 0;
>
>         field_order = NULL;
> diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
> index c03e4ff..f00900a 100644
> --- a/tools/perf/util/sort.h
> +++ b/tools/perf/util/sort.h
> @@ -34,10 +34,12 @@ extern int have_ignore_callees;
>  extern int sort__need_collapse;
>  extern int sort__has_parent;
>  extern int sort__has_sym;
> +extern int sort__has_ip;
>  extern enum sort_mode sort__mode;
>  extern struct sort_entry sort_comm;
>  extern struct sort_entry sort_dso;
>  extern struct sort_entry sort_sym;
> +extern struct sort_entry sort_ip;
>  extern struct sort_entry sort_parent;
>  extern struct sort_entry sort_dso_from;
>  extern struct sort_entry sort_dso_to;
> @@ -161,6 +163,7 @@ enum sort_type {
>         SORT_COMM,
>         SORT_DSO,
>         SORT_SYM,
> +       SORT_IP,
>         SORT_PARENT,
>         SORT_CPU,
>         SORT_SRCLINE,
