Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaDWFPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:15:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56794 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaDWFPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:15:03 -0400
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
	<20140422171048.GL1104@krava.brq.redhat.com>
Date: Wed, 23 Apr 2014 14:14:59 +0900
In-Reply-To: <20140422171048.GL1104@krava.brq.redhat.com> (Jiri Olsa's message
	of "Tue, 22 Apr 2014 19:10:49 +0200")
Message-ID: <8738h4sk30.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 19:10:49 +0200, Jiri Olsa wrote:
> On Tue, Apr 22, 2014 at 05:49:45PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>>  
>> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
>> index 1c77714f668d..f955ae5a41c5 100644
>> --- a/tools/perf/util/hist.c
>> +++ b/tools/perf/util/hist.c
>> @@ -344,9 +344,11 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
>>  		hists__calc_col_len(hists, h);
>>  		hists->nr_non_filtered_entries++;
>>  		hists->stats.total_non_filtered_period += h->stat.period;
>> +		hists->stats.nr_non_filtered_samples += h->stat.nr_events;
>>  	}
>>  	hists->nr_entries++;
>>  	hists->stats.total_period += h->stat.period;
>> +	hists__add_nr_events(hists, PERF_RECORD_SAMPLE, h->stat.nr_events);
>
> while at it.. could hists__remove_entry_filter call hists__inc_nr_entries too?

Nope, I (and Arnaldo) want to the default stats invariant - they are not
changed by any filter.  As you can see hists__remove_entry_filter() only
updates non-filtered stats.

>
> not sure about those 2 extra lines in hists__remove_entry_filter:
>
>         if (h->ms.unfolded)
>                 hists->nr_non_filtered_entries += h->nr_rows;
>         h->row_offset = 0;
>
> maybe they should be added into hists__inc_nr_entries?

Hmm.. this seems like a mix of generic code and UI-specific code.  The
->nr_rows, ->row_offset and ->ms.unfolded are only used by TUI browser
code AFAIK and it takes the folding state into account.

I think we should just make it folded to make things simple - and
finally get rid of the UI-specific bits in the generic code.

Thanks,
Namhyung
