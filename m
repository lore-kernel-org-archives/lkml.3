Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3CaFCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 01:02:04 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:39270 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3CaFCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 01:02:02 -0400
Message-ID: <1364706119.6239.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Date: Sat, 30 Mar 2013 22:01:59 -0700
In-Reply-To: <CA+i8gKL3PCBW_KxkYSOKE7-PHdHVsP6eLUBTuYRtunBheALJMg@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	 <20130326192852.GA25899@redhat.com>
	 <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	 <20130329161746.GA8391@redhat.com>
	 <CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	 <CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
	 <CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
	 <CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
	 <1364609309.1818.8.camel@buesod1.americas.hpqcorp.net>
	 <CA+i8gK+LP_4SU8GwLMau0QvyGswZ5sKqOYnJVPZNWXZY_W9dEA@mail.gmail.com>
	 <CA+55aFzqzHa_6bHrqaa+6k3PZiibuJuDd1VwVD7jL047BjR=hA@mail.gmail.com>
	 <CA+i8gKL3PCBW_KxkYSOKE7-PHdHVsP6eLUBTuYRtunBheALJMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-30 at 11:33 +0700, Emmanuel Benisty wrote:
> On Sat, Mar 30, 2013 at 10:46 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Fri, Mar 29, 2013 at 8:02 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
> >>
> >> Then I start building a random package and the problems start. They
> >> may also happen without compiling but this seems to trigger the bug
> >> quite quickly.
> >
> > I suspect it's about preemption, and the build just results in enough
> > scheduling load that you start hitting whatever race there is.
> >
> >> Anyway, some progress here, I hope: dmesg seems to be
> >> willing to reveal some secrets (using some pastebin service since this
> >> is pretty big):
> >>
> >> https://gist.github.com/anonymous/5275120
> >
> > That looks like exactly the exit_sem() bug that Davidlohr was talking
> > about, where the
> >
> >                 /* exit_sem raced with IPC_RMID, nothing to do */
> >                 if (IS_ERR(sma))
> >                         continue;
> >
> > should be moved to *before* the
> >
> >                 sem_lock(sma, NULL, -1);
> >
> > call. And apparently the bug I had found is already fixed in -next.
> 
> I just tried the 7 original patches + the 2 one liners from -next +
> modified Linus' patch (attached) on the top of 3.9-rc4 using
> PREEMPT_NONE and after moving sem_lock(sma, NULL, -1) as explained
> above. I was building two packages at the same time, went away for 30
> seconds, came back and everything froze as soon as I touched the
> laptop's touchpad. Maybe a coincidence but anyway... Another shot in
> the dark, I had this weird message when trying to build gcc:
> semop(2): encountered an error: Identifier removed

*sigh*. I had high hopes for this being the bug triggering your issue,
specially after seeing exit_sem() in the trace. 

Emmanuel, just to be sure, does your changes reflect the patch below?
Specially dropping the rcu read lock before the continue statement
(sorry for not mentioning this in the last email).

Anyway, this is still a bug. Andrew, the patch below applies to
linux-next, please queue this up if you don't have any objections. 

Thanks,
Davidlohr

---8<---
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH] ipc, sem: do not call sem_lock when bogus sma

In exit_sem() we attempt to acquire the sma->sem_perm.lock by calling
sem_lock() immediately after obtaining sma. However, if sma isn't valid,
then calling sem_lock() will tend to do bad things.

Move the sma error check right after the sem_obtain_object_check() call instead.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/sem.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index f257afe..74cedfe 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1867,8 +1867,7 @@ void exit_sem(struct task_struct *tsk)
 		struct sem_array *sma;
 		struct sem_undo *un;
 		struct list_head tasks;
-		int semid;
-		int i;
+		int semid, i;
 
 		rcu_read_lock();
 		un = list_entry_rcu(ulp->list_proc.next,
@@ -1884,12 +1883,13 @@ void exit_sem(struct task_struct *tsk)
 		}
 
 		sma = sem_obtain_object_check(tsk->nsproxy->ipc_ns, un->semid);
-		sem_lock(sma, NULL, -1);
-
 		/* exit_sem raced with IPC_RMID, nothing to do */
-		if (IS_ERR(sma))
+		if (IS_ERR(sma)) {
+			rcu_read_unlock();
 			continue;
+		}
 
+		sem_lock(sma, NULL, -1);
 		un = __lookup_undo(ulp, semid);
 		if (un == NULL) {
 			/* exit_sem raced with IPC_RMID+semget() that created
-- 
1.7.11.7



