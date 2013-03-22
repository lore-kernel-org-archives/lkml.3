Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3CVXm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 19:42:56 -0400
Received: from shelob.surriel.com ([74.92.59.67]:58405 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3CVXmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 19:42:55 -0400
Date: Fri, 22 Mar 2013 19:42:48 -0400
From: Rik van Riel <riel@surriel.com>
To: Michel Lespinasse <walken@google.com>
Cc: torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, lwoodman@redhat.com,
        chegu_vinod@hp.com, Rik van Riel <riel@redhat.com>
Subject: [PATCH 7/7 part3] fix for sem_lock
Message-ID: <20130322194248.6d2802d6@annuminas.surriel.com>
In-Reply-To: <CANN689FT6LGtFykOScV29MzZp2qeooaXZSeFp6_HhEF20g7ZMg@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<1363809337-29718-8-git-send-email-riel@surriel.com>
	<CANN689FT6LGtFykOScV29MzZp2qeooaXZSeFp6_HhEF20g7ZMg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +               /*
> > +                * If sma->complex_count was set while we were spinning,
> > +                * we may need to look at things we did not lock here.
> > +                */
> > +               if (unlikely(sma->complex_count)) {
> > +                       spin_unlock(&sma->sem_perm.lock);
> 
> I believe this should be spin_unlock(&sem->lock) instead ?

Michel, thanks for spotting this!

Andrew, could you fold this fix into my patch 7/7 before submitting
things for 3.10?  Thank you.

--->8---
Fix a typo in sem_lock.  Of course we need to unlock the local
semaphore lock before jumping to lock_all, in the rare case that
somebody started a complex operation while we were spinning on
the spinlock.

Can be folded into patch 7/7 before merging

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Michel Lespinasse <walken@google.com>
---
 ipc/sem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index a4b93fb..450248e 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -346,7 +346,7 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 		 * we may need to look at things we did not lock here.
 		 */
 		if (unlikely(sma->complex_count)) {
-			spin_unlock(&sma->sem_perm.lock);
+			spin_unlock(&sem->lock);
 			goto lock_all;
 		}
 		locknum = sops->sem_num;
