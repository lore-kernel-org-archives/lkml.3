Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231AbaCSNd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:33:59 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34322 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873AbaCSNdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140319124149.GM27632@laptop.programming.kicks-ass.net>
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
 <1395165409-18055-3-git-send-email-vincent.guittot@linaro.org>
 <53297F10.3050106@arm.com> <20140319124149.GM27632@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 19 Mar 2014 14:33:35 +0100
Message-ID: <CAKfTPtDF27X_QJAYEdkb3q6HbULeT4N9t+ChDpdWST+15sndOw@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] sched: rework of sched_domain topology definition
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
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

On 19 March 2014 13:41, Peter Zijlstra <peterz@infradead.org> wrote:
>
> The keyboard deity gave us delete, please apply graciously when replying
> to large emails.
>
> On Wed, Mar 19, 2014 at 11:27:12AM +0000, Dietmar Eggemann wrote:
>> On 18/03/14 17:56, Vincent Guittot wrote:
>> > +       if (sd->flags & SD_SHARE_CPUPOWER) {
>> > +               sd->imbalance_pct = 110;
>> > +               sd->smt_gain = 1178; /* ~15% */
>> > +               sd->flags |= arch_sd_sibling_asym_packing();
>> > +
>> > +       } else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
>> > +               sd->imbalance_pct = 117;
>> > +               sd->cache_nice_tries = 1;
>> > +               sd->busy_idx = 2;
>> > +
>> > +#ifdef CONFIG_NUMA
>> > +       } else if (sd->flags & SD_NUMA) {
>> > +               sd->cache_nice_tries = 2;
>> > +               sd->busy_idx = 3;
>> > +               sd->idle_idx = 2;
>> > +
>> > +               sd->flags |= SD_SERIALIZE;
>> > +               if (sched_domains_numa_distance[tl->numa_level] > RECLAIM_DISTANCE) {
>> > +                       sd->flags &= ~(SD_BALANCE_EXEC |
>> > +                                      SD_BALANCE_FORK |
>> > +                                      SD_WAKE_AFFINE);
>> > +               }
>> > +
>> > +#endif
>> > +       } else {
>> > +               sd->flags |= SD_PREFER_SIBLING;
>> > +               sd->cache_nice_tries = 1;
>> > +               sd->busy_idx = 2;
>> > +               sd->idle_idx = 1;
>> > +       }
>>
>> This 'if ... else statement' is still a weak point from the perspective
>> of making the code robust:
>
> <snip>
>
>> Is there a way to check that MC and GMC have to have
>> SD_SHARE_PKG_RESOURCES set so that this can't happen unnoticed?
>
> So from the core codes perspective those names mean less than nothing.
> Its just a string to carry along for us meat-bags. The string isn't even
> there when !SCHED_DEBUG.
>
> So from this codes POV you told it it had a domain without PKGSHARE,
> that's fine.
>
> That said; yeah the thing isn't the prettiest piece of code. But it has
> the big advantage of being the one place where we convert topology into
> behaviour.

We might add a check of the child in sd_init to ensure that the child
has at least some properties of the current level.
I mean that if a level has got the SD_SHARE_PKG_RESOURCES flag, its
child must also have it. The same for SD_SHARE_CPUPOWER and
SD_ASYM_PACKING.

so we can add something like the below in sd_init

child_flags = SD_SHARE_PKG_RESOURCES | SD_SHARE_CPUPOWER | SD_ASYM_PACKING
flags = sd->flags & child_flags
if (sd->child)
   child_flags &= sd->child->flags
child_flags &= flags
if (flags != child_flags)
    pr_info("The topology description looks strange \n");

Vincent
