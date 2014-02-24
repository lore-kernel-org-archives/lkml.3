Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaBXGhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 01:37:19 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57820 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaBXGhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 01:37:17 -0500
X-AuditID: 9c93016f-b7c65ae000004a2a-f8-530ae89aa15c
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/8] perf report: Add --percentage option
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
	<1392000446-14744-4-git-send-email-namhyung@kernel.org>
	<20140220103950.GA11018@krava.brq.redhat.com>
Date: Mon, 24 Feb 2014 15:37:14 +0900
In-Reply-To: <20140220103950.GA11018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 20 Feb 2014 11:39:50 +0100")
Message-ID: <87mwhhvwx1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 20 Feb 2014 11:39:50 +0100, Jiri Olsa wrote:
> On Mon, Feb 10, 2014 at 11:47:20AM +0900, Namhyung Kim wrote:
>> The --percentage option is for controlling overhead percentage
>> displayed.  It can only receive either of "relative" or "absolute".
>> 
>> "relative" means it's relative to filtered entries only so that the
>> sum of shown entries will be always 100%.  "absolute" means it retains
>> the original value before and after the filter is applied.
>
> SNIP
>
>> diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
>> index 78f4c92e9b73..714f3f00ea55 100644
>> --- a/tools/perf/ui/hist.c
>> +++ b/tools/perf/ui/hist.c
>> @@ -21,10 +21,13 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
>>  
>>  	if (fmt_percent) {
>>  		double percent = 0.0;
>> +		u64 total = hists->stats.total_period;
>>  
>> -		if (hists->stats.total_period)
>> -			percent = 100.0 * get_field(he) /
>> -				  hists->stats.total_period;
>> +		if (symbol_conf.filter_relative)
>> +			total = hists->stats.total_filtered_period;
>> +
>> +		if (total)
>> +			percent = 100.0 * get_field(he) / total;
>>  
>>  		ret = print_fn(hpp->buf, hpp->size, fmt, percent);
>>  	} else
>> @@ -41,6 +44,9 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
>>  			u64 period = get_field(pair);
>>  			u64 total = pair->hists->stats.total_period;
>>  
>> +			if (symbol_conf.filter_relative)
>> +				total = pair->hists->stats.total_filtered_period;
>> +
>>  			if (!total)
>>  				continue;
>
> looks like we could use something like:
>
> perf_hists__total_period(hists)
> {
> 	u64 total = hists->stats.total_period;
>
> 	if (symbol_conf.filter_relative)
> 		total = hists->stats.total_filtered_period;
>
> 	return total;
> }
>
> probably on other places as well

Right!  Will change.

Thanks,
Namhyung
