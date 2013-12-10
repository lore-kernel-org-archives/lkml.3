Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab3LJG5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:57:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:62002 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab3LJG5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:57:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,864,1378882800"; 
   d="scan'208";a="422123870"
Message-ID: <52A6BD34.60006@intel.com>
Date: Tue, 10 Dec 2013 09:05:24 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH V2 3/3] perf script: Improve srcline display for BTS
References: <1386315778-11633-1-git-send-email-adrian.hunter@intel.com> <1386315778-11633-4-git-send-email-adrian.hunter@intel.com> <20131209180441.GA8098@ghostprotocols.net> <52A6BCE0.9010805@intel.com>
In-Reply-To: <52A6BCE0.9010805@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/13 09:04, Adrian Hunter wrote:
> On 09/12/13 20:04, Arnaldo Carvalho de Melo wrote:
>> Em Fri, Dec 06, 2013 at 09:42:58AM +0200, Adrian Hunter escreveu:
>>> Change the order of the output to put the srcline last.
>>> e.g. old format:
>>
>> Can you please always provide the command line used, so that people can
>> quickly reproduce your results, before and after your changes?
> 
> OK
> 
> perf record -e branches:u -c 1 -d ls
> 
> perf script -fip,sym,symoff,addr,srcline

Oops missed dso.  That should be:

	perf script -fip,sym,symoff,dso,addr,srcline

> 
>>
>> - Arnaldo
>>  
>>>           4028fc main+0x2c (/bin/ls)
>>>   /build/buildd/coreutils-8.20/src/ls.c:1269 =>           40d8a0 set_program_name+0x0 (/bin/ls)
>>>
>>> new format:
>>>
>>>           4028fc main+0x2c (/bin/ls) =>           40d8a0 set_program_name+0x0 (/bin/ls)
>>>   /build/buildd/coreutils-8.20/src/ls.c:1269
>>>
>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>>> ---
>>>  tools/perf/builtin-script.c | 20 +++++++++++++++-----
>>>  1 file changed, 15 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
>>> index 7a571fb..8997b69 100644
>>> --- a/tools/perf/builtin-script.c
>>> +++ b/tools/perf/builtin-script.c
>>> @@ -428,15 +428,22 @@ static void print_sample_bts(union perf_event *event,
>>>  			     struct addr_location *al)
>>>  {
>>>  	struct perf_event_attr *attr = &evsel->attr;
>>> +	bool print_srcline_last = false;
>>>  
>>>  	/* print branch_from information */
>>>  	if (PRINT_FIELD(IP)) {
>>> -		if (!symbol_conf.use_callchain)
>>> -			printf(" ");
>>> -		else
>>> +		unsigned int print_opts = output[attr->type].print_ip_opts;
>>> +
>>> +		if (symbol_conf.use_callchain && sample->callchain) {
>>>  			printf("\n");
>>> -		perf_evsel__print_ip(evsel, sample, machine, al,
>>> -				     output[attr->type].print_ip_opts,
>>> +		} else {
>>> +			printf(" ");
>>> +			if (print_opts & PRINT_IP_OPT_SRCLINE) {
>>> +				print_srcline_last = true;
>>> +				print_opts &= ~PRINT_IP_OPT_SRCLINE;
>>> +			}
>>> +		}
>>> +		perf_evsel__print_ip(evsel, sample, machine, al, print_opts,
>>>  				     PERF_MAX_STACK_DEPTH);
>>>  	}
>>>  
>>> @@ -448,6 +455,9 @@ static void print_sample_bts(union perf_event *event,
>>>  	     !output[attr->type].user_set))
>>>  		print_sample_addr(event, sample, machine, thread, attr);
>>>  
>>> +	if (print_srcline_last)
>>> +		map__fprintf_srcline(al->map, al->addr, "\n  ", stdout);
>>> +
>>>  	printf("\n");
>>>  }
>>>  
>>> -- 
>>> 1.7.11.7
>>
>>
> 
> 
> 

