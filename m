Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaCLEhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:37:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbaCLEhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:37:53 -0400
Date: Wed, 12 Mar 2014 15:37:41 +1100
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "majianpeng" <majianpeng@gmail.com>
Subject: Re: [PATCH] poll/wait/md: allow module to safely support 'poll' on
 /proc files
Message-ID: <20140312153741.07251019@notabene.brown>
In-Reply-To: <20140311211924.a7f57352.akpm@linux-foundation.org>
References: <20140312133638.1fd84632@notabene.brown>
	<20140311200331.2a841ea9.akpm@linux-foundation.org>
	<20140312141025.1a6c535f@notabene.brown>
	<20140311211924.a7f57352.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AU4vM0VFvAPvR0lwakwxkCo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AU4vM0VFvAPvR0lwakwxkCo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Mar 2014 21:19:24 -0700 Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Wed, 12 Mar 2014 14:10:25 +1100 NeilBrown <neilb@suse.de> wrote:
>=20
> > On Tue, 11 Mar 2014 20:03:31 -0700 Andrew Morton <akpm@linux-foundation=
.org>
> > wrote:
> >=20
> > > On Wed, 12 Mar 2014 13:36:38 +1100 NeilBrown <neilb@suse.de> wrote:
> > >=20
> > > >=20
> > > > The md driver currently supports 'poll' on /proc/mdstat.
> > > > This is unsafe as if the md-mod module is removed while a 'poll'
> > > > or 'select' is outstanding on /proc/mdstat, an oops occurs
> > > > when the syscall completes.
> > > > poll_freewait() will call remove_wait_queue() on a wait_queue_head_t
> > > > which was local to the module which no-longer exists.
> > > >=20
> > > > This problem is particular to /proc.  Most filesystems do not
> > > > allow the module to be unloaded while any files are open on it.
> > > > /proc only blocks module unloading while a file_operations
> > > > call is currently active into the module, not while the file is ope=
n.
> > > > kernfs has this property too but kernfs allocates a wait_queue_head=
_t
> > > > in its internal data structures so the module doesn't need to provi=
de
> > > > one.
> > > > (A previous patch to add a similar allocation to procfs was not
> > > > accepted).
> > >=20
> > > By who, me?  I was hoping we could somehow keep the implementation
> > > contained within md.  I don't think I actually looked at it to any
> > > significant extent!
> > >=20
> > > Was hoping that viro would pipe up.
> >=20
> > Was not accepted by anybody.  Everybody is guilty :-)
> > You were at least nice enough to comment (thanks).
> >=20
> > I think I like this version better so it might not be a problem that the
> > previous version was not accepted.  Depends on what the scheduler guys =
think
> > though....
>=20
> OK..
>=20
> > > > ...
> > > >
> > > > +/**
> > > > + * wait_queue_purge - remove all waiter from a wait_queue
> > > > + * @q: The queue to be purged
> > > > + *
> > > > + * Unlink all pending waiters from the queue.
> > > > + * This can be used prior to freeing a queue providing all waiters=
 are
> > > > + * prepared for queue purging.
> > > > + * Waiters must call remove_wait_queue_puregeable() rather than
> > > > + * remove_wait_queue().
> > > > + *
> > > > + */
> > > > +void wait_queue_purge(wait_queue_head_t *q)
> > > > +{
> > > > +	spin_lock(&q->lock);
> > > > +	while (!list_empty(&q->task_list))
> > > > +		list_del_init(q->task_list.next);
> > > > +	spin_unlock(&q->lock);
> > > > +	synchronize_rcu();
> > > > +}
> > > > +EXPORT_SYMBOL(wait_queue_purge);
> > >=20
> > > I don't get this.  If a task is waiting on that wait_queue_head_t, how
> > > does it get woken?
> >=20
> > This is only expected to be used by tasks which have some other means of
> > being woken up.  Possibly a timeout passed to 'select' or 'poll', possi=
bly a
> > signal.
>=20
> Oh.  So the caller is supposed to take the tasks off the queue via
> wait_queue_purge(), then to wake them up (which implies the caller has
> a second way of looking the tasks up).

No.  The caller of wait_queue_purge() doesn't care beyond purging the queue.
The process that are waiting will be in 'select' or 'poll' or similar and
there is no guarantee that anything will ever happen to wake them up.
They can just keep waiting for all I care.
I most cases they will have set their own timeout (or should have done).

I could wake_up() the wait_queue before purging it. Then the callers would
wake up, attempt IO, probably get EINVAL or something because the /proc file
has been de-registered and hopefully move on with life.
But that is really independent of the implementation of wait_queue_purge().

It is entirely possible for a process to be waiting on multiple events (And
in the select/poll case it is very common) and if one event wants to say
"this event is never ever going to happen so I'm detaching the queue", then
there is no particular reason to do anything but detach the queue.

>=20
> And the tasks themselves ...  do they need to know what happened?  If
> they run remove_wait_queue() then will still take
> wait_queue_head_t.lock, so the calling task need to somehow keep the
> wait_queue_head_t alive until everyone has woken and cleared off.

The tasks themselves mustn't run remove_wait_queue().  They must run
remove_wait_queue_purgeable().  This check if the remove has already happen=
ed
and avoids taking the spinlock (which no longer exists) in that case.

You cannot just call wait_queue_purge() on any old queue - only one that is
known to be potentially purged and waiters know to use
remove_wait_queue_purge().
Currently that is only wait_queues that are passed to poll_wait() inside a
->poll() method.

>=20
> Complex!  Could we please get that all fleshed out in the changelog and
> kerneldoc?

I thought the important parts (the waiter having to call
remove_wait_queue_purgeable()) already was in the kerneldoc.

Thanks,
NeilBrown


>=20
> > >=20
> > > > +/**
> > > > + * remove_wait_queue_puregeable - remove_wait_queue if wait_queue_=
purge might be used.
> > > > + * @q: the queue, which may already be purged, to remove from
> > > > + * @wait: the waiter to remove
> > > > + *
> > > > + * Remove a waiter from a queue if it hasn't already been purged.
> > > > + * If the queue has already been purged then task_list will be emp=
ty.
> > > > + * If it isn't then it is still safe to lock the queue and remove
> > > > + * the task.
> > > > + */
> > > > +void remove_wait_queue_purgeable(wait_queue_head_t *q, wait_queue_=
t *wait)
> > > > +{
> > > > +	unsigned long flags;
> > > > +
> > > > +	rcu_read_lock();
> > > > +	if (!list_empty(&wait->task_list)) {
> > > > +		spin_lock_irqsave(&q->lock, flags);
> > >=20
> > > Mixture of spin_lock_irqsave() here and spin_lock() in
> > > wait_queue_purge() looks odd.
> >=20
> > True - I was copying remove_wait_queue().  Maybe I should have just cal=
led
> > remove_wait_queue() directly (we don't actually need that _init on the
> > list_del).
>=20
> lockdep should have complained about the spin_lock().


--Sig_/AU4vM0VFvAPvR0lwakwxkCo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUx/kljnsnt1WYoG5AQIGfRAAprXb2a392krvRlw+ghVS0HgM1rePaGri
ah0cJjYIlQpxh7SdntKS15Bc+ANZfLXK2g5SaKzlXLBQuuCyw589Mbmczvvxr1Lu
jFARU4ehEv4ZYIBKtGflXtn646L0OfQue3RnUltNq8ohEry5jILqO1W3CMmu1ala
jk5p6EnHjvcgmhvYx/FllYeU6wKOj1QBHkIDlJjLieAu5xP2RP02k4b8AiRkuhok
LVuEcFYFcKjTb0FB0pSh+EImAJXsC2t12LCg/833HtJ1kBXecPO3me30vbWCUcyQ
Gwaf9bt1dk8g1uLRD4/I74mt/yZaXRsN7uR0Qbm1C+AWcH6Or8TF4i3xvNvkbgro
6GtPCOwe5oQfo9vN8y6OYP6jWNw2Ko0OSlwUHOumbxZZb0AoJkudEgwh2IeJa599
Lg73dy8Xjq0eFQDZ//EKEf9MYvu4+6Rm0OBTBtPd+FdNcu6Q9cVTIL6QVxMePp3G
wp/1B6JSTr4t+8Y9whITg5lqneiNWXPZeMm9HEeWKzLHspPXM0/ABRlCqvjo4v/w
GM6L3t78RU5hE3FY0givCKU1YSOMGpBb2yRZ7NVUOgT+O4b99apNszO/Mpyb/X+n
mlUyrRMiPNspJBfx81bdof9QE9X/iMXBy843O5V/kOzlMA7JxGd8XH/4rHTRNXi/
pre3OrVljps=
=9NEb
-----END PGP SIGNATURE-----

--Sig_/AU4vM0VFvAPvR0lwakwxkCo--
