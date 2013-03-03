Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab3CCFcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 00:32:20 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:30760 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3CCFcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 00:32:19 -0500
Message-ID: <1362288734.2886.14.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH 1/2] ipc: introduce obtaining a lockless ipc object
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Emmanuel Benisty <benisty.e@gmail.com>, Rik van Riel <riel@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 02 Mar 2013 21:32:14 -0800
In-Reply-To: <CA+55aFzxJo3y7r_5BvUVwZX4LyC6dba8qPTbp+iDf_nRgYg4cw@mail.gmail.com>
References: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFzxJo3y7r_5BvUVwZX4LyC6dba8qPTbp+iDf_nRgYg4cw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 13:24 -0800, Linus Torvalds wrote:
> On Fri, Mar 1, 2013 at 4:16 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> > @@ -784,7 +806,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
> >         int err;
> >
> >         down_write(&ids->rw_mutex);
> > -       ipcp = ipc_lock_check(ids, id);
> > +       ipcp = ipc_obtain_object_check(ids, id);
> >         if (IS_ERR(ipcp)) {
> >                 err = PTR_ERR(ipcp);
> >                 goto out_up;
> > @@ -801,7 +823,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
> >                 return ipcp;
> >
> >         err = -EPERM;
> > -       ipc_unlock(ipcp);
> > +       rcu_read_unlock();
> >  out_up:
> >         up_write(&ids->rw_mutex);
> >         return ERR_PTR(err);
> 
> Uhhuh. This is very buggy, and I think it's the reason for the later
> bugs that Emmanuel reported.

Yes, quite buggy. I was able to mess up three different machines with
this, and since semaphores aren't the only users of ipcctl_pre_down(),
it could explain the sys_shmctl() call in the trace Emmanuel reported. 

> 
> In particular, the *non-error* case is buggy, where it in the middle
> of the function does
> 
>     return ipcp;
> 
> for a successful lookup.
> 
> It used to return a locked ipcp, now it no longer does. And you didn't
> change any of the callers, which still do the "ipc_unlock()" at the
> end.  So all the locking gets completely confused.
> 

After updating the callers, [msgctl, semctl, shmctl]_down, to acquire
the lock for IPC_RMID and IPC_SET commands, I'm no longer seeing these
issues - so far on my regular laptop and two big boxes running my Oracle
benchmarks for a few hours. Something like below (yes, I will address
the open coded spin_lock calls):

@@ -1101,16 +1138,20 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 
        switch(cmd){
        case IPC_RMID:
+               spin_lock(&sma->sem_perm.lock);
                freeary(ns, ipcp);
                goto out_up;
        case IPC_SET:
+               spin_lock(&sma->sem_perm.lock);
                err = ipc_update_perm(&semid64.sem_perm, ipcp);
                if (err)
                        goto out_unlock;
                sma->sem_ctime = get_seconds();
                break;
        default:
+               rcu_read_unlock();
                err = -EINVAL;
+               goto out_up;
        }

