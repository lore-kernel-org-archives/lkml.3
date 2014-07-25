Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbaGYOHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:07:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760150AbaGYOHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:07:07 -0400
Date: Fri, 25 Jul 2014 16:06:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
Message-ID: <20140725140652.GA6758@twins.programming.kicks-ass.net>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
 <20140725081033.GV3935@laptop>
 <53D216A4.3090600@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="imfu1ARW87HJT4Qa"
Content-Disposition: inline
In-Reply-To: <53D216A4.3090600@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--imfu1ARW87HJT4Qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 04:34:44PM +0800, Yan, Zheng wrote:
> On 07/25/2014 04:10 PM, Peter Zijlstra wrote:
> > On Tue, Jul 22, 2014 at 04:09:59PM +0800, Yan, Zheng wrote:
> >> One corner case needs to mention is that the PEBS hardware doesn't
> >> deal well with collisions, when PEBS events happen near to each
> >> other. The records for the events can be collapsed into a single
> >> one. However in practice collisions are extremely rare, as long as
> >> different events are used. The periods are typically very large,
> >> so any collision is unlikely. When collision happens, we can either
> >> drop the PEBS record or use the record to serve multiple events.
> >> This patch chooses the later approach.
> >=20
> > You can't.. the events might have different security context.
> >=20
> > Remember, the overflow bit is set from the overflow until the PEBS
> > event is generated, this is quite a long time. So if another PEBS event
> > gets generated while the other is still pending it will have both bits
> > set. Even though the second bit is for another (unrelated) counter.
> >=20
> > The unrelated counter might not have privilege to observe the data of
> > the generated event.
> >=20
> > I think you can unwind and fully correct this trainwreck.
>=20
> could you give more information how to do this.

We went over that already:

lkml.kernel.org/r/20140528170531.GT30445@twins.programming.kicks-ass.net

Now ignore the patch there, its nonsense.

But the idea is that the bit gets cleared upon writing the PEBS record.
So look to the next record and see which bit got cleared.

Furthermore, we know that all bits set at PMI time are in-progress and
can therefore be cleared from the last record.

This should allow us to iterate the entire thing backwards and provide
a unique event for each record.

So take this series of 2 records and a PMI:

 C0  C1  C3  C4
 ---------------
  O
  |   O
  |   |
  |   A          < R1
  |       O
  A       |      < R2
 ---------+----- < PMI

O - overflow
A - assist

So at PMI time we have C3 set in the overflow mask, our last even R2
will have both C0 and C3 set, we clear C3 because we know it cannot have
been that. Then for R1 we have C0 and C1 set, but because R2 was C0 we
can clear C0 from R1, finding it was indeed C1.

So typically we'd have one event set and no problem, but in case there's
more we can reconstruct with such a backwards pass from a known good
state.

But when in doubt, we should drop the record, its the safest choice.

--imfu1ARW87HJT4Qa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT0mR3AAoJEHZH4aRLwOS6M60QAKDOa/bMtmrpymqGeEj6Oyqr
iPw+kbwz7e67B8WVVdK1liAcHz85FjOzYBhVEvzI7UQ0yVS2x+jPFBw1Wj54VM5H
qJIm5RG4JylBELiiZXzGAqHqWAaw7/XnOTK/n8zR8O+a1yiqKTwgaykmArrgWnG9
4rTSDuc906eUlXXiyWz3gq6cxRifzNXfz3imbqCyfITDsRcPBFjJLZi4tX2l/8tT
SkdG3NWTYv/ZfP8v3a1p/7KwiMRr1+KJNTixADJp8ZeuL0iEb0KMe/v7Sixo3rcB
tGeGedSyrxM+uBp98Y8O5900AkdKzMIGChpPxWZmXGQ6AaDiU8fpOu5LVJttV+Ge
N9DuVgbbyWq4STZ4Y2Ssylxfz5H9Xzd2WglHzxIYTKzITulmKs8w/tvBrkG4dZP/
Sa9FaLbaqCrtVcisTYYAlLdOG084aNMqzQGEjlHIA4YqjKxPQijTV2NsfHVueFXY
msDLnlGeA6Eo3enfo3s3OZcuaDSdMt8JeBrMkOhAK497PccKA2HdsM0FvmEnRaSw
4S27QcQVHvucbRJ4n9NCEhFe0a1/5HWxyIkAP9MC9Wsxr98W7fNkNG1aAp9DnWPd
6Ts/UEjW0QcNOkecxCC8uFjRtQmconjD5XHU3udEFfzDVebUUsyrAYsiTPjWqw3c
2IsqhJjjOZSlMAlhxBpr
=gOAY
-----END PGP SIGNATURE-----

--imfu1ARW87HJT4Qa--
