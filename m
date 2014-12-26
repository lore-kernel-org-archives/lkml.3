Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109AbaLZCK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 21:10:56 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:48048 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLZCKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 21:10:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141225225339.GA15569@krava.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-14-git-send-email-namhyung@kernel.org> <20141225225339.GA15569@krava.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 26 Dec 2014 11:10:33 +0900
X-Google-Sender-Auth: RPU5RF4TuhaRukuVHYD-Wp2AJzQ
Message-ID: <CAM9d7chaJbYqYQT=ExDVEeUaZoexgZi1QCzoQO9qsdWCmb_AKA@mail.gmail.com>
Subject: Re: [PATCH 13/37] perf tools: Use thread__comm_time() when adding
 hist entries
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 7:53 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Dec 24, 2014 at 04:15:09PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>>
>>                       he = __hists__add_entry(hists, &al, NULL,
>> -                                             NULL, NULL, 1, 1, 0, true);
>> +                                             NULL, NULL, 1, 1, 0, -1, true);
>>                       if (he == NULL)
>>                               goto out;
>>
>> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
>> index 9314286ed25c..d322264bac22 100644
>> --- a/tools/perf/util/hist.c
>> +++ b/tools/perf/util/hist.c
>> @@ -451,11 +451,11 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
>>                                     struct branch_info *bi,
>>                                     struct mem_info *mi,
>>                                     u64 period, u64 weight, u64 transaction,
>> -                                   bool sample_self)
>> +                                   u64 timestamp, bool sample_self)
>>  {
>>       struct hist_entry entry = {
>>               .thread = al->thread,
>> -             .comm = thread__comm(al->thread),
>> +             .comm = thread__comm_time(al->thread, timestamp),
>
> with thread object having multiple comm entries, could this hurt
> the single threaded performance?

Probably.  But in my test, the single threaded performance on a single
data file is slightly better or almost same.  I didn't investigate it
yet where the performance gain comes, but anyway, I think this has
almost no effect on the performance since most thread will have just
one or two comms I guess.

And JFYI, the single threaded performance on a multi-file data is
better (I tested same data using 'perf data split' command and no
--multi-thread option to perf report) as IMHO it doesn't need to use
the ordered event queue layer.

>
> The thread__comm_time function iterates comm_list each time,
> maybe you could add some 'last_comm found check' logic in it?

I think it can be easily added later if it really affects the performance.

Thanks,
Namhyung
