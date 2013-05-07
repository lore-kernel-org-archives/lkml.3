Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3EGWrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 18:47:48 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:34933 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3EGWrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 18:47:47 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 18:47:47 EDT
Message-ID: <1367966343.1770.3.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH v3 15/14] rwsem: check counter to avoid cmpxchg calls
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, Alex Shi <alex.shi@intel.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 07 May 2013 15:39:03 -0700
In-Reply-To: <1367934362-10433-1-git-send-email-walken@google.com>
References: <1367934362-10433-1-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 06:45 -0700, Michel Lespinasse wrote:
> (Davidlohr also has one additional patch which further improves throughput,
> though I will ask him to send it directly to you as I have suggested some
> minor changes).

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

This patch tries to reduce the amount of cmpxchg calls in the
writer failed path by checking the counter value first before
issuing the instruction. If ->count is not set to RWSEM_WAITING_BIAS
then there is no point wasting a cmpxchg call.

Furthermore, Michel states "I suppose it helps due to the case where
someone else steals the lock while we're trying to acquire sem->wait_lock."

Two very different workloads and machines were used to see how this
patch improves throughput: pgbench on a quad-core laptop and aim7 on a
large 8 socket box with 80 cores.

Some results comparing Michel's fast-path write lock stealing
(tps-rwsem) on a quad-core laptop running pgbench:

| db_size | clients  |  tps-rwsem     |   tps-patch  |
+---------+----------+----------------+--------------+
| 160 MB   |       1 |           6906 |         9153 | + 32.5
| 160 MB   |       2 |          15931 |        22487 | + 41.1%
| 160 MB   |       4 |          33021 |        32503 |
| 160 MB   |       8 |          34626 |        34695 |
| 160 MB   |      16 |          33098 |        34003 |
| 160 MB   |      20 |          31343 |        31440 |
| 160 MB   |      30 |          28961 |        28987 |
| 160 MB   |      40 |          26902 |        26970 |
| 160 MB   |      50 |          25760 |        25810 |
------------------------------------------------------
| 1.6 GB   |       1 |           7729 |         7537 |
| 1.6 GB   |       2 |          19009 |        23508 | + 23.7%
| 1.6 GB   |       4 |          33185 |        32666 |
| 1.6 GB   |       8 |          34550 |        34318 |
| 1.6 GB   |      16 |          33079 |        32689 |
| 1.6 GB   |      20 |          31494 |        31702 |
| 1.6 GB   |      30 |          28535 |        28755 |
| 1.6 GB   |      40 |          27054 |        27017 |
| 1.6 GB   |      50 |          25591 |        25560 |
------------------------------------------------------
| 7.6 GB   |       1 |           6224 |         7469 | + 20.0%
| 7.6 GB   |       2 |          13611 |        12778 |
| 7.6 GB   |       4 |          33108 |        32927 |
| 7.6 GB   |       8 |          34712 |        34878 |
| 7.6 GB   |      16 |          32895 |        33003 |
| 7.6 GB   |      20 |          31689 |        31974 |
| 7.6 GB   |      30 |          29003 |        28806 |
| 7.6 GB   |      40 |          26683 |        26976 |
| 7.6 GB   |      50 |          25925 |        25652 |
------------------------------------------------------

For the aim7 worloads, they overall improved on top of Michel's
patchset. For full graphs on how the rwsem series plus this patch
behaves on a large 8 socket machine against a vanilla kernel:
http://stgolabs.net/rwsem-aim7-results.tar.gz

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 lib/rwsem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index cf0ad2a..19c5fa9 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -223,7 +223,9 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 			count = RWSEM_ACTIVE_WRITE_BIAS;
 			if (!list_is_singular(&sem->wait_list))
 				count += RWSEM_WAITING_BIAS;
-			if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
+
+			if (sem->count == RWSEM_WAITING_BIAS &&
+			    cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
 							RWSEM_WAITING_BIAS)
 				break;
 		}
-- 
1.7.11.7



