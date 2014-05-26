Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaEZHtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:49:41 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:49260 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaEZHtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:49:39 -0400
MIME-Version: 1.0
In-Reply-To: <5381C70E.3030605@linux.vnet.ibm.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-2-git-send-email-vincent.guittot@linaro.org> <5381C70E.3030605@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 26 May 2014 09:49:18 +0200
Message-ID: <CAKfTPtDBZyrJJpUHPZcG9Jf4egneyqQ7TR3QXiR0Wff8ZBkHAw@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] sched: fix imbalance flag reset
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 May 2014 12:33, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Hi Vincent,
>
> On 05/23/2014 09:22 PM, Vincent Guittot wrote:
>> The imbalance flag can stay set whereas there is no imbalance.
>>
>> Let assume that we have 3 tasks that run on a dual cores /dual cluster system.
>> We will have some idle load balance which are triggered during tick.
>> Unfortunately, the tick is also used to queue background work so we can reach
>> the situation where short work has been queued on a CPU which already runs a
>> task. The load balance will detect this imbalance (2 tasks on 1 CPU and an idle
>> CPU) and will try to pull the waiting task on the idle CPU. The waiting task is
>> a worker thread that is pinned on a CPU so an imbalance due to pinned task is
>> detected and the imbalance flag is set.
>> Then, we will not be able to clear the flag because we have at most 1 task on
>> each CPU but the imbalance flag will trig to useless active load balance
>> between the idle CPU and the busy CPU.
>
> Why do we do active balancing today when there is at-most 1 task on the
> busiest cpu? Shouldn't we be skipping load balancing altogether? If we
> do active balancing when the number of tasks = 1, it will lead to a ping
> pong right?

That's the purpose of the patch to prevent this useless active load
balance. When the imbalance flag is set, an active load balance is
triggered whatever the load balance is because of pinned tasks that
prevents a balance state.

Vincent

>
> Regards
> Preeti U Murthy
>
