Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab3CMNTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:19:09 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:47277 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab3CMNTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <1362624201-6161-1-git-send-email-andi@firstfloor.org>
References: <1362624201-6161-1-git-send-email-andi@firstfloor.org>
Date: Wed, 13 Mar 2013 14:19:05 +0100
Message-ID: <CABPqkBT06EVjuy1ew1Z+vrGMf0p+mH19-M71xzTGVyZTtcaLUA@mail.gmail.com>
Subject: Re: [PATCH] perf, tools: Make perf stat -I ... CSV output flat
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 3:43 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> The new perf stat interval code is quite useful, especially when the
> data is post processed. Unfortunately the default -x, output is not
> very friendly to programs when it contains more than one event.
>
> Each event is printed on its own line, each keyed with the time.
>
> You cannot directly feed it to gnuplot or into R to
> compare different events at a specific point in time.
>
> This patch normalizes the output so that a single line contains all
> the events for a given time period. Each event is an own column.
>
> With that it's quite easy to do plots and other analysis,
> as this is the normalized format many data processing programs expect.
>
> This is not fully normalized yet, as per cpu counts also
> end up on the same line (fixing this would be more intrusive)
> But good enough for most purposes.
>
> The non CSV output is not changed.
>
> Example:
>
> $ perf stat -o /tmp/x.csv -I 100 -x, bc  <<< 2^400000 > /dev/null
> $ gnuplot
> gnuplot> set datafile separator ","
> gnuplot> set terminal dumb
> gnuplot> plot "/tmp/x.csv" every ::3 using 1:3
>
>   110 ++--------+---------+---------+--------+---------+---------+--------++
>       +         +         +        "/tmp/x.csv" every ::3 using 1:3   A    +
>   100 ++   A    A    A    A    A    A    A    A   A    A    A    A        ++
>    90 ++                                                                  ++
>       |                                                                    |
>    80 ++                                                                  ++
>       |                                                                    |
>    70 ++                                                                  ++
>       |                                                                    |
>    60 ++                                                                  ++
>    50 ++                                                                  ++
>       |                                                                    |
>    40 ++                                                                  ++
>       |                                                                    |
>    30 ++                                                                  ++
>       |                                                                    |
>    20 ++                                                                  ++
>    10 ++                                                                  ++
>       +         +         +         +        +         +         +A        +
>     0 ++--------+---------+---------+--------+---------+---------+--------++
>      0.2       0.4       0.6       0.8       1        1.2       1.4       1.6
>
> Cc: eranian@google.com
> ---
>  tools/perf/builtin-stat.c |  118 +++++++++++++++++++++++++++++++--------------
>  1 files changed, 82 insertions(+), 36 deletions(-)
>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index e6f4d1d..81d704a 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -66,8 +66,10 @@
>  #define CNTR_NOT_COUNTED       "<not counted>"
>
>  static void print_stat(int argc, const char **argv);
> -static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
> -static void print_counter(struct perf_evsel *counter, char *prefix);
> +static void print_counter_aggr(struct perf_evsel *counter, char *prefix, int delim,
> +                              int name);
> +static void print_counter(struct perf_evsel *counter, char *prefix, int delim,
> +                         int name);
>  static void print_aggr_socket(char *prefix);
>
>  /* Default events used for perf stat -T */
> @@ -343,6 +345,7 @@ static void print_interval(void)
>         struct perf_stat *ps;
>         struct timespec ts, rs;
>         char prefix[64];
> +       int delim = '\n';
>
>         if (no_aggr) {
>                 list_for_each_entry(counter, &evsel_list->entries, node) {
> @@ -373,15 +376,23 @@ static void print_interval(void)
>         if (++num_print_interval == 25)
>                 num_print_interval = 0;
>
> +       if (csv_output) {
> +               delim = ',';
> +               fprintf(output, "%s,", prefix);
> +               prefix[0] = 0;
> +       }
> +
>         if (aggr_socket)
>                 print_aggr_socket(prefix);
>         else if (no_aggr) {
>                 list_for_each_entry(counter, &evsel_list->entries, node)
> -                       print_counter(counter, prefix);
> +                       print_counter(counter, prefix, delim, !csv_output);
>         } else {
>                 list_for_each_entry(counter, &evsel_list->entries, node)
> -                       print_counter_aggr(counter, prefix);
> +                       print_counter_aggr(counter, prefix, delim, !csv_output);
>         }
> +       if (csv_output)
> +               fputc('\n', output);
>  }
>
>  static int __run_perf_stat(int argc __maybe_unused, const char **argv)
> @@ -503,6 +514,21 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
>         t0 = rdclock();
>         clock_gettime(CLOCK_MONOTONIC, &ref_time);
>
> +       if (interval && csv_output) {
> +               fprintf(output, "time,,");

Don't quite understand the point of the ,,. By definition this
extension is used for automatic
post-processing. I cannot find a good justification for the
double-comma, except for making
reading the output easy. But that's contradictory with the gnuplot goal.
Also you need to add a # in front of this line to mark the line so it
can be discarded (as comment)
by any post-processing parser (such as gnuplot).


Also I think something needs to be improved for the non-aggregated output
in system-wide mode:

$ perf stat -I 10000 -x, -a -A -e cycles,instructions sleep 5

Don't you want events also grouped by CPU?


Also noticed a bunch of trailing white spaces.

I am not opposed to the idea of the patch, I think it is indeed useful
for post-processing tools.


> +               list_for_each_entry (counter, &evsel_list->entries, node) {
> +                       if (aggr_socket)
> +                               fprintf(output, "socket%scpu-num%s",
> +                                       csv_sep, csv_sep);
> +                       fprintf(output, "%s%s",
> +                               perf_evsel__name(counter), csv_sep);
> +                       if (counter->cgrp)
> +                               fprintf(output, "%s-cgroup%s",
> +                                       perf_evsel__name(counter), csv_sep);
> +               }
> +               fputc('\n', output);
> +       }
> +
>         if (forks) {
>                 close(go_pipe[1]);
>                 if (interval) {
> @@ -589,7 +615,8 @@ static void print_noise(struct perf_evsel *evsel, double avg)
>         print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
>  }
>
> -static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
> +static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg,
> +                         int name)
>  {
>         double msecs = avg / 1e6;
>         char cpustr[16] = { '\0', };
> @@ -608,7 +635,9 @@ static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
>                         csv_output ? 0 : -4,
>                         perf_evsel__cpus(evsel)->map[cpu], csv_sep);
>
> -       fprintf(output, fmt, cpustr, msecs, csv_sep, perf_evsel__name(evsel));
> +       fprintf(output, fmt, cpustr, msecs,
> +                       name ? csv_sep : "",
> +                       name ? perf_evsel__name(evsel) : "");
>
>         if (evsel->cgrp)
>                 fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
> @@ -802,7 +831,8 @@ static void print_ll_cache_misses(int cpu,
>         fprintf(output, " of all LL-cache hits   ");
>  }
>
> -static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
> +static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg,
> +                        int name)
>  {
>         double total, ratio = 0.0, total2;
>         char cpustr[16] = { '\0', };
> @@ -830,7 +860,9 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
>         else
>                 cpu = 0;
>
> -       fprintf(output, fmt, cpustr, avg, csv_sep, perf_evsel__name(evsel));
> +       fprintf(output, fmt, cpustr, avg,
> +                       name ? csv_sep : "",
> +                       name ? perf_evsel__name(evsel) : "");
>
>         if (evsel->cgrp)
>                 fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
> @@ -969,6 +1001,7 @@ static void print_aggr_socket(char *prefix)
>         struct perf_evsel *counter;
>         u64 ena, run, val;
>         int cpu, s, s2, sock, nr;
> +       bool cmode = csv_output && interval;
>
>         if (!sock_map)
>                 return;
> @@ -991,7 +1024,7 @@ static void print_aggr_socket(char *prefix)
>                                 fprintf(output, "%s", prefix);
>
>                         if (run == 0 || ena == 0) {
> -                               fprintf(output, "S%*d%s%*d%s%*s%s%*s",
> +                               fprintf(output, "S%*d%s%*d%s%*s",
>                                         csv_output ? 0 : -5,
>                                         s,
>                                         csv_sep,
> @@ -999,22 +1032,24 @@ static void print_aggr_socket(char *prefix)
>                                         nr,
>                                         csv_sep,
>                                         csv_output ? 0 : 18,
> -                                       counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
> -                                       csv_sep,
> -                                       csv_output ? 0 : -24,
> -                                       perf_evsel__name(counter));
> +                                       counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED);
> +                               if (!cmode)
> +                                       fprintf(output, "%s%*s",
> +                                               csv_sep,
> +                                               csv_output ? 0 : -24,
> +                                               perf_evsel__name(counter));
>                                 if (counter->cgrp)
>                                         fprintf(output, "%s%s",
>                                                 csv_sep, counter->cgrp->name);
>
> -                               fputc('\n', output);
> +                               fputs(cmode ? csv_sep : "\n", output);
>                                 continue;
>                         }
>
>                         if (nsec_counter(counter))
> -                               nsec_printout(sock, nr, counter, val);
> +                               nsec_printout(sock, nr, counter, val, !cmode);
>                         else
> -                               abs_printout(sock, nr, counter, val);
> +                               abs_printout(sock, nr, counter, val, !cmode);
>
>                         if (!csv_output) {
>                                 print_noise(counter, 1.0);
> @@ -1023,16 +1058,19 @@ static void print_aggr_socket(char *prefix)
>                                         fprintf(output, "  (%.2f%%)",
>                                                 100.0 * run / ena);
>                         }
> -                       fputc('\n', output);
> +                       fputs(cmode ? csv_sep : "\n", output);
>                 }
>         }
> +       if (cmode)
> +               fputc('\n', output);
>  }
>
>  /*
>   * Print out the results of a single counter:
>   * aggregated counts in system-wide mode
>   */
> -static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
> +static void print_counter_aggr(struct perf_evsel *counter, char *prefix, int delim,
> +                              int name)
>  {
>         struct perf_stat *ps = counter->priv;
>         double avg = avg_stats(&ps->res_stats[0]);
> @@ -1052,19 +1090,19 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
>                 if (counter->cgrp)
>                         fprintf(output, "%s%s", csv_sep, counter->cgrp->name);
>
> -               fputc('\n', output);
> +               fputc(delim, output);
>                 return;
>         }
>
>         if (nsec_counter(counter))
> -               nsec_printout(-1, 0, counter, avg);
> +               nsec_printout(-1, 0, counter, avg, name);
>         else
> -               abs_printout(-1, 0, counter, avg);
> +               abs_printout(-1, 0, counter, avg, name);
>
>         print_noise(counter, avg);
>
>         if (csv_output) {
> -               fputc('\n', output);
> +               fputc(delim, output);
>                 return;
>         }
>
> @@ -1076,17 +1114,19 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
>
>                 fprintf(output, " [%5.2f%%]", 100 * avg_running / avg_enabled);
>         }
> -       fprintf(output, "\n");
> +       fputc(delim, output);
>  }
>
>  /*
>   * Print out the results of a single counter:
>   * does not use aggregated count in system-wide
>   */
> -static void print_counter(struct perf_evsel *counter, char *prefix)
> +static void print_counter(struct perf_evsel *counter, char *prefix, int delim,
> +                         int name)
>  {
>         u64 ena, run, val;
>         int cpu;
> +       bool cmode = interval && csv_output;
>
>         for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
>                 val = counter->counts->cpu[cpu].val;
> @@ -1097,27 +1137,33 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
>                         fprintf(output, "%s", prefix);
>
>                 if (run == 0 || ena == 0) {
> -                       fprintf(output, "CPU%*d%s%*s%s%*s",
> -                               csv_output ? 0 : -4,
> -                               perf_evsel__cpus(counter)->map[cpu], csv_sep,
> +                       if (!cmode)
> +                               fprintf(output, "CPU%*d%s",
> +                                       csv_output ? 0 : -4,
> +                                       perf_evsel__cpus(counter)->map[cpu],
> +                                       csv_sep);
> +                       fprintf(output, "%*s%s",
>                                 csv_output ? 0 : 18,
>                                 counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
> -                               csv_sep,
> -                               csv_output ? 0 : -24,
> -                               perf_evsel__name(counter));
> +                               csv_sep);
> +                       if (!cmode)
> +                               fprintf(output, "%*s%s",
> +                                       csv_output ? 0 : -24,
> +                                       perf_evsel__name(counter),
> +                                       csv_sep);
>
>                         if (counter->cgrp)
>                                 fprintf(output, "%s%s",
>                                         csv_sep, counter->cgrp->name);
>
> -                       fputc('\n', output);
> +                       fputc(delim, output);
>                         continue;
>                 }
>
>                 if (nsec_counter(counter))
> -                       nsec_printout(cpu, 0, counter, val);
> +                       nsec_printout(cpu, 0, counter, val, name);
>                 else
> -                       abs_printout(cpu, 0, counter, val);
> +                       abs_printout(cpu, 0, counter, val, name);
>
>                 if (!csv_output) {
>                         print_noise(counter, 1.0);
> @@ -1126,7 +1172,7 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
>                                 fprintf(output, "  (%.2f%%)",
>                                         100.0 * run / ena);
>                 }
> -               fputc('\n', output);
> +               fputc(delim, output);
>         }
>  }
>
> @@ -1159,10 +1205,10 @@ static void print_stat(int argc, const char **argv)
>                 print_aggr_socket(NULL);
>         else if (no_aggr) {
>                 list_for_each_entry(counter, &evsel_list->entries, node)
> -                       print_counter(counter, NULL);
> +                       print_counter(counter, NULL, '\n', 1);
>         } else {
>                 list_for_each_entry(counter, &evsel_list->entries, node)
> -                       print_counter_aggr(counter, NULL);
> +                       print_counter_aggr(counter, NULL, '\n', 1);
>         }
>
>         if (!csv_output) {
> --
> 1.7.7.6
>
