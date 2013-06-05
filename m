Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3FEKo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 06:44:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3FEKo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:44:26 -0400
Date: Wed, 5 Jun 2013 12:44:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH v2] sched: fix clear NOHZ_BALANCE_KICK
Message-ID: <20130605104419.GW8923@twins.programming.kicks-ass.net>
References: <1370419991-13870-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370419991-13870-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:13:11AM +0200, Vincent Guittot wrote:
> I have faced a sequence where the Idle Load Balance was sometime not
> triggered for a while on my platform.
> 
> CPU 0 and CPU 1 are running tasks and CPU 2 is idle
> 
> CPU 1 kicks the Idle Load Balance
> CPU 1 selects CPU 2 as the new Idle Load Balancer
> CPU 2 sets NOHZ_BALANCE_KICK for CPU 2
> CPU 2 sends a reschedule IPI to CPU 2
> While CPU 3 wakes up, CPU 0 or CPU 1 migrates a waking up task A on CPU 2
> CPU 2 finally wakes up, runs task A and discards the Idle Load Balance
> task A quickly goes back to sleep (before a tick occurs on CPU 2)
> CPU 2 goes back to idle with NOHZ_BALANCE_KICK set
> 
> Whenever CPU 2 will be selected as the ILB, no reschedule IPI will be sent
> because NOHZ_BALANCE_KICK is already set and no Idle Load Balance will be
> performed.
> 
> We must wait for the sched softirq to be raised on CPU 2 thanks to another
> part the kernel to come back to clear NOHZ_BALANCE_KICK.
> 
> The proposed solution clears NOHZ_BALANCE_KICK in schedule_ipi if
> we can't raise the sched_softirq for the Idle Load Balance.
> 
> Change since V1:
> - move the clear of NOHZ_BALANCE_KICK in got_nohz_idle_kick if the ILB
> can't run on this CPU (as suggested by Peter)
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Thanks!
