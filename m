Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab3LINxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:53:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:25626 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933590Ab3LINw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:52:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,858,1378882800"; 
   d="scan'208";a="446974461"
Message-ID: <52A5CD19.1020207@intel.com>
Date: Mon, 09 Dec 2013 16:00:57 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/4] perf tools: Fix max mmap_pages
References: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com> <1386595120-22978-3-git-send-email-adrian.hunter@intel.com> <20131209133529.GA30360@krava.brq.redhat.com>
In-Reply-To: <20131209133529.GA30360@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/13 15:35, Jiri Olsa wrote:
> On Mon, Dec 09, 2013 at 03:18:38PM +0200, Adrian Hunter wrote:
>> 'SIZE_MAX / page_size' is an upper limit for
>> the maximum number of mmap pages, not a lower
>> limit.  Change the condition accordingly.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/evlist.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>> index 4d0945c..98ec96b 100644
>> --- a/tools/perf/util/evlist.c
>> +++ b/tools/perf/util/evlist.c
>> @@ -754,7 +754,7 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
>>  	unsigned long max = UINT_MAX;
>>  	long pages;
>>  
>> -	if (max < SIZE_MAX / page_size)
>> +	if (max > SIZE_MAX / page_size)
>>  		max = SIZE_MAX / page_size;
> 
> I agree with the change.. but it looks like the check
> is superfluos, maybe we want to define max as:
> 
>    unsigned long max = SIZE_MAX / page_size

I think it is OK because mmap_pages (in struct perf_record_opts) is an
unsigned int i.e.

	max = MIN(UINT_MAX, SIZE_MAX / 4096)

c.f.
			32-bit		64-bit
UINT_MAX		2^32 - 1	2^32 - 1
SIZE_MAX		2^32 - 1	2^64 - 1
SIZE_MAX / 4096		2^20 - 1	2^52 - 1

So on 32-bit the max is SIZE_MAX / 4096 but on
64-bit the max is UINT_MAX

> 
> ?
> 
> jirka
>>  
>>  	pages = parse_pages_arg(str, 1, max);
>> -- 
>> 1.7.11.7
>>
> 
> 

