Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3HEFxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 01:53:43 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51695 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3HEFxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 01:53:41 -0400
Message-ID: <51FF3DDA.6080108@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 13:53:30 +0800
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
Subject: Re: [PATCH 5/9] perf kvm: add live mode - v3
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com> <1375473947-64285-6-git-send-email-dsahern@gmail.com>
In-Reply-To: <1375473947-64285-6-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080516-3568-0000-0000-0000040962F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for your nice job! I got some questions.

On 08/03/2013 04:05 AM, David Ahern wrote:

>  static int kvm_events_hash_fn(u64 key)
>  {
>  	return key & (EVENTS_CACHE_SIZE - 1);
> @@ -472,7 +501,11 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
>  	vcpu_record->last_event = NULL;
>  	vcpu_record->start_time = 0;
> 
> -	BUG_ON(timestamp < time_begin);
> +	/* seems to happen once in a while during live mode */
> +	if (timestamp < time_begin) {
> +		pr_debug("End time before begin time; skipping event.\n");
> +		return true;
> +	}

No idea why it can happen. :(

> +static bool verify_vcpu(int vcpu)
> +{
> +	int nr_cpus;
> +
> +	if (vcpu != -1 && vcpu < 0) {
> +		pr_err("Invalid vcpu:%d.\n", vcpu);
> +		return false;
> +	}
> +
> +	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
> +	if ((nr_cpus > 0) && (vcpu > nr_cpus - 1)) {
> +		pr_err("Invalid vcpu:%d.\n", vcpu);
> +		return false;
> +	}

Hmm, kvm can use more vcpus than the cpus on host.

> +static int kvm_events_live(struct perf_kvm_stat *kvm,
> +			   int argc, const char **argv)
> +{
> +	char errbuf[BUFSIZ];
> +	int err;
> +
> +	const struct option live_options[] = {
> +		OPT_STRING('p', "pid", &kvm->opts.target.pid, "pid",
> +			"record events on existing process id"),
> +		OPT_STRING('t', "tid", &kvm->opts.target.tid, "tid",
> +			"record events on existing thread id"),
> +		OPT_STRING('C', "cpu", &kvm->opts.target.cpu_list, "cpu",
> +			"list of host cpus to monitor"),
> +		OPT_UINTEGER('m', "mmap-pages", &kvm->opts.mmap_pages,
> +			"number of mmap data pages"),
> +		OPT_INCR('v', "verbose", &verbose,
> +			"be more verbose (show counter open errors, etc)"),
> +		OPT_BOOLEAN('a', "all-cpus", &kvm->opts.target.system_wide,
> +			"system-wide collection from all CPUs"),
> +		OPT_UINTEGER('d', "display", &kvm->display_time,
> +			"time in seconds between display updates"),
> +		OPT_STRING(0, "event", &kvm->report_event, "report event",
> +			"event for reporting: vmexit, mmio, ioport"),
> +		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
> +			"vcpu id to report"),
> +		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
> +			"key for sorting: sample(sort by samples number)"
> +			" time (sort by avg time)"),

Why we have so many parameters used for tracking. For KVM, we only need to know
1) which guest is tracked and 2) which vcpu in the guest is tracked and 3) what
kind of events. no?

Others look good to me. :)

