Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3HEOtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:49:55 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35014 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3HEOtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:49:53 -0400
Message-ID: <51FFBB8E.2050509@gmail.com>
Date: Mon, 05 Aug 2013 10:49:50 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/9] perf kvm: option to print events that exceed a threshold
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com> <1375473947-64285-8-git-send-email-dsahern@gmail.com> <51FF4891.8060900@linux.vnet.ibm.com>
In-Reply-To: <51FF4891.8060900@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/13 2:39 AM, Xiao Guangrong wrote:
> On 08/03/2013 04:05 AM, David Ahern wrote:
>> This is useful to spot high latency blips.
>
> Yes, it is a good idea.
>
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
>> ---
>>   tools/perf/builtin-kvm.c |   25 +++++++++++++++++++++----
>>   tools/perf/perf.h        |    3 +++
>>   2 files changed, 24 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
>> index 5c6e3cd..28afc05d 100644
>> --- a/tools/perf/builtin-kvm.c
>> +++ b/tools/perf/builtin-kvm.c
>> @@ -106,6 +106,7 @@ struct perf_kvm_stat {
>>   	u64 total_time;
>>   	u64 total_count;
>>   	u64 lost_events;
>> +	u64 threshold;
>>
>>   	struct rb_root result;
>>
>> @@ -470,7 +471,7 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
>>   static bool handle_end_event(struct perf_kvm_stat *kvm,
>>   			     struct vcpu_event_record *vcpu_record,
>>   			     struct event_key *key,
>> -			     u64 timestamp)
>> +			     struct perf_sample *sample)
>>   {
>>   	struct kvm_event *event;
>>   	u64 time_begin, time_diff;
>> @@ -507,12 +508,24 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
>>   	vcpu_record->start_time = 0;
>>
>>   	/* seems to happen once in a while during live mode */
>> -	if (timestamp < time_begin) {
>> +	if (sample->time < time_begin) {
>>   		pr_debug("End time before begin time; skipping event.\n");
>>   		return true;
>>   	}
>>
>> -	time_diff = timestamp - time_begin;
>> +	time_diff = sample->time - time_begin;
>> +
>> +	if (kvm->threshold && time_diff > kvm->threshold) {
>> +		char decode[32];
>> +
>> +		kvm->events_ops->decode_key(kvm, &event->key, decode);
>> +		if (strcmp(decode, "HLT")) {
>> +			pr_info("%" PRIu64 " VM %d, vcpu %d: %s event took %" PRIu64 "usec\n",
>> +				 sample->time, sample->pid, vcpu_record->vcpu_id,
>> +				 decode, time_diff/1000);
>> +		}
>
> Any reason to filter HLT out? it is too frequent? But the info will be missed if
> we're really interested in this event.

It is normal for HLT events to be long duration and by not stripping out 
HLT events you get a flood of messages.

It is abnormal for other kvm-exit events to take considerable time and 
those are the ones to emphasize to a user.

>
> It shows the info when the events is parsed which is not very readable and analyzable,
> can we only record and print the events that cost long time (handle-time > threshould)?

With the existing workflow -- record and then report -- those events are 
dumped prior to the stats output so they can be visible.

With the live mode command the intent is to keep going. The console 
output can be reviewed by scrolling up -- or redirect to a file as well 
with tee. I do both options.

We could add another option -- show the high latency events only and not 
the stats output.

David
