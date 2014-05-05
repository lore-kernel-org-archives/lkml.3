Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbaEEK2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:28:10 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:48623 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbaEEK2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:28:07 -0400
Message-ID: <536767AF.3000907@de.ibm.com>
Date: Mon, 05 May 2014 12:27:59 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH 08/11] perf kvm: allow for variable string sizes
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com> <1398417153-57347-9-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1398417153-57347-9-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050510-5024-0000-0000-000009B30E1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

thanks for the review. 

Are you ok with this change as well? The alternative is to shorten our descriptions (in 1/11 s390: add sie exit reasons tables), which would make the trace output less comprehensible, though.

Christian

On 25/04/14 11:12, Christian Borntraeger wrote:
> From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> 
> This makes it possible for other architectures to decode to different
> string lengths.
> 
> Needed by follow-up patch "perf kvm: add stat support on s390".
> 
> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  tools/perf/builtin-kvm.c | 38 +++++++++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 922706c..806c0e4 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -75,7 +75,7 @@ struct kvm_events_ops {
>  	bool (*is_end_event)(struct perf_evsel *evsel,
>  			     struct perf_sample *sample, struct event_key *key);
>  	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
> -			   char decode[20]);
> +			   char *decode);
>  	const char *name;
>  };
> 
> @@ -84,6 +84,8 @@ struct exit_reasons_table {
>  	const char *reason;
>  };
> 
> +#define DECODE_STR_LEN_MAX 80
> +
>  #define EVENTS_BITS		12
>  #define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
> 
> @@ -101,6 +103,8 @@ struct perf_kvm_stat {
>  	struct exit_reasons_table *exit_reasons;
>  	const char *exit_reasons_isa;
> 
> +	int decode_str_len;
> +
>  	struct kvm_events_ops *events_ops;
>  	key_cmp_fun compare;
>  	struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
> @@ -182,12 +186,12 @@ static const char *get_exit_reason(struct perf_kvm_stat *kvm,
> 
>  static void exit_event_decode_key(struct perf_kvm_stat *kvm,
>  				  struct event_key *key,
> -				  char decode[20])
> +				  char *decode)
>  {
>  	const char *exit_reason = get_exit_reason(kvm, kvm->exit_reasons,
>  						  key->key);
> 
> -	scnprintf(decode, 20, "%s", exit_reason);
> +	scnprintf(decode, kvm->decode_str_len, "%s", exit_reason);
>  }
> 
>  static struct kvm_events_ops exit_events = {
> @@ -249,10 +253,11 @@ static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
> 
>  static void mmio_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
>  				  struct event_key *key,
> -				  char decode[20])
> +				  char *decode)
>  {
> -	scnprintf(decode, 20, "%#lx:%s", (unsigned long)key->key,
> -				key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
> +	scnprintf(decode, kvm->decode_str_len, "%#lx:%s",
> +		  (unsigned long)key->key,
> +		  key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
>  }
> 
>  static struct kvm_events_ops mmio_events = {
> @@ -292,10 +297,11 @@ static bool ioport_event_end(struct perf_evsel *evsel,
> 
>  static void ioport_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
>  				    struct event_key *key,
> -				    char decode[20])
> +				    char *decode)
>  {
> -	scnprintf(decode, 20, "%#llx:%s", (unsigned long long)key->key,
> -				key->info ? "POUT" : "PIN");
> +	scnprintf(decode, kvm->decode_str_len, "%#llx:%s",
> +		  (unsigned long long)key->key,
> +		  key->info ? "POUT" : "PIN");
>  }
> 
>  static struct kvm_events_ops ioport_events = {
> @@ -523,13 +529,13 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
>  	time_diff = sample->time - time_begin;
> 
>  	if (kvm->duration && time_diff > kvm->duration) {
> -		char decode[32];
> +		char decode[DECODE_STR_LEN_MAX];
> 
>  		kvm->events_ops->decode_key(kvm, &event->key, decode);
>  		if (strcmp(decode, "HLT")) {
> -			pr_info("%" PRIu64 " VM %d, vcpu %d: %s event took %" PRIu64 "usec\n",
> +			pr_info("%" PRIu64 " VM %d, vcpu %d: %*s event took %" PRIu64 "usec\n",
>  				 sample->time, sample->pid, vcpu_record->vcpu_id,
> -				 decode, time_diff/1000);
> +				 32, decode, time_diff/1000);
>  		}
>  	}
> 
> @@ -738,7 +744,7 @@ static void show_timeofday(void)
> 
>  static void print_result(struct perf_kvm_stat *kvm)
>  {
> -	char decode[20];
> +	char decode[DECODE_STR_LEN_MAX];
>  	struct kvm_event *event;
>  	int vcpu = kvm->trace_vcpu;
> 
> @@ -749,7 +755,7 @@ static void print_result(struct perf_kvm_stat *kvm)
> 
>  	pr_info("\n\n");
>  	print_vcpu_info(kvm);
> -	pr_info("%20s ", kvm->events_ops->name);
> +	pr_info("%*s ", kvm->decode_str_len, kvm->events_ops->name);
>  	pr_info("%10s ", "Samples");
>  	pr_info("%9s ", "Samples%");
> 
> @@ -768,7 +774,7 @@ static void print_result(struct perf_kvm_stat *kvm)
>  		min = get_event_min(event, vcpu);
> 
>  		kvm->events_ops->decode_key(kvm, &event->key, decode);
> -		pr_info("%20s ", decode);
> +		pr_info("%*s ", kvm->decode_str_len, decode);
>  		pr_info("%10llu ", (unsigned long long)ecount);
>  		pr_info("%8.2f%% ", (double)ecount / kvm->total_count * 100);
>  		pr_info("%8.2f%% ", (double)etime / kvm->total_time * 100);
> @@ -839,9 +845,11 @@ static int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid)
>  	if (strstr(cpuid, "Intel")) {
>  		kvm->exit_reasons = vmx_exit_reasons;
>  		kvm->exit_reasons_isa = "VMX";
> +		kvm->decode_str_len = 20;
>  	} else if (strstr(cpuid, "AMD")) {
>  		kvm->exit_reasons = svm_exit_reasons;
>  		kvm->exit_reasons_isa = "SVM";
> +		kvm->decode_str_len = 20;
>  	} else {
>  		pr_err("CPU %s is not supported.\n", cpuid);
>  		return -ENOTSUP;
> 

