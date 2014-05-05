Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaEEP3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:29:47 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33589 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaEEP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:29:45 -0400
Message-ID: <5367AE6B.8050303@gmail.com>
Date: Mon, 05 May 2014 09:29:47 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH 08/11] perf kvm: allow for variable string sizes
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com> <1398417153-57347-9-git-send-email-borntraeger@de.ibm.com> <536767AF.3000907@de.ibm.com>
In-Reply-To: <536767AF.3000907@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/14, 4:27 AM, Christian Borntraeger wrote:
>> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
>> index 922706c..806c0e4 100644
>> --- a/tools/perf/builtin-kvm.c
>> +++ b/tools/perf/builtin-kvm.c
>> @@ -75,7 +75,7 @@ struct kvm_events_ops {
>>   	bool (*is_end_event)(struct perf_evsel *evsel,
>>   			     struct perf_sample *sample, struct event_key *key);
>>   	void (*decode_key)(struct perf_kvm_stat *kvm, struct event_key *key,
>> -			   char decode[20]);
>> +			   char *decode);
>>   	const char *name;
>>   };
>>
>> @@ -84,6 +84,8 @@ struct exit_reasons_table {
>>   	const char *reason;
>>   };
>>
>> +#define DECODE_STR_LEN_MAX 80
>> +
>>   #define EVENTS_BITS		12
>>   #define EVENTS_CACHE_SIZE	(1UL << EVENTS_BITS)
>>
>> @@ -101,6 +103,8 @@ struct perf_kvm_stat {
>>   	struct exit_reasons_table *exit_reasons;
>>   	const char *exit_reasons_isa;
>>
>> +	int decode_str_len;
>> +

This should not be a part of the perf_kvm_stat struct. Just leave it as 
a macro and use DECODE_STR_LEN_MAX in place of 20. Which means 
DECODE_STR_LEN_MAX needs to be 20 in this patch, and arch specific in 
the follow up patch.

>>   	struct kvm_events_ops *events_ops;
>>   	key_cmp_fun compare;
>>   	struct list_head kvm_events_cache[EVENTS_CACHE_SIZE];
>> @@ -182,12 +186,12 @@ static const char *get_exit_reason(struct perf_kvm_stat *kvm,
>>
>>   static void exit_event_decode_key(struct perf_kvm_stat *kvm,
>>   				  struct event_key *key,
>> -				  char decode[20])
>> +				  char *decode)
>>   {
>>   	const char *exit_reason = get_exit_reason(kvm, kvm->exit_reasons,
>>   						  key->key);
>>
>> -	scnprintf(decode, 20, "%s", exit_reason);
>> +	scnprintf(decode, kvm->decode_str_len, "%s", exit_reason);
>>   }
>>
>>   static struct kvm_events_ops exit_events = {
>> @@ -249,10 +253,11 @@ static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
>>
>>   static void mmio_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
>>   				  struct event_key *key,
>> -				  char decode[20])
>> +				  char *decode)
>>   {
>> -	scnprintf(decode, 20, "%#lx:%s", (unsigned long)key->key,
>> -				key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
>> +	scnprintf(decode, kvm->decode_str_len, "%#lx:%s",
>> +		  (unsigned long)key->key,
>> +		  key->info == KVM_TRACE_MMIO_WRITE ? "W" : "R");
>>   }
>>
>>   static struct kvm_events_ops mmio_events = {
>> @@ -292,10 +297,11 @@ static bool ioport_event_end(struct perf_evsel *evsel,
>>
>>   static void ioport_event_decode_key(struct perf_kvm_stat *kvm __maybe_unused,
>>   				    struct event_key *key,
>> -				    char decode[20])
>> +				    char *decode)
>>   {
>> -	scnprintf(decode, 20, "%#llx:%s", (unsigned long long)key->key,
>> -				key->info ? "POUT" : "PIN");
>> +	scnprintf(decode, kvm->decode_str_len, "%#llx:%s",
>> +		  (unsigned long long)key->key,
>> +		  key->info ? "POUT" : "PIN");
>>   }
>>
>>   static struct kvm_events_ops ioport_events = {
>> @@ -523,13 +529,13 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
>>   	time_diff = sample->time - time_begin;
>>
>>   	if (kvm->duration && time_diff > kvm->duration) {
>> -		char decode[32];
>> +		char decode[DECODE_STR_LEN_MAX];
>>
>>   		kvm->events_ops->decode_key(kvm, &event->key, decode);
>>   		if (strcmp(decode, "HLT")) {
>> -			pr_info("%" PRIu64 " VM %d, vcpu %d: %s event took %" PRIu64 "usec\n",
>> +			pr_info("%" PRIu64 " VM %d, vcpu %d: %*s event took %" PRIu64 "usec\n",
>>   				 sample->time, sample->pid, vcpu_record->vcpu_id,
>> -				 decode, time_diff/1000);
>> +				 32, decode, time_diff/1000);

This pr_info does not need the length.

David
