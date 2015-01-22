Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbbAVQVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:21:50 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:64261 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbbAVQVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:21:48 -0500
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <CAMsRxfKnDVxc4awnGPQ+7s1BvsUHDQV5GwDRmV2J9BGKP2EMXg@mail.gmail.com>
References: <alpine.DEB.2.11.1501211348470.22707@vincent-weaver-1.umelst.maine.edu>
	<CAMsRxfJVxUcTvpaUSvTY19Ha93J1R-=o97hO+bfgkL3zU7Nrpw@mail.gmail.com>
	<20150122101720.GA2896@worktop.programming.kicks-ass.net>
	<CAMsRxfKnDVxc4awnGPQ+7s1BvsUHDQV5GwDRmV2J9BGKP2EMXg@mail.gmail.com>
Date: Thu, 22 Jan 2015 17:21:48 +0100
Message-ID: <CAMsRxfLek-_4o+t2OV_31MyC=76z6u7wn4Nm-yKpa1NN9kjh7Q@mail.gmail.com>
Subject: Re: perf: easily crash kernel with rapl event close
From: Stephane Eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        cl@linux.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 1:39 PM, Stephane Eranian
<eranian@googlemail.com> wrote:
> On Thu, Jan 22, 2015 at 2:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, Jan 21, 2015 at 09:13:11PM -0800, Stephane Eranian wrote:
>>> Vince,
>>>
>>> On Wed, Jan 21, 2015 at 10:55 AM, Vince Weaver <vincent.weaver@maine.edu> wrote:
>>> > Hello
>>> >
>>> > on my haswell system, running 3.19-rc5, and with
>>> >         echo "0" > /proc/sys/kernel/perf_event_paranoid
>>> >
>>> > I can easily crash my system with the attached test program that simply
>>> > opens a RAPL event and then closes it.
>>> >
>>> > This bug was found by the perf_fuzzer.
>>> >
>>> > It looks like somehow rapl_pmu gets freed to NULL but the
>>> > call in rapl_scale()
>>> >         __this_cpu_read(rapl_pmu->hw_unit)
>>> > still happens.
>>> >
>>> I don't see how this can happen.
>>>
>>> I get some crashes but not with your program on my laptop.
>>> But I cannot catch the serial console from my laptop.
>>> Will try with another machine tomorrow.
>>
>> I saw it today as well on an ivb-ep. I disabled rapl for now since I'm
>> chasing other things.
>
> I will fix that today.

Ok, problem identified. One liner.
Bug introduced by:

commit 89cbc76768c2fa4ed95545bf961f3a14ddfeed21
Author: Christoph Lameter <cl@linux.com>
Date:   Sun Aug 17 12:30:40 2014 -0500

    x86: Replace __get_cpu_var uses


Fix looks like this:

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 6e434f8..c4bb8b8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -142,7 +142,7 @@ static inline u64 rapl_scale(u64 v)
         * or use ldexp(count, -32).
         * Watts = Joules/Time delta
         */
-       return v << (32 - __this_cpu_read(rapl_pmu->hw_unit));
+       return v << (32 - __this_cpu_read(rapl_pmu)->hw_unit);
 }


Will post the patch shortly.
Thanks Vince for reporting this issue.
