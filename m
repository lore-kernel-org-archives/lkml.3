Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3CNL0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:26:10 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:40442 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3CNL0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:26:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130313165622.GA19692@tassilo.jf.intel.com>
References: <1362624201-6161-1-git-send-email-andi@firstfloor.org>
	<CABPqkBT06EVjuy1ew1Z+vrGMf0p+mH19-M71xzTGVyZTtcaLUA@mail.gmail.com>
	<20130313165622.GA19692@tassilo.jf.intel.com>
Date: Thu, 14 Mar 2013 12:26:07 +0100
Message-ID: <CABPqkBSnhWtcATEX46fzPZcGhph8oGoe9yR9qgfChAj7fQ0NGQ@mail.gmail.com>
Subject: Re: [PATCH] perf, tools: Make perf stat -I ... CSV output flat
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 5:56 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Wed, Mar 13, 2013 at 02:19:05PM +0100, Stephane Eranian wrote:
>> On Thu, Mar 7, 2013 at 3:43 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> > From: Andi Kleen <ak@linux.intel.com>
>> >
>> > The new perf stat interval code is quite useful, especially when the
>> > data is post processed. Unfortunately the default -x, output is not
>> > very friendly to programs when it contains more than one event.
>> >
>> > Each event is printed on its own line, each keyed with the time.
>> >
>> > You cannot directly feed it to gnuplot or into R to
>> > compare different events at a specific point in time.
>> >
>> > This patch normalizes the output so that a single line contains all
>> > the events for a given time period. Each event is an own column.
>> >
>> > With that it's quite easy to do plots and other analysis,
>> > as this is the normalized format many data processing programs expect.
>> >
>> > This is not fully normalized yet, as per cpu counts also
>> > end up on the same line (fixing this would be more intrusive)
>> > But good enough for most purposes.
>> >
>> > The non CSV output is not changed.
>> >
>> > Example:
>> >
>> > $ perf stat -o /tmp/x.csv -I 100 -x, bc  <<< 2^400000 > /dev/null
>> > $ gnuplot
>> > gnuplot> set datafile separator ","
>> > gnuplot> set terminal dumb
>> > gnuplot> plot "/tmp/x.csv" every ::3 using 1:3
>> >
>> >   110 ++--------+---------+---------+--------+---------+---------+--------++
>> >       +         +         +        "/tmp/x.csv" every ::3 using 1:3   A    +
>> >   100 ++   A    A    A    A    A    A    A    A   A    A    A    A        ++
>> >    90 ++                                                                  ++
>> >       |                                                                    |
>> >    80 ++                                                                  ++
>> >       |                                                                    |
>> >    70 ++                                                                  ++
>> >       |                                                                    |
>> >    60 ++                                                                  ++
>> >    50 ++                                                                  ++
>> >       |                                                                    |
>> >    40 ++                                                                  ++
>> >       |                                                                    |
>> >    30 ++                                                                  ++
>> >       |                                                                    |
>> >    20 ++                                                                  ++
>> >    10 ++                                                                  ++
>> >       +         +         +         +        +         +         +A        +
>> >     0 ++--------+---------+---------+--------+---------+---------+--------++
>> >      0.2       0.4       0.6       0.8       1        1.2       1.4       1.6
>> >
>> > Cc: eranian@google.com
>> > ---
>> >  tools/perf/builtin-stat.c |  118 +++++++++++++++++++++++++++++++--------------
>> >  1 files changed, 82 insertions(+), 36 deletions(-)
>> >
>> > diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
>> > index e6f4d1d..81d704a 100644
>> > --- a/tools/perf/builtin-stat.c
>> > +++ b/tools/perf/builtin-stat.c
>> > @@ -66,8 +66,10 @@
>> >  #define CNTR_NOT_COUNTED       "<not counted>"
>> >
>> >  static void print_stat(int argc, const char **argv);
>> > -static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
>> > -static void print_counter(struct perf_evsel *counter, char *prefix);
>> > +static void print_counter_aggr(struct perf_evsel *counter, char *prefix, int delim,
>> > +                              int name);
>> > +static void print_counter(struct perf_evsel *counter, char *prefix, int delim,
>> > +                         int name);
>> >  static void print_aggr_socket(char *prefix);
>> >
>> >  /* Default events used for perf stat -T */
>> > @@ -343,6 +345,7 @@ static void print_interval(void)
>> >         struct perf_stat *ps;
>> >         struct timespec ts, rs;
>> >         char prefix[64];
>> > +       int delim = '\n';
>> >
>> >         if (no_aggr) {
>> >                 list_for_each_entry(counter, &evsel_list->entries, node) {
>> > @@ -373,15 +376,23 @@ static void print_interval(void)
>> >         if (++num_print_interval == 25)
>> >                 num_print_interval = 0;
>> >
>> > +       if (csv_output) {
>> > +               delim = ',';
>> > +               fprintf(output, "%s,", prefix);
>> > +               prefix[0] = 0;
>> > +       }
>> > +
>> >         if (aggr_socket)
>> >                 print_aggr_socket(prefix);
>> >         else if (no_aggr) {
>> >                 list_for_each_entry(counter, &evsel_list->entries, node)
>> > -                       print_counter(counter, prefix);
>> > +                       print_counter(counter, prefix, delim, !csv_output);
>> >         } else {
>> >                 list_for_each_entry(counter, &evsel_list->entries, node)
>> > -                       print_counter_aggr(counter, prefix);
>> > +                       print_counter_aggr(counter, prefix, delim, !csv_output);
>> >         }
>> > +       if (csv_output)
>> > +               fputc('\n', output);
>> >  }
>> >
>> >  static int __run_perf_stat(int argc __maybe_unused, const char **argv)
>> > @@ -503,6 +514,21 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
>> >         t0 = rdclock();
>> >         clock_gettime(CLOCK_MONOTONIC, &ref_time);
>> >
>> > +       if (interval && csv_output) {
>> > +               fprintf(output, "time,,");
>>
>> Don't quite understand the point of the ,,. By definition this
>> extension is used for automatic
>
> That was for one of the extra modi, I think cgroups.
> It was easier to have the extra empty column than to special case this.
>
tried with cgroups, the double-comma is still there. I don't see in the code
where this is special-cased. I think you can probably drop this.

sudo ./perf stat  -e cycles,instructions -G test -a -A -I 1000 -x, noploop 5
time,,cycles,cycles-cgroup,instructions,
noploop for 5 seconds
     1.000147504,,<not counted>,,test,<not counted>,,test,<not
counted>,,test,<not
counted>,,test,CPU0,5003932,CPU1,2223864,CPU2,2377340865,CPU3,275001,

>
>> in system-wide mode:
>>
>> $ perf stat -I 10000 -x, -a -A -e cycles,instructions sleep 5
>>
>> Don't you want events also grouped by CPU?
>
> I mentioned that as an open. It would be good to have separate lines
> per cpu, but that would have complicated the patch somewhat.
> Could be done as a next step I suppose.
>
I think getting a CPU per line would make it easier to parse and display.
So why don't you do this now? I understand it is a more significant change
but I think it would make this extension more thorough that way.
