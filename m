Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab3FLAAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:00:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3812 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab3FLAAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:00:16 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=rYVB1A-BO04A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=uih3XFgG020A:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=ZVHykTHjAElvi-HyQcsA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370995213.9844.228.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] ftrace: test basic statistics calculation
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>
Date: Tue, 11 Jun 2013 20:00:13 -0400
In-Reply-To: <1370941728-15456-3-git-send-email-juri.lelli@gmail.com>
References: <1370941728-15456-1-git-send-email-juri.lelli@gmail.com>
	 <1370941728-15456-3-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 11:08 +0200, Juri Lelli wrote:
> Perform a simple test comparing static and running (implemented by
> function_stat_calc()) average and stddev calculations.

Thanks, as these are not regressions but just bugs since its
incorporation, they are too late for 3.10. I'll queue them up for 3.11.

But this has a small bug...

> 
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/trace_selftest.c |   72 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 72 insertions(+)
> 
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index 2901e3b..e8ecb9a 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -4,6 +4,7 @@
>  #include <linux/kthread.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
> +#include <linux/random.h>
>  
>  static inline int trace_valid_entry(struct trace_entry *entry)
>  {
> @@ -724,6 +725,74 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
>  }

Need to encapsulate this with:

#ifdef CONFIG_FUNCTION_PROFILER

>  
>  /*
> + * Test the trace basic running statistic calculations to see if they
> + * agree with static one.
> + */
> +#define	TIME_ENTRIES	50
> +#define	MAX_DURATION	1000000 /* ns */
> +
> +static int trace_test_stat(void)
> +{
> +	unsigned long long time_array[TIME_ENTRIES];
> +	unsigned long long averages[TIME_ENTRIES], stddevs[TIME_ENTRIES];
> +	int i, j, count;
> +	unsigned long long avg, stddev;
> +	struct ftrace_profile rec;
> +
> +	/*
> +	 * Fill-up time_array, each element corresponds to the time spent
> +	 * executing some function.
> +	 */
> +	for (i = 0; i < TIME_ENTRIES; i++) {
> +		get_random_bytes(&time_array[i], sizeof(unsigned long long));
> +		time_array[i] %= MAX_DURATION;
> +		averages[i] = stddevs[i] = 0;
> +	}
> +
> +	/*
> +	 * Calculate stats in the static way.
> +	 */
> +	for (i = 0; i < TIME_ENTRIES; i++) {
> +		if (i == 0) {
> +			averages[i] = time_array[i];
> +			stddevs[i] = 0;
> +			continue;
> +		}
> +
> +		count = 0;
> +		for (j = 0; j < i + 1; j++) {
> +			count++;
> +			averages[i] += time_array[j];
> +		}
> +		do_div(averages[i], count);
> +
> +		for (j = 0; j < count; j++)
> +			stddevs[i] += (time_array[j] - averages[i]) *
> +				      (time_array[j] - averages[i]);
> +		/* Reflect ns^2 -> us^2 conversion. */
> +		do_div(stddevs[i], (count - 1) * 1000);
> +	}
> +
> +	/*
> +	 * Now do the same using running stats and compare results.
> +	 */
> +	rec.time = rec.time_squared = 0;
> +
> +	for (i = 0; i < TIME_ENTRIES; i++) {
> +		avg = stddev = 0;
> +		rec.counter = i + 1;
> +		rec.time += time_array[i];
> +		rec.time_squared += time_array[i] * time_array[i];
> +		function_stat_calc(&rec, &avg, &stddev);
> +
> +		if (avg != averages[i] || stddev != stddevs[i])
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +

#else

static int trace_test_stat(void)
{
	return 0;
}

#endif /* CONFIG_FUNCTION_PROFILER */

-- Steve

> +/*
>   * Pretty much the same than for the function tracer from which the selftest
>   * has been borrowed.
>   */
> @@ -774,6 +843,9 @@ trace_selftest_startup_function_graph(struct tracer *trace,
>  
>  	/* Don't test dynamic tracing, the function tracer already did */
>  
> +	/* Check basic statistics */
> +	ret = trace_test_stat();
> +
>  out:
>  	/* Stop it if we failed */
>  	if (ret)


