Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3FYHiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:38:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41010 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3FYHiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:38:19 -0400
Date: Tue, 25 Jun 2013 09:37:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Michel Lespinasse <walken@google.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] rwsem: do optimistic spinning for writer lock
 acquisition
Message-ID: <20130625073739.GX28407@twins.programming.kicks-ass.net>
References: <cover.1371855277.git.tim.c.chen@linux.intel.com>
 <1371858700.22432.5.camel@schen9-DESK>
 <51C558E2.1040108@hurleysoftware.com>
 <1372017836.1797.14.camel@buesod1.americas.hpqcorp.net>
 <1372093876.22432.34.camel@schen9-DESK>
 <51C894C3.4040407@hurleysoftware.com>
 <1372105065.22432.65.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372105065.22432.65.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 01:17:45PM -0700, Tim Chen wrote:
> On second thought, I agree with you.  I should change this to
> something like
> 
> 	int retval = true;
> 	task_struct *sem_owner;
> 
> 	/* Spin only if active writer running */
> 	if (!sem->owner)
> 		return false;
> 
> 	rcu_read_lock();
> 	sem_owner = sem->owner;

That should be: sem_owner = ACCESS_ONCE(sem->owner); to make sure the
compiler doesn't try and be clever and rereads.

> 	if (sem_owner)
> 		retval = sem_owner->on_cpu;
> 
