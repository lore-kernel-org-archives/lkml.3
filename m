Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaA1VIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:08:38 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20646 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbaA1VIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:08:36 -0500
Message-ID: <1390943313.11839.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 0/5] mutex: Mutex scalability patches
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Date: Tue, 28 Jan 2014 13:08:33 -0800
In-Reply-To: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 11:13 -0800, Jason Low wrote:
> v1->v2:
> - Replace the previous patch that limits the # of times a thread can spin with
>   !lock->owner with a patch that releases the mutex before holding the wait_lock
>   in the __mutex_unlock_common_slowpath() function.
> - Add a patch which allows a thread to attempt 1 mutex_spin_on_owner() without
>   checking need_resched() if need_resched() triggered while in the MCS queue.
> - Add a patch which disables preemption between modifying lock->owner and
>   acquiring/releasing the mutex.
> 
> This patchset addresses a few scalability issues with mutexes.
> 
> Patch 1 has the mutex_can_spin_on_owner() funtion check for need_resched()
> before being added to MCS queue. 
> 
> Patches 2, 3 are to fix issues with threads spinning when
> there is no lock owner when the mutex is under high contention.
> 
> Patch 4 and 5 are RFC patches. Patch 4 disables preemption between modifying
> lock->owner and locking/unlocking the mutex. Patch 5 addresses the situation
> where spinners can potentially wait a long time in the MCS queue for a chance
> to spin on mutex owner (not checking for need_resched()), yet ends up not
> getting to spin.
> 
> These changes benefit the AIM7 fserver and high_systime workloads (run on disk)
> on an 8 socket, 80 core box. The table below shows the performance
> improvements with 3.13 + patches 1, 2, 3 when compared to the 3.13 baseline,
> and the performance improvements with 3.13 + all 5 patches compared to
> the 3.13 baseline.

A lot of these changes are quite subtle. It would be good to see how
smaller systems are impacted with other workloads, not only big servers.
Since you see improvement in fserver, perhaps similar workloads could
also be of use: fio, filebench, postmark, fstress, etc.

Thanks,
Davidlohr

