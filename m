Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab3CGVjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:39:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858Ab3CGVjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:39:18 -0500
Date: Thu, 7 Mar 2013 22:38:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v2 1/3] perf stat: refactor aggregation code
Message-ID: <20130307213844.GB24191@krava.redhat.com>
References: <1360846649-6411-1-git-send-email-eranian@google.com>
 <1360846649-6411-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360846649-6411-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 01:57:27PM +0100, Stephane Eranian wrote:

SNIP

> -		if (aggr_socket)
> +		switch (aggr_mode) {
> +		case AGGR_SOCKET:
>  			fprintf(output, "#           time socket cpus             counts events\n");
> -		else if (no_aggr)
> +			break;
> +		case AGGR_NONE:
>  			fprintf(output, "#           time CPU                 counts events\n");
> -		else
> +			break;
> +		case AGGR_GLOBAL:
> +		default:
>  			fprintf(output, "#           time             counts events\n");
> +		}
>  	}
>  
>  	if (++num_print_interval == 25)
>  		num_print_interval = 0;
>  
> -	if (aggr_socket)
> -		print_aggr_socket(prefix);
> -	else if (no_aggr) {



this:

---
> +	switch (aggr_mode) {
> +	case AGGR_SOCKET:
> +		print_aggr(prefix);
> +		break;
> +	case AGGR_NONE:
>  		list_for_each_entry(counter, &evsel_list->entries, node)
>  			print_counter(counter, prefix);
> -	} else {
> +		break;
> +	case AGGR_GLOBAL:
> +	default:
>  		list_for_each_entry(counter, &evsel_list->entries, node)
>  			print_counter_aggr(counter, prefix);
>  	}
---



> @@ -356,12 +372,6 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
>  		ts.tv_nsec = 0;
>  	}

SNIP

> -	if (aggr_socket)
> -		print_aggr_socket(NULL);
> -	else if (no_aggr) {
> -		list_for_each_entry(counter, &evsel_list->entries, node)
> -			print_counter(counter, NULL);
> -	} else {


and this:
---
> +	switch (aggr_mode) {
> +	case AGGR_SOCKET:
> +		print_aggr(NULL);
> +		break;
> +	case AGGR_GLOBAL:
>  		list_for_each_entry(counter, &evsel_list->entries, node)
>  			print_counter_aggr(counter, NULL);
> +		break;
> +	case AGGR_NONE:
> +		list_for_each_entry(counter, &evsel_list->entries, node)
> +			print_counter(counter, NULL);
> +		break;
> +	default:
> +		break;
>  	}
---

could be in a single function with 'prefix' arg

Also in non interval mode no column headers are printed and the
output is sort of not user friendly, I think we could print the
header same as for the interval case.

[jolsa@krava perf]$ sudo ./perf stat -a --per-socket -e cycles /bin/true 

 Performance counter stats for '/bin/true':

S0        4          1,472,345 cycles                    #    0.000 GHz                    

^^^^^^^^^^^, versus:

[jolsa@krava perf]$ sudo ./perf stat -a --per-socket -I 100 -e cycles
sleep 10
#           time socket cpus             counts events
     0.100283713 S0        4         12,975,188 cycles                   
     0.200881622 S0        4         15,982,354 cycles                   

thanks,
jirka
