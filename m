Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3HEGJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:09:21 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51355 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3HEGJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:09:19 -0400
Message-ID: <51FF4184.30501@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 14:09:08 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] perf kvm: add min and max stats to display
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com> <1375473947-64285-7-git-send-email-dsahern@gmail.com>
In-Reply-To: <1375473947-64285-7-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080505-6102-0000-0000-000003F80FFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 04:05 AM, David Ahern wrote:
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
> ---
>  tools/perf/builtin-kvm.c |   21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 12f7593..5c6e3cd 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -337,14 +337,19 @@ static void clear_events_cache_stats(struct list_head *kvm_events_cache)
>  	struct list_head *head;
>  	struct kvm_event *event;
>  	unsigned int i;
> +	int j;
> 
>  	for (i = 0; i < EVENTS_CACHE_SIZE; i++) {
>  		head = &kvm_events_cache[i];
>  		list_for_each_entry(event, head, hash_entry) {
>  			/* reset stats for event */
> -			memset(&event->total, 0, sizeof(event->total));
> -			memset(event->vcpu, 0,
> -			       event->max_vcpu * sizeof(*event->vcpu));
> +			event->total.time = 0;
> +			init_stats(&event->total.stats);
> +
> +			for (j = 0; j < event->max_vcpu; ++j) {
> +				event->vcpu[j].time = 0;
> +				init_stats(&event->vcpu[j].stats);
> +			}
>  		}
>  	}
>  }
> @@ -718,6 +723,7 @@ static void print_result(struct perf_kvm_stat *kvm)
>  	char decode[20];
>  	struct kvm_event *event;
>  	int vcpu = kvm->trace_vcpu;
> +	struct kvm_event_stats *kvm_stats;
> 
>  	if (kvm->live) {
>  		puts(CONSOLE_CLEAR);
> @@ -731,6 +737,8 @@ static void print_result(struct perf_kvm_stat *kvm)
>  	pr_info("%9s ", "Samples%");
> 
>  	pr_info("%9s ", "Time%");
> +	pr_info("%10s ", "Min Time");
> +	pr_info("%10s ", "Max Time");
>  	pr_info("%16s ", "Avg time");
>  	pr_info("\n\n");
> 
> @@ -740,11 +748,18 @@ static void print_result(struct perf_kvm_stat *kvm)
>  		ecount = get_event_count(event, vcpu);
>  		etime = get_event_time(event, vcpu);
> 
> +		if (vcpu == -1)
> +			kvm_stats = &event->total;
> +		else
> +			kvm_stats = &event->vcpu[vcpu];

Can introduce a function to do it like get_event_count()/get_event_time()?

And the min/max value are updated in patch 2, so others look good to me:
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

