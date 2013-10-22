Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3JVCKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 22:10:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab3JVCKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 22:10:18 -0400
Date: Tue, 22 Oct 2013 13:09:53 +1100
From: NeilBrown <neilb@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131022130953.29fc5ac3@notabene.brown>
In-Reply-To: <20131017092349.GL2675@laptop.programming.kicks-ass.net>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
	<1381949500-501-2-git-send-email-treding@nvidia.com>
	<20131016200645.GD10651@twins.programming.kicks-ass.net>
	<20131016201410.GA26785@twins.programming.kicks-ass.net>
	<20131017073100.2cab1ffa@notabene.brown>
	<20131016205207.GE10651@twins.programming.kicks-ass.net>
	<20131017122859.67432627@notabene.brown>
	<20131017092349.GL2675@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NM7nuvxjn6cDahB6FRlUJBb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NM7nuvxjn6cDahB6FRlUJBb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Oct 2013 11:23:49 +0200 Peter Zijlstra <peterz@infradead.org>
wrote:

> On Thu, Oct 17, 2013 at 12:28:59PM +1100, NeilBrown wrote:
> > I always run with lockdep enabled, and I have done at least basic testi=
ng
>=20
> Very good!
>=20
> > >=20
> > > Stuff like:
> > >=20
> > > +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > > +		spin_lock_init(conf->hash_locks + i);
> > >=20
> > > And:
> > >=20
> > > +static void __lock_all_hash_locks(struct r5conf *conf)
> > > +{
> > > +	int i;
> > > +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > > +		spin_lock(conf->hash_locks + i);
> > > +}
> > >=20
> > > Tends to complain real loud.
> >=20
> > Why is that?
> > Because "conf->hash_locks + i" gets used as the "name" of the lockdep m=
ap for
> > each one, and when they are all locked it looks like nested locking??
>=20
> Exactly so; they all share the same class (and name) because they have
> the same init site; so indeed the multiple lock will look like a nested
> lock.
>=20
> > Do you have a suggestion for how to make this work?
> > Would
> >     spin_lock_nested(conf->hash_locks + i, i)
> > do the trick?
>=20
> 	spin_lock_nest_lock(conf->hash_locks + i, &conf->device_lock);

Unfortunately this doesn't work as the order is backwards.
hash_lock is taken first, then (when necessary) device lock.
(hash_lock is needed more often, so we split it up to reduce contention.
 device lock is needed less often, but sometimes when hash_lock is held).

I've currently got:
	spin_lock_init(conf->hash_locks);
	for (i =3D 1; i < NR_STRIPE_HASH_LOCKS; i++)
		spin_lock_init(conf->hash_locks + i);

and

	spin_lock(conf->hash_locks);
	for (i =3D 1; i < NR_STRIPE_HASH_LOCKS; i++)
		spin_lock_nest_lock(conf->hash_locks + i, conf->hash_locks);
	spin_lock(&conf->device_lock);

which doesn't trigger any lockdep warnings and isn't too ugly.

Does it seem OK to you?

Thanks,
NeilBrown


>=20
> Would be the better option; your suggestion might just work because
> NR_STRIP_HASH_LOCKS is 8 and we have exactly 8 subclasses available, but
> any increase to NR_STRIPE_HASH_LOCKS will make things explode again.
>=20
> The spin_lock_nest_lock() annotation tells that the lock order is
> irrelevant because all such multiple acquisitions are serialized under
> the other lock.
>=20
> Also, if in future you feel the need to increase NR_STRIP_HASH_LOCKS,
> please keep it <=3D 64 or so; if you have a need to go above that, please
> yell and we'll see if we can do something smarter.

I've added a comment to this effect in the code.


>=20
> This is because of:
>  - each spin_lock() increases preempt_count and that's 8 bits; we
>    wouldn't want to overflow that
>  - each consecutive nested spin_lock() increases the total acquisition
>    wait-time for all locks. Note that the worst case acquisition time
>    for even a single hash lock is gated by the complete acquisition time
>    of all of them in this scenario.


--Sig_/NM7nuvxjn6cDahB6FRlUJBb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmXecjnsnt1WYoG5AQJgPxAAhMNAQG299BHYgwRB/Q18TBGM5ISXjELq
0qJP3uY+R37GoNJdBf0P5asgbB8wMGCswTNQVbR8is1vdAbQrfd773lfKPdsFFM5
/eNfL9or3r6zzgHjwj5lF+qZfDXRcQUMIk4wXe0VOXElVKq+64cJ16p1KPyXwgfL
weweIwQNNhlKGffm1LprfvQN6fW6q66+WqGtDmO9nP8o228N3eaIKLtla2nyzLvE
1sULDW8T6pOdTGRJ6cX1NAAMiqmlnc+Dr5fU2Z6T6fbVjZCfklHJnm3D5aAMVr8Q
ihumO/+xNVg+2dDO8swSzDATNCj8jVzQ8+8WPI9iDbyy2rHRN3HBscWf4U9MVeMc
Su94jIV9g8epIRd689sUHU/juBc3v8PQDmRp5uEXCOQRp24cTrTdCFbYJ5pWuPTG
QRIqXTq5qwMqGAWvlO0GGqBxgogxwiYzMcpgw5yl0t7xWc3/rWWr/KMiSsEwrGI8
a4uuRlkKhHZKfw44X8ysnYdCRJsPdsTAn9zpgyzQaKwCvVI5yR1pLXv1NCqYMFy7
f7fjKCKt1XV68hyN81M5devfP1fxKaxQV2E5+AGWXaDtBXTUfWYBa2KURNQM8ldj
Gp1b8AdCFRC/zW2d4QtipAKPG+3rfoA4vuSQyGO+0szqkNdmMoJoRAsdnlQK5HkI
ddEndjn49w0=
=i9Et
-----END PGP SIGNATURE-----

--Sig_/NM7nuvxjn6cDahB6FRlUJBb--
