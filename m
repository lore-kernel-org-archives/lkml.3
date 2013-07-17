Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3GQKzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:55:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:2260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab3GQKzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:55:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,683,1367996400"; 
   d="scan'208";a="346954649"
Message-ID: <51E679B0.5030903@intel.com>
Date: Wed, 17 Jul 2013 14:02:08 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V5 12/12] perf tools: add a sample parsing test
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com> <1373548341-24119-13-git-send-email-adrian.hunter@intel.com> <20130716124846.GE9964@krava.brq.redhat.com>
In-Reply-To: <20130716124846.GE9964@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/13 15:48, Jiri Olsa wrote:
> On Thu, Jul 11, 2013 at 04:12:21PM +0300, Adrian Hunter wrote:
>> Add a test that checks that sample parsing is correctly
>> implemented.
> 
> nice!!! :)
> 
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> 
> SNIP
> 
>> +static int do_test(u64 sample_type, u64 sample_regs_user)
>> +{
>> +	struct perf_evsel evsel = {
>> +		.needs_swap = false,
>> +		.attr = {
>> +			.sample_type = sample_type,
>> +			.sample_regs_user = sample_regs_user,
>> +		},
>> +	};
>> +	union perf_event event = {
>> +		.header = {
>> +			.type = PERF_RECORD_SAMPLE,
>> +			.size = sizeof(union perf_event),
>> +		},
>> +	};
> 
> maybe I'm missing something but how does event.sample.array get
> allocated? It's used in perf_event__synthesize_sample func.

'union perf_event' is very big because of 'struct mmap_event' which contains
'char filename[PATH_MAX]' and PATH_MAX is 4096.

> 
> do we need to use something like in the patch below..

Might as well calculate it correctly.

> 
> thanks,
> jirka
> 
> ---
> diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
> index c6e6813..dcbd40d 100644
> --- a/tools/perf/tests/sample-parsing.c
> +++ b/tools/perf/tests/sample-parsing.c
> @@ -111,12 +111,8 @@ static int do_test(u64 sample_type, u64 sample_regs_user)
>  			.sample_regs_user = sample_regs_user,
>  		},
>  	};
> -	union perf_event event = {
> -		.header = {
> -			.type = PERF_RECORD_SAMPLE,
> -			.size = sizeof(union perf_event),
> -		},
> -	};
> +	u64 buf[100];
> +	union perf_event *event = (union perf_event *) buf;
>  	union {
>  		struct ip_callchain callchain;
>  		u64 data[64];
> @@ -162,10 +158,15 @@ static int do_test(u64 sample_type, u64 sample_regs_user)
>  	size_t i;
>  	int err;
>  
> +	event->sample.header = (struct perf_event_header) {
> +		.type = PERF_RECORD_SAMPLE,
> +		.size = sizeof(union perf_event),
> +	};
> +
>  	for (i = 0; i < sizeof(user_regs); i++)
>  		*(u8 *)user_regs = i;
>  
> -	err = perf_event__synthesize_sample(&event, sample_type,
> +	err = perf_event__synthesize_sample(event, sample_type,
>  					    sample_regs_user, &sample, false);
>  	if (err) {
>  		pr_debug("%s failed for sample_type %#"PRIx64", error %d\n",
> @@ -175,7 +176,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user)
>  
>  	evsel.sample_size = __perf_evsel__sample_size(sample_type);
>  
> -	err = perf_evsel__parse_sample(&evsel, &event, &sample_out);
> +	err = perf_evsel__parse_sample(&evsel, event, &sample_out);
>  	if (err) {
>  		pr_debug("%s failed for sample_type %#"PRIx64", error %d\n",
>  			 "perf_evsel__parse_sample", sample_type, err);
> 
> 

