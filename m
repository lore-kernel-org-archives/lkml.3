Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbaGXM6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:58:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027AbaGXM6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:58:33 -0400
Date: Thu, 24 Jul 2014 14:58:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Waiman Long <Waiman.Long@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: Linux 3.16-rc6
Message-ID: <20140724125814.GX6758@twins.programming.kicks-ass.net>
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com>
 <20140723095327.GA23131@pd.tnic>
 <CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com>
 <20140724064353.GW9918@twins.programming.kicks-ass.net>
 <20140724084126.GB19239@pd.tnic>
 <20140724122513.GM19239@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pu+9umg0azy3+Jou"
Content-Disposition: inline
In-Reply-To: <20140724122513.GM19239@pd.tnic>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pu+9umg0azy3+Jou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2014 at 02:25:13PM +0200, Borislav Petkov wrote:
> On Thu, Jul 24, 2014 at 10:41:27AM +0200, Borislav Petkov wrote:
> > you can easily reproduce by booting a kvm guest with rc6 + tip/master.
>=20
> Right, so reverting
>=20
> 586fefe5bbdc ("locking/selftest: Support queued rwlock")
> e0645a111cb4 ("locking/lockdep: Restrict the use of recursive read_lock()=
 with qrwlock")
>=20
> from the top of tip/locking/core seems to fix the issue, with the kvm
> guests at least.

Well, it makes the report go away.. I'm currently leaning towards that
the report is valid. We did after all change rwlock semantics, and that
lockdep patch is making lockdep match those new semantics.

Of course, its also possible the lockdep patch is wrong. But I'm leaning
towards that the report is valid.

So going by the nifty picture rostedt made:

[   61.454336]        CPU0                    CPU1
[   61.454336]        ----                    ----
[   61.454336]   lock(&(&p->alloc_lock)->rlock);
[   61.454336]                                local_irq_disable();
[   61.454336]                                lock(tasklist_lock);
[   61.454336]                                lock(&(&p->alloc_lock)->rlock=
);
[   61.454336]   <Interrupt>
[   61.454336]     lock(tasklist_lock);

the fact that CPU1 holds tasklist_lock for reading, does not
automagically allow CPU0 to acquire tasklist_lock for reading too, for
example if CPU2 (not in the picture) is waiting to acquire tasklist_lock
for writing, CPU0's read acquire is made to wait.

The only kind of recursion that's safe is same CPU interrupt.

Of course we should have made the lockdep change before merging qrwlock,
and that's entirely my fail, but with qrwlock in these new semantics are
already a reality.

We could of course disable qrwlock until all such issues are cleared up
(its the safe option)...

--Pu+9umg0azy3+Jou
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT0QLgAAoJEHZH4aRLwOS6FBMP/11YWsH2SzDVjTFzZsPqU4DB
Xkj5sacGX49/HMTBtUAwTnUw2f/WA4Yy9zRV28CvZHnu2SYXUxLoXyy0wRxdIhZd
8xxDN3avlDcf+VjU3TlVOwgcxRlEz3CKpBThoPnKVdJA3vmrItFpgsj6hw6fy1xg
GpQE6vD0u1B+kL8oJXTho1JMMA/3ZcsyNB+pLLZi+3pdut5LU/56zvuVO7oD3d0H
+C4iq/EmdAwbdUbXqo2aPQIBNJDfVgAd6Cnn8Ax8x/qSYOLE1ojJzGjDdte6irP2
Utl2Q6YjChLTGpk5BaDZDANvwFpjNFVfhOiKm/XpuKTEhJA2/wEiQjKw4yRhZ13/
e13mZ1+OfvUjLYqeEHEkJgSwrjWTNsLjhuoPJBT6ram7p4nXHtpobihs2zuYJJ5s
G0VtUFPqYTIR0DEWorrTZrH2ac0h0DxAN2Dn3QI/PAA804G4iyvl4E7nPNiM5Jps
NO+oQ1Vq+LdPkKPNaczkJ7xeExlTACCWRfSXZHAm1cyIV1NhJUh3wuu56S7yr2qj
UafBVoDO8DSkleOHKkH0HJS5n2C/owzn/JV4YrTsIsA+VGF/oTt8w2qUEKysWPlo
kYQYnS4Gtg8w50YEr+TWE/CnGWHNIgpTLjjux0Ffa8CyfGeetC4i9Wxdq/QpQScU
JZBpt4mJneMXA5wFduwg
=cn/o
-----END PGP SIGNATURE-----

--Pu+9umg0azy3+Jou--
