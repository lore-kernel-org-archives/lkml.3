Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab3FLDJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 23:09:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab3FLDJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 23:09:21 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hQqaEBWkjLkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=sAMK0X7KwfYA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=CMzIWUik0UGGDUc9bqAA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=EZppNln4m65Z36Il:21 a=1_WueE0MbuW6-KLc:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371006559.9844.250.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] ftrace: fix stddev calculation
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>
Date: Tue, 11 Jun 2013 23:09:19 -0400
In-Reply-To: <1370941728-15456-4-git-send-email-juri.lelli@gmail.com>
References: <1370941728-15456-1-git-send-email-juri.lelli@gmail.com>
	 <1370941728-15456-4-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 11:08 +0200, Juri Lelli wrote:
> When FUNCTION_GRAPH_TRACER is enabled, ftrace can profile kernel functions
> and print basic statistics about them. Unfortunately, running stddev
> calculation is wrong. This patch corrects it implementing Welford’s method:
> 
>         s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2) .

Looking at this further, we only need this fix. We don't need the other
two patches, as that's just verifying the algorithm, and not something
we need to do for run time tests. The run time tests is to test
functionality, not calculations that can be done out of the kernel.

Can you resubmit with just this change. And add the above line as a
comment below.

> 
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/ftrace.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 6caaa0e..073a328 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -593,13 +593,17 @@ void function_stat_calc(struct ftrace_profile *rec,
>  	if (rec->counter <= 1)
>  		*stddev = 0;
>  	else {
> -		*stddev = rec->time_squared - rec->counter * (*avg) * (*avg);
> +		/*
> +		 * Apply Welford's method.

Welford's method is not well known. Please add:

		* s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)

Thanks!

-- Steve

> +		 */
> +		*stddev = rec->counter * rec->time_squared -
> +			  rec->time * rec->time;
>  
>  		/*
>  		 * Divide only 1000 for ns^2 -> us^2 conversion.
>  		 * trace_print_graph_duration will divide 1000 again.
>  		 */
> -		do_div(*stddev, (rec->counter - 1) * 1000);
> +		do_div(*stddev, rec->counter * (rec->counter - 1) * 1000);
>  	}
>  }
>  


