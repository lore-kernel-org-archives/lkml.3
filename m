Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbaCPE6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 00:58:13 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55191 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaCPE6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 00:58:11 -0400
Date: Sun, 16 Mar 2014 12:58:01 +0800
From: Kevin Hao <haokexin@gmail.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Chenhui Zhao <chenhui.zhao@freescale.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, leoli@freescale.com,
        Jason.Jin@freescale.com
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
Message-ID: <20140316045801.GA32188@pek-khao-d1.corp.ad.wrs.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
 <1394586624.13761.132.camel@snotra.buserror.net>
 <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
 <1394646185.13761.145.camel@snotra.buserror.net>
 <20140313074613.GD26692@pek-khao-d1.corp.ad.wrs.com>
 <1394835987.12479.119.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <1394835987.12479.119.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2014 at 05:26:27PM -0500, Scott Wood wrote:
> On Thu, 2014-03-13 at 15:46 +0800, Kevin Hao wrote:
> > On Wed, Mar 12, 2014 at 12:43:05PM -0500, Scott Wood wrote:
> > > > Shouldn't we use "readback, sync" here? The following is quoted for=
m t4240RM:
> > > >   To guarantee that the results of any sequence of writes to config=
uration
> > > >   registers are in effect, the final configuration register write s=
hould be
> > > >   immediately followed by a read of the same register, and that sho=
uld be
> > > >   followed by a SYNC instruction. Then accesses can safely be made =
to memory
> > > >   regions affected by the configuration register write.
> > >=20
> > > I agree that the sync before the readback is probably not necessary,
> > > since transactions to the same address should already be ordered.
> > >=20
> > > A sync after the readback helps if you're trying to order the readback
> > > with subsequent memory accesses, though in that case wouldn't a sync
> > > alone (no readback) be adequate?
> >=20
> > No, we don't just want to order the subsequent memory access here.
> > The 'write, readback, sync' is the required sequence if we want to make
> > sure that the writing to CCSR register does really take effect.
> >=20
> > >  Though maybe not always -- see the
> > > comment near the end of fsl_elbc_write_buf() in
> > > drivers/mtd/nand_fsl_elbc.c.  I guess the readback does more than just
> > > make sure the device has seen the write, ensuring that the device has
> > > finished the transaction to the point of acting on another one.
> >=20
> > Agree.
> >=20
> > >=20
> > > The data dependency plus isync sequence, which is done by the normal =
I/O
> > > accessors used from C code, orders the readback versus all future
> > > instructions (not just I/O).  The delay loop is not I/O.
> >=20
> > According to the PowerISA, the sequence 'load, date dependency, isync' =
only
> > order the load accesses.=20
>=20
> The point is to order the delay loop after the load, not to order
> storage versus storage.

I think the point is to make sure that the writing of the CCSR_DDR_SDRAM_CF=
G_2
does really take effect before we begin to delay loop. The sequence "write,
readback, sync" will guarantee this according to the manual. If we just wan=
t to
order the delay loop after the load, the following sequence should be enoug=
h:
	store to CCSR_DDR_SDRAM_CFG_2
	load from CCSR_DDR_SDRAM_CFG_2
	isync or sync
	delay loop

Why do we need the 'date dependency' here? According to the e6500 manual, t=
he
instructions can execute out of order, but complete in order. So I am really
wondering why we need to order the load and the following delay loop if the=
re
is no intention to order the storage access?=20

>=20
> This is a sequence we're already using on all of our I/O loads
> (excluding accesses like in this patch that don't use the standard
> accessors).  I'm confident that it works even if it's not
> architecturally guaranteed.

This sequence is used to order the load and the followed storage access.
And this is guaranteed by the architecture. But I don't think it is suitable
for a case like this. The following is quoted from PowerISA:
  Because stores cannot be performed =E2=80=9Cout-of-order=E2=80=9D
  (see Book III), if a Store instruction depends on the
  value returned by a preceding Load instruction
  (because the value returned by the Load is used to
  compute either the effective address specified by the
  Store or the value to be stored), the corresponding stor-
  age accesses are performed in program order. The
  same applies if whether the Store instruction is exe-
  cuted depends on a conditional Branch instruction that
  in turn depends on the value returned by a preceding
  Load instruction.
 =20
  Because an isync instruction prevents the execution of
  instructions following the isync until instructions pre-
  ceding the isync have completed, if an isync follows a
  conditional Branch instruction that depends on the
  value returned by a preceding Load instruction, the
  load on which the Branch depends is performed before
  any loads caused by instructions following the isync.

I think the above description would guarantee that the load will be perform=
ed
before any storage access (both load and store) following the isync in the
following scenario:
	lwz	r4, 0(r3)
	twi	0, r4, 0
	isync

>  I'm not sure that there exists a clear
> architectural way of synchronizing non-storage instructions relative to
> storage instructions.

Isn't what the execution synchronization instructions such as sync, isync, =
mtmsr
do?

>=20
> Given that isync is documented as preventing any execution of
> instructions after the isync until all previous instructions complete,
> it doesn't seem to make sense for the architecture to explicitly talk
> about loads (as opposed to any other instruction) following a load,
> dependent conditional branch, isync sequence.

Sorry, I didn't get what you mean.

>=20
> > So if we want to order all the storage access as well
> > as execution synchronization, we should choose sync here.
>=20
> Do we need execution synchronization or context synchronization?

There is no context-altering instruction here, so I think an execution
synchronizing instruction should be enough here.

>=20
> The t4240 RM section that talks about a readback and a sync is in the
> context of subsequent memory operations ("Then accesses can safely be
> made to memory regions affected..."), not arbitrary instructions.

I assume that this sequence also guarantee that the writing does take effec=
t.

>  There
> are also a couple other places in the RM where isync is recommended
> instead (when setting LAWs or CCSRBAR), even though those also only
> involve memory accesses.

No idea why isync is used here.

>=20
> In any case, this is not performance critical and thus it's better to
> oversynchronize than undersynchronize.

On the contrary I think that sync is oversynchronize instead of
undersynchronize. It not only provide the execution synchronizing but also
order all the storage accesses. That is why I prefer the sync. :-)

Thanks,
Kevin

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTJS9ZAAoJEJNY7TDerrFxHvEIAKxLedRdg2Ov+9i+rg+TrYn1
mIov48dZzDN7ruLm+j8AN6jXlG9N5BkiiFWvEREjzjhTObl80/ziJoUYOIzuelp4
x8iwJ04SEYNcP1Pm1uqA0PjIqcn5WgxVnrOeJeNgRe9+QT1GjDCRyCahk4BKZcSE
9QVv8cY3pgMFkmsdDv8yd5HKLrznXPsyoleo81E41QimmdMzaUKzvFfi/iOxvlQL
EbV7cNaV0q+tSoms/wMg2NFFSSWAZSPQqqGFISgJaNoxvx3IOnRdsnP3zPsmGdAo
P4kCc/4VmmHJNuzVzZOnu3V5MAEM2EOhzu//KNVYeUbmsH3EF6kxHcbJghVKzUE=
=s6BD
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
