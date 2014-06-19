Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934537AbaFSTae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:30:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:57715 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757780AbaFSTab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:30:31 -0400
Date: Thu, 19 Jun 2014 16:30:26 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] perf bench: sched-messaging: Redo runtime output
Message-ID: <20140619193026.GC31524@kernel.org>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
 <1402942467-10671-3-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402942467-10671-3-git-send-email-davidlohr@hp.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 16, 2014 at 11:14:20AM -0700, Davidlohr Bueso escreveu:
> Instead of printing sec and usec individually, simplify
> into a 'runtime' variable to later use accordingly. This
> is particularly helpful when later adding multiple runs
> and collecting statistics.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  tools/perf/bench/sched-messaging.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
> index cc1190a..df0828a 100644
> --- a/tools/perf/bench/sched-messaging.c
> +++ b/tools/perf/bench/sched-messaging.c
> @@ -269,9 +269,9 @@ static const char * const bench_sched_message_usage[] = {
>  int bench_sched_messaging(int argc, const char **argv,
>  		    const char *prefix __maybe_unused)
>  {
> -	unsigned int i, total_children;
> +	unsigned int i, total_children, num_fds = 20;
>  	struct timeval start, stop, diff;
> -	unsigned int num_fds = 20;
> +	unsigned long runtime;
>  	int readyfds[2], wakefds[2];
>  	char dummy;
>  	pthread_t *pth_tab;
> @@ -307,8 +307,8 @@ int bench_sched_messaging(int argc, const char **argv,
>  		reap_worker(pth_tab[i]);
>  
>  	gettimeofday(&stop, NULL);
> -
>  	timersub(&stop, &start, &diff);
> +	runtime = (diff.tv_sec * 1e3) + (diff.tv_usec/1e3);

So if you want to really change this into something more compact, why
not declare runtime as float and do the div here, so that you don't have
to do it everytime you need to format it?

But perhaps because in the kernel we avoid doing floating point I found
this code unusual, was expecting things like USEC_PER_MSEC, and no
floating pointing operations being used, i.e. as before :-\

Anyway, I took most of the patches in this series, will push what I have
after some more testing.

- Arnaldo

>  
>  	switch (bench_format) {
>  	case BENCH_FORMAT_DEFAULT:
> @@ -317,13 +317,10 @@ int bench_sched_messaging(int argc, const char **argv,
>  		printf("# %d groups == %d %s run\n\n",
>  		       num_groups, num_groups * 2 * num_fds,
>  		       thread_mode ? "threads" : "processes");
> -		printf(" %14s: %lu.%03lu [sec]\n", "Total time",
> -		       diff.tv_sec,
> -		       (unsigned long) (diff.tv_usec/1000));
> +		printf(" %14s: %.3f [sec]\n", "Total time", runtime/1e3);
>  		break;
>  	case BENCH_FORMAT_SIMPLE:
> -		printf("%lu.%03lu\n", diff.tv_sec,
> -		       (unsigned long) (diff.tv_usec/1000));
> +		printf("%.3f\n", runtime/1e3);
>  		break;
>  	default:
>  		/* reaching here is something disaster */
> -- 
> 1.8.1.4
