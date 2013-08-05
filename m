Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3HEGj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:39:27 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:44449 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3HEGjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:39:24 -0400
Message-ID: <51FF4891.8060900@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 14:39:13 +0800
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
Subject: Re: [PATCH 7/9] perf kvm: option to print events that exceed a threshold
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com> <1375473947-64285-8-git-send-email-dsahern@gmail.com>
In-Reply-To: <1375473947-64285-8-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080506-3864-0000-0000-0000096B12FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 04:05 AM, David Ahern wrote:
> This is useful to spot high latency blips.

Yes, it is a good idea.

> 
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
>  tools/perf/builtin-kvm.c |   25 +++++++++++++++++++++----
>  tools/perf/perf.h        |    3 +++
>  2 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 5c6e3cd..28afc05d 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -106,6 +106,7 @@ struct perf_kvm_stat {
>  	u64 total_time;
>  	u64 total_count;
>  	u64 lost_events;
> +	u64 threshold;
> 
>  	struct rb_root result;
> 
> @@ -470,7 +471,7 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
>  static bool handle_end_event(struct perf_kvm_stat *kvm,
>  			     struct vcpu_event_record *vcpu_record,
>  			     struct event_key *key,
> -			     u64 timestamp)
> +			     struct perf_sample *sample)
>  {
>  	struct kvm_event *event;
>  	u64 time_begin, time_diff;
> @@ -507,12 +508,24 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
>  	vcpu_record->start_time = 0;
> 
>  	/* seems to happen once in a while during live mode */
> -	if (timestamp < time_begin) {
> +	if (sample->time < time_begin) {
>  		pr_debug("End time before begin time; skipping event.\n");
>  		return true;
>  	}
> 
> -	time_diff = timestamp - time_begin;
> +	time_diff = sample->time - time_begin;
> +
> +	if (kvm->threshold && time_diff > kvm->threshold) {
> +		char decode[32];
> +
> +		kvm->events_ops->decode_key(kvm, &event->key, decode);
> +		if (strcmp(decode, "HLT")) {
> +			pr_info("%" PRIu64 " VM %d, vcpu %d: %s event took %" PRIu64 "usec\n",
> +				 sample->time, sample->pid, vcpu_record->vcpu_id,
> +				 decode, time_diff/1000);
> +		}

Any reason to filter HLT out? it is too frequent? But the info will be missed if
we're really interested in this event.

It shows the info when the events is parsed which is not very readable and analyzable,
can we only record and print the events that cost long time (handle-time > threshould)?

