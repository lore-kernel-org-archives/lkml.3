Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaEUNTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:19:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35669 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaEUNTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:19:54 -0400
Date: Wed, 21 May 2014 15:19:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: spinlock recursion in migrate_swap_stop
Message-ID: <20140521131948.GF2485@laptop.programming.kicks-ass.net>
References: <5371122D.6020605@oracle.com>
 <537AB86B.4020901@oracle.com>
 <20140520110431.GX2485@laptop.programming.kicks-ass.net>
 <537B52BD.1080807@oracle.com>
 <537CA54A.8030408@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537CA54A.8030408@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 09:08:26AM -0400, Sasha Levin wrote:
> On 05/20/2014 09:03 AM, Sasha Levin wrote:
> > On 05/20/2014 07:04 AM, Peter Zijlstra wrote:
> >> > On Mon, May 19, 2014 at 10:05:31PM -0400, Sasha Levin wrote:
> >>> >> ping? It seems to be easy enough to reproduce on -next, I'd be happy to try
> >>> >> debug patches/fixes.
> >> > 
> >> > Does this fuzzing you do also include hotplug? If so, does disabling
> >> > that make this problem go away?
> >> > 
> > There were no hotplug operations going on when this happens, so it seems
> > unrelated.
> 
> I've added a small test:
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 927fa33..b5e11c7 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1154,6 +1156,7 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
>                 goto out;
> 
>         trace_sched_swap_numa(cur, arg.src_cpu, p, arg.dst_cpu);
> +       BUG_ON(cur == p);
>         ret = stop_two_cpus(arg.dst_cpu, arg.src_cpu, migrate_swap_stop, &arg);
> 
>  out:
> 
> 
> Which seems to get hit. This sounds like a race with task moving to
> other cpu maybe?

Oi, good call that, lemme go stare.
