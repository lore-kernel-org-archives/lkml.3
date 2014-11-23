Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaKWSX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:23:59 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33420 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaKWSX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:23:57 -0500
Message-ID: <54722639.1040605@colorfullife.com>
Date: Sun, 23 Nov 2014 19:23:53 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rafael Aquini <aquini@redhat.com>,
        1vier1@web.de
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma initialization
References: <20141121145226.2ac598af@annuminas.surriel.com>
In-Reply-To: <20141121145226.2ac598af@annuminas.surriel.com>
Content-Type: multipart/mixed;
 boundary="------------050707060309090800000502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050707060309090800000502
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rik,

On 11/21/2014 08:52 PM, Rik van Riel wrote:
> When manipulating just one semaphore with semop, sem_lock only takes that
> single semaphore's lock. This creates a problem during initialization of
> the semaphore array, when the data structures used by sem_lock have not
> been set up yet. The sma->lock is already held by newary, and we just
> have to make sure everything else waits on that lock during initialization.
>
> Luckily it is easy to make sem_lock wait on the sma->lock, by pretending
> there is a complex operation in progress while the sma is being initialized.
That's not sufficient, as sma->sem_nsems is accessed before calling 
sem_lock(), both within find_alloc_undo() and within semtimedop().

The root problem is that sma->sem_nsems and sma->sem_base are accessed 
without any locks, this conflicts with the approach that sma starts to 
exist as not yet initialized but locked and is unlocked after the 
initialization is completed.

Attached is an idea. It did pass a few short tests.
What do you think?

With regards to affected kernels:
- wrong -EFBIG are possible since 3.10 (test for sma->sem_nsems moved 
before taking the lock)
- kernel memory corruptions with 0-sized undo buffer allocation is 
possible since 3.10, too.
   (sem_lock before accessing sma->sem_nsems replaced with 
sem_obtain_object_check).


--
     Manfred

--------------050707060309090800000502
Content-Type: text/x-patch;
 name="0001-ipc-sem.c-Fully-initialize-sem_array-before-making-i.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ipc-sem.c-Fully-initialize-sem_array-before-making-i.pa";
 filename*1="tch"

>From fa928cdd6b5e032006f100f9689a5a4167c086e8 Mon Sep 17 00:00:00 2001
From: Manfred Spraul <manfred@colorfullife.com>
Date: Sun, 23 Nov 2014 19:08:57 +0100
Subject: [PATCH] ipc/sem.c: Fully initialize sem_array before making it
 visible

ipc_addid() makes a new ipc identifier visible to everyone.
New objects start as locked, so that the caller can complete
the initialization after the call.
Within struct sem_array, at least sma->sem_base and sma->sem_nsems
are accessed without any locks, therefore this approach doesn't work.

Thus: Move the ipc_addid() to the end of the initialization.

Reported-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 454f6c6..53c3310 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -507,13 +507,6 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 		return retval;
 	}
 
-	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
-	if (id < 0) {
-		ipc_rcu_putref(sma, sem_rcu_free);
-		return id;
-	}
-	ns->used_sems += nsems;
-
 	sma->sem_base = (struct sem *) &sma[1];
 
 	for (i = 0; i < nsems; i++) {
@@ -528,6 +521,14 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
+
+	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
+	if (id < 0) {
+		ipc_rcu_putref(sma, sem_rcu_free);
+		return id;
+	}
+	ns->used_sems += nsems;
+
 	sem_unlock(sma, -1);
 	rcu_read_unlock();
 
-- 
1.9.3


--------------050707060309090800000502--
