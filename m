Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaCLNrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:47:51 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:45574 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbaCLNrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:47:49 -0400
MIME-Version: 1.0
In-Reply-To: <532060E7.7010203@arm.com>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
 <5317B092.7070805@arm.com> <CAKfTPtDGbT717Y5F1GoBgr4pnvApG5Gphu2Me_bAFrM0+qsfAg@mail.gmail.com>
 <53186A8A.9060406@arm.com> <CAKfTPtCspVk+X3O23ikTt3MZUHVrrp21PyhmrcLF-GwW3OjOqA@mail.gmail.com>
 <531B0FDA.2040302@arm.com> <20140311131719.GY9987@twins.programming.kicks-ass.net>
 <532060E7.7010203@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 12 Mar 2014 14:47:28 +0100
Message-ID: <CAKfTPtC3Y7s=n205MND24tLrsT+-3+JhWHebxcBkwAuaMngDhA@mail.gmail.com>
Subject: Re: [RFC 0/6] rework sched_domain topology description
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
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

On 12 March 2014 14:28, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 11/03/14 13:17, Peter Zijlstra wrote:
>> On Sat, Mar 08, 2014 at 12:40:58PM +0000, Dietmar Eggemann wrote:
>>>>
>>>> I don't have a strong opinion about using or not a cpu argument for
>>>> setting the flags of a level (it was part of the initial proposal
>>>> before we start to completely rework the build of sched_domain)
>>>> Nevertheless, I see one potential concern that you can have completely
>>>> different flags configuration of the same sd level of 2 cpus.
>>>
>>> Could you elaborate a little bit further regarding the last sentence? Do you
>>> think that those completely different flags configuration would make it
>>> impossible, that the load-balance code could work at all at this sd?
>>
>> So a problem with such an interfaces is that is makes it far too easy to
>> generate completely broken domains.
>
> I see the point. What I'm still struggling with is to understand why
> this interface is worse then the one where we set-up additional,
> adjacent sd levels with new cpu_foo_mask functions plus different static
> sd-flags configurations and rely on the sd degenerate functionality in
> the core scheduler to fold these levels together to achieve different
> per cpu sd flags configurations.

The main difference is that all CPUs has got the same levels at the
initial state and then the degenerate sequence can decide that it's
worth removing a level and if it will not create unsuable domains.

>
> IMHO, exposing struct sched_domain_topology_level bar_topology[] to the
> arch is the reason why the core scheduler has to check if the arch
> provides a sane sd setup in both cases.
>
>>
>> You can, for two cpus in the same domain provide, different flags; such
>> a configuration doesn't make any sense at all.
>>
>> Now I see why people would like to have this; but unless we can make it
>> robust I'd be very hesitant to go this route.
>>
>
> By making it robust, I guess you mean that the core scheduler has to
> check that the provided set-ups are sane, something like the following
> code snippet in sd_init()
>
> if (WARN_ONCE(tl->sd_flags & ~TOPOLOGY_SD_FLAGS,
>                 "wrong sd_flags in topology description\n"))
>         tl->sd_flags &= ~TOPOLOGY_SD_FLAGS;
>
> but for per cpu set-up's.
> Obviously, this check has to be in sync with the usage of these flags in
> the core scheduler algorithms. This comprises probably that a subset of
> these topology sd flags has to be set for all cpus in a sd level whereas
> other can be set only for some cpus.
>
>>
>>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
