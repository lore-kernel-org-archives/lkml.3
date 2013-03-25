Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab3CYQXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:23:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896Ab3CYQXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:23:01 -0400
Date: Mon, 25 Mar 2013 13:22:47 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v2 1/3] perf stat: refactor aggregation code
Message-ID: <20130325162247.GA14604@infradead.org>
References: <1360846649-6411-1-git-send-email-eranian@google.com>
 <1360846649-6411-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360846649-6411-2-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 14, 2013 at 01:57:27PM +0100, Stephane Eranian escreveu:
> Refactor aggregation code by introducing a single aggr_mode variable
> and an enum for aggregation.

<SNIP>
 
> @@ -542,26 +553,37 @@ static void print_noise(struct perf_evsel *evsel, double avg)
>  	print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
>  }
>  
> -static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
> +static void aggr_printout(int cpu, int nr)
>  {
> -	double msecs = avg / 1e6;
> -	char cpustr[16] = { '\0', };
> -	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-25s";
> -
> -	if (aggr_socket)
> -		sprintf(cpustr, "S%*d%s%*d%s",
> +	switch (aggr_mode) {
> +	case AGGR_SOCKET:
> +		fprintf(output, "S%*d%s%*d%s",
>  			csv_output ? 0 : -5,
>  			cpu,
>  			csv_sep,
>  			csv_output ? 0 : 4,
>  			nr,
>  			csv_sep);
> -	else if (no_aggr)
> -		sprintf(cpustr, "CPU%*d%s",
> +			break;
> +	case AGGR_NONE:
> +		fprintf(output, "CPU%*d%s",
>  			csv_output ? 0 : -4,
>  			perf_evsel__cpus(evsel)->map[cpu], csv_sep);

I'm fixing this up, how would evsel here work if it is not passed to
aggr_printout()?

I'm also fixing it up wrt the --forever patch and the one Namyung sent
that makes perf stat use perf_evlist__prepare_workload that I had
applied before this one. Will do some tests, put on a separate branch
for you to check that all is still ok and works as expected,

thanks,

- Arnaldo
