Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446Ab3JPNN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:13:57 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:39847 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934157Ab3JPNN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:13:56 -0400
MIME-Version: 1.0
In-Reply-To: <20131016124627.GA2611@gmail.com>
References: <1381416608-2741-1-git-send-email-eranian@google.com>
	<20131010180049.GD9929@pd.tnic>
	<20131016124627.GA2611@gmail.com>
Date: Wed, 16 Oct 2013 15:13:54 +0200
Message-ID: <CABPqkBRQcisi8ukhD=6fKMq+iqwM+Qgxd3=jo82EUJB5coXs1A@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 2:46 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> So, the RAPL patch-set clearly needs more work.
>
> * Borislav Petkov <bp@alien8.de> wrote:
>
>> On Thu, Oct 10, 2013 at 04:50:05PM +0200, Stephane Eranian wrote:
>> > $ perf stat -a -e rapl/rapl-energy-cores/,rapl/rapl-energy-pkg/ -I 1000 sleep 10
>> >             time             counts events
>> >      1.000345931        772 278 493 rapl/rapl-energy-cores/
>> >      1.000345931     55 539 138 560 rapl/rapl-energy-pkg/
>> >      2.000836387        771 751 936 rapl/rapl-energy-cores/
>> >      2.000836387     55 326 015 488 rapl/rapl-energy-pkg/
>
> Why is there the rapl/rapl duplication in the event name? It should be
> rapl/energy-cores, rapl/energy-pkg, etc.
>
yeah, I thought about doing that too. I will change the names.

> I'm also not sure about the Intel-specific naming. Joules per core and
> Joules per socket ought to be pretty generic, even if the initial
> implementation is Intel-only. I.e.:
>
Joules per cores (with an s)
Joules per package.
Joules per dram, i.e., all the DRAM attached to a socket (I think).


>         power/energy-core
>         power/energy-pkg
>
Fine with me. Or joules-cores to make the unit explicit

>> Hmm, so I'm looking at builtin-stat.c::print_interval() and since it
>> gets the perf_evsel counters and you can deduce the counter name from
>> it, you probably could match the rapl counters and do the Watts
>> conversion above as a special case.
>>
>> I dunno, it is much better than having some naked numbers for which
>> people have to go stare at the sources + CPU vendor docs as to what they
>> actually mean.
>
> So what should happen here is to extend the sysfs attributes that tell us
> that it's in 32.32 fixed-point format.
>
We could add that in sysfs, but then I am wondering how would the tool realize
it has to use this file. We'd have to create something generic like a scaling
factor. If the file is there, then use it, if not assume 1x. Is that what you
are thinking about?


> We should also tell user-space that the unit of this counter is 'Joule'.
>
> Then things like:
>
>         perf stat -a -e power/* sleep 1
>
> would output, without knowing any RAPL details:
>
>             0.20619 Joule    power/energy-core
>             2.42151 Joule    power/energy-pkg
>
Not sure there is already some support for this in perf stat. Arnaldo?
If not that we need another sysfs file to export the unit. Another
possibility is for perf stat to recognize the power/* and extract the
unit from the event name. In my example power/joules-cores -> joules.
