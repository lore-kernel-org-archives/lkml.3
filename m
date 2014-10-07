Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbaJGGY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 02:24:59 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35296 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaJGGY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 02:24:58 -0400
Message-ID: <5433872B.1080405@linux.vnet.ibm.com>
Date: Tue, 07 Oct 2014 11:54:43 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v2 4/5] perf/sdt: Delete SDT events from cache
References: <20141001023723.28985.39736.stgit@hemant-fedora> <20141001024834.28985.5943.stgit@hemant-fedora> <87egukh8lq.fsf@sejong.aot.lge.com>
In-Reply-To: <87egukh8lq.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100706-5140-0000-0000-000000619218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/07/2014 08:47 AM, Namhyung Kim wrote:
> On Wed, 01 Oct 2014 08:18:41 +0530, Hemant Kumar wrote:
>> This patch adds the support to delete SDT events from the cache.
>> To delete an event corresponding to a file, first the cache is read into
>> the file_hash list. The key is calculated from the file name.
>> And then, the file_list for that file_hash entry is traversed to find out
>> the target file_list entry. Once, it is found, its contents are all freed up.
>>
>> # ./perf sdt-cache --del /usr/lib64/libc-2.16.so
>>
>> 8 events removed for /usr/lib64/libc-2.16.so!
>>
>> Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
>> ---
>>   tools/perf/builtin-sdt-cache.c |   28 +++++++++++++++++++++++++++-
>>   tools/perf/util/parse-events.h |    1 +
>>   tools/perf/util/sdt.c          |   35 +++++++++++++++++++++++++++++++++++
>>   3 files changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/builtin-sdt-cache.c b/tools/perf/builtin-sdt-cache.c
>> index 5faf8e5..12276da 100644
>> --- a/tools/perf/builtin-sdt-cache.c
>> +++ b/tools/perf/builtin-sdt-cache.c
>> @@ -16,6 +16,7 @@
>>   /* Session management structure */
>>   static struct {
>>   	bool add;
>> +	bool del;
>>   	bool dump;
>>   	const char *target;
>>   } params;
>> @@ -29,6 +30,15 @@ static int opt_add_sdt_events(const struct option *opt __maybe_unused,
>>   	return 0;
>>   }
>>   
>> +static int opt_del_sdt_events(const struct option *opt __maybe_unused,
>> +			      const char *str, int unset __maybe_unused)
>> +{
>> +	params.del = true;
>> +	params.target = str;
>> +
>> +	return 0;
>> +}
>> +
>>   static int opt_show_sdt_events(const struct option *opt __maybe_unused,
>>   			       const char *str, int unset __maybe_unused)
>>   {
>> @@ -45,13 +55,17 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
>>   		OPT_CALLBACK('a', "add", NULL, "filename",
>>   			     "add SDT events from a file.",
>>   			     opt_add_sdt_events),
>> +		OPT_CALLBACK('d', "del", NULL, "filename",
>> +			     "Remove SDT events corresponding to a file from the"
>> +			     " sdt cache.",
>> +			     opt_del_sdt_events),
>>   		OPT_CALLBACK_NOOPT('s', "dump", NULL, "show SDT events",
>>   				   "Read SDT events from cache and display.",
>>   				   opt_show_sdt_events),
>>   		OPT_END()
>>   	};
>>   	const char * const sdt_cache_usage[] = {
>> -		"perf sdt_cache [--add filename | --dump]",
>> +		"perf sdt_cache [--add filename | --del filename | --dump]",
> I think it'd be better split the usage into two lines:
>
> 		"perf sdt_cache [--add | --del] <filename>"
> 		"perf sdt_cache --dump"

Nice suggestion. Will change that.

>
>>   		NULL
>>   	};
>>   
>> @@ -63,6 +77,10 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
>>   
>>   	symbol__elf_init();
>>   	if (params.add) {
>> +		if (params.del) {
>> +			pr_err("Error: Don't use --del with --add\n");
>> +			usage_with_options(sdt_cache_usage, sdt_cache_options);
>> +		}
>>   		if (params.dump) {
>>   			pr_err("Error: Don't use --dump with --add\n");
>>   			usage_with_options(sdt_cache_usage, sdt_cache_options);
>> @@ -70,6 +88,14 @@ int cmd_sdt_cache(int argc, const char **argv, const char *prefix __maybe_unused
>>   		ret = add_sdt_events(params.target);
>>   		if (ret < 0)
>>   			pr_err("Cannot add SDT events to cache!\n");
>> +	} else if (params.del) {
>> +		if (params.dump) {
>> +			pr_err("Error: Don't use --dump with --del\n");
>> +			usage_with_options(sdt_cache_usage, sdt_cache_options);
>> +		}
>> +		ret = remove_sdt_events(params.target);
>> +		if (ret < 0)
>> +			pr_err("Cannot remove SDT events from cache!\n");
>>   	} else if (params.dump) {
>>   		if (argc == 0) {
>>   			ret = dump_sdt_events();
> I think we need to a flag for exclusive options so that it can emit
> warnings like this automatically during option parsing.

Ok.

> Thanks,
> Namhyung
>
> [...]

-- 
Thanks,
Hemant Kumar

