Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaCLDKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:10:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbaCLDKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:10:36 -0400
Date: Wed, 12 Mar 2014 14:10:25 +1100
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "majianpeng" <majianpeng@gmail.com>
Subject: Re: [PATCH] poll/wait/md: allow module to safely support 'poll' on
 /proc files
Message-ID: <20140312141025.1a6c535f@notabene.brown>
In-Reply-To: <20140311200331.2a841ea9.akpm@linux-foundation.org>
References: <20140312133638.1fd84632@notabene.brown>
	<20140311200331.2a841ea9.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jY.Z+HGRRKKEBXLUVL4c=K/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jY.Z+HGRRKKEBXLUVL4c=K/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Mar 2014 20:03:31 -0700 Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Wed, 12 Mar 2014 13:36:38 +1100 NeilBrown <neilb@suse.de> wrote:
>=20
> >=20
> > The md driver currently supports 'poll' on /proc/mdstat.
> > This is unsafe as if the md-mod module is removed while a 'poll'
> > or 'select' is outstanding on /proc/mdstat, an oops occurs
> > when the syscall completes.
> > poll_freewait() will call remove_wait_queue() on a wait_queue_head_t
> > which was local to the module which no-longer exists.
> >=20
> > This problem is particular to /proc.  Most filesystems do not
> > allow the module to be unloaded while any files are open on it.
> > /proc only blocks module unloading while a file_operations
> > call is currently active into the module, not while the file is open.
> > kernfs has this property too but kernfs allocates a wait_queue_head_t
> > in its internal data structures so the module doesn't need to provide
> > one.
> > (A previous patch to add a similar allocation to procfs was not
> > accepted).
>=20
> By who, me?  I was hoping we could somehow keep the implementation
> contained within md.  I don't think I actually looked at it to any
> significant extent!
>=20
> Was hoping that viro would pipe up.

Was not accepted by anybody.  Everybody is guilty :-)
You were at least nice enough to comment (thanks).

I think I like this version better so it might not be a problem that the
previous version was not accepted.  Depends on what the scheduler guys think
though....

>=20
> > This patch takes a different approach and allows a module to
> > disconnect the wait_queue_head_t that was passed to poll_wait()
> > from all the clients which are waiting on it.  Thus after calling
> >  proc_remove_entry("mdstat", NULL);
> > we simply call
> >  wait_queue_purge(&md_event_waiters);
> >=20
> > and then know that it is safe to remove the module.
> >=20
> > rcu infrastructure is used to avoid races.
> > poll_freewait() checks if the purge has happened under rcu_read_lock()
> > to ensure that it never touches any freed memory.  wait_queue_purge()
> > uses synchronize_rcu() to ensure no poll_freewait() could still be
> > looking at the wait_queue_head_t.
> >=20
> > ...
> >
> > +/**
> > + * wait_queue_purge - remove all waiter from a wait_queue
> > + * @q: The queue to be purged
> > + *
> > + * Unlink all pending waiters from the queue.
> > + * This can be used prior to freeing a queue providing all waiters are
> > + * prepared for queue purging.
> > + * Waiters must call remove_wait_queue_puregeable() rather than
> > + * remove_wait_queue().
> > + *
> > + */
> > +void wait_queue_purge(wait_queue_head_t *q)
> > +{
> > +	spin_lock(&q->lock);
> > +	while (!list_empty(&q->task_list))
> > +		list_del_init(q->task_list.next);
> > +	spin_unlock(&q->lock);
> > +	synchronize_rcu();
> > +}
> > +EXPORT_SYMBOL(wait_queue_purge);
>=20
> I don't get this.  If a task is waiting on that wait_queue_head_t, how
> does it get woken?

This is only expected to be used by tasks which have some other means of
being woken up.  Possibly a timeout passed to 'select' or 'poll', possibly a
signal.

>=20
> > +/**
> > + * remove_wait_queue_puregeable - remove_wait_queue if wait_queue_purg=
e might be used.
> > + * @q: the queue, which may already be purged, to remove from
> > + * @wait: the waiter to remove
> > + *
> > + * Remove a waiter from a queue if it hasn't already been purged.
> > + * If the queue has already been purged then task_list will be empty.
> > + * If it isn't then it is still safe to lock the queue and remove
> > + * the task.
> > + */
> > +void remove_wait_queue_purgeable(wait_queue_head_t *q, wait_queue_t *w=
ait)
> > +{
> > +	unsigned long flags;
> > +
> > +	rcu_read_lock();
> > +	if (!list_empty(&wait->task_list)) {
> > +		spin_lock_irqsave(&q->lock, flags);
>=20
> Mixture of spin_lock_irqsave() here and spin_lock() in
> wait_queue_purge() looks odd.

True - I was copying remove_wait_queue().  Maybe I should have just called
remove_wait_queue() directly (we don't actually need that _init on the
list_del).

>=20
> > +		list_del_init(&wait->task_list);
> > +		spin_unlock_irqrestore(&q->lock, flags);
> > +	}
> > +	rcu_read_unlock();
> > +}
> > +EXPORT_SYMBOL(remove_wait_queue_purgeable);

Thanks,
NeilBrown

--Sig_/jY.Z+HGRRKKEBXLUVL4c=K/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUx/QITnsnt1WYoG5AQI98w/+LFGD4Lyk86WYxvce02ALr/bK67BQB0Pp
3G5gRYnqEYjeGxxDR3J19wzU4nBKpoNesOE4wy4LOadfBBAacuODsSlFYg9gAKyF
RNOI5cCHDOE8v1a1Mw/YogwlfgHB4NDaAeuf5Sx54mu7mCtMRmeG3nJp6XJhOwQ9
qYoa6C+E5uiGhiXBaJFbcMhjjC97SGVoxIcY8S/VPwt2tRq0HOkRnhqRIN9VKZnF
1H8rH/CTL2DCOVhLEVS8AsWDH6Siqw7AV2V+RrbOuftXd2KZDHKpj1HFjj3CNAKz
xAuAw8agf7GYZ6Up7HaFcylZno8jLpVZEZ87MmwRisNAR+eMWcS5NupcYl3jOUmk
Pzw4yAjjhnul+kuFucfUg5YdQGYGkqkUnWqFKhxVKSOIlFpPguuo5wr31nGPC4GA
dbTVuf1LDWWMNmVww5IS74ESBPH2sno0rS5GHXefVQy4xlbzNHyjZ+8oAG6Ynqsx
UUCs3Ta16DbXfdi3JRyIuGnj0dF8jGHe/JiViGl25mrEm0+d5/0jNYwUtfjrLSIF
XHQO7g9y64keuALJUh/mOsNWKiEwLMhZRbW4UWl64Mtr7Ay96OHuAOKS8vu2DhHX
Acvk2yCAsqKgU1cg6zyOX5fHOKA/JxEcQ7iTq99/vp6stgUYLnMMVofHK/E9pQa9
SzozHUXlM+I=
=Y/IW
-----END PGP SIGNATURE-----

--Sig_/jY.Z+HGRRKKEBXLUVL4c=K/--
