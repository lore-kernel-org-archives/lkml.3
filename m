Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbaGPNFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:05:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:34828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaGPNFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:05:47 -0400
Date: Wed, 16 Jul 2014 15:05:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 3/4] documentation: Add acquire/release
 barriers to pairing rules
Message-ID: <20140716130534.GB19379@twins.programming.kicks-ass.net>
References: <20140707222345.GA6320@linux.vnet.ibm.com>
 <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404771862-6904-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708075902.GM19379@twins.programming.kicks-ass.net>
 <20140708153117.GJ4603@linux.vnet.ibm.com>
 <20140714115738.GW19379@twins.programming.kicks-ass.net>
 <20140716121626.GM8690@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TjrdA9oBG3OWww3L"
Content-Disposition: inline
In-Reply-To: <20140716121626.GM8690@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TjrdA9oBG3OWww3L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 05:16:26AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 14, 2014 at 01:57:38PM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 08, 2014 at 08:31:17AM -0700, Paul E. McKenney wrote:
> >=20
> > > Good point, how about the following?
> > >=20
> > > 	General barriers pair with each other, though they also pair
> > > 	with most other types of barriers, albeit without transitivity.
> >=20
> > > 	An acquire barrier pairs with a release barrier, but both may also
> > > 	pair with other barriers, including of course general barriers.
> >=20
> > > 	A write barrier pairs with a data dependency barrier, an acquire
> > > 	barrier, a release barrier, a read barrier, or a general barrier.
> >=20
> > > 	Similarly a read barrier or a data dependency barrier pairs
> > > 	with a write barrier, an acquire barrier, a release barrier,
> > > 	or a general barrier:
> >=20
> > It might be clearer with the added whitespace, or as an explicit list  I
> > suppose, but yes.
>=20
> If I get ambitious, I might try making a table out of it, but I am not
> yet sure how I would set that up.  Something about having to say a lot
> in each cell, but with only a small amount of room in which to say it.


      |  mb | wmb | rmb | rbd | acq | rel |
 -----+-----+-----+-----+-----+-----+-----+
   mb |  X  |  X  |  X  |  X  |  X  |  X  |
 -----+-----+-----+-----+-----+-----+-----+
  wmb |  X  |     |  X  |  X  |     |     |
 -----+-----+-----+-----+-----+-----+-----+
  rmb |  X  |  X  |     |     |     |     |
 -----+-----+-----+-----+-----+-----+-----+
  rbd |  X  |  X  |     |     |     |     |
 -----+-----+-----+-----+-----+-----+-----+
  acq |  X  |     |     |     |     |  X  |
 -----+-----+-----+-----+-----+-----+-----+
  rel |  X  |     |     |     |  X  |     |
 -----+-----+-----+-----+-----+-----+-----+

(where rbd is read_barrier_depends).

Which is not entirely filled out, in particular I didn't do the creative
acq/rel bits.

> > Ah, I was more thinking of the fact that ACQUIRE/RELEASE are
> > semi-permeable while READ/WRITE are memop dependent.
> >=20
> > So any combination will be a semi-permeable memop dependent thing,
> > which is the most narrow barrier possible.
> >=20
> > So if we thing of ACQUIRE/RELEASE as being 'half' a full barrier,
> > separated in direction, and READ/WRITE as being 'half' a full barrier
> > separated on type, then the combination is a 'quarter' barrier.
> >=20
> > Not arguing they're not useful, just saying we need to be extra careful.
>=20
> I do agree completely about the need for extra care!
>=20
> For whatever it is worth, the permeability and read-write properties
> are isolated to each barrier in the pair.  For example, with "a" and
> "b" both initially zero:
>=20
> 	CPU 1				CPU 2
> 	-----				-----
> 	ACCESS_ONCE(a) =3D 1;		r1 =3D b;
> 	smp_store_release(&b, 1);	smp_rmb();
> 	ACCESS_ONCE(c) =3D 1;		r2 =3D a;
> 					ACCESS_ONCE(c) =3D 2;
>=20
> The outcome r1=3D=3D1&&r2=3D=3D0 is prohibited, but the ordering of the s=
tores
> to "c" are not ordered: CPU 1's smp_store_release() does not affect
> later accesses, and CPU 2's smp_rmb() does not order stores.
>=20
> Not sure that it is worth adding this sort of example, though.

Yeah, not sure either. Maybe just a big fat caution if you pair acq/rel
with anything other than its opposite or a general barrier.

Maybe use small 'x' for acq/rel + rmb/wmb and put a caution in the
'legend' for 'x'.

--TjrdA9oBG3OWww3L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxnieAAoJEHZH4aRLwOS6Th8P/1d0iYnnJijc1g+bwRaDAnsO
HZqT2+UdL2fWRKfr25cvoiCUb/x+NDwJ+xeL9tfFrXnjzGL2M+X6uCs/HNNMfBJa
TIfwtk8jl/yus136e6OEqqdk3Begom3BdpGEx485jqC8k/QKmmwV8FhZH82/+EmH
dtkcFLACaI2Otmv08tuMuFTHKqanPb+7ZYPWIz46zlnhzLfpHawq92wXdfhXno/9
GboKtO/Bpx8FtFz6a39Ri8ILsAWQIq23j419c9Qufi5sP1fhC0udu/IhM0NDRfKR
JqsDlq9a47QbtnIMyZRvek6gbk7SIm5Xk7Hqzpz6TzR4PHjcppH1vaeC9pyAX8wQ
ec2qwBULEjnYxut1/7+kYtcPcdblMzLatWlaOoPL7+PyU5uIpa/HZ2xdIpKgDZts
6dN1VrjrdDuzqvK9NuhKf68oqVnRmnGUHP1wYI9rEzcI27gyaoV9QI4/zMweNx/w
HB1uLmqsbez4HlzoIzVYMqsO9wTVNmDDlyVu7kA4nVG/VTEBsOIHYdgk/HImWAYe
Od0JLJH3CxT9ZL9m5ibxbmV9Xv5UwKtJefcEV68avqJBNaYUIPjKozc0M1f8jvue
0Su/Lq0qB9A4vtLsXUnl9UwxzWSD1lMKzByueNOCqXActjA6N9slBWjvNNo1Dd4X
hX0jzpa7p0UsbQRmK50i
=J7Ro
-----END PGP SIGNATURE-----

--TjrdA9oBG3OWww3L--
