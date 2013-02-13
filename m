Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab3BMHuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:50:54 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:65090 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab3BMHux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:50:53 -0500
X-AuditID: 9c930179-b7c24ae00000119c-bb-511b45daeb0b
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH 1/2] perf stat: refactor aggregation code
References: <1360678168-6974-1-git-send-email-eranian@google.com>
	<1360678168-6974-2-git-send-email-eranian@google.com>
Date: Wed, 13 Feb 2013 16:50:50 +0900
In-Reply-To: <1360678168-6974-2-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Tue, 12 Feb 2013 15:09:27 +0100")
Message-ID: <874nhgps85.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Tue, 12 Feb 2013 15:09:27 +0100, Stephane Eranian wrote:
> Refactor aggregation code by introducing
> a single aggr_mode variable and an enum
> for aggregation.
>
> Also refactor cpumap code having to do
> with cpu to socket mappings. All in preparation
> for extended modes, such as cpu -> core.
>
> Also fix socket aggregation and ensure
> that sockets are printed in increasing order.
[snip]
> -static void print_aggr_socket(char *prefix)
> +static void print_aggr(char *prefix)
>  {
>  	struct perf_evsel *counter;
> +	int cpu, s, s2, id, nr;
>  	u64 ena, run, val;
> -	int cpu, s, s2, sock, nr;
>  
> -	if (!sock_map)
> +	if (!(aggr_map || aggr_get_id))
>  		return;
>  
> -	for (s = 0; s < sock_map->nr; s++) {
> -		sock = cpu_map__socket(sock_map, s);
> +	for (s = 0; s < aggr_map->nr; s++) {
> +		id = aggr_map->map[s];
>  		list_for_each_entry(counter, &evsel_list->entries, node) {
>  			val = ena = run = 0;
>  			nr = 0;
...
> @@ -1073,14 +1081,20 @@ static void print_stat(int argc, const char **argv)
>  		fprintf(output, ":\n\n");
>  	}
>  
> -	if (aggr_socket)
> -		print_aggr_socket(NULL);
> -	else if (no_aggr) {
> -		list_for_each_entry(counter, &evsel_list->entries, node)
> -			print_counter(counter, NULL);
> -	} else {
> +	switch (aggr_mode) {
> +	case AGGR_SOCKET:
> +		print_aggr(NULL);
> +		break;

This line should look like this IMHO:

		list_for_each_entry(counter, &evsel_list->entries, node)
			print_aggr(counter, NULL);

and the equivalent loop in the print_aggr() should be removed.  This is
for consistency with other formats if multiple events counted.

For instance, it'd sorting on events first and then sockets like:

  #      time socket cpus     counts events
           t0 S0     4        XXXXXX cycles
           t0 S1     4        XXXXXX cycles
           t0 S0     4          YYYY cache-misses
           t0 S1     4          YYYY cache-misses
           t1 S0     4        ZZZZZZ cycles
  ...

But current code looks like sorting on sockets first instead.

  #      time socket cpus     counts events
           t0 S0     4        XXXXXX cycles
           t0 S0     4          YYYY cache-misses
           t0 S1     4        XXXXXX cycles
           t0 S1     4          YYYY cache-misses
           t1 S0     4        ZZZZZZ cycles
  ...

Thanks,
Namhyung


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
