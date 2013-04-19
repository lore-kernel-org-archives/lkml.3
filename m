Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030752Ab3DSOoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:44:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19276 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030615Ab3DSOoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:44:16 -0400
Date: Fri, 19 Apr 2013 10:44:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        axboe@kernel.dk
Cc: roger.pau@citrix.com
Subject: [GIT PULL] (xen) stable/for-jens-3.10
Message-ID: <20130419144401.GA14700@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Jens,

Please in your spare time (if there is such a thing at a conference)
pull this branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-je=
ns-3.10

for your v3.10 branch. Sorry for being so late with this.

<blurb>
It has the 'feature-max-indirect-segments' implemented in both backend
and frontend. The current problem with the backend and frontend is that the
segment size is limited to 11 pages. It means we can at most squeeze in 44k=
B per
request. The ring can hold 32 (next power of two below 36) requests, meanin=
g we
can do 1.4M of outstanding requests. Nowadays that is not enough.

The problem in the past was addressed in two ways - but neither one went up=
stream.
The first solution to this proposed by Justin from Spectralogic was to nego=
tiate
the segment size.  This means that the =E2=80=98struct blkif_sring_entry=E2=
=80=99 is now a variable size.
It can expand from 112 bytes (cover 11 pages of data - 44kB) to 1580 bytes
(256 pages of data - so 1MB). It is a simple extension by just making the a=
rray in the
request expand from 11 to a variable size negotiated. But it had limits: th=
is extension
still limits the number of segments per request to 255 (as the total number=
 must be
specified in the request, which only has an 8-bit field for that purpose).

The other solution (from Intel - Ronghui) was to create one extra ring that=
 only has the
=E2=80=98struct blkif_request_segment=E2=80=99 in them. The =E2=80=98struct=
 blkif_request=E2=80=99 would be changed to have
an index in said =E2=80=98segment ring=E2=80=99. There is only one segment =
ring. This means that the size of
the initial ring is still the same. The requests would point to the segment=
 and enumerate out
how many of the indexes it wants to use. The limit is of course the size of=
 the segment.
If one assumes a one-page segment this means we can in one request cover ~4=
MB.
Those patches were posted as RFC and the author never followed up on the id=
eas on changing
it to be a bit more flexible.

There is yet another mechanism that could be employed =C2=A0(which these pa=
tches implement) - and it
borrows from VirtIO protocol. And that is the =E2=80=98indirect descriptors=
=E2=80=99. This very similar to
what Intel suggests, but with a twist. The twist is to negotiate how many o=
f these
'segment' pages (aka indirect descriptor pages) we want to support (in real=
ity we negotiate
how many entries in the segment we want to cover, and we module the number =
if it is
bigger than the segment size).

This means that with the existing 36 slots in the ring (single page) we can=
 cover:
32 slots * each blkif_request_indirect covers: 512 * 4096 ~=3D 64M. Since w=
e ample space
in the blkif_request_indirect to span more than one indirect page, that num=
ber (64M)
can be also multiplied by eight =3D 512MB.=20

Roger Pau Monne took the idea and implemented them in these patches. They w=
ork
great and the corner cases (migration between backends with and without thi=
s extension)
work nicely. The backend has a limit right now off how many indirect entries
it can handle: one indirect page, and at maximum 256 entries (out of 512 - =
so  50% of the page
is used). That comes out to 32 slots * 256 entries in a indirect page * 1 i=
ndirect page
per request * 4096 =3D 32MB.

This is a conservative number that can change in the future. Right now it s=
trikes
a good balance between giving excellent performance, memory usage in the ba=
ckend, and
balancing the needs of many guests.

In the patchset there is also the split of the blkback structure to be per-=
VBD.
This means that the spinlock contention we had with many guests trying to d=
o I/O and
all the blkback threads hitting the same lock has been eliminated.
</blurb>

Anyhow, please pull and if possible include the nice overview I typed up in=
 the
merge commit.

 Documentation/ABI/stable/sysfs-bus-xen-backend |  18 +
 drivers/block/xen-blkback/blkback.c            | 843 ++++++++++++++++-----=
----
 drivers/block/xen-blkback/common.h             | 145 ++++-
 drivers/block/xen-blkback/xenbus.c             |  38 ++
 drivers/block/xen-blkfront.c                   | 490 +++++++++++---
 include/xen/interface/io/blkif.h               |  53 ++
 6 files changed, 1188 insertions(+), 399 deletions(-)

Roger Pau Monne (7):
      xen-blkback: print stats about persistent grants
      xen-blkback: use balloon pages for all mappings
      xen-blkback: implement LRU mechanism for persistent grants
      xen-blkback: move pending handles list from blkbk to pending_req
      xen-blkback: make the queue of free requests per backend
      xen-blkback: expand map/unmap functions
      xen-block: implement indirect descriptors


--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQEcBAEBAgAGBQJRcVftAAoJEFjIrFwIi8fJiy0IANuJrJDfmspI+adPo0GbopRa
peELMKtKW7R2T8EjPn/GZfI2iaagl4fiLlAkNM5DK0QjAvoITvnTW3prPJNDbeuL
KPY9S/hO+clddYojuUuIyojH3FJ3Y8CytwLYzVuOsb0Tez5BYBczS3zwL/JuMnW4
GC6STcfSO6QPB0ibIgm1DTXNcPETGTKJNveHa+CIzwrfxzJIJYKNDVIMkXm/nRyk
tNfrHNwfwsQMpfOwT8vTxGzdPEBw/4Me225ZhOhM8S/28x3IJ5IiaxIwRAkrUyVb
Oum4iYsX1V0sJjc7UEHamVTfuKVe3GgmVtfW4wiFwVTySkt7M++4snjyBF4LCgI=
=dlnj
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
