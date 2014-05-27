Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaE0Rdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:33:33 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:2052 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaE0Rda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:33:30 -0400
Message-ID: <1401212004.2199.11.camel@j-VirtualBox>
Subject: Re: [PATCH v3] mutex: Documentation rewrite
From: Jason Low <jason.low2@hp.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        tim.c.chen@linux.intel.com, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        aswin@hp.com, linux-kernel@vger.kernel.org, jason.low2@hp.com
Date: Tue, 27 May 2014 10:33:24 -0700
In-Reply-To: <5384B735.6050501@hp.com>
References: <1400694115.2646.4.camel@buesod1.americas.hpqcorp.net>
	 <1400858184.2527.2.camel@buesod1.americas.hpqcorp.net>
	 <5384B735.6050501@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 12:03 -0400, Waiman Long wrote:
> On 05/23/2014 11:16 AM, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso<davidlohr@hp.com>
> >
> >
> > +
> > +(ii) midpath: aka optimistic spinning, tries to spin for acquisition
> > +     when there are no pending waiters and the lock owner is currently
> 
> That is not true. The spinning code doesn't check if there is any 
> pending waiters. So some tasks can be spinning while the others are 
> sleeping. The only checks are: 1) The lock owner is running; 2) there is 
> no other higher-priority ready-to-run task (need_resched).

Ah yes, I have noticed a similar comment in the mutex.c file and I have
been holding on to a patch which corrects the comments in that file. 

Below was the patch for your reference:

-----
Subject: [PATCH 2/3] mutex: Correct documention on mutex optimistic spinning

The mutex optimistic spinning documentation states that we spin for
acquisition when we find that there are no pending waiters. However,
in actuality, whether or not there are waiters for the mutex doesn't
determine if we will spin for it.

This patch removes that statement and also adds a comment which
mentions that we spin for the mutex while we don't need to reschedule.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 0925968..fc55f72 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -389,12 +389,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	/*
 	 * Optimistic spinning.
 	 *
-	 * We try to spin for acquisition when we find that there are no
-	 * pending waiters and the lock owner is currently running on a
-	 * (different) CPU.
-	 *
-	 * The rationale is that if the lock owner is running, it is likely to
-	 * release the lock soon.
+	 * We try to spin for acquisition when we find that the lock owner
+	 * is currently running on a (different) CPU and while we don't
+	 * need to reschedule. The rationale is that if the lock owner is
+	 * running, it is likely to release the lock soon.
 	 *
 	 * Since this needs the lock owner, and this mutex implementation
 	 * doesn't track the owner atomically in the lock field, we need to
-- 
1.7.1



