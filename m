Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaA1XL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:11:27 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:6162 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaA1XLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:11:25 -0500
Message-ID: <1390950683.2807.58.camel@j-VirtualBox>
Subject: Re: [PATCH v2 0/5] mutex: Mutex scalability patches
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Date: Tue, 28 Jan 2014 15:11:23 -0800
In-Reply-To: <1390943313.11839.7.camel@buesod1.americas.hpqcorp.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	 <1390943313.11839.7.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 13:08 -0800, Davidlohr Bueso wrote:
> On Tue, 2014-01-28 at 11:13 -0800, Jason Low wrote:
> > v1->v2:
> > - Replace the previous patch that limits the # of times a thread can spin with
> >   !lock->owner with a patch that releases the mutex before holding the wait_lock
> >   in the __mutex_unlock_common_slowpath() function.
> > - Add a patch which allows a thread to attempt 1 mutex_spin_on_owner() without
> >   checking need_resched() if need_resched() triggered while in the MCS queue.
> > - Add a patch which disables preemption between modifying lock->owner and
> >   acquiring/releasing the mutex.
> > 
> > This patchset addresses a few scalability issues with mutexes.
> > 
> > Patch 1 has the mutex_can_spin_on_owner() funtion check for need_resched()
> > before being added to MCS queue. 
> > 
> > Patches 2, 3 are to fix issues with threads spinning when
> > there is no lock owner when the mutex is under high contention.
> > 
> > Patch 4 and 5 are RFC patches. Patch 4 disables preemption between modifying
> > lock->owner and locking/unlocking the mutex. Patch 5 addresses the situation
> > where spinners can potentially wait a long time in the MCS queue for a chance
> > to spin on mutex owner (not checking for need_resched()), yet ends up not
> > getting to spin.
> > 
> > These changes benefit the AIM7 fserver and high_systime workloads (run on disk)
> > on an 8 socket, 80 core box. The table below shows the performance
> > improvements with 3.13 + patches 1, 2, 3 when compared to the 3.13 baseline,
> > and the performance improvements with 3.13 + all 5 patches compared to
> > the 3.13 baseline.
> 
> A lot of these changes are quite subtle. It would be good to see how
> smaller systems are impacted with other workloads, not only big servers.
> Since you see improvement in fserver, perhaps similar workloads could
> also be of use: fio, filebench, postmark, fstress, etc.

Okay, I will include the numbers I collect on smaller systems next time
(even if the % difference is small).

Thanks,
Jason

