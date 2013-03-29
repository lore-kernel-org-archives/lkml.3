Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3C2VMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:12:16 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53818 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab3C2VMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:12:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
Date: Fri, 29 Mar 2013 14:12:13 -0700
X-Google-Sender-Auth: nrdcNp2tJUSC9l8DunjxlB1Rit4
Message-ID: <CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 1:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The alternative would be to make sure the thing is always locked (and
> in a rcu-read-safe region) before putref/getref. The only place (apart
> from the initial allocation, which doesn't matter, because nothing can
> see if itf that path fails) seems to be that freeque(), but I didn't
> check everything.
>
> Moving the
>
>     msg_unlock(msq);
>
> to the end of freeque() might be the way to go. It's going to cause us
> to hold the lock for longer, but I'm not sure we care for that path.

Uhhuh. I think shm_destroy() has the same pattern. And I think that
one has locking reasons why it has to do the shm_unlock() before
tearing some things down, although I'm not sure..

The good news is that shm doesn't seem to have any users of
ipc_rcu_get/putref(), so I don't see anything to race against. So it
has the same buggy pattern, but I don't think it can trigger anything.

And ipc/sem.c has the same bug-pattern in freeary(). It does
"sem_unlock(sma)" followed by "ipc_rcu_putref(sma);", and it *does*
seem to have code that that can race against (sem_lock_and_putref()).
The whole "sem_putref()" tries to be careful and gets the lock for the
last ref, but getting the lock doesn't help when freeary() does the
refcount access without it.

The semaphore case seems to argue fairly strongly for an "atomic_t
refcount", because right now it does a lot of "sem_putref()" stuff
that just gets the lock for the putref. So not only is that
insufficient (if it races against freeary(), but it's also more
expensive than just an atomic refcount would have been.

I dunno. I'm still not sure this is triggerable, but it looks bad. But
both the semaphore case and the msg cases seem to be solvable by
moving the unlock down, and shm seem to have no getref/putref users to
race with, so this (whitespace-damaged) patch *may* be sufficient:

diff --git a/ipc/msg.c b/ipc/msg.c
index 31cd1bf6af27..338d8e2b589b 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -284,7 +284,6 @@ static void freeque(struct ipc_namespace *ns,
struct kern_ipc_perm *ipcp)
        expunge_all(msq, -EIDRM);
        ss_wakeup(&msq->q_senders, 1);
        msg_rmid(ns, msq);
-       msg_unlock(msq);

        tmp = msq->q_messages.next;
        while (tmp != &msq->q_messages) {
@@ -297,6 +296,7 @@ static void freeque(struct ipc_namespace *ns,
struct kern_ipc_perm *ipcp)
        atomic_sub(msq->q_cbytes, &ns->msg_bytes);
        security_msg_queue_free(msq);
        ipc_rcu_putref(msq);
+       msg_unlock(msq);
 }

 /*
diff --git a/ipc/sem.c b/ipc/sem.c
index 58d31f1c1eb5..1cf024b9eac0 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -766,12 +766,12 @@ static void freeary(struct ipc_namespace *ns,
struct kern_ipc_perm *ipcp)

        /* Remove the semaphore set from the IDR */
        sem_rmid(ns, sma);
-       sem_unlock(sma);

        wake_up_sem_queue_do(&tasks);
        ns->used_sems -= sma->sem_nsems;
        security_sem_free(sma);
        ipc_rcu_putref(sma);
+       sem_unlock(sma);
 }

 static unsigned long copy_semid_to_user(void __user *buf, struct
semid64_ds *in, int version)

(I didn't check very carefully, it's possible that we end up having
some locking problem if we move the unlocks down later, but it *looks*
fine)

Anybody?

                Linus
