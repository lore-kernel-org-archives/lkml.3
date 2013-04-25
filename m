Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab3DYQeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:34:13 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56680
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756869Ab3DYQeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:34:12 -0400
Date: Thu, 25 Apr 2013 18:32:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, fweisbec@gmail.com, pjt@google.com,
        rostedt@goodmis.org, efault@gmx.de
Subject: Re: [PATCH v8] sched: fix init NOHZ_IDLE flag
Message-ID: <20130425163242.GC5828@dyad.programming.kicks-ass.net>
References: <1366729142-14662-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366729142-14662-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 04:59:02PM +0200, Vincent Guittot wrote:
> On my smp platform which is made of 5 cores in 2 clusters, I have the
> nr_busy_cpu field of sched_group_power struct that is not null when the
> platform is fully idle. The root cause is:
> During the boot sequence, some CPUs reach the idle loop and set their
> NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
> field is initialized later with the assumption that all CPUs are in the busy
> state whereas some CPUs have already set their NOHZ_IDLE flag.
> 
> More generally, the NOHZ_IDLE flag must be initialized when new sched_domains
> are created in order to ensure that NOHZ_IDLE and nr_busy_cpus are aligned.
> 
> This condition can be ensured by adding a synchronize_rcu between the
> destruction of old sched_domains and the creation of new ones so the NOHZ_IDLE
> flag will not be updated with old sched_domain once it has been initialized.
> But this solution introduces a additionnal latency in the rebuild sequence
> that is called during cpu hotplug.
> 
> As suggested by Frederic Weisbecker, another solution is to have the same
> rcu lifecycle for both NOHZ_IDLE and sched_domain struct.
> A new nohz_idle field is added to sched_domain so both status and sched_domain
> will share the same RCU lifecycle and will be always synchronized.
> In addition, there is no more need to protect nohz_idle against concurrent
>  access as it is only modified by 2 exclusive functions called by local cpu.
> 
> This solution has been prefered to the creation of a new struct with an extra
> pointer indirection for sched_domain.

> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks for persisting!
