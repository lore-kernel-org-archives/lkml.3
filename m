Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaHSLRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:17:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaHSLRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:17:13 -0400
Date: Tue, 19 Aug 2014 21:16:54 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] RCU-walk support for autofs
Message-ID: <20140819211654.5ec3853a@notabene.brown>
In-Reply-To: <1408442547.11314.9.camel@perseus.themaw.net>
References: <20140818062844.9860.43007.stgit@notabene.brown>
	<1408350340.2533.3.camel@perseus.fritz.box>
	<1408442547.11314.9.camel@perseus.themaw.net>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/XgXnPR2MAOak02yXB+y2Jzu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XgXnPR2MAOak02yXB+y2Jzu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Aug 2014 18:02:27 +0800 Ian Kent <raven@themaw.net> wrote:

> On Mon, 2014-08-18 at 16:25 +0800, Ian Kent wrote:
> > On Mon, 2014-08-18 at 16:33 +1000, NeilBrown wrote:
> > > Hi Ian,
> > >  Have you had a chance to run your tests in these patches yet?
> > >  I've done what testing I can think of and cannot fault them.
> >=20
> > I haven't, I've been plagued with illness so I'm not getting nearly
> > enough done. I'll try to put a kernel together and run the test in the
> > next week or so.
>=20
> Just to let you know that I managed to spend some time on this. I built
> a kernel (3.17.0-rc1) with the series and ran a couple of tests.
>=20
> I'm not certain that the patches I used are identical to your posting, I
> saw one difference, after the fact, that shouldn't matter, I'll have to
> check that.
>=20
> It isn't possible to test expire to mount races because the mounts in
> the tree never expire.
>=20
> At first I thought it was because so many processes were accessing the
> tree all the time but manually constructing the maps and mounting the
> mounts shows that nothing ever expires, at least for this tree.
>=20
> However, issuing a shut down does expire all the mounts and shuts down
> autofs cleanly.
>=20
> So there is something not quite right with the expire check or my
> patches have mistakes.

Ahh.. I bet I know what it is.
autofs4_can_expire() isn't idempotent.
Because we call should_expire twice, autofs4_can_expire() is called twice a=
nd
the second time it failed because  the first time it resets ->last_used.

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index eb4b770a4bf6..80133a9d9427 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -26,6 +26,9 @@ static inline int autofs4_can_expire(struct dentry *dentr=
y,
 	if (ino =3D=3D NULL)
 		return 0;
=20
+	if (ino->flags & AUTOFS_INF_NO_RCU)
+		/* Already performed this test */
+		return 1;
 	if (!do_now) {
 		/* Too young to die */
 		if (!timeout || time_after(ino->last_used + timeout, now))



might fix it, but might be a hack.
(tests.... yep, that seems to fix it).

I'll think some more tomorrow.

Thanks,
NeilBrown

--Sig_/XgXnPR2MAOak02yXB+y2Jzu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/MyJznsnt1WYoG5AQL0kA//Q26OtkMFtRDEr08DMnFTtdDXmSm+4/kv
jatZfcaJ6Lj7Q70S5xR18f++uyKO48A1WHwUcfVbIbFzRo+GyRsZ0s9vtPqgnpO7
7PjUpfH+4Ro4gVOQ1d4DrcbFLvAWRKbeNlns6oQZoL9TCIkFb78qGob6Aq6423Sy
4ujESZvJtg3VVUZrv0E6sN1Qz3cLHkTXNgl3Sm/ozBIq7/Y8TaUROb9ICr3LkQMH
HcFpbO46vdHUrIo40rSki1hDYU1Emcwr3fNgyUAPEcRs+9dMB5r0WYNGa7kz9SZF
95JKwx5LIs0rIhszUdqBBwm35qMHPA5FMlUnEyG13bDPWTDd+LKoWB7P9iiMI/4C
WlFxN2bdvLxaZJGtROjBBHhSYr+qvzSKOaGoqKjkXWxGV6pfvUJklOgAQYMigEhz
lV1j0Am0QVcVw4veeVQ3LEEXK36yjMm3m7P3iwbcDWxH3eA0+drEDinlfzxaEEoq
JBRlAUIp6pm44jg6BDHHY7B8iMmZTosSKdRpCSncGEBmnxfkrMRxmbDBKFOLKgWT
++XyHeaARvRm64LRz6qbK8ZRosgi6WOF9pWxOqImpzQn5Gsk2HJq803duKVTSKlM
Z2HS68OKkVA+FalHt1M6NNW/mcgEXkmXhxu6P9qvL/vHOckz5rTeAMhCS2N8wqYo
hLGgXIrEZP4=
=RFQb
-----END PGP SIGNATURE-----

--Sig_/XgXnPR2MAOak02yXB+y2Jzu--
