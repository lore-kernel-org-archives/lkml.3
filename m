Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaEZR22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:28:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbaEZR21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:28:27 -0400
Date: Mon, 26 May 2014 19:27:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Support spark lines in perf stat v3
Message-ID: <20140526172746.GB2763@krava.brq.redhat.com>
References: <1397673678-27452-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397673678-27452-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 11:41:18AM -0700, Andi Kleen wrote:
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

hi,
sorry for delay...

Could you please also update doc with some of above info?
Other than that and one comment below, I'd like to take this patch.

thanks,
jirka


> diff --git a/tools/perf/util/spark.c b/tools/perf/util/spark.c
> new file mode 100644
> index 0000000..ac5b3a5
> --- /dev/null
> +++ b/tools/perf/util/spark.c
> @@ -0,0 +1,28 @@
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
> +	unsigned long min = ULONG_MAX, max = 0, f;
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
> +	for (i = 0; i < numval; i++)
> +		fputs(ticks[((val[i] - min) << SPARK_SHIFT) / f], outf);
> +}
> diff --git a/tools/perf/util/spark.h b/tools/perf/util/spark.h
> new file mode 100644
> index 0000000..f2d5ac5
> --- /dev/null
> +++ b/tools/perf/util/spark.h
> @@ -0,0 +1,3 @@
> +#pragma once
> +void print_spark(FILE *outf, unsigned long *val, int numval);
> +

google says this pragma got obsolete.. any reason for using this?

SNIP

> +
> +void print_stat_spark(FILE *f, struct stats *stat)
> +{
> +	int n = stat->n, len;
> +
> +	if (n <= 1)
> +		return;
> +
> +	len = n;
> +	if (len > NUM_SPARK_VALS)
> +		len = NUM_SPARK_VALS;
> +	if (all_the_same(stat->svals, len))
> +		return;

I still dont understand why 'n' variable is needed in here,
but I can live with that ;-)
