Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3LQNia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:38:30 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:39492 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab3LQNi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:38:28 -0500
Date: Tue, 17 Dec 2013 10:38:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com
Subject: Re: [PATCH 5/5 v2] perf timechart: add emphasize option
Message-ID: <20131217133821.GA6517@ghostprotocols.net>
References: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
 <20131216193800.GA19283@ghostprotocols.net>
 <20131217093855.GA3345@stfomichev-desktop>
 <20131217112303.GB27791@gmail.com>
 <20131217121522.GA6357@stfomichev-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217121522.GA6357@stfomichev-desktop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 17, 2013 at 04:15:22PM +0400, Stanislav Fomichev escreveu:
> > Please give a sample usage command line and a sample output. (the 
> > highlighting can be done using ASCII escape sequences in the changelog 
> > as well.)
> Highlighting is done in the generated SVG, so I can't really show it in
> the log or documentation. But I added simple example with -e option.
> 
> >   -e::
> >   --emphasize=<duration_nsecs|task_name>::
> Thanks, added.

I also wonder how to allocate single letter options here... can we live
with just --emphasize for now? Wouldn't at some point we maybe want to
use -e in 'perf timechart' to pick some specific event, and then, to
make it consistent with the other tools, -e would then be used?

- Arnaldo
 
> > It's also not made clear that the option can take a numeric input, and 
> > if the input is numeric, it is interpreted as a task name.
> > 
> > So please make features more approachable!
> Added more info to the documentation.
> 
> Attached new patch below.
> 
> ---
> 
> This option highlights tasks (using different color) that run more than given
> duration or tasks with given name.
> 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/Documentation/perf-timechart.txt | 14 ++++++++++++++
>  tools/perf/builtin-timechart.c              | 21 ++++++++++++++++++++-
>  tools/perf/util/svghelper.c                 | 23 ++++++++++++++++++++---
>  tools/perf/util/svghelper.h                 |  4 +++-
>  4 files changed, 57 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
> index 367c1be0551c..b81e91dd16ce 100644
> --- a/tools/perf/Documentation/perf-timechart.txt
> +++ b/tools/perf/Documentation/perf-timechart.txt
> @@ -56,12 +56,26 @@ $ perf timechart
>  
>    Written 10.2 seconds of trace to output.svg.
>  
> +Record system-wide timechart:
> +
> +  $ perf timechart record
> +
> +  then generate timechart and highlight 'gcc' tasks:
> +
> +  $ perf timechart -e gcc
> +
>  -n::
>  --proc-num::
>          Print task info for at least given number of tasks.
>  -t::
>  --topology::
>          Sort CPUs according to topology.
> +-e::
> +--emphasize=<duration_nsecs|task_name>::
> +	Highlight tasks (using different color) that run more than given
> +	duration or tasks with given name. If number is given it's interpreted
> +	as number of nanoseconds. If non-numeric string is given it's
> +	interpreted as task name.
>  
>  RECORD OPTIONS
>  --------------
> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> index 8bde57c5c908..c0dcb05909b2 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -841,7 +841,6 @@ static void draw_cpu_usage(struct timechart *tchart)
>  						    sample->start_time,
>  						    sample->end_time,
>  						    p->pid,
> -						    "sample",
>  						    c->comm,
>  						    sample->backtrace);
>  				}
> @@ -1252,6 +1251,23 @@ parse_process(const struct option *opt __maybe_unused, const char *arg,
>  	return 0;
>  }
>  
> +static int
> +parse_emphasize(const struct option *opt __maybe_unused, const char *arg,
> +		int __maybe_unused unset)
> +{
> +	unsigned long duration = strtoul(arg, NULL, 0);
> +
> +	if (svg_emphasize || svg_emphasize_name)
> +		return -1;
> +
> +	if (duration)
> +		svg_emphasize = duration;
> +	else
> +		svg_emphasize_name = strdup(arg);
> +
> +	return 0;
> +}
> +
>  int cmd_timechart(int argc, const char **argv,
>  		  const char *prefix __maybe_unused)
>  {
> @@ -1270,6 +1286,9 @@ int cmd_timechart(int argc, const char **argv,
>  	OPT_STRING('i', "input", &input_name, "file", "input file name"),
>  	OPT_STRING('o', "output", &output_name, "file", "output file name"),
>  	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
> +	OPT_CALLBACK('e', "emphasize", NULL, "duration or name",
> +		      "emphasize tasks. Pass duration in ns or process name.",
> +		       parse_emphasize),
>  	OPT_BOOLEAN('P', "power-only", &tchart.power_only, "output power data only"),
>  	OPT_BOOLEAN('T', "tasks-only", &tchart.tasks_only,
>  		    "output processes data only"),
> diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
> index 9468136735ca..f056a7450e5f 100644
> --- a/tools/perf/util/svghelper.c
> +++ b/tools/perf/util/svghelper.c
> @@ -31,6 +31,8 @@ static u64 turbo_frequency, max_freq;
>  #define SLOT_HEIGHT 25.0
>  
>  int svg_page_width = 1000;
> +u64 svg_emphasize;
> +const char *svg_emphasize_name;
>  
>  #define MIN_TEXT_SIZE 0.01
>  
> @@ -112,6 +114,7 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
>  	fprintf(svgfile, "      rect.process  { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:1;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
> +	fprintf(svgfile, "      rect.sample_em{ fill:rgb(255,128,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.waiting  { fill:rgb(224,214,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.WAITING  { fill:rgb(255,214, 48); fill-opacity:0.6; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
> @@ -155,17 +158,24 @@ void svg_blocked(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
>  void svg_running(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
>  {
>  	double text_size;
> +	const char *type;
> +
>  	if (!svgfile)
>  		return;
>  
> +	if (svg_emphasize && end - start > svg_emphasize)
> +		type = "sample_em";
> +	else
> +		type = "sample";
>  	fprintf(svgfile, "<g>\n");
>  
>  	fprintf(svgfile, "<title>#%d running %s</title>\n",
>  		cpu, time_to_string(end - start));
>  	if (backtrace)
>  		fprintf(svgfile, "<desc>Switched because:\n%s</desc>\n", backtrace);
> -	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"sample\"/>\n",
> -		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT);
> +	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
> +		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT,
> +		type);
>  
>  	text_size = (time2pixels(end)-time2pixels(start));
>  	if (cpu > 9)
> @@ -293,13 +303,20 @@ void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
>  	fprintf(svgfile, "</g>\n");
>  }
>  
> -void svg_process(int cpu, u64 start, u64 end, int pid, const char *type, const char *name, const char *backtrace)
> +void svg_process(int cpu, u64 start, u64 end, int pid, const char *name, const char *backtrace)
>  {
>  	double width;
> +	const char *type;
>  
>  	if (!svgfile)
>  		return;
>  
> +	if (svg_emphasize && end - start >= svg_emphasize)
> +		type = "sample_em";
> +	else if (svg_emphasize_name && strstr(name, svg_emphasize_name))
> +		type = "sample_em";
> +	else
> +		type = "sample";
>  
>  	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), cpu2y(cpu));
>  	fprintf(svgfile, "<title>%d %s running %s</title>\n", pid, name, time_to_string(end - start));
> diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
> index 1df4fb6c3a4a..10b4187bff6a 100644
> --- a/tools/perf/util/svghelper.h
> +++ b/tools/perf/util/svghelper.h
> @@ -11,7 +11,7 @@ extern void svg_waiting(int Yslot, int cpu, u64 start, u64 end, const char *back
>  extern void svg_cpu_box(int cpu, u64 max_frequency, u64 turbo_frequency);
>  
>  
> -extern void svg_process(int cpu, u64 start, u64 end, int pid, const char *type, const char *name, const char *backtrace);
> +extern void svg_process(int cpu, u64 start, u64 end, int pid, const char *name, const char *backtrace);
>  extern void svg_cstate(int cpu, u64 start, u64 end, int type);
>  extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
>  
> @@ -27,5 +27,7 @@ extern int svg_build_topology_map(char *sib_core, int sib_core_nr,
>  				  char *sib_thr, int sib_thr_nr);
>  
>  extern int svg_page_width;
> +extern u64 svg_emphasize;
> +extern const char *svg_emphasize_name;
>  
>  #endif /* __PERF_SVGHELPER_H */
> -- 
> 1.8.3.2
> 
