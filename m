Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3AKOJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:09:05 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44864 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3AKOJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:09:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130111133132.GC2847@krava.brq.redhat.com>
References: <1357583277-4553-1-git-send-email-eranian@google.com>
	<1357583277-4553-12-git-send-email-eranian@google.com>
	<20130109165539.GB1045@krava.brq.redhat.com>
	<CABPqkBTTE=36vjMuXjiPojAYsTQfYzSk7=3Jo2WC4ryh7+gpaQ@mail.gmail.com>
	<20130111133132.GC2847@krava.brq.redhat.com>
Date: Fri, 11 Jan 2013 15:08:59 +0100
Message-ID: <CABPqkBSQv7GiuEuD+gWDUu8Y0CXmSr5C56JG-5mNWLgTux3zKw@mail.gmail.com>
Subject: Re: [PATCH v5 11/18] perf tools: add mem access sampling core support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 2:31 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Jan 10, 2013 at 10:53:26PM +0100, Stephane Eranian wrote:
>> On Wed, Jan 9, 2013 at 5:55 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> > On Mon, Jan 07, 2013 at 07:27:50PM +0100, Stephane Eranian wrote:
>
> SNIP
>
>> >
>> > The crash I report is due to the some maps could be removed
>> > via map_groups__fixup_overlappings.
>> >
>> > Attached patch makes the code working for me, but we might
>> > want to have some global unified fix for that, since this
>> > is not the only place suffering for that.
>> >
>> > Like globaly set map->referenced in add_hist_entry or
>> > hist_entry__new functions..
>> >
>> >
>> Would something like that work for you (untested)?
>
> yep, works ok for me (tested)... how about branch_info? looks like
>
>   branch_info::from
>   branch_info::to
>
> need same treatment
>
Yes. Will post a patch for this separately.

> thanks,
> jirka
>
>>
>> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
>> index 7034500..fc05b9f 100644
>> --- a/tools/perf/util/hist.c
>> +++ b/tools/perf/util/hist.c
>> @@ -274,6 +274,12 @@ static struct hist_entry *hist_entry__new(struct
>> hist_entry *template)
>>
>>                 if (he->ms.map)
>>                         he->ms.map->referenced = true;
>> +               if (he->mem_info) {
>> +                       if (he->mem_info->iaddr.map)
>> +                               he->mem_info->iaddr.map->referenced = true;
>> +                       if (he->mem_info->daddr.map)
>> +                               he->mem_info->daddr.map->referenced = true;
>> +               }
>>                 if (symbol_conf.use_callchain)
>>                         callchain_init(he->callchain);
