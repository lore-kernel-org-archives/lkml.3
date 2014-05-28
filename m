Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaE1NFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:05:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbaE1NFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:05:31 -0400
Date: Wed, 28 May 2014 15:04:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Support spark lines in perf stat v4
Message-ID: <20140528130446.GD1193@krava.brq.redhat.com>
References: <1401236970-31106-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401236970-31106-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 05:29:30PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>

SNIP

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

I've got segfault in here on 32 bits, due to above computation overflow.
When I used attached patch, it works as expected.

Also please update this with some boundaries checks before
we access the array.

> +}
> diff --git a/tools/perf/util/spark.h b/tools/perf/util/spark.h
> new file mode 100644
> index 0000000..59b04ad
> --- /dev/null
> +++ b/tools/perf/util/spark.h
> @@ -0,0 +1,4 @@
> +#ifndef SPARK_H
> +#define SPARK_H 1
> +void print_spark(FILE *outf, unsigned long *val, int numval);
> +#endif
> diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
> index 6506b3d..2e76d9c 100644
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

also I think we need svals to be array of u64 values

>  
>  	stats->n++;
>  	delta = val - stats->mean;
> @@ -61,3 +67,31 @@ double rel_stddev_stats(double stddev, double avg)
>  
>  	return pct;
>  }

thanks,
jirka


---
diff --git a/tools/perf/util/spark.c b/tools/perf/util/spark.c
index ac5b3a5..eb35592 100644
--- a/tools/perf/util/spark.c
+++ b/tools/perf/util/spark.c
@@ -12,7 +12,7 @@ void print_spark(FILE *outf, unsigned long *val, int numval)
 		"▁",  "▂", "▃", "▄", "▅", "▆", "▇", "█"
 	};
 	int i;
-	unsigned long min = ULONG_MAX, max = 0, f;
+	unsigned long long min = LLONG_MAX, max = 0, f;
 
 	for (i = 0; i < numval; i++) {
 		if (val[i] < min)
