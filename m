Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaAIBkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:40:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:17045 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbaAIBkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:40:46 -0500
X-IronPort-AV: E=Sophos;i="4.95,627,1384272000"; 
   d="scan'208";a="9393011"
Message-ID: <52CEB46D.2000008@cn.fujitsu.com>
Date: Thu, 09 Jan 2014 09:38:37 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, dsahern@gmail.com,
        artagnon@gmail.com
Subject: Re: [PATCH 4/8] perf tools: Improve the message of perf list for
 unexpected input.
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com> <f03103f44fd4c4889920ff57f2cb5b6d2aea2435.1388416837.git.yangds.fnst@cn.fujitsu.com> <20140108151637.GC2626@infradead.org>
In-Reply-To: <20140108151637.GC2626@infradead.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 09:39:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 09:39:41,
	Serialize complete at 2014/01/09 09:39:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 10:16 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 30, 2013 at 10:26:39AM -0500, Dongsheng Yang escreveu:
>> Example:
>>          # perf list test
>>
>>          List of pre-defined events (to be used in -e):
>>          # echo $?
>>          0
>>
>> Verification:
>>          # perf list test
>>
>>          No event for test.
> ?
>
> Are we "testing" events?
>
> The message is not clear, I can get some info from looking at the Usage,
> but not from 'No event for test'.
>
> At a minimum 'test' (whatevet invalid type/class is specified and found
> to be invalid/unknown) should be quoted.
>
> Perhaps the message should be along the lines of:
>
> 	# perf list test
>
> 	'test' is not a valid event type, please see the usage below for
> 	acceptable ones.

Makes sense. I will update it.
>
>>          Usage:
>>                  perf list [hw|sw|cache|tracepoint|pmu|event_glob]
>>          # echo $?
>>          255
>>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   tools/perf/builtin-list.c | 25 +++++++++++++++++--------
>>   1 file changed, 17 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
>> index 011195e..fed6792 100644
>> --- a/tools/perf/builtin-list.c
>> +++ b/tools/perf/builtin-list.c
>> @@ -19,6 +19,7 @@
>>   int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>>   {
>>   	int i;
>> +	unsigned int count = 0;
>>   	const struct option list_options[] = {
>>   		OPT_END()
>>   	};
>> @@ -41,26 +42,27 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>>   		if (i)
>>   			putchar('\n');
>>   		if (strncmp(argv[i], "tracepoint", 10) == 0)
>> -			print_tracepoint_events(NULL, NULL, false);
>> +			count += print_tracepoint_events(NULL, NULL, false);
>>   		else if (strcmp(argv[i], "hw") == 0 ||
>>   			 strcmp(argv[i], "hardware") == 0)
>> -			print_events_type(PERF_TYPE_HARDWARE);
>> +			count += print_events_type(PERF_TYPE_HARDWARE);
>>   		else if (strcmp(argv[i], "sw") == 0 ||
>>   			 strcmp(argv[i], "software") == 0)
>> -			print_events_type(PERF_TYPE_SOFTWARE);
>> +			count += print_events_type(PERF_TYPE_SOFTWARE);
>>   		else if (strcmp(argv[i], "cache") == 0 ||
>>   			 strcmp(argv[i], "hwcache") == 0)
>> -			print_hwcache_events(NULL, false);
>> +			count += print_hwcache_events(NULL, false);
>>   		else if (strcmp(argv[i], "pmu") == 0)
>> -			print_pmu_events(NULL, false);
>> +			count += print_pmu_events(NULL, false);
>>   		else if (strcmp(argv[i], "--raw-dump") == 0)
>> -			print_events(NULL, true);
>> +			count += print_events(NULL, true);
>>   		else {
>>   			char *sep = strchr(argv[i], ':'), *s;
>>   			int sep_idx;
>>   
>>   			if (sep == NULL) {
>> -				print_events(argv[i], false);
>> +				if(!(count += print_events(argv[i], false)))
>> +					goto err_out;
>>   				continue;
>>   			}
>>   			sep_idx = sep - argv[i];
>> @@ -69,9 +71,16 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>>   				return -1;
>>   
>>   			s[sep_idx] = '\0';
>> -			print_tracepoint_events(s, s + sep_idx + 1, false);
>> +			if (!(count += print_tracepoint_events(s, s + sep_idx + 1, false)))
>> +				goto err_out;
>>   			free(s);
>>   		}
>>   	}
>> +
>>   	return 0;
>> +
>> +err_out:
>> +	pr_info("\nNo event for %s.\n", argv[i]);
>> +	pr_info("Usage:\n\t%s\n", list_usage[0]);
>> +	return -1;
>>   }
>> -- 
>> 1.8.2.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

