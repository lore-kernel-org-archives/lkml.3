Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3FXURo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:17:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:44233 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3FXURn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:17:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,930,1363158000"; 
   d="scan'208";a="358852838"
Subject: Re: [PATCH 2/2] rwsem: do optimistic spinning for writer lock
 acquisition
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Alex Shi <alex.shi@intel.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <51C894C3.4040407@hurleysoftware.com>
References: <cover.1371855277.git.tim.c.chen@linux.intel.com>
	 <1371858700.22432.5.camel@schen9-DESK>
	 <51C558E2.1040108@hurleysoftware.com>
	 <1372017836.1797.14.camel@buesod1.americas.hpqcorp.net>
	 <1372093876.22432.34.camel@schen9-DESK>
	 <51C894C3.4040407@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jun 2013 13:17:45 -0700
Message-ID: <1372105065.22432.65.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 14:49 -0400, Peter Hurley wrote:
> On 06/24/2013 01:11 PM, Tim Chen wrote:
> > On Sun, 2013-06-23 at 13:03 -0700, Davidlohr Bueso wrote:
> >> On Sat, 2013-06-22 at 03:57 -0400, Peter Hurley wrote:
> >>> On 06/21/2013 07:51 PM, Tim Chen wrote:
> >>>>
> >>>> +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> >>>> +{
> >>>> +	int retval = true;
> >>>> +
> >>>> +	/* Spin only if active writer running */
> >>>> +	if (!sem->owner)
> >>>> +		return false;
> >>>> +
> >>>> +	rcu_read_lock();
> >>>> +	if (sem->owner)
> >>>> +		retval = sem->owner->on_cpu;
> >>>                            ^^^^^^^^^^^^^^^^^^
> >>>
> >>> Why is this a safe dereference? Could not another cpu have just
> >>> dropped the sem (and thus set sem->owner to NULL and oops)?
> >>>
> >
> > The rcu read lock should protect against sem->owner being NULL.
> 
> It doesn't.
> 
> Here's the comment from mutex_spin_on_owner():
> 
>    /*
>     * Look out! "owner" is an entirely speculative pointer
>     * access and not reliable.
>     */

On second thought, I agree with you.  I should change this to
something like

	int retval = true;
	task_struct *sem_owner;

	/* Spin only if active writer running */
	if (!sem->owner)
		return false;

	rcu_read_lock();
	sem_owner = sem->owner;
	if (sem_owner)
		retval = sem_owner->on_cpu;

Thanks.

Tim


