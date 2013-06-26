Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab3FZPUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:20:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60517 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3FZPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:20:04 -0400
Date: Wed, 26 Jun 2013 14:53:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2 5/5] rwsem: do optimistic spinning for writer lock
 acquisition
Message-ID: <20130626125338.GK28407@twins.programming.kicks-ass.net>
References: <cover.1372112541.git.tim.c.chen@linux.intel.com>
 <1372116051.22432.95.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372116051.22432.95.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 04:20:51PM -0700, Tim Chen wrote:
> +#ifdef CONFIG_RWSEM_SPIN_ON_WRITE_OWNER
> +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> +{
> +	int retval;
> +	task_struct *owner;
> +
> +	rcu_read_lock();
> +	owner = sem->owner;

That wants to be: owner = ACCESS_ONCE(sem->owner);

> +
> +	/* Spin only if active writer running */
> +	if (owner)
> +		retval = owner->on_cpu;
> +	else
> +		retval = false;
> +
> +	rcu_read_unlock();
> +	/*
> +	 * if lock->owner is not set, the sem owner may have just acquired
> +	 * it and not set the owner yet, or the sem has been released, or
> +	 * reader active.
> +	 */
> +	return retval;
> +}
