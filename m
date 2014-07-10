Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaGJN6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:58:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36268 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaGJN6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:58:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140710110644.GX3935@laptop>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-8-git-send-email-vincent.guittot@linaro.org> <20140710110644.GX3935@laptop>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 10 Jul 2014 15:58:20 +0200
Message-ID: <CAKfTPtB0hPyfzMpF_=34y=AyrEPXztbZCVvpqHZtEeR56_Qyiw@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] sched: test the cpu's capacity in wake affine
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2014 13:06, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 06:05:38PM +0200, Vincent Guittot wrote:
>> Currently the task always wakes affine on this_cpu if the latter is idle.
>> Before waking up the task on this_cpu, we check that this_cpu capacity is not
>> significantly reduced because of RT tasks or irq activity.
>>
>> Use case where the number of irq and/or the time spent under irq is important
>> will take benefit of this because the task that is woken up by irq or softirq
>> will not use the same CPU than irq (and softirq) but a idle one which share
>> its cache.
>
> The above, doesn't seem to explain:
>
>> +     } else if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
>> +             this_eff_load = 0;
>> +     }
>> +
>> +     balanced = this_eff_load <= prev_eff_load;
>
> this. Why would you unconditionally allow wake_affine across cache
> domains?

The current policy is to use this_cpu if this_load <= 0. I want to
keep the current wake affine policy for all sched_domain that doesn't
share cache so if the involved CPUs don't share cache, I clear
this_eff_load to force balanced to be true. But when CPUs share their
cache,  we not only look at idleness but also at available capacity of
prev and local CPUs.
