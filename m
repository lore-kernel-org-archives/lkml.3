Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506Ab3CZO1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:27:10 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35420
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759784Ab3CZO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:27:07 -0400
Message-ID: <1364308023.5053.40.camel@laptop>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@surriel.com>, Sasha Levin <sasha.levin@oracle.com>,
        torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, lwoodman@redhat.com,
        chegu_vinod@hp.com, Dave Jones <davej@redhat.com>, benisty.e@gmail.com,
        Ingo Molnar <mingo@redhat.com>
Date: Tue, 26 Mar 2013 15:27:03 +0100
In-Reply-To: <CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <5150B1C2.8090607@oracle.com>
	 <20130325163844.042a45ba@annuminas.surriel.com>
	 <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
	 <1364303965.5053.29.camel@laptop>
	 <CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 06:40 -0700, Michel Lespinasse wrote:

> sem_nsems is user provided as the array size in some semget system
> call. It's the size of an ipc semaphore array.

So we're basically adding a random (big) number to preempt_count
(obviously while preemption is disabled), seems rather costly and
undesirable.

> complex semop operations take the array's lock plus every semaphore
> locks; simple semop operations (operating on a single semaphore) only
> take that one semaphore's lock.

Right, standard global/local lock like stuff. Is there a way we can add
a r/o test to the 'local' lock operation and avoid doing the above?

Maybe something like:

void sma_lock(struct sem_array *sma) /* global */
{
	int i;

	sma->global_locked = 1;
	smp_wmb(); /* can we merge with the LOCK ? */
	spin_lock(&sma->global_lock);

	/* wait for all local locks to go away */
	for (i = 0; i < sma->sem_nsems; i++)
		spin_unlock_wait(&sem->sem_base[i]->lock);	
}

void sma_lock_one(struct sem_array *sma, int nr) /* local */
{
	smp_rmb(); /* pairs with wmb in sma_lock() */
	if (unlikely(sma->global_locked)) { /* wait for global lock */
		while (sma->global_locked)
			spin_unlock_wait(&sma->global_lock);
	}
	spin_lock(&sma->sem_base[nr]->lock);
}

This still has the problem of a non-preemptible section of O(sem_nsems) 
(with the avg wait-time on the local lock). Could we make the global 
lock a sleeping lock?



