Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaGWOB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:01:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:36961 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaGWOB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:01:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,717,1400050800"; 
   d="scan'208";a="566050425"
Message-ID: <53CFBFCB.90303@intel.com>
Date: Wed, 23 Jul 2014 16:59:39 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 52/52] perf tools: Add support for 32-bit compatibility
 VDSOs
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com> <1406035081-14301-53-git-send-email-adrian.hunter@intel.com> <20140723130215.GC1207@krava.brq.redhat.com>
In-Reply-To: <20140723130215.GC1207@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 04:02 PM, Jiri Olsa wrote:
> On Tue, Jul 22, 2014 at 04:18:01PM +0300, Adrian Hunter wrote:
>> 'perf record' post-processes the event stream  to create
>> a list of build-ids for object files for which sample
>> events have been recorded.  That results in those object
>> files being recorded in the build-id cache.
> 
> SNIP
> 
>>  
>>  	if (vdso_info->vdso.found)
>>  		unlink(vdso_info->vdso.temp_file_name);
>> +#if BITS_PER_LONG == 64
>> +	if (vdso_info->vdso32.found)
>> +		unlink(vdso_info->vdso.temp_file_name);
>> +	if (vdso_info->vdsox32.found)
>> +		unlink(vdso_info->vdso.temp_file_name);
>> +#endif
>>  
>>  	zfree(&machine->vdso_info);
>>  }
>> @@ -135,6 +159,143 @@ static struct dso *vdso__new(struct machine *machine, const char *short_name,
>>  	return dso;
>>  }
>>  
>> +#if BITS_PER_LONG == 64
> 
> Does this define mean all 64 archs? Do we want other than x86 in here?
> (all of its instances)

Any 64-bit arch can have 32-bit compatibility VDSOs.  This should
be OK for other arches too.

> 
> jirka
> 
>> +
>> +static enum dso_type machine__thread_dso_type(struct machine *machine,
>> +					      struct thread *thread)
>> +{
>> +	enum dso_type dso_type = DSO__TYPE_UNKNOWN;
>> +	struct map *map;
>> +	struct dso *dso;
>> +
>> +	map = map_groups__first(thread->mg, MAP__FUNCTION);
>> +	for (; map ; map = map_groups__next(map)) {
>> +		dso = map->dso;
>> +		if (!dso || dso->long_name[0] != '/')
>> +			continue;
>> +		dso_type = dso__type(dso, machine);
>> +		if (dso_type != DSO__TYPE_UNKNOWN)
>> +			break;
>> +	}
>> +
>> +	return dso_type;
>> +}
> 
> SNIP
> 
> 

