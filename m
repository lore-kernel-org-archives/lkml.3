Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaDWE6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 00:58:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52533 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaDWE6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 00:58:23 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/9] perf tools: Account entry stats when it's added to the output tree
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
	<1398156591-11001-4-git-send-email-namhyung@kernel.org>
	<20140422145449.GI1104@krava.brq.redhat.com>
Date: Wed, 23 Apr 2014 13:58:22 +0900
In-Reply-To: <20140422145449.GI1104@krava.brq.redhat.com> (Jiri Olsa's message
	of "Tue, 22 Apr 2014 16:54:49 +0200")
Message-ID: <877g6gskup.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 16:54:49 +0200, Jiri Olsa wrote:
> On Tue, Apr 22, 2014 at 05:49:45PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>>  }
>>  
>>  static int process_sample_event(struct perf_tool *tool,
>> @@ -234,19 +230,17 @@ static int __cmd_annotate(struct perf_annotate *ann)
>>  	total_nr_samples = 0;
>>  	evlist__for_each(session->evlist, pos) {
>>  		struct hists *hists = &pos->hists;
>> -		u32 nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
>>  
>> -		if (nr_samples > 0) {
>
> so this condition of having some data is handled in the
> resort I guess.. hm, it will just iterate 0 times ;-)

Right.  But I decided to keep this logic as is - will explain on other thread.

>
>> -			total_nr_samples += nr_samples;
>> -			hists__collapse_resort(hists, NULL);
>> -			hists__output_resort(hists);
>> +		hists__collapse_resort(hists, NULL);
>> +		hists__output_resort(hists);
>>  
>> -			if (symbol_conf.event_group &&
>> -			    !perf_evsel__is_group_leader(pos))
>> -				continue;
>> +		if (symbol_conf.event_group &&
>> +		    !perf_evsel__is_group_leader(pos))
>> +			continue;
>>  
>> -			hists__find_annotations(hists, pos, ann);
>> -		}
>> +		hists__find_annotations(hists, pos, ann);
>> +
>> +		total_nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
>>  	}
>>  
>>  	if (total_nr_samples == 0) {
>>  
>
> SNIP
>
>> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
>> index 1c77714f668d..f955ae5a41c5 100644
>> --- a/tools/perf/util/hist.c
>> +++ b/tools/perf/util/hist.c
>> @@ -344,9 +344,11 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
>
> I was wondering for a while about the name of this function
> since it no longer increments only nr_entries.. but could not
> think about any good replacement ;-)
>
> We could also add hists__reset_nr_entries for the zeroing code.

How about hists__inc_stats() and hists__reset_stats()?

>
>
>>  		hists__calc_col_len(hists, h);
>
> also having hists__calc_col_len called here seems strange

Agreed.  I'll move this out of the function.

Thanks,
Namhyung
