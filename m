Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaFFRSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:18:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaFFRSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:18:04 -0400
Date: Fri, 6 Jun 2014 19:18:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@kernel.org
Subject: Re: [PATCH] sched,numa: always try to migrate to preferred node at
 task_numa_placement time
Message-ID: <20140606171801.GE11371@laptop.programming.kicks-ass.net>
References: <20140604163315.1dbc7b56@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604163315.1dbc7b56@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 04:33:15PM -0400, Rik van Riel wrote:
> It is possible that at task_numa_placement time, the task's
> numa_preferred_nid does not change, but the task is not
> actually running on the preferred node at the time.
> 
> In that case, we still want to attempt migration to the
> preferred node.

So we have that numa_migrate_retry which was supposed to keep kicking
the task until it got where it needed to go.

But now you continuously kick from task_numa_placement().

Clearly the retry thing didn't work, what happened? We got to the
preferred nid, disabled the retry and got moved away again?

Do we want to remove the retry logic in favour of this more aggressive
form?

> @@ -1575,11 +1575,13 @@ static void task_numa_placement(struct task_struct *p)

> +	if (max_faults) {
> +		/* Set the new preferred node */
> +		if (max_nid != p->numa_preferred_nid)
> +			sched_setnuma(p, max_nid);
> +
> +		if (task_node(p) != p->numa_preferred_nid)
> +			numa_migrate_preferred(p);
>  	}
>  


