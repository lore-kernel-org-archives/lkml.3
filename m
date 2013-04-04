Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663Ab3DDAtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:49:22 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65252 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761367Ab3DDAtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:49:21 -0400
X-AuditID: 9c930197-b7b50ae00000018c-70-515cce0cb1b8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 03/10] perf sort: Add 'addr' sort key
References: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
	<1364991979-3008-4-git-send-email-namhyung@kernel.org>
	<20130403170610.GA5493@ghostprotocols.net>
Date: Thu, 04 Apr 2013 09:49:16 +0900
In-Reply-To: <20130403170610.GA5493@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 3 Apr 2013 14:06:10 -0300")
Message-ID: <87ppybdss3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 3 Apr 2013 14:06:10 -0300, Arnaldo Carvalho de Melo wrote:
> What I expected was that the result was this:
>
> perf report --sort addr | grep -v ^# | sort -k2 -n | less
>
> And in hexadecimal, can you fix this?

Oops, it was a mistake in the last minute change, sorry. :(

>
> Em Wed, Apr 03, 2013 at 09:26:12PM +0900, Namhyung Kim escreveu:
>>  static void hists__set_unres_dso_col_len(struct hists *hists, int dso)
>> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
>> index 14c2fe20aa62..9599f805828f 100644
>> --- a/tools/perf/util/hist.h
>> +++ b/tools/perf/util/hist.h
>> @@ -43,12 +43,13 @@ enum hist_column {
>>  	HISTC_COMM,
>>  	HISTC_PARENT,
>>  	HISTC_CPU,
>> +	HISTC_SRCLINE,
>
> Why move SRCLINE?

Because it's in common dimension.  I'd like to separate it to give a
consistent view.

Thanks,
Namhyung

>
>> +	HISTC_ADDR,
>>  	HISTC_MISPREDICT,
>>  	HISTC_SYMBOL_FROM,
>>  	HISTC_SYMBOL_TO,
>>  	HISTC_DSO_FROM,
>>  	HISTC_DSO_TO,
>> -	HISTC_SRCLINE,
>>  	HISTC_LOCAL_WEIGHT,
>>  	HISTC_GLOBAL_WEIGHT,
>>  	HISTC_MEM_DADDR_SYMBOL,
>> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
>> index 1dbf16949250..5640a95b3575 100644
>> --- a/tools/perf/util/sort.c
>> +++ b/tools/perf/util/sort.c
>> @@ -342,6 +342,34 @@ struct sort_entry sort_cpu = {
>>  	.se_width_idx	= HISTC_CPU,
>>  };
>>  
>> +/* --sort addr */
>> +
>> +static int64_t
>> +sort__addr_cmp(struct hist_entry *left, struct hist_entry *right)
>> +{
>> +	return right->ip - left->ip;
>> +}
>> +
>> +static int hist_entry__addr_snprintf(struct hist_entry *self, char *bf,
>> +				     size_t size, unsigned int width)
>> +{
>> +	struct map *map = self->ms.map;
>> +	u64 addr = self->ip;
>> +
>> +	if (map)
>> +		addr = map->unmap_ip(map, self->ip);
>> +
>> +	return repsep_snprintf(bf, size, "%#*llu", width, addr);
>> +}
>> +
>> +struct sort_entry sort_addr = {
>> +	.se_header      = "Address",
>> +	.se_cmp	        = sort__addr_cmp,
>> +	.se_snprintf    = hist_entry__addr_snprintf,
>> +	.se_width_idx	= HISTC_ADDR,
>> +};
>> +
>> +
>>  /* sort keys for branch stacks */
>>  
>>  static int64_t
>> @@ -871,6 +899,7 @@ static struct sort_dimension common_sort_dimensions[] = {
>>  	DIM(SORT_PARENT, "parent", sort_parent),
>>  	DIM(SORT_CPU, "cpu", sort_cpu),
>>  	DIM(SORT_SRCLINE, "srcline", sort_srcline),
>> +	DIM(SORT_ADDR, "addr", sort_addr),
>>  };
>>  
>>  #undef DIM
>> diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
>> index 0232d476da87..0815e344f38c 100644
>> --- a/tools/perf/util/sort.h
>> +++ b/tools/perf/util/sort.h
>> @@ -138,6 +138,7 @@ enum sort_type {
>>  	SORT_PARENT,
>>  	SORT_CPU,
>>  	SORT_SRCLINE,
>> +	SORT_ADDR,
>>  
>>  	/* branch stack specific sort keys */
>>  	__SORT_BRANCH_STACK,
>> -- 
>> 1.7.11.7
