Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3JWJep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:34:45 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:51509 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3JWJen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:34:43 -0400
MIME-Version: 1.0
In-Reply-To: <20131022221803.GA3824@infradead.org>
References: <1381416608-2741-1-git-send-email-eranian@google.com>
	<20131010180049.GD9929@pd.tnic>
	<20131016124627.GA2611@gmail.com>
	<CABPqkBRQcisi8ukhD=6fKMq+iqwM+Qgxd3=jo82EUJB5coXs1A@mail.gmail.com>
	<20131016175302.GB4100@infradead.org>
	<CABPqkBSs1YwTiy_nkyXc89vg8-Tg=ONqCk930A+ksoLKsGLdHw@mail.gmail.com>
	<20131017081420.GB22705@gmail.com>
	<CABPqkBTBqEUU9p3SwNTXwwJ9j7VQXdofA5DzyoDmw+xJBE-uUw@mail.gmail.com>
	<20131022221803.GA3824@infradead.org>
Date: Wed, 23 Oct 2013 11:34:42 +0200
Message-ID: <CABPqkBSSFFVHH657-bvis4sSz9av4V4ziG4TVdmMZhO4LMfAdw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

On Wed, Oct 23, 2013 at 12:18 AM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Tue, Oct 22, 2013 at 06:47:38PM +0200, Stephane Eranian escreveu:
>> I have updated my RAPL patches to implement the suggested changes.
>> I will post the patch very soon. The new look and feel is as folllows:
>
>> # perf stat -a -e power/energy-cores/,power/energy-pkg/,ref-cycles -I
>> 1000 sleep 1000
>> #           time        unit            counts events
>>      1.000264953      Joules              2.09 power/energy-cores/
>>   [100.00%]
>>      1.000264953      Joules              5.94 power/energy-pkg/
>>      1.000264953                   160,530,320 ref-cycles
>>      2.000640422      Joules              2.07 power/energy-cores/
>>      2.000640422      Joules              5.94 power/energy-pkg/
>>      2.000640422                   152,673,056 ref-cycles
>>      3.000964416      Joules              2.08 power/energy-cores/
>>      3.000964416      Joules              5.93 power/energy-pkg/
>>      3.000964416                   158,779,184 ref-cycles
>
> What about:
>
>  # perf stat -a -e power/energy-cores/,power/energy-pkg/,ref-cycles -I 1000 sleep 1000
>  #           time                     events
>       1.000264953              2.09 Joules power/energy-cores/
>       1.000264953              5.94 Joules power/energy-pkg/
>       1.000264953       160,530,320 ref-cycles
>       2.000640422              2.07 Joules power/energy-cores/
>       2.000640422              5.94 Joules power/energy-pkg/
>       2.000640422       152,673,056 ref-cycles
>       3.000964416              2.08 Joules power/energy-cores/
>       3.000964416              5.93 Joules power/energy-pkg/
>       3.000964416       158,779,184 ref-cycles
>
> ?
>
> Or even 2.09J power/energy-cores/?
>
I can try that.

> I.e. a perf_evsel__fprintf_value(evsel) would append a unit string, if
> available.
>
I don't have this function is my tree yet (tip.git).

> - Arnaldo
>
>
>>
>> # ls -1 /sys/devices/power/events/
>> energy-cores
>> energy-cores.scale
>> energy-cores.unit
>> energy-pkg
>> energy-pkg.scale
>> energy-pkg.unit
>>
>> # cat /sys/devices/power/events/energy-cores.scale
>> 2.3e-10
>> # cat /sys/devices/power/events/energy-cores.unit
>> Joules
>>
>> Of course, this unit and scaling support is generic and not limited
>> to the RAPL events. For now, this only works with events exported
>> by the kernel via sysfs.
>>
>>
>>
>> On Thu, Oct 17, 2013 at 10:14 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Stephane Eranian <eranian@google.com> wrote:
>> >
>> >> On Wed, Oct 16, 2013 at 7:53 PM, Arnaldo Carvalho de Melo
>> >> <acme@redhat.com> wrote:
>> >> > Em Wed, Oct 16, 2013 at 03:13:54PM +0200, Stephane Eranian escreveu:
>> >> >> On Wed, Oct 16, 2013 at 2:46 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> >> >> > We should also tell user-space that the unit of this counter is 'Joule'.
>> >> >> >
>> >> >> > Then things like:
>> >> >> >
>> >> >> >         perf stat -a -e power/* sleep 1
>> >> >> >
>> >> >> > would output, without knowing any RAPL details:
>> >> >> >
>> >> >> >             0.20619 Joule    power/energy-core
>> >> >> >             2.42151 Joule    power/energy-pkg
>> >> >> >
>> >> >> Not sure there is already some support for this in perf stat. Arnaldo?
>> >> >
>> >> > Nope, there is not, we would have to have some table somewhere with
>> >> > "event-regexp: unit-string"
>> >> >
>> >> >> If not that we need another sysfs file to export the unit. Another
>> >> >> possibility is for perf stat to recognize the power/* and extract the
>> >> >> unit from the event name. In my example power/joules-cores -> joules.
>> >> >
>> >> > I.e. you would be encoding the counter unit as the suffix, might as well
>> >> > call it "power/cores.joules" and use the dot as the separator for the
>> >> > unit, but would be just a compact form to encode the counter->unit
>> >> > table.
>> >>
>> >> May be easier to add a sysfs entry with the unit to display.
>> >
>> > Yes - with no entry meaning a raw 'count' or such.
>> >
>> > Thanks,
>> >
>> >         Ingo
