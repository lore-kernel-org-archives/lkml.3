Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3HEGxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:53:44 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:40615 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3HEGxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:53:43 -0400
Message-ID: <51FF4BEA.7070308@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 14:53:30 +0800
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
Subject: Re: [PATCH 8/9] perf kvm: debug for missing vmexit/vmentry event
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com> <1375473947-64285-9-git-send-email-dsahern@gmail.com>
In-Reply-To: <1375473947-64285-9-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080506-8256-0000-0000-000008A791ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 04:05 AM, David Ahern wrote:
> Expected to have missing events for each vcpu when perf is
> started. After that should not have missing events.

Sorry, i can not understand what's this info used for.

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
>  tools/perf/builtin-kvm.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 28afc05d..41dd25a 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -568,11 +568,22 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
>  	    (kvm->trace_vcpu != vcpu_record->vcpu_id))
>  		return true;
> 
> -	if (kvm->events_ops->is_begin_event(evsel, sample, &key))
> +	if (kvm->events_ops->is_begin_event(evsel, sample, &key)) {
> +		if (vcpu_record->start_time) {
> +			pr_debug("consecutive begin events (%s) for pid %d, vcpu %d\n",
> +				 evsel->name, sample->pid, vcpu_record->vcpu_id);
> +		}

This is not true, the ->start_time is set in handle_begin_event() for the new alloced
vcpu_record.

If you just want to know the point where is the first event lost, you can track
it in:

static bool handle_end_event(struct perf_kvm_stat *kvm,
			     struct vcpu_event_record *vcpu_record,
			     struct event_key *key,
			     u64 timestamp)
{
	......

	/* The begin event is not caught. */
	if (!time_begin)                       <======
		return true;

