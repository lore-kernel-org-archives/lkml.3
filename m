Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaA1TNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:13:22 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:44590 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaA1TNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:13:20 -0500
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [PATCH v2 0/5] mutex: Mutex scalability patches
Date: Tue, 28 Jan 2014 11:13:11 -0800
Message-Id: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
- Replace the previous patch that limits the # of times a thread can spin with
  !lock->owner with a patch that releases the mutex before holding the wait_lock
  in the __mutex_unlock_common_slowpath() function.
- Add a patch which allows a thread to attempt 1 mutex_spin_on_owner() without
  checking need_resched() if need_resched() triggered while in the MCS queue.
- Add a patch which disables preemption between modifying lock->owner and
  acquiring/releasing the mutex.

This patchset addresses a few scalability issues with mutexes.

Patch 1 has the mutex_can_spin_on_owner() funtion check for need_resched()
before being added to MCS queue. 

Patches 2, 3 are to fix issues with threads spinning when
there is no lock owner when the mutex is under high contention.

Patch 4 and 5 are RFC patches. Patch 4 disables preemption between modifying
lock->owner and locking/unlocking the mutex. Patch 5 addresses the situation
where spinners can potentially wait a long time in the MCS queue for a chance
to spin on mutex owner (not checking for need_resched()), yet ends up not
getting to spin.

These changes benefit the AIM7 fserver and high_systime workloads (run on disk)
on an 8 socket, 80 core box. The table below shows the performance
improvements with 3.13 + patches 1, 2, 3 when compared to the 3.13 baseline,
and the performance improvements with 3.13 + all 5 patches compared to
the 3.13 baseline.

Note: I split the % improvement into these 2 categories because
patch 3 and patch 5 are the most interesting/important patches in
this patchset in terms of performance improvements.

---------------------------------------------------------------
		high_systime
---------------------------------------------------------------
# users   | avg % improvement with | avg % improvement with
          | 3.13 + patch 1, 2, 3   | 3.13 + patch 1, 2, 3, 4, 5
---------------------------------------------------------------
1000-2000 |    +27.05%             |    +53.35%
---------------------------------------------------------------
100-900   |    +36.11%             |    +52.56%
---------------------------------------------------------------
10-90     |     +2.47%             |     +4.05%
---------------------------------------------------------------


---------------------------------------------------------------
		fserver
---------------------------------------------------------------
# users   | avg % improvement with | avg % improvement with
          | 3.13 + patch 1, 2, 3   | 3.13 + patch 1, 2, 3, 4, 5
---------------------------------------------------------------
1000-2000 |    +18.31%             |    +37.65%
---------------------------------------------------------------
100-900   |     +5.99%             |    +17.50%
---------------------------------------------------------------
10-90     |     +2.47%             |     +6.10%



