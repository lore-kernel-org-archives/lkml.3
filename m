Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaLHWrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:47:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbaLHWrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:47:47 -0500
Date: Tue, 9 Dec 2014 09:47:35 +1100
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH workqueue/for-3.18-fixes 2/2] workqueue: allow rescuer
 thread to do more work
Message-ID: <20141209094735.0a5cfab0@notabene.brown>
In-Reply-To: <20141208174052.GA12274@htj.dyndns.org>
References: <20141110162848.6f2246bb@notabene.brown>
	<20141110085250.GB15948@quack.suse.cz>
	<20141111090402.35fa0700@notabene.brown>
	<20141118152754.60b0c75e@notabene.brown>
	<20141202204304.GR10918@htj.dyndns.org>
	<20141203114011.5d02dc43@notabene.brown>
	<20141203172010.GC5013@htj.dyndns.org>
	<20141203180241.GD5013@htj.dyndns.org>
	<20141204151104.GD15219@htj.dyndns.org>
	<20141204151223.GE15219@htj.dyndns.org>
	<20141208174052.GA12274@htj.dyndns.org>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/lheQ7uvvtqigtzNYpX40_rI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lheQ7uvvtqigtzNYpX40_rI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Dec 2014 12:40:52 -0500 Tejun Heo <tj@kernel.org> wrote:

> On Thu, Dec 04, 2014 at 10:12:23AM -0500, Tejun Heo wrote:
> > From: NeilBrown <neilb@suse.de>
> >=20
> > When there is serious memory pressure, all workers in a pool could be
> > blocked, and a new thread cannot be created because it requires memory
> > allocation.
> >=20
> > In this situation a WQ_MEM_RECLAIM workqueue will wake up the
> > rescuer thread to do some work.
> >=20
> > The rescuer will only handle requests that are already on ->worklist.
> > If max_requests is 1, that means it will handle a single request.
> >=20
> > The rescuer will be woken again in 100ms to handle another max_requests
> > requests.
> >=20
> > I've seen a machine (running a 3.0 based "enterprise" kernel) with
> > thousands of requests queued for xfslogd, which has a max_requests of
> > 1, and is needed for retiring all 'xfs' write requests.  When one of
> > the worker pools gets into this state, it progresses extremely slowly
> > and possibly never recovers (only waited an hour or two).
> >=20
> > With this patch we leave a pool_workqueue on mayday list
> > until it is clearly no longer in need of assistance.  This allows
> > all requests to be handled in a timely fashion.
> >=20
> > We keep each pool_workqueue on the mayday list until
> > need_to_create_worker() is false, and no work for this workqueue is
> > found in the pool.
> >=20
> > I have tested this in combination with a (hackish) patch which forces
> > all work items to be handled by the rescuer thread.  In that context
> > it significantly improves performance.  A similar patch for a 3.0
> > kernel significantly improved performance on a heavy work load.
> >=20
> > Thanks to Jan Kara for some design ideas, and to Dongsu Park for
> > some comments and testing.
> >=20
> > tj: Inverted the lock order between wq_mayday_lock and pool->lock with
> >     a preceding patch and simplified this patch.  Added comment and
> >     updated changelog accordingly.  Dongsu spotted missing get_pwq()
> >     in the simplified code.
> >=20
> > Cc: Dongsu Park <dongsu.park@profitbricks.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > Signed-off-by: Tejun Heo <tj@kernel.org>
>=20
> Too late for for-3.18-fixes.  Applied the two patches to wq/for-3.19.

I've just run my synthetic test which forces most works to be handled by the
rescuer thread.  With these patches it works more smoothly than without.
And importantly: it still works :-)

Thanks,
NeilBrown

--Sig_/lheQ7uvvtqigtzNYpX40_rI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVIYqhznsnt1WYoG5AQLfihAAjajliIcNbslIpxJ+zlZXXhncXw/dIK8T
eCvNCqU+ZZsUdKRtBWdjHNONXgJP+2L/mwCq0vktd8wk5yWRasXZvs8goWwG/6ht
ktI2iIgmGLKsq4pFytBmqz8wM7eW1CzMzf5zX/pf6+b5XpHPaLSmYsaWJhDb2DOJ
fpESRCZoeUy4yynLeyhh0uycNMu9LFmrr01OpO9Xx9oB5YnkIYCFFwGYDUESRgHK
wd7ekpQ9hVjtaq1DzZyoRB+vFnbU8N57sQo7SJHcKKF+mu8uha9LBINN8dFZjHBJ
IxPCro3FqhtR4OVdyRTOAgkl/Q4t883RuFC1Jx6QV9s9xRvcKyAWfzXIB0TiuV6Y
zKQVjEL45+SbKG3xUopvj2EiqlgVInb3jfC3ExE8OSiVAPNpTotGFKXeOyEx39ZL
HpAPOQ/5ydPGi1rRdloAXUC+Nhuy5suflgT/tgZw6f7DwEEgCQ57VCjPa0jMQgoG
aQVYThy/qyxD6vCRBKGOlwh8sO18tnZZczfrZqZmHbBb23XyHtUfMe9sSVy2Ll6p
U1O41vtMSeQBf3mRwNg4ewRk+sK+/8V26sLWUTC6t1SGsPIUmKUOSs+4WAVXGdk7
lIoGIeFRlhkIdfYckjvLA9AWZBIlggYkLBbFXbCyFSnucCzeFya9WBU30xs2JVWz
cLuEneFU9As=
=7l1D
-----END PGP SIGNATURE-----

--Sig_/lheQ7uvvtqigtzNYpX40_rI--
