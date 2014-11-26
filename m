Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaKZNM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:12:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:58614 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbaKZNMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:12:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,462,1413270000"; 
   d="scan'208";a="614352392"
Message-ID: <5475D174.50402@intel.com>
Date: Wed, 26 Nov 2014 15:11:16 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 02/22] perf evlist: Add initial support for mmapping
 an Instruction Trace buffer
References: <1416489808-4489-1-git-send-email-adrian.hunter@intel.com> <1416489808-4489-3-git-send-email-adrian.hunter@intel.com> <20141125165752.GB563@krava.brq.redhat.com>
In-Reply-To: <20141125165752.GB563@krava.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/11/14 18:57, Jiri Olsa wrote:
> On Thu, Nov 20, 2014 at 03:23:08PM +0200, Adrian Hunter wrote:
> 
> SNIP
> 
>> +			bool per_cpu __maybe_unused)
>> +{
>> +}
>> +
>>  static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
>>  {
>>  	if (evlist->mmap[idx].base != NULL) {
>> @@ -731,6 +759,7 @@ static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
>>  		evlist->mmap[idx].base = NULL;
>>  		evlist->mmap[idx].refcnt = 0;
>>  	}
>> +	itrace_mmap__munmap(&evlist->mmap[idx].itrace_mmap);
>>  }
>>  
>>  void perf_evlist__munmap(struct perf_evlist *evlist)
>> @@ -758,6 +787,7 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
>>  struct mmap_params {
>>  	int prot;
>>  	int mask;
>> +	struct itrace_mmap_params itrace_mp;
>>  };
>>  
>>  static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
>> @@ -788,6 +818,10 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
>>  		return -1;
>>  	}
>>  
>> +	if (itrace_mmap__mmap(&evlist->mmap[idx].itrace_mmap,
>> +			      &mp->itrace_mp, evlist->mmap[idx].base, fd))
>> +		return -1;
>> +
> 
> so the itrace mmap is mmaped with right after event mmap for event fd..?

The AUX area support is not implemented yet.  The AUX mmap size and offset
are set through the mmap page via aux_offset and aux_size.

> is there any latest version of kernel changes, so I could check with
> kernel's perf_mmap? hum.. or you just use the same mmap?

I re-based and pushed to:

	git://git.infradead.org/users/ahunter/linux-perf.git

The missing AUX bits are added in this patch:

	http://git.infradead.org/users/ahunter/linux-perf.git/commitdiff/f1be40371b5600a5c4a20f88adff9595bdf5e7ec

