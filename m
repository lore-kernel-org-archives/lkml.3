Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaG0Gbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 02:31:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:10338 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaG0Gbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 02:31:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,741,1400050800"; 
   d="scan'208";a="576023462"
Message-ID: <53D49CC5.80107@intel.com>
Date: Sun, 27 Jul 2014 09:31:33 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 28/52] perf script: Allow callchains if any event samples
 them
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com> <1406035081-14301-29-git-send-email-adrian.hunter@intel.com> <20140725132705.GJ7831@kernel.org>
In-Reply-To: <20140725132705.GJ7831@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/2014 4:27 p.m., Arnaldo Carvalho de Melo wrote:
> Em Tue, Jul 22, 2014 at 04:17:37PM +0300, Adrian Hunter escreveu:
>> perf script was not displaying callchains if any selected
>> event did not have PERF_SAMPLE_CALLCHAIN.  Change this to
>> disable callchains only if all selected events do not have
>> PERF_SAMPLE_CALLCHAIN.
>
> I wonder if some other tool gets this wrong as well, report maybe?

perf report was ok

>
> Perhaps we need to have this check in some perf_evlist method?

Possibly

>
> Wonder how report/top, i.e. the hists browser will react with some
> events having callchains while some don't, specially with this new
> children stuff, Namhyung, can you please check that?
>
> Adrian, can you, in a case like that, provide a command line that
> creates such combo? I.e. how to create a perf.data file with multiple
> events with some having callchains while some don't.

For now, it looks like this is something that only Intel PT will do.
Intel PT decoding can create "instructions" samples that look like they
came from the "instructions" hardware event, and then Intel PT will
optionally synthesize call chains on them as well.

>
> As a rule, it is better to ease reproducing behaviour you mention when
> fixing stuff, so that quickly others can try and go on trying to fix it.
>
> Thanks,
>
> - Arnaldo
>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   tools/perf/builtin-script.c | 17 +++++++++++++----
>>   1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
>> index 582da97..c1a56f2 100644
>> --- a/tools/perf/builtin-script.c
>> +++ b/tools/perf/builtin-script.c
>> @@ -184,10 +184,6 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
>>   		if (perf_evsel__check_stype(evsel, PERF_SAMPLE_IP, "IP",
>>   					    PERF_OUTPUT_IP))
>>   			return -EINVAL;
>> -
>> -		if (!no_callchain &&
>> -		    !(attr->sample_type & PERF_SAMPLE_CALLCHAIN))
>> -			symbol_conf.use_callchain = false;
>>   	}
>>
>>   	if (PRINT_FIELD(ADDR) &&
>> @@ -290,6 +286,19 @@ static int perf_session__check_output_opt(struct perf_session *session)
>>   		set_print_ip_opts(&evsel->attr);
>>   	}
>>
>> +	if (!no_callchain) {
>> +		bool use_callchain = false;
>> +
>> +		evlist__for_each(session->evlist, evsel) {
>> +			if (evsel->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
>> +				use_callchain = true;
>> +				break;
>> +			}
>> +		}
>> +		if (!use_callchain)
>> +			symbol_conf.use_callchain = false;
>> +	}
>> +
>>   	/*
>>   	 * set default for tracepoints to print symbols only
>>   	 * if callchains are present
>> --
>> 1.8.3.2
