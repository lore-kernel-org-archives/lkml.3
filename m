Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab3J1Kdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:33:53 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:58678 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3J1Kdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:33:51 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBR0gEz7cauev0hk=oofO1m9RP=wP3NK3j0y7EiNE8j3tg@mail.gmail.com>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
	<1382533085-7166-4-git-send-email-eranian@google.com>
	<20131025111422.GC1219@krava.redhat.com>
	<CABPqkBR0gEz7cauev0hk=oofO1m9RP=wP3NK3j0y7EiNE8j3tg@mail.gmail.com>
Date: Mon, 28 Oct 2013 11:33:50 +0100
Message-ID: <CABPqkBShxTc3wBkwWej6gaWJK3GmdtV71hNdozabnbwpesXx_A@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was thinking about the scaling issue over the week-end.

We agreed that it was necessary to export the
scaling via sysfs per event. The RAPL v3 has
an implementation of that including in the perf tool.

If we have that, then it may not be necessary anymore
to express the raw count in the 1/2^32 J unit like we
are currently doing. This loses a bit of precision. We
could as well expose the actual raw count and export
the actual unit via sysfs. For instance, on SNB/IVB the
unit is 1/2^16, but on Haswell it is 1/2^14.

I see two issues with that approach though:

- the interpretation of the raw count changes from machine to
  machine and needs to ALWAYS be used with the scaling.
  It is not always possible to just compare raw counts directly.

- we would need a way to express that ratio without actually
  calculating it in the kernel. There are 6 ratios possible. So
  we either have a lookup table with the floating point values
  already computed and encoded as strings. Or we need to
  add a calculator style parsing in the perf tool (or any other)
  tool to parse a ratio: 1 / 65536 or any basic mathematical
  expression. After all, the scaling support has to be generic.
  Other events may use a different form of scaling ratios. But
  that seems overkill to me.

So in the end, it may be the case that what we have not in RAPLv3
is the simplest approach.

Any opinion?




On Sat, Oct 26, 2013 at 7:00 PM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Oct 25, 2013 at 1:14 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> On Wed, Oct 23, 2013 at 02:58:04PM +0200, Stephane Eranian wrote:
>>
>> SNIP
>>
>>> +
>>> +static void rapl_init_cpu(int cpu)
>>> +{
>>> +     int i, phys_id = topology_physical_package_id(cpu);
>>> +
>>> +     spin_lock(&rapl_hotplug_lock);
>>> +
>>> +     /* check if phys_is is already covered */
>>> +     for_each_cpu(i, &rapl_cpu_mask) {
>>> +             if (phys_id == topology_physical_package_id(i))
>>> +                     return;
>>
>> missing 'spin_unlock(&rapl_hotplug_lock)' above
>>
> Good catch. I fixed that now.
>
>>> +     }
>>> +     /* was not found, so add it */
>>> +     cpumask_set_cpu(cpu, &rapl_cpu_mask);
>>> +
>>> +     spin_unlock(&rapl_hotplug_lock);
>>> +}
>>> +
