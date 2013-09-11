Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3IKQEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:04:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab3IKQD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:03:58 -0400
Date: Wed, 11 Sep 2013 18:03:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>, Anton Vorontsov <anton@enomsg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] vmpressure: fix divide-by-0 in vmpressure_work_fn
Message-ID: <20130911160357.GA32273@dhcp22.suse.cz>
References: <alpine.LNX.2.00.1309062254470.11420@eggly.anvils>
 <20130909110847.GB18056@dhcp22.suse.cz>
 <20130911154057.GA16765@teo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911154057.GA16765@teo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-09-13 08:40:57, Anton Vorontsov wrote:
> On Mon, Sep 09, 2013 at 01:08:47PM +0200, Michal Hocko wrote:
> > On Fri 06-09-13 22:59:16, Hugh Dickins wrote:
> > > Hit divide-by-0 in vmpressure_work_fn(): checking vmpr->scanned before
> > > taking the lock is not enough, we must check scanned afterwards too.
> > 
> > As vmpressure_work_fn seems the be the only place where we set scanned
> > to 0 (except for the rare occasion when scanned overflows which
> > would be really surprising) then the only possible way would be two
> > vmpressure_work_fn racing over the same work item. system_wq is
> > !WQ_NON_REENTRANT so one work item might be processed by multiple
> > workers on different CPUs. This means that the vmpr->scanned check in
> > the beginning of vmpressure_work_fn is inherently racy.
> > 
> > Hugh's patch fixes the issue obviously but doesn't it make more sense to
> > move the initial vmpr->scanned check under the lock instead?
> > 
> > Anton, what was the initial motivation for the out of the lock
> > check? Does it really optimize anything?
> 
> Thanks a lot for the explanation.
> 
> Answering your question: the idea was to minimize the lock section, but the
> section is quite small anyway so I doubt that it makes any difference (during
> development I could not measure any effect of vmpressure() calls in my system,
> though the system itself was quite small).
> 
> I am happy with moving the check under the lock

The patch below. I find it little bit nicer than Hugh's original one
because having the two checks sounds more confusing.
What do you think Hugh, Anton?

> or moving the work into its own WQ_NON_REENTRANT queue.

That sounds like an overkill.

---
>From 888745909da34f8aee8a208a82d467236b828d0d Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 11 Sep 2013 17:48:10 +0200
Subject: [PATCH] vmpressure: fix divide-by-0 in vmpressure_work_fn

Hugh Dickins has reported a division by 0 when a vmpressure event is
processed. The reason for the exception is that a single vmpressure
work item (which is per memcg) might be processed by multiple CPUs
because it is enqueued on system_wq which is !WQ_NON_REENTRANT.
This means that the out of lock vmpr->scanned check in
vmpressure_work_fn is inherently racy and the racing workers will see
already zeroed scanned value after they manage to take the spin lock.

The patch simply moves the vmp->scanned check inside the sr_lock to fix
the race.

The issue was there since the very beginning but "vmpressure: change
vmpressure::sr_lock to spinlock" might have made it more visible as the
racing workers would sleep on the mutex and give it more time to see
updated value. The issue was still there, though.

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: stable@vger.kernel.org
---
 mm/vmpressure.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index e0f6283..ad679a0 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -164,18 +164,19 @@ static void vmpressure_work_fn(struct work_struct *work)
 	unsigned long scanned;
 	unsigned long reclaimed;
 
+	spin_lock(&vmpr->sr_lock);
+
 	/*
-	 * Several contexts might be calling vmpressure(), so it is
-	 * possible that the work was rescheduled again before the old
-	 * work context cleared the counters. In that case we will run
-	 * just after the old work returns, but then scanned might be zero
-	 * here. No need for any locks here since we don't care if
-	 * vmpr->reclaimed is in sync.
+	 * Several contexts might be calling vmpressure() and the work
+	 * item is sitting on !WQ_NON_REENTRANT workqueue so different
+	 * CPUs might execute it concurrently. Bail out if the scanned
+	 * counter is already 0 because all the work has been done already.
 	 */
-	if (!vmpr->scanned)
+	if (!vmpr->scanned) {
+		spin_unlock(&vmpr->sr_lock);
 		return;
+	}
 
-	spin_lock(&vmpr->sr_lock);
 	scanned = vmpr->scanned;
 	reclaimed = vmpr->reclaimed;
 	vmpr->scanned = 0;
-- 
1.7.10.4


-- 
Michal Hocko
SUSE Labs
