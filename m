Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbaGWN4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:56:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:13427 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbaGWN4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:56:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,717,1400050800"; 
   d="scan'208";a="566048193"
Message-ID: <53CFBEB7.9000903@intel.com>
Date: Wed, 23 Jul 2014 16:55:03 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 49/52] perf tools: Build programs to copy 32-bit compatibility
 VDSOs
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com> <1406035081-14301-50-git-send-email-adrian.hunter@intel.com> <20140723124849.GB1207@krava.brq.redhat.com>
In-Reply-To: <20140723124849.GB1207@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 03:48 PM, Jiri Olsa wrote:
> On Tue, Jul 22, 2014 at 04:17:58PM +0300, Adrian Hunter wrote:
> 
> SNIP
> 
>> index 1f67aa0..45ab040 100644
>> --- a/tools/perf/config/Makefile
>> +++ b/tools/perf/config/Makefile
>> @@ -604,6 +604,27 @@ ifdef HAVE_KVM_STAT_SUPPORT
>>      CFLAGS += -DHAVE_KVM_STAT_SUPPORT
>>  endif
>>  
>> +ifeq (${IS_64_BIT}, 1)
>> +  ifndef NO_PERF_READ_VDSO32
>> +    CAN_DO := $(shell echo "main() {}" | ${CC} -m32 -x c - >/dev/null 2>/dev/null && echo 1 || echo 0)
>> +    ifneq (${CAN_DO}, 1)
>> +      NO_PERF_READ_VDSO32 := 1
>> +    endif
>> +  endif
>> +  ifneq (${IS_X86_64}, 1)
>> +    NO_PERF_READ_VDSOX32 := 1
>> +  endif
>> +  ifndef NO_PERF_READ_VDSOX32
>> +    CAN_DO := $(shell echo 'main() {}' | ${CC} -mx32 -x c - >/dev/null 2>/dev/null && echo 1 || echo 0)
>> +    ifneq (${CAN_DO}, 1)
>> +      NO_PERF_READ_VDSOX32 := 1
>> +    endif
>> +  endif
> 
> please move those check into feature config code under config/features/..

I will look at doing that.

> 
> SNIP
> 
>> +++ b/tools/perf/perf-read-vdso.c
>> @@ -0,0 +1,59 @@
>> +#include <stdio.h>
>> +#include <string.h>
>> +
>> +#define VDSO__MAP_NAME "[vdso]"
>> +
>> +static int find_vdso_map(void **start, void **end)
>> +{
>> +	FILE *maps;
>> +	char line[128];
>> +	int found = 0;
>> +
>> +	maps = fopen("/proc/self/maps", "r");
>> +	if (!maps) {
>> +		fprintf(stderr, "vdso: cannot open maps\n");
>> +		return -1;
>> +	}
>> +
>> +	while (!found && fgets(line, sizeof(line), maps)) {
>> +		int m = -1;
>> +
>> +		/* We care only about private r-x mappings. */
>> +		if (2 != sscanf(line, "%p-%p r-xp %*x %*x:%*x %*u %n",
>> +				start, end, &m))
>> +			continue;
>> +		if (m < 0)
>> +			continue;
>> +
>> +		if (!strncmp(&line[m], VDSO__MAP_NAME,
>> +			     sizeof(VDSO__MAP_NAME) - 1))
>> +			found = 1;
>> +	}
>> +
>> +	fclose(maps);
>> +	return !found;
>> +}
> 
> hum, any easy way to use/share find_vdso_map from vdso.c?
> I guess this way is more straighforward and clear.. it's
> probably not worthy for function this simple

Would have to create another source file and include it.
I am not sure it is worth it.  Maybe Arnaldo can decide?

