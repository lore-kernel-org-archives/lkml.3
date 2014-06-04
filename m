Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbaFDHrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 03:47:49 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:52164 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaFDHrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 03:47:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140603155007.GZ30445@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin> <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin> <20140603155007.GZ30445@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 4 Jun 2014 09:47:26 +0200
Message-ID: <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
To: Peter Zijlstra <peterz@infradead.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2014 17:50, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, May 28, 2014 at 04:47:03PM +0100, Morten Rasmussen wrote:
>> Since we may do periodic load-balance every 10 ms or so, we will perform
>> a number of load-balances where runnable_avg_sum will mostly be
>> reflecting the state of the world before a change (new task queued or
>> moved a task to a different cpu). If you had have two tasks continuously
>> on one cpu and your other cpu is idle, and you move one of the tasks to
>> the other cpu, runnable_avg_sum will remain unchanged, 47742, on the
>> first cpu while it starts from 0 on the other one. 10 ms later it will
>> have increased a bit, 32 ms later it will be 47742/2, and 345 ms later
>> it reaches 47742. In the mean time the cpu doesn't appear fully utilized
>> and we might decide to put more tasks on it because we don't know if
>> runnable_avg_sum represents a partially utilized cpu (for example a 50%
>> task) or if it will continue to rise and eventually get to 47742.
>
> Ah, no, since we track per task, and update the per-cpu ones when we
> migrate tasks, the per-cpu values should be instantly updated.
>
> If we were to increase per task storage, we might as well also track
> running_avg not only runnable_avg.

I agree that the removed running_avg should give more useful
information about the the load of a CPU.

The main issue with running_avg is that it's disturbed by other tasks
(as point out previously). As a typical example,  if we have 2 tasks
with a load of 25% on 1 CPU, the unweighted runnable_load_avg will be
in the range of [100% - 50%] depending of the parallelism of the
runtime of the tasks whereas the reality is 50% and the use of
running_avg will return this value

Vincent
