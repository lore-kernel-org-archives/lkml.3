Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaIDPcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:32:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbaIDPcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:32:50 -0400
Date: Thu, 4 Sep 2014 17:32:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com, jcastillo@redhat.com,
        oleg@redhat.com, pzijlstr@redhat.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, minchan@kernel.org
Subject: Re: [PATCH 2/2] sched: BUG when stack end location is over written
Message-ID: <20140904153231.GE346@worktop.programming.kicks-ass.net>
References: <1409842224-11847-1-git-send-email-atomlin@redhat.com>
 <1409842224-11847-3-git-send-email-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409842224-11847-3-git-send-email-atomlin@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 03:50:24PM +0100, Aaron Tomlin wrote:
> Currently in the event of a stack overrun a call to schedule()
> does not check for this type of corruption. This corruption is
> often silent and can go unnoticed. However once the corrupted
> region is examined at a later stage, the outcome is undefined
> and often results in a sporadic page fault which cannot be
> handled.
> 
> This patch checks for a stack overrun and takes appropriate
> action since the damage is already done, there is no point
> in continuing.
> 
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> ---
>  kernel/sched/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ec1a286..d6af6a0 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2660,6 +2660,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
>   */
>  static inline void schedule_debug(struct task_struct *prev)
>  {
> +	if (unlikely(prev != &init_task &&
> +		task_stack_end_corrupted(prev)))
> +		BUG();

superfluous linebreak, also we appear to have BUG_ON() for situations
just like these.

secondly, while I appreciate the 'feature' you're making schedule()
slower for everybody, what do you propose to do about that?
