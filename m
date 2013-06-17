Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3FQRHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:07:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3FQRHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:07:43 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9-gx877wJvsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=sAMK0X7KwfYA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=m6v0A_qGWvULShiTw24A:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=SJowZ604iqnVpbTL:21 a=o85v4qbudk0yLlV9:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371488862.18733.21.camel@gandalf.local.home>
Subject: Re: [PATCH] ftrace: fix stddev calculation
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 17 Jun 2013 13:07:42 -0400
In-Reply-To: <1371031398-24048-1-git-send-email-juri.lelli@gmail.com>
References: <1371031398-24048-1-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 12:03 +0200, Juri Lelli wrote:
> When FUNCTION_GRAPH_TRACER is enabled, ftrace can profile kernel functions
> and print basic statistics about them. Unfortunately, running stddev
> calculation is wrong. This patch corrects it implementing Welford’s method:
> 
>         s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2) .
> 
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>

I pulled this into my 3.11 queue. Thanks!

-- Steve

> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/ftrace.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 6c508ff..6c3fce2 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -622,12 +622,18 @@ static int function_stat_show(struct seq_file *m, void *v)
>  	if (rec->counter <= 1)
>  		stddev = 0;
>  	else {
> -		stddev = rec->time_squared - rec->counter * avg * avg;
> +		/*
> +		 * Apply Welford's method:
> +		 * s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
> +		 */
> +		stddev = rec->counter * rec->time_squared -
> +			 rec->time * rec->time;
> +
>  		/*
>  		 * Divide only 1000 for ns^2 -> us^2 conversion.
>  		 * trace_print_graph_duration will divide 1000 again.
>  		 */
> -		do_div(stddev, (rec->counter - 1) * 1000);
> +		do_div(stddev, rec->counter * (rec->counter - 1) * 1000);
>  	}
>  
>  	trace_seq_init(&s);


