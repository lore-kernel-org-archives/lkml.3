Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869AbaFCRUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:20:44 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:54814 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932560AbaFCRUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:20:43 -0400
Date: Tue, 3 Jun 2014 18:20:48 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Benjamin Segall <bsegall@google.com>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140603172048.GF29593@e103034-lin>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <20140603155007.GZ30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603155007.GZ30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 04:50:07PM +0100, Peter Zijlstra wrote:
> On Wed, May 28, 2014 at 04:47:03PM +0100, Morten Rasmussen wrote:
> > Since we may do periodic load-balance every 10 ms or so, we will perform
> > a number of load-balances where runnable_avg_sum will mostly be
> > reflecting the state of the world before a change (new task queued or
> > moved a task to a different cpu). If you had have two tasks continuously
> > on one cpu and your other cpu is idle, and you move one of the tasks to
> > the other cpu, runnable_avg_sum will remain unchanged, 47742, on the
> > first cpu while it starts from 0 on the other one. 10 ms later it will
> > have increased a bit, 32 ms later it will be 47742/2, and 345 ms later
> > it reaches 47742. In the mean time the cpu doesn't appear fully utilized
> > and we might decide to put more tasks on it because we don't know if
> > runnable_avg_sum represents a partially utilized cpu (for example a 50%
> > task) or if it will continue to rise and eventually get to 47742.
> 
> Ah, no, since we track per task, and update the per-cpu ones when we
> migrate tasks, the per-cpu values should be instantly updated.

No, not for this per-cpu tracking metric :) For cfs.runnable_load_avg
you are right, but this patch set is using rq->avg.runnable_avg_sum
which is different. See my other reply.

> If we were to increase per task storage, we might as well also track
> running_avg not only runnable_avg.

That could probably make sense. We had that in pjt's first proposal.
