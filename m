Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaDOGfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:35:44 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:53737 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaDOGfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:35:43 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, acme@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Support spark lines in perf stat v2
References: <1397491771-19473-1-git-send-email-andi@firstfloor.org>
Date: Tue, 15 Apr 2014 15:35:35 +0900
In-Reply-To: <1397491771-19473-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 14 Apr 2014 09:09:31 -0700")
Message-ID: <87wqerrtfs.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, 14 Apr 2014 09:09:31 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> perf stat -rX prints the stddev for multiple measurements.
> Just looking at the stddev for judging the quality of the data
> is a bit dangerous The simplest sanity check is to just look
> at a simple plot. This patchs add a sparkline to the end
> of the measurements to make it simple to judge the data.
>
> The sparkline only uses UTF-8, so should be readable
> in all modern tools and terminals.
>
> The sparkline is between the minimum and maximum of the data,
> so it's mainly a indicator of variance. To keep the code
> simple and make the output not too wide only the first
> 8 values are printed. If more values are there it adds '..'
>
> The code is inspired by Zach Holman's spark shell script.
>
> Example output (view in non-proportial font):
>
>  Performance counter stats for 'true' (10 runs):
>
>           0.175672      task-clock (msec)         #    0.555 CPUs utilized            ( +-  1.77% ) █▄▁▁▁▁▁▁..
>                  0      context-switches          #    0.000 K/sec
>                  0      cpu-migrations            #    0.000 K/sec
>                114      page-faults               #    0.647 M/sec                    ( +-  0.14% ) ▁█▁▁████..
>            520,798      cycles                    #    2.965 GHz                      ( +-  1.75% ) █▄▁▁▁▁▁▁..
>            433,525      instructions              #    0.83  insns per cycle          ( +-  0.28% ) ▅▇▅▄▇█▁▆..
>             83,012      branches                  #  472.537 M/sec                    ( +-  0.31% ) ▅▇▆▄▇█▁▆..
>              3,157      branch-misses             #    3.80% of all branches          ( +-  2.55% ) ▇█▃▅▁▃▁▂..
>
>        0.000316660 seconds time elapsed                                          ( +-  1.78% ) █▅▁▁▁▁▁▁..
>
> As you can see even in the most simple run there are quite interesting
> patterns. The time sparkline suggests it would be also useful to have an option
> to throw the first measurement away.
>
> Known issues:
> - Makes the perf stat output wider. Could be adjust by shrinking
> some white space. Not done so far.
> - No output for -A/--per-socket/--per-core with -rX. This code
> is missing the basic noise detection code. Once it's added there
> sparklines could be shown too.
>
> v2: Avoid printing spark lines for normal CSV case (Jiri)
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---


[SNIP]
> diff --git a/tools/perf/util/spark.c b/tools/perf/util/spark.c
> new file mode 100644
> index 0000000..a677d2c
> --- /dev/null
> +++ b/tools/perf/util/spark.c
> @@ -0,0 +1,45 @@
> +#include <stdio.h>
> +#include <limits.h>
> +#include "spark.h"
> +
> +#define NUM_SPARKS 8
> +#define SPARK_SHIFT 8
> +
> +/* Print spark lines on outf for numval values in val. */
> +void print_spark(FILE *outf, unsigned long *val, int numval)
> +{
> +	static const char *ticks[NUM_SPARKS] = {
> +		"▁",  "▂", "▃", "▄", "▅", "▆", "▇", "█"
> +	};
> +	int i;
> +	unsigned long min = LONG_MAX, max = 0, f;

s/LONG_MAX/ULONG_MAX/ ?

> +
> +	for (i = 0; i < numval; i++) {
> +		if (val[i] < min)
> +			min = val[i];
> +		if (val[i] > max)
> +			max = val[i];
> +	}
> +	f = ((max - min) << SPARK_SHIFT) / (NUM_SPARKS - 1);
> +	if (f < 1)
> +		f = 1;
> +	for (i = 0; i < numval; i++) {
> +		fputs(ticks[((val[i] - min) << SPARK_SHIFT) / f], outf);
> +	}
> +}
> +
> +#ifdef TEST
> +#include <stdlib.h>
> +
> +int main(int ac, char **av)
> +{
> +	unsigned long *val = calloc(ac - 1, sizeof(unsigned long));
> +	int i;
> +
> +	for (i = 1; i < ac; i++)
> +		val[i - 1] = strtoul(av[i], NULL, 0);
> +	print_spark(stdout, val, ac - 1);
> +	putchar('\n');
> +	return 0;
> +}
> +#endif

Hmm.. test codes usually live in the tools/perf/tests directory.


> diff --git a/tools/perf/util/spark.h b/tools/perf/util/spark.h
> new file mode 100644
> index 0000000..f2d5ac5
> --- /dev/null
> +++ b/tools/perf/util/spark.h
> @@ -0,0 +1,3 @@
> +#pragma once
> +void print_spark(FILE *outf, unsigned long *val, int numval);
> +
> diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
> index 6506b3d..2b26d74 100644
> --- a/tools/perf/util/stat.c
> +++ b/tools/perf/util/stat.c
> @@ -1,10 +1,16 @@
>  #include <math.h>
> +#include <stdio.h>
>  
>  #include "stat.h"
> +#include "spark.h"
>  
>  void update_stats(struct stats *stats, u64 val)
>  {
>  	double delta;
> +	int n = stats->n;
> +
> +	if (n < NUM_SPARK_VALS)
> +		stats->svals[n] = val;
>  
>  	stats->n++;
>  	delta = val - stats->mean;
> @@ -61,3 +67,30 @@ double rel_stddev_stats(double stddev, double avg)
>  
>  	return pct;
>  }
> +
> +static int all_the_same(unsigned long *vals, int len)
> +{
> +	int i;
> +	unsigned long v0 = vals[0];
> +
> +	for (i = 1; i < len; i++)
> +		if (vals[i] != v0)
> +			return 0;
> +	return 1;
> +}
> +
> +void print_stat_spark(FILE *f, struct stats *stat)
> +{
> +	int n = stat->n, len;
> +
> +	if (n <= 1)
> +		return;
> +	len = n;

It seems the 'n' is not needed at all - just use 'len'.


> +	if (len > NUM_SPARK_VALS)
> +		len = NUM_SPARK_VALS;
> +	if (all_the_same(stat->svals, len))
> +		return;

Why does it skip printing if all values are same?  I think you wanted to
skip the "all zero" (uncounted) case, right?

Also adding a few blank lines might improve readability a bit IMHO.

Thanks,
Namhyung


> +	print_spark(f, stat->svals, len);
> +	if (stat->n > NUM_SPARK_VALS)
> +		fputs("..", f);
> +}
> diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
> index ae8ccd7..1b4dc71 100644
> --- a/tools/perf/util/stat.h
> +++ b/tools/perf/util/stat.h
> @@ -1,12 +1,16 @@
>  #ifndef __PERF_STATS_H
>  #define __PERF_STATS_H
>  
> +#include <stdio.h>
>  #include "types.h"
>  
> +#define NUM_SPARK_VALS 8 /* support spark line on first N items */
> +
>  struct stats
>  {
>  	double n, mean, M2;
>  	u64 max, min;
> +	unsigned long svals[NUM_SPARK_VALS];
>  };
>  
>  void update_stats(struct stats *stats, u64 val);
> @@ -14,12 +18,18 @@ double avg_stats(struct stats *stats);
>  double stddev_stats(struct stats *stats);
>  double rel_stddev_stats(double stddev, double avg);
>  
> +void print_stat_spark(FILE *f, struct stats *stat);
> +
>  static inline void init_stats(struct stats *stats)
>  {
> +	int i;
> +
>  	stats->n    = 0.0;
>  	stats->mean = 0.0;
>  	stats->M2   = 0.0;
>  	stats->min  = (u64) -1;
>  	stats->max  = 0;
> +	for (i = 0; i < NUM_SPARK_VALS; i++)
> +		stats->svals[i] = 0;
>  }
>  #endif
