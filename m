Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3I0QTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:19:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:48455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab3I0QTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:19:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,994,1371106800"; 
   d="scan'208";a="410477768"
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <1380298323.2031.13.camel@j-VirtualBox>
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>
	 <1380147049.3467.67.camel@schen9-DESK>
	 <CAGQ1y=7Ehkr+ot3tDZtHv6FR6RQ9fXBVY0=LOyWjmGH_UjH7xA@mail.gmail.com>
	 <1380226007.2170.2.camel@buesod1.americas.hpqcorp.net>
	 <1380226997.2602.11.camel@j-VirtualBox>
	 <1380228059.2170.10.camel@buesod1.americas.hpqcorp.net>
	 <1380229794.2602.36.camel@j-VirtualBox>
	 <1380231702.3467.85.camel@schen9-DESK>
	 <1380235333.3229.39.camel@j-VirtualBox>
	 <1380236265.3467.103.camel@schen9-DESK> <20130927060213.GA6673@gmail.com>
	 <1380298323.2031.13.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Sep 2013 09:19:01 -0700
Message-ID: <1380298741.3467.104.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 09:12 -0700, Jason Low wrote:
> On Fri, 2013-09-27 at 08:02 +0200, Ingo Molnar wrote:
> > Would be nice to have this as a separate, add-on patch. Every single 
> > instruction removal that has no downside is an upside!
> 
> Okay, so here is a patch. Tim, would you like to add this to v7?

Okay.  Will do.

Tim

> 
> ...
> Subject: MCS lock: Remove and reorder unnecessary assignments in mcs_spin_lock()
> 
> In mcs_spin_lock(), if (likely(prev == NULL)) is true, then the lock is free
> and we won't spin on the local node. In that case, we don't have to assign
> node->locked because it won't be used. We can also move the node->locked = 0
> assignment so that it occurs after the if (likely(prev == NULL)) check.
> 
> This might also help make it clearer as to how the node->locked variable
> is used in MCS locks.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>  include/linux/mcslock.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mcslock.h b/include/linux/mcslock.h
> index 20fd3f0..1167d57 100644
> --- a/include/linux/mcslock.h
> +++ b/include/linux/mcslock.h
> @@ -21,15 +21,14 @@ void mcs_spin_lock(struct mcs_spin_node **lock, struct mcs_spin_node *node)
>  	struct mcs_spin_node *prev;
>  
>  	/* Init node */
> -	node->locked = 0;
>  	node->next   = NULL;
>  
>  	prev = xchg(lock, node);
>  	if (likely(prev == NULL)) {
>  		/* Lock acquired */
> -		node->locked = 1;
>  		return;
>  	}
> +	node->locked = 0;
>  	ACCESS_ONCE(prev->next) = node;
>  	smp_wmb();
>  	/* Wait until the lock holder passes the lock down */


