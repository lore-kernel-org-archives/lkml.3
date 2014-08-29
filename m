Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaH2MUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:20:12 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:50877 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaH2MUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:20:10 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf kvm stat: unify print_vcpu_info() for report/live
References: <1409242664-10883-1-git-send-email-yarygin@linux.vnet.ibm.com>
	<53FF69E3.2020501@gmail.com>
Date: Fri, 29 Aug 2014 16:20:03 +0400
In-Reply-To: <53FF69E3.2020501@gmail.com> (David Ahern's message of "Thu, 28
	Aug 2014 11:41:55 -0600")
Message-ID: <87vbpbsd1o.fsf@linux.vnet.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082912-3548-0000-0000-000001300885
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 8/28/14, 10:17 AM, Alexander Yarygin wrote:
>> The print_vcpu_info() function prints title line "Analyze events ..."
>> with a description of the current target. For 'live' option, the
>> output includes "system-wide/specific pids, all vcpus/specific vcpus".
>> Example:
>> $ sudo perf kvm stat live -p 1
>> Analyze events for pid(s) 1, all VCPUs: [..]
>>
>> But for 'report' option the output only contains "all vcpus/specific
>> vcpus":
>> $ sudo perf kvm stat report -p 1
>> Analyze events for all VCPUs: [..]
>>
>> Adding '-a' option for 'stat report' and unifying the print_vcpu_info()
>> function, so it can print complete target info for 'stat report':
>>
>> $ sudo perf kvm stat report -p 1
>> Analyze events for pid(s) 1, all VCPUs: [..]
>
> I did not follow that commit message at all.
>

I'll rephrase.

>>
>> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>> Cc: David Ahern <dsahern@gmail.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Jiri Olsa <jolsa@kernel.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
>> ---
>>   tools/perf/builtin-kvm.c   |   37 ++++++++++++++++++++++++++-----------
>>   tools/perf/util/kvm-stat.h |    1 -
>>   2 files changed, 26 insertions(+), 12 deletions(-)
>>
>> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
>> index 43367eb..ab97920 100644
>> --- a/tools/perf/builtin-kvm.c
>> +++ b/tools/perf/builtin-kvm.c
>> @@ -543,14 +543,12 @@ static void print_vcpu_info(struct perf_kvm_stat *kvm)
>>
>>   	pr_info("Analyze events for ");
>>
>> -	if (kvm->live) {
>> -		if (kvm->opts.target.system_wide)
>> -			pr_info("all VMs, ");
>> -		else if (kvm->opts.target.pid)
>> -			pr_info("pid(s) %s, ", kvm->opts.target.pid);
>> -		else
>> -			pr_info("dazed and confused on what is monitored, ");
>> -	}
>> +	if (kvm->opts.target.system_wide)
>> +		pr_info("all VMs, ");
>> +	else if (kvm->opts.target.pid)
>> +		pr_info("pid(s) %s, ", kvm->opts.target.pid);
>> +	else
>> +		pr_info("dazed and confused on what is monitored, ");
>
> Ah, you are unifying the output -- same title bar for both live and report.
>
>>
>>   	if (vcpu == -1)
>>   		pr_info("all VCPUs:\n\n");
>> @@ -1088,8 +1086,8 @@ static int read_events(struct perf_kvm_stat *kvm)
>>
>>   static int parse_target_str(struct perf_kvm_stat *kvm)
>>   {
>> -	if (kvm->pid_str) {
>> -		kvm->pid_list = intlist__new(kvm->pid_str);
>> +	if (kvm->opts.target.pid) {
>> +		kvm->pid_list = intlist__new(kvm->opts.target.pid);
>>   		if (kvm->pid_list == NULL) {
>>   			pr_err("Error parsing process id string\n");
>>   			return -EINVAL;
>
> And this is an unrelated change. please make it a separate patch.
>
> David
>

Why? These are necessary changes for the output unification part:
print_vcpu_info() looks for a pid string in kvm->opts.target.pid, but
'report' command keeps it in kvm->pid_str instead. It also wants the
kvm->opts.target.system_wide flag, that 'report' doesn't have, so this
patch switches from kvm->pid_str to kvm->opts.target.pid, adds the flag
and enables it by default.

So, should I resend it with 2 patches?

>> @@ -1182,16 +1180,21 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
>>   static int
>>   kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
>>   {
>> +	char errbuf[BUFSIZ];
>> +	int err;
>> +
>>   	const struct option kvm_events_report_options[] = {
>>   		OPT_STRING(0, "event", &kvm->report_event, "report event",
>>   			   "event for reporting: vmexit, "
>>   			   "mmio (x86 only), ioport (x86 only)"),
>> +		OPT_BOOLEAN('a', "all-cpus", &kvm->opts.target.system_wide,
>> +			    "system-wide collection from all CPUs"),
>>   		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
>>   			    "vcpu id to report"),
>>   		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
>>   			    "key for sorting: sample(sort by samples number)"
>>   			    " time (sort by avg time)"),
>> -		OPT_STRING('p', "pid", &kvm->pid_str, "pid",
>> +		OPT_STRING('p', "pid", &kvm->opts.target.pid, "pid",
>>   			   "analyze events only for given process id(s)"),
>>   		OPT_END()
>>   	};
>> @@ -1212,6 +1215,18 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
>>   					   kvm_events_report_options);
>>   	}
>>
>> +	/*
>> +	 * target related setups
>> +	 */
>> +	err = target__validate(&kvm->opts.target);
>> +	if (err) {
>> +		target__strerror(&kvm->opts.target, err, errbuf, BUFSIZ);
>> +		ui__warning("%s", errbuf);
>> +	}
>> +
>> +	if (target__none(&kvm->opts.target))
>> +		kvm->opts.target.system_wide = true;
>> +
>>   	return kvm_events_report_vcpu(kvm);
>>   }
>>
>> diff --git a/tools/perf/util/kvm-stat.h b/tools/perf/util/kvm-stat.h
>> index 0b5a8cd..cf1d7913 100644
>> --- a/tools/perf/util/kvm-stat.h
>> +++ b/tools/perf/util/kvm-stat.h
>> @@ -92,7 +92,6 @@ struct perf_kvm_stat {
>>   	u64 lost_events;
>>   	u64 duration;
>>
>> -	const char *pid_str;
>>   	struct intlist *pid_list;
>>
>>   	struct rb_root result;
>> --
>> 1.7.9.5
>>

