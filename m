Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbbAGRG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:06:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41600 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbbAGRGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:06:54 -0500
Date: Wed, 7 Jan 2015 17:06:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Ashay Jaiswal <ashayj@codeaurora.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Anirudh Ghayal <aghayal@codeaurora.org>
Message-ID: <20150107170646.GX2634@sirena.org.uk>
References: <1420638683-20216-1-git-send-email-ashayj@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RN8gaMXH6squMiby"
Content-Disposition: inline
In-Reply-To: <1420638683-20216-1-git-send-email-ashayj@codeaurora.org>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: fix race condition in regulator_put()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RN8gaMXH6squMiby
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 07, 2015 at 07:21:23PM +0530, Ashay Jaiswal wrote:

> The regulator framework maintains a list of consumer regulators
> for a regulator device and protects it from concurrent access
> using the regulator device's mutex lock.

> In the case of regulator_put() the consumer is removed without
> holding the regulator device's mutex, resulting in a race condition
> between any regulator operation which traverses the consumer list
> and regulator_put() which releases the consumer regulator.
> Fix this race condition by holding the regulator device's mutex while
> removing and releasing the consumer regulator.

This is a good spot thanks but I think your analysis here is missing a
bit - it's not just the list manipulation that affects the rdev, it's
also the reference count in the rdev and the exclusive flag.  Indeed
some of this issue applies on the _get() side too, while we do add the
regulator to the list under the rdev mutex we don't have the mutex when
we update the reference count meaning that we've got a potential issue
with that.  That *is* kind of separate though so could be dealt with in
a separate patch.

The lock region also seems too wide, the lock is only needed for the
operations that affect the rdev not for the operations only on the
object being freed - holding the lock for too long means impacting other
users and some of the cleanup is potentially expensive.  The comment at
the top of the function needs updating too, it currently says that the
lock is held in the caller but this applies only to the regulator_list_mutex.

--RN8gaMXH6squMiby
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrWemAAoJECTWi3JdVIfQi84H/0JhSflCobZvP6KmvLWNRGpU
oOVDj/wLefmLXctT/Gts2WKa6eoN6E3ij38oxZuNsNFlry3eU/wP+XPZthmb6n36
q7eBpNUxUqu5lx0KNGVFfW6W2Cv0MVn7rj0KoUpRW9bsthLzQRZw2VBKHTQfSjHi
hOUl3CAJfn92Yz7nwevelz+LMOl2rVkaIFNsU5I1ChSxGYeLRUesIW/tRyHqdntj
n/FF21tetd6Vw2iwB99C8//z5G916ZpKKCwwqWDENSEP8t+ha7ol4/qO+DNkkUhv
2vQ8D2TbPhjX391VbhwMy63j9ETsi5cbgbzpX1TxFMgwI1NwVtDVX6FV8/Y/nQQ=
=mP29
-----END PGP SIGNATURE-----

--RN8gaMXH6squMiby--
