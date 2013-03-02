Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3CBVSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 16:18:40 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1086 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3CBVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 16:18:38 -0500
Message-ID: <1362259114.3602.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 2/2] ipc: semaphores: do not hold ipc lock more than
 necessary
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, "Vinod, Chegu" <chegu_vinod@hp.com>,
        "Low, Jason" <jason.low2@hp.com>, linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 02 Mar 2013 13:18:34 -0800
In-Reply-To: <CA+55aFx6Fhc8i1CFFOtwvZ-2=ir=Gs-8XjviXNTXJ0kew+N1DQ@mail.gmail.com>
References: <1362183404.3420.25.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFx6Fhc8i1CFFOtwvZ-2=ir=Gs-8XjviXNTXJ0kew+N1DQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 17:20 -0800, Linus Torvalds wrote:
> On Fri, Mar 1, 2013 at 4:16 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> > +static inline struct sem_array *sem_obtain_object(struct ipc_namespace *ns, int id)
> > +{
> > +       struct kern_ipc_perm *ipcp = ipc_obtain_object(&sem_ids(ns), id);
> > +
> > +       if (IS_ERR(ipcp))
> > +               return (struct sem_array *)ipcp;
> 
> This should use ERR_CAST() to make it more obvious what's going on.
> 
> > +static inline struct sem_array *sem_obtain_object_check(struct ipc_namespace *ns,
> > +                                                       int id)
> > +{
> > +       struct kern_ipc_perm *ipcp = ipc_obtain_object_check(&sem_ids(ns), id);
> > +
> > +       if (IS_ERR(ipcp))
> > +               return (struct sem_array *)ipcp;
> 
> Same here.

Ok

> 
> > +/*
> > + * Call inside the rcu read section.
> > + */
> > +static inline void sem_getref(struct sem_array *sma)
> > +{
> > +       spin_lock(&(sma)->sem_perm.lock);
> > +       ipc_rcu_getref(sma);
> > +       ipc_unlock(&(sma)->sem_perm);
> > +}
> 
> This really makes me wonder if we shouldn't just use an atomic counter
> for "refcount". But I guess that would be a separate patch.
> 

Ah, yes indeed.

> But all the uses of refcount really look like the normal atomic ops
> migth be the right thing. Especially if we no longer expect to hold
> the lock most of the time.
> 
> > +               spin_lock(&sma->sem_perm.lock);
> 
> I really would almost want to make these things be "ipc_lock_object()"
> rather than an open-coded spinlock like this. But that's not a big
> deal.

Sure.

> 
> Patch looks fine to me in general.
> 

Thanks for taking a look!

Davidlohr

