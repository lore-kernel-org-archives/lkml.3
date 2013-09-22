Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3IVI0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 04:26:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3IVI0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:26:15 -0400
Message-ID: <1379838364.5499.39.camel@marge.simpson.net>
Subject: Re: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in
 semaphore initialization
From: Mike Galbraith <bitbucket@online.de>
To: Jia He <jiakernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Sun, 22 Sep 2013 10:26:04 +0200
In-Reply-To: <1379837823.5499.34.camel@marge.simpson.net>
References: <1379815884-11035-1-git-send-email-jiakernel@gmail.com>
	 <1379837823.5499.34.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:kxIlArGnSy4L47ZPGIiU01ysMIlp5um8bp0/KaAHMlb
 fK52YwSlujsLM3toQcC5yKmHOOVVh6CZmWVuCkKIbGQLM+wZrq
 pLRck8R4y9EVBx+M3hkUv97yp9KMGGXOzhSKOzPPgvZyYReHoc
 A2DQwzmdRoxel6QLpNzD3WQ9htHiA8kzkgE1rvy62nrgJ0etKa
 Rs6nlwqaVYzL6NrgFBGrdx4c3BzEiKIywB5k/w2tVIGM7XSjcf
 Yv/q8OeQm2BVy2Ia1K4YYSYu7XAYqu/N3y7vDZnLU+rbczO28J
 gYvLAvKPMDnCftqWaQtuwuwlO45VfsrAXmRElBTD3qv1QDhmoZ
 eKYhVPYPqi0iVtPs0gZ06bp//3NgYnZyAnv2hvlLnsS0WZ6Jyv
 C2dRgpIhxebJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 10:17 +0200, Mike Galbraith wrote: 
> On Sun, 2013-09-22 at 10:11 +0800, Jia He wrote: 
> > In commit 0a2b9d4c,the update of semaphore's sem_otime(last semop time)
> > was removed because he wanted to move setting sem->sem_otime to one
> > place. But after that, the initial semop() will not set the otime
> > because its sem_op value is 0(in semtimedop,will not change
> > otime if alter == 1).
> > 
> > the error case:
> > process_a(server)       process_b(client)
> > semget()
> > semctl(SETVAL)
> > semop()
> >                         semget()
> >                         setctl(IP_STAT)
> >                         for(;;) {               <--not successful here
> >                           check until sem_otime > 0
> >                         }
> 
> Why not..

(pokes evolution's don't-munge-me button)

ipc,sem: Create semaphores with plausible sem_otime.

Signed-off-by: Mike Galbraith <bitbucket@online.de>

diff --git a/ipc/sem.c b/ipc/sem.c
index 4108889..f2564d7 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -471,19 +471,20 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	ns->used_sems += nsems;
 
 	sma->sem_base = (struct sem *) &sma[1];
+	sma->complex_count = 0;
+	INIT_LIST_HEAD(&sma->pending_alter);
+	INIT_LIST_HEAD(&sma->pending_const);
+	INIT_LIST_HEAD(&sma->list_id);
+	sma->sem_nsems = nsems;
+	sma->sem_ctime = get_seconds();
 
 	for (i = 0; i < nsems; i++) {
 		INIT_LIST_HEAD(&sma->sem_base[i].pending_alter);
 		INIT_LIST_HEAD(&sma->sem_base[i].pending_const);
 		spin_lock_init(&sma->sem_base[i].lock);
+		sma->sem_base[i].sem_otime = sma->sem_ctime;
 	}
 
-	sma->complex_count = 0;
-	INIT_LIST_HEAD(&sma->pending_alter);
-	INIT_LIST_HEAD(&sma->pending_const);
-	INIT_LIST_HEAD(&sma->list_id);
-	sma->sem_nsems = nsems;
-	sma->sem_ctime = get_seconds();
 	sem_unlock(sma, -1);
 	rcu_read_unlock();
 


