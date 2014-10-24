Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbaJXOgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:36:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:38639 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaJXOgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,780,1406617200"; 
   d="scan'208";a="595291928"
Message-ID: <544A63FE.60902@intel.com>
Date: Fri, 24 Oct 2014 17:36:46 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/16] perf pmu: Let pmu's with no events show up on perf
 list
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com> <1414061124-26830-3-git-send-email-adrian.hunter@intel.com> <87y4s6cak7.fsf@sejong.aot.lge.com> <20141024125702.GZ14687@kernel.org> <20141024130320.GA14687@kernel.org> <20141024132141.GB14687@kernel.org>
In-Reply-To: <20141024132141.GB14687@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/2014 4:21 p.m., Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 24, 2014 at 10:03:20AM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Fri, Oct 24, 2014 at 09:57:02AM -0300, Arnaldo Carvalho de Melo escreveu:
>>> Em Fri, Oct 24, 2014 at 02:15:52PM +0900, Namhyung Kim escreveu:
>>>> On Thu, 23 Oct 2014 13:45:10 +0300, Adrian Hunter wrote:
>>>>> +		if (pmu->selectable) {
>>>>> +			scnprintf(buf, sizeof(buf), "%s//", pmu->name);
>>>>> +			aliases[j] = strdup(buf);
>>>>
>>>> You need to check the return value here (and above too).
>>>
>>> Well spotted, fixing this up.
>>
>> Oh well, this print_pmu_events() function needs some care, it starts by
>> trying to alloc the array, if it fails, it silently returns, does that
>> mean that there are no pmu events? Or that memory allocation failed?
>>
>> Ok, will do the fixes in a separate patch...
>>
>> - Arnaldo
>
> The patch below should check everything and warn the user, even
> maintaining that void return...
>
> Acked-by tags welcome as always :-)
>
> - Arnaldo
>
>
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 91dca60..881b754 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -753,9 +753,9 @@ void print_pmu_events(const char *event_glob, bool name_only)
>   		if (pmu->selectable)
>   			len++;
>   	}
> -	aliases = malloc(sizeof(char *) * len);
> +	aliases = zalloc(sizeof(char *) * len);
>   	if (!aliases)
> -		return;
> +		goto out_enomem;

That path tries to free aliases[j] but aliases is null.  You could set len to 0 in that case.

>   	pmu = NULL;
>   	j = 0;
>   	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
> @@ -768,16 +768,20 @@ void print_pmu_events(const char *event_glob, bool name_only)
>   			      (!is_cpu && strglobmatch(alias->name,
>   						       event_glob))))
>   				continue;
> -			aliases[j] = name;
> +
>   			if (is_cpu && !name_only)
> -				aliases[j] = format_alias_or(buf, sizeof(buf),
> -							      pmu, alias);
> -			aliases[j] = strdup(aliases[j]);
> +				name = format_alias_or(buf, sizeof(buf), pmu, alias);
> +
> +			aliases[j] = strdup(name);
> +			if (aliases[j] == NULL)
> +				goto out_enomem;
>   			j++;
>   		}
>   		if (pmu->selectable) {
> -			scnprintf(buf, sizeof(buf), "%s//", pmu->name);
> -			aliases[j] = strdup(buf);
> +			char *s;
> +			if (asprintf(&s, "%s//", pmu->name) < 0)
> +				goto out_enomem;
> +			aliases[j] = s;
>   			j++;
>   		}
>   	}
> @@ -789,12 +793,20 @@ void print_pmu_events(const char *event_glob, bool name_only)
>   			continue;
>   		}
>   		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
> -		zfree(&aliases[j]);
>   		printed++;
>   	}
>   	if (printed)
>   		printf("\n");
> -	free(aliases);
> +out_free:
> +	for (j = 0; j < len; j++)
> +		zfree(&aliases[j]);
> +	zfree(&aliases);
> +	return;
> +
> +out_enomem:
> +	printf("FATAL: not enough memory to print PMU events\n");
> +	if (aliases)
> +		goto out_free;
>   }
>
>   bool pmu_have_event(const char *pname, const char *name)
>
