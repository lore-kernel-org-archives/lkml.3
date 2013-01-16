Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3APRT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:19:59 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48865 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab3APRT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:19:58 -0500
Date: Wed, 16 Jan 2013 09:19:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] async: fix __lowest_in_progress()
Message-ID: <20130116171952.GQ2668@htj.dyndns.org>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
 <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115183204.GE2668@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

083b804c4d3e1e3d0eace56bdbc0f674946d2847 ("async: use workqueue for
worker pool") made it possible that async jobs are moved from pending
to running out-of-order.  While pending async jobs will be queued and
dispatched for execution in the same order, nothing guarantees they'll
enter "1) move self to the running queue" of async_run_entry_fn() in
the same order.

This broke __lowest_in_progress().  running->domain may not be
properly sorted and is not guaranteed to contain lower cookies than
pending list when not empty.  Fix it by ensuring sort-inserting to the
running list and always looking at both pending and running when
trying to determine the lowest cookie.

Over time, the async synchronization implementation became quite
messy.  We better restructure it such that each async_entry is linked
to two lists - one global and one per domain - and not move it when
execution starts.  There's no reason to distinguish pending and
running.  They behave the same for synchronization purposes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: stable@vger.kernel.org
---
And here's the fix for the breakage I mentioned earlier.  It wouldn't
happen often in the wild and the effect of it happening wouldn't be
critical for modern distros but it's still kinda surprising nobody
noticed this.

We definitely need to rewrite async synchronization.  It was already
messy and this makes it worse and there's no reason to be messy here.

Thanks.

 kernel/async.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/kernel/async.c
+++ b/kernel/async.c
@@ -86,18 +86,27 @@ static atomic_t entry_count;
  */
 static async_cookie_t  __lowest_in_progress(struct async_domain *running)
 {
+	async_cookie_t first_running = next_cookie;	/* infinity value */
+	async_cookie_t first_pending = next_cookie;	/* ditto */
 	struct async_entry *entry;
 
+	/*
+	 * Both running and pending lists are sorted but not disjoint.
+	 * Take the first cookies from both and return the min.
+	 */
 	if (!list_empty(&running->domain)) {
 		entry = list_first_entry(&running->domain, typeof(*entry), list);
-		return entry->cookie;
+		first_running = entry->cookie;
 	}
 
-	list_for_each_entry(entry, &async_pending, list)
-		if (entry->running == running)
-			return entry->cookie;
+	list_for_each_entry(entry, &async_pending, list) {
+		if (entry->running == running) {
+			first_pending = entry->cookie;
+			break;
+		}
+	}
 
-	return next_cookie;	/* "infinity" value */
+	return min(first_running, first_pending);
 }
 
 static async_cookie_t  lowest_in_progress(struct async_domain *running)
@@ -118,13 +127,17 @@ static void async_run_entry_fn(struct wo
 {
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
+	struct async_entry *pos;
 	unsigned long flags;
 	ktime_t uninitialized_var(calltime), delta, rettime;
 	struct async_domain *running = entry->running;
 
-	/* 1) move self to the running queue */
+	/* 1) move self to the running queue, make sure it stays sorted */
 	spin_lock_irqsave(&async_lock, flags);
-	list_move_tail(&entry->list, &running->domain);
+	list_for_each_entry_reverse(pos, &running->domain, list)
+		if (entry->cookie < pos->cookie)
+			break;
+	list_move_tail(&entry->list, &pos->list);
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* 2) run (and print duration) */
