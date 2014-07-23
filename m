Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaGWGId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:08:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:6094 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaGWGIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:08:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,715,1400050800"; 
   d="scan'208";a="565874332"
Message-ID: <53CF5106.8080100@intel.com>
Date: Wed, 23 Jul 2014 09:07:02 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/52] perf tools: Fix jump label always changing during
 tracing
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com> <1406035081-14301-2-git-send-email-adrian.hunter@intel.com> <20140722140034.GE20303@kernel.org>
In-Reply-To: <20140722140034.GE20303@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 05:00 PM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jul 22, 2014 at 04:17:10PM +0300, Adrian Hunter escreveu:
>> Intel PT decoding walks the object code to reconstruct
>> the trace.  A jump label change during tracing causes
>> decoding errors.
>>
>> The "Enable close-on-exec flag on perf file descriptor"
>> patch caused there to be always a jump label change.
>>
>> It was found that using a per-cpu context instead of a
>> per-thread context for the probe of the close-on-exec
>> feature, made the problem go away.
> 
> And it is ok for our purposes, as this code just needs to figure out if
> PERF_FLAG_FD_CLOEXEC is present, but I wonder when this kind of thing
> will hit again...

Possibly

> 
> Anyway, I'll take this patch.

Thanks!

> 
> - Arnaldo
>  
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/cloexec.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
>> index c5d05ec..6a37be5 100644
>> --- a/tools/perf/util/cloexec.c
>> +++ b/tools/perf/util/cloexec.c
>> @@ -1,3 +1,4 @@
>> +#include <sched.h>
>>  #include "util.h"
>>  #include "../perf.h"
>>  #include "cloexec.h"
>> @@ -14,9 +15,13 @@ static int perf_flag_probe(void)
>>  	};
>>  	int fd;
>>  	int err;
>> +	int cpu = sched_getcpu();
>> +
>> +	if (cpu < 0)
>> +		cpu = 0;
>>  
>>  	/* check cloexec flag */
>> -	fd = sys_perf_event_open(&attr, 0, -1, -1,
>> +	fd = sys_perf_event_open(&attr, -1, cpu, -1,
>>  				 PERF_FLAG_FD_CLOEXEC);
>>  	err = errno;
>>  
>> @@ -30,7 +35,7 @@ static int perf_flag_probe(void)
>>  		  err, strerror(err));
>>  
>>  	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
>> -	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
>> +	fd = sys_perf_event_open(&attr, -1, cpu, -1, 0);
>>  	err = errno;
>>  
>>  	if (WARN_ONCE(fd < 0,
>> -- 
>> 1.8.3.2
> 
> 

