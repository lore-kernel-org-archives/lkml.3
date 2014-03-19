Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742AbaCSQOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:14:53 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37435 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964900AbaCSQOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:14:51 -0400
MIME-Version: 1.0
In-Reply-To: <5329B63F.9090800@arm.com>
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
 <1395165409-18055-3-git-send-email-vincent.guittot@linaro.org>
 <53297F10.3050106@arm.com> <20140319124149.GM27632@laptop.programming.kicks-ass.net>
 <CAKfTPtDF27X_QJAYEdkb3q6HbULeT4N9t+ChDpdWST+15sndOw@mail.gmail.com> <5329B63F.9090800@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 19 Mar 2014 17:14:30 +0100
Message-ID: <CAKfTPtCttOU-ANJohxxNJax0OQzZduDQ-VJuM8Qz48w-LUGB2g@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] sched: rework of sched_domain topology definition
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 16:22, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 19/03/14 13:33, Vincent Guittot wrote:
> [...]
>
>>>> Is there a way to check that MC and GMC have to have
>>>> SD_SHARE_PKG_RESOURCES set so that this can't happen unnoticed?
>>>
>>> So from the core codes perspective those names mean less than nothing.
>>> Its just a string to carry along for us meat-bags. The string isn't even
>>> there when !SCHED_DEBUG.
>>>
>>> So from this codes POV you told it it had a domain without PKGSHARE,
>>> that's fine.
>>>
>>> That said; yeah the thing isn't the prettiest piece of code. But it has
>>> the big advantage of being the one place where we convert topology into
>>> behaviour.
>>
>> We might add a check of the child in sd_init to ensure that the child
>> has at least some properties of the current level.
>> I mean that if a level has got the SD_SHARE_PKG_RESOURCES flag, its
>> child must also have it. The same for SD_SHARE_CPUPOWER and
>> SD_ASYM_PACKING.
>>
>> so we can add something like the below in sd_init
>>
>> child_flags = SD_SHARE_PKG_RESOURCES | SD_SHARE_CPUPOWER | SD_ASYM_PACKING
>> flags = sd->flags & child_flags
>> if (sd->child)
>>    child_flags &= sd->child->flags
>> child_flags &= flags
>> if (flags != child_flags)
>>     pr_info("The topology description looks strange \n");
>
> I tried it with my faulty set-up on TC2 and I get the info message for
> the GMC level for all CPU's in sd_init.
>
> I had to pass an 'struct sched_domain *child' pointer into sd_init()
> from build_sched_domain() because inside sd_init() sd->child is always NULL.

ah yes... the child is set after the call to sd_init so we don't have
access to the child

>
> So one of the requirements of this approach is that a child level like
> GMC (which could potentially replace its parent level or otherwise is
> destroyed itself) has to specify all flags of its parent level (MC)?

yes among the 3 flags that i mention because we have simple
parent/child relation for this 3 flags

>
> What about SD_NUMA in child_flags? SD_ASYM_PACKING is also a little bit

SD_NUMA doesn't follow the same rule

> different than SD_SHARE_PKG_RESOURCES or SD_SHARE_CPUPOWER because it's
> not used in the if ... else statement.

It's not a matter of being in a if else statement but more a topology
dependency.

>
> But I'm afraid this only works for this specific case of the MC/GMC

This also works if a level with SD_SHARE_CPUPOWER flag is declared in
the table after a level without the flag which doesn't make sense
AFAIK.

> layer and is not scalable. If sd->child is a level for which you don't
> want to potentially destroy itself or its parent, then you would get
> false alarms. IMHO, sd_init() has no information for which pair of
> adjacent levels it should apply this check and for which not. Do I miss
> something here?

This check could apply on all level.

Vincent

>
> -- Dietmar
>
>>
>> Vincent
>>
>
>
