Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab3CYUiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:38:54 -0400
Received: from shelob.surriel.com ([74.92.59.67]:54597 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab3CYUix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:38:53 -0400
Date: Mon, 25 Mar 2013 16:38:44 -0400
From: Rik van Riel <riel@surriel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com
Subject: [PATCH -mm -next] ipc,sem: fix lockdep false positive
Message-ID: <20130325163844.042a45ba@annuminas.surriel.com>
In-Reply-To: <5150B1C2.8090607@oracle.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<5150B1C2.8090607@oracle.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013 16:21:22 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> On 03/20/2013 03:55 PM, Rik van Riel wrote:
> > Include lkml in the CC: this time... *sigh*
> > ---8<---
> > 
> > This series makes the sysv semaphore code more scalable,
> > by reducing the time the semaphore lock is held, and making
> > the locking more scalable for semaphore arrays with multiple
> > semaphores.
> 
> Hi Rik,
> 
> I'm getting the following false positives from lockdep:

Does this patch fix it?

Andrew, this looks like another one for the queue...
---8<---
Subject: [PATCH -mm -next] ipc,sem: fix lockdep false positive

When locking all the semaphores inside a sem_array, the kernel ends up
locking a large number of locks with identical lockdep status. This
trips up lockdep.  Annotate the code to prevent such warnings.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 ipc/sem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 450248e..f46441a 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -357,7 +357,7 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 		spin_lock(&sma->sem_perm.lock);
 		for (i = 0; i < sma->sem_nsems; i++) {
 			struct sem *sem = sma->sem_base + i;
-			spin_lock(&sem->lock);
+			spin_lock_nested(&sem->lock, SINGLE_DEPTH_NESTING);
 		}
 		locknum = -1;
 	}
@@ -558,7 +558,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	for (i = 0; i < nsems; i++) {
 		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
 		spin_lock_init(&sma->sem_base[i].lock);
-		spin_lock(&sma->sem_base[i].lock);
+		spin_lock_nested(&sma->sem_base[i].lock, SINGLE_DEPTH_NESTING);
 	}
 
 	sma->complex_count = 0;

