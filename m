Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaDYHp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:45:57 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62681 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaDYHpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <53590835.9090803@arm.com>
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org>
 <1397209481-28542-6-git-send-email-vincent.guittot@linaro.org>
 <5357A802.1030804@arm.com> <CAKfTPtDnw-OZZekdE3oNGS11m6dfpS4veMNZ_Bezs-Lm7zn6QQ@mail.gmail.com>
 <5357DBA5.1010106@arm.com> <CAKfTPtAOZqnP=sWeJuqFAqrGT8vLQZKj+tpqiwOTG37paXoGjg@mail.gmail.com>
 <53590835.9090803@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 25 Apr 2014 09:45:34 +0200
Message-ID: <CAKfTPtAq8PXS-n7A0W6ESe08m-6O3u84BcY3==+-0+63+uca9g@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] sched: ARM: create a dedicated scheduler topology table
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 April 2014 14:48, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 24/04/14 08:30, Vincent Guittot wrote:
>> On 23 April 2014 17:26, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>>> On 23/04/14 15:46, Vincent Guittot wrote:
>>>> On 23 April 2014 13:46, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>>>>> Hi,
>
> [...]
>
>>
>> More than the flag that is used for the example, it's about the
>> cpumask which are inconsistent across CPUs for the same level and the
>> build_sched_domain sequence rely on this consistency to build
>> sched_group
>
> Now I'm lost here. I thought so far that by specifying different cpu
> masks per CPU in an sd level, we get the sd level folding functionality
> in sd degenerate?
>
> We discussed this here for an example on TC2 for the GMC level:
> https://lkml.org/lkml/2014/3/21/126
>
> Back than I had
>   CPU0: cpu_corepower_mask=0-1
>   CPU2: cpu_corepower_mask=2
> so for GMC level the cpumasks are inconsistent across CPUs and it worked.

The example above is consistent because CPU2 mask and CPU0 mask are
fully exclusive

so
CPU0: cpu_corepower_mask=0-1
CPU2: cpu_corepower_mask=2
are consistent

CPU0: cpu_corepower_mask=0-2
CPU2: cpu_corepower_mask=0-2
are also consistent

but

CPU0: cpu_corepower_mask=0-1
CPU2: cpu_corepower_mask=0-2
are not consistent

and your example uses the last configuration

To be more precise, the rule above applies on default SDT definition
but the flag SD_OVERLAP enables such kind of overlap between group.
Have you tried it ?

Vincent

>
> The header of '[PATCH v4 1/5] sched: rework of sched_domain topology
> definition' mentions only the requirement "Then, each level must be a
> subset on the next one" and this one I haven't broken w/ my
> GMC/MC/GDIE/DIE set-up.
>
> Do I miss something else here?
>
>>
>>> Essentially what I want to do is bind an SD_SHARE_*FOO* flag to the GDIE
>>> related sd's of CPU2/3/4 and not to the DIE related sd's of CPU0/1.
>>>
>>> I thought so far that I can achieve that by getting rid of GDIE sd level
>>> for CPU0/1 simply by choosing the cpu_foo_mask() function in such a way
>>> that it returns the same cpu mask as its child sd level (MC) and of DIE
>>> sd level for CPU2/3/4 because it returns the same cpu mask as its child
>>> sd level (GDIE) related cpu mask function. This will let sd degenerate
>>> do it's job of folding sd levels which it does. The only problem I have
>>> is that the groups are not created correctly any more.
>>>
>>> I don't see right now how the flag SD_SHARE_FOO affects the code in
>>> get_group()/build_sched_groups().
>>>
>>> Think of SD_SHARE_FOO of something I would like to have for all sd's of
>>> CPU's of cluster 1 (CPU2/3/4) and not on cluster 0 (CPU0/1) in the sd
>>> level where each CPU sees two groups (group0 containing CPU0/1 and
>>> group1 containing CPU2/3/4 or vice versa) (GDIE/DIE) .
>>
>> I'm not sure that's it's feasible because it's not possible from a
>> topology pov to have different flags if the span include all cpus.
>> Could you give us more details about what you want to achieve with
>> this flag ?
>
> IMHO, the flag is not important for this discussion.  OTHA, information
> like you can't use sd degenerate functionality to fold adjacent sd
> levels (GFOO/FOO) on sd level which span all CPUs would be.  I want to
> make sure we understand what are the limitations to use folding of
> adjacent sd levels based on per-cpu differences in the return value of
> cpu_mask functions.
>
> -- Dietmar
>
> [...]
>
