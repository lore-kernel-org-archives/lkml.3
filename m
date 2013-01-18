Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3ARNu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:50:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab3ARNu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:50:56 -0500
Date: Fri, 18 Jan 2013 14:50:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v2 2/2] perf stat: add interval printing
Message-ID: <20130118135018.GB1579@krava>
References: <1358514388-4344-1-git-send-email-eranian@google.com>
 <1358514388-4344-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358514388-4344-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:06:28PM +0100, Stephane Eranian wrote:
> This patch adds a new printing mode for perf stat.
> It allows internval printing. That means perf stat

SNIP

>  	const char * const stat_usage[] = {
> @@ -1245,12 +1356,23 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  		usage_with_options(stat_usage, options);
>  		return -1;
>  	}
> +	if (interval < 0 || (interval > 0 && interval < 100)) {
> +		pr_err("print interval must be >= 100ms\n");
> +		usage_with_options(stat_usage, options);
> +		return -1;
> +	}
>  
>  	list_for_each_entry(pos, &evsel_list->entries, node) {
>  		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
>  		    perf_evsel__alloc_counts(pos, perf_evsel__nr_cpus(pos)) < 0)
>  			goto out_free_fd;
>  	}
> +	if (interval) {
> +		list_for_each_entry(pos, &evsel_list->entries, node) {
> +			if (perf_evsel__alloc_prev_raw_counts(pos) < 0)
> +				goto out_free_fd;
> +		}
> +	}

this could be squeezed up into the previous loop,

the perf_evsel__alloc_counts function does the same
job for 'counts', maybe it could be unified


>  
>  	/*
>  	 * We dont want to block the signals - that would cause
> @@ -1260,6 +1382,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  	 */
>  	atexit(sig_atexit);
>  	signal(SIGINT,  skip_signal);
> +	signal(SIGCHLD, skip_signal);
>  	signal(SIGALRM, skip_signal);
>  	signal(SIGABRT, skip_signal);
>  
> @@ -1272,11 +1395,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  		status = run_perf_stat(argc, argv);
>  	}
>  
> -	if (status != -1)
> +	if (status != -1 && !interval)
>  		print_stat(argc, argv);

The way this is done prevents final stats to be printed,
which seems unfortunate.

Actually I don't mind that much, because I haven't even thought about
this feature, but looks like it could be done separately with no affect
to final counts.

But since you probably use it mostly for feeding some graph ploting
program, it's probably fine.. just feels wrong ;-)

jirka
