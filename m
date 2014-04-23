Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaDWF6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:58:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50789 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaDWF6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:58:52 -0400
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
Subject: Re: [PATCH 4/9] perf tools: Introduce hists__inc_dump_events()
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
	<1398156591-11001-5-git-send-email-namhyung@kernel.org>
	<20140422165355.GK1104@krava.brq.redhat.com>
Date: Wed, 23 Apr 2014 14:58:50 +0900
In-Reply-To: <20140422165355.GK1104@krava.brq.redhat.com> (Jiri Olsa's message
	of "Tue, 22 Apr 2014 18:53:55 +0200")
Message-ID: <87y4ywr3hh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 18:53:55 +0200, Jiri Olsa wrote:
> On Tue, Apr 22, 2014 at 05:49:46PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> index f955ae5a41c5..883340d7d43e 100644
>> --- a/tools/perf/util/hist.c
>> +++ b/tools/perf/util/hist.c
>> @@ -333,6 +333,19 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
>>  	__events_stats__add(&hists->stats, type, 1);
>>  }
>>  
>> +void hists__inc_dump_events(struct hists *hists)
>> +{
>> +	if (!dump_trace)
>> +		return;
>> +
>> +	/*
>> +	 * If dump_trace is enabled, perf will exit before accounting
>> +	 * sample events during hists__output_resort().  Thus it needs to
>> +	 * be done separately.
>> +	 */
>> +	__events_stats__add(&hists->stats, PERF_RECORD_SAMPLE, 1);
>> +}
>
> hum, we already clear all the stats before resorting for output so why done
> we call hists__inc_nr_entries from add_hist_entry? (at out label)

In short, because it could be seen by perf top's display thread before
the entry actually moves in the output tree.

Let me explain what this series does again.

There're three main fields in the hists->stats to affect the output:
number of samples, number of hist entries and total periods.

Also there're three stages to process samples: at first, samples are
converted to a hist entry and added to the input tree, and then they are
moved to the collapsed tree if needed, and finally they're moved to the
output tree to be shown to user.

The (part of) stats are accounted when samples are added to the input
tree and then reset before moving to the output tree, and re-counted
during insertion to the output tree.

I can see some reason to do it this way but it's basically not necessary
and could make a problem in multi-threaded programs like perf top.

The perf report does all these passes sequentially in a single thread so
it seems no problem.  But perf top uses two threads - one for gathering
samples (in the input tree) and another for (collapsing and) moving them
to the output tree.  Thus accounting stat in parallel can result in an
inaccurate stats and the output.

So I'd like to get rid of the accounting on the input stage as you can
see it just gets dropped before doing output resort.  I originally make
the all three stats are accounted when doing output resort but changed
mind to account number of samples in the input stage and others in the
output stage.  Because it'd make more sense accounting number of events
(sample event) in the input stage (as all other events are also
accounted in the input stage) and it'd make less changes in code.

So yes, it has a same problem of inaccurate number of samples, but its
impact should be smaller than other stats - seeing increasing sample
count (could be slightly inaccurate) without new entries in the browser.

Thoughts?

Thanks,
Namhyung
