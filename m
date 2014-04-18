Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaDRGz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 02:55:57 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:64191 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaDRGzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 02:55:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140417185258.GJ7422@krava.brq.redhat.com>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
 <20140417120046.GC7422@krava.brq.redhat.com> <1397741900.1731.17.camel@leonhard>
 <20140417185258.GJ7422@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 18 Apr 2014 15:55:33 +0900
X-Google-Sender-Auth: 2LxY9pRp3EEwBTWfBjc4sgnt2Ak
Message-ID: <CAM9d7chozUKw=TJNCJnR_e5fKmwgSPoBvQdA92N=MStErMFPQA@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf top/tui: Fixes for percentage filter behavior
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, Apr 18, 2014 at 3:52 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Apr 17, 2014 at 10:38:19PM +0900, Namhyung Kim wrote:
>> Hi Jiri,
>>
>> 2014-04-17 (목), 14:00 +0200, Jiri Olsa:
>> > On Thu, Apr 17, 2014 at 04:53:23PM +0900, Namhyung Kim wrote:
>> > > Hi,
>> > >
>> > > This is a small fixes for a bug in perf top I found during some tests.
>> > > It gets segfault if symbol filter found no entries - accessing NULL
>> > > pointer in that case.
>> >
>> > yep, I hit that yesterday as well, but I ended up just with
>> > the patch below, your changes seems more comprehensive ;-)
>> > going to review..
>>
>> Well, the end result will be same, but I think it should have 0
>> nr_entries when there's no entry to show.
>
> also I hit another issue ;-)
>
> - running report on data with callchains, and the screen is populated to the middle
> - press 'END' key and the cursor goes to the bottom of the screen (I can tell based
>   on the scrollbar), but there are no entries
>
> I could make the cursor appear by pressing UP arrow, I bisected to:
>   f214833 perf report: Add --percentage option
>
> not sure where's the problem

Hmm.. did you find it when running perf report?  AFAIK there's a
subtle problem of counting number of entries in perf report TUI with
callchains.  I wished fixing it but I was afraid of diving into the
tui code. ;-p  But I think it's a different one to the bug you
reported.

Anyway I found that there's an inconsistency when handling
hists->nr_entries.  We're increasing hists->nr_entries when new sample
comes in (ang not merged into an existing entry), but accesses the
nr_entries before adding it to the hist browser (i.e. output tree).  I
suspect the original perf top code has similar problem already but it
seems my change made it to be triggered easily.

Also when it moves hist entries to the output tree, it resets
nr_entries and increases nr_entries again as they're moved.  I think
it's a problem on perf top since it'll loose the number of entries
already existing on the output tree.  I'm not sure how it has been
working.. maybe I'm missing something.

I'm out of office now, I'll investigate it more when I'm back to
office next week.

Thanks,
Namhyung
