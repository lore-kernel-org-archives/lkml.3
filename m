Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbaIZKda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:33:30 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:50270 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbaIZKd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <1411591846-32736-1-git-send-email-andi@firstfloor.org>
References: <1411591846-32736-1-git-send-email-andi@firstfloor.org>
Date: Fri, 26 Sep 2014 12:33:27 +0200
Message-ID: <CABPqkBQRX6Mk5dut0oGPqe8t5D1TxvGrsQE7KWifK9oD9X=YTg@mail.gmail.com>
Subject: Re: [PATCH] perf, tools: Fix perf stat --per-core on multi socket systems
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:50 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> On systems with more than one socket perf stat --per-core
> would either segfault or stop before outputting all cores.
> The problem was that the output code referenced the
> id including the socket number in the higher bits, which
> is far beyond any per cpu array.
>
> Mask out the socket number before referencing cpus
> in abs_printout.
>
> I also renamed the variable in nsec_printout to be clear
> what it is, even though it doesn't reference cpus.
>
> Cc: eranian@google.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

This works for me and is the better approach compared to what
I saw in Matt Flemming's patch: https://lkml.org/lkml/2014/9/24/571

Acked-by: Stephane Eranian <eranian@google.com>

> ---
>  tools/perf/builtin-stat.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 3e80aa1..6e636b9 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -732,7 +732,7 @@ static void aggr_printout(struct perf_evsel *evsel, int id, int nr)
>         }
>  }
>
> -static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
> +static void nsec_printout(int id, int nr, struct perf_evsel *evsel, double avg)
>  {
>         double msecs = avg / 1e6;
>         const char *fmt_v, *fmt_n;
> @@ -741,7 +741,7 @@ static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
>         fmt_v = csv_output ? "%.6f%s" : "%18.6f%s";
>         fmt_n = csv_output ? "%s" : "%-25s";
>
> -       aggr_printout(evsel, cpu, nr);
> +       aggr_printout(evsel, id, nr);
>
>         scnprintf(name, sizeof(name), "%s%s",
>                   perf_evsel__name(evsel), csv_output ? "" : " (msec)");
> @@ -947,11 +947,12 @@ static void print_ll_cache_misses(int cpu,
>         fprintf(output, " of all LL-cache hits   ");
>  }
>
> -static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
> +static void abs_printout(int id, int nr, struct perf_evsel *evsel, double avg)
>  {
>         double total, ratio = 0.0, total2;
>         double sc =  evsel->scale;
>         const char *fmt;
> +       int cpu = cpu_map__id_to_cpu(id);
>
>         if (csv_output) {
>                 fmt = sc != 1.0 ?  "%.2f%s" : "%.0f%s";
> @@ -962,7 +963,7 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
>                         fmt = sc != 1.0 ? "%18.2f%s" : "%18.0f%s";
>         }
>
> -       aggr_printout(evsel, cpu, nr);
> +       aggr_printout(evsel, id, nr);
>
>         if (aggr_mode == AGGR_GLOBAL)
>                 cpu = 0;
> --
> 1.9.3
>
