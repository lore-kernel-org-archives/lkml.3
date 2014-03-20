Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbaCTLr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:47:56 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52297 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbaCTLrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:47:55 -0400
Date: Thu, 20 Mar 2014 19:47:35 +0800
From: Kevin Hao <haokexin@gmail.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Chenhui Zhao <chenhui.zhao@freescale.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, leoli@freescale.com,
        Jason.Jin@freescale.com
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
Message-ID: <20140320114735.GD10182@pek-khao-d1.corp.ad.wrs.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
 <1394586624.13761.132.camel@snotra.buserror.net>
 <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
 <1394646185.13761.145.camel@snotra.buserror.net>
 <20140313074613.GD26692@pek-khao-d1.corp.ad.wrs.com>
 <1394835987.12479.119.camel@snotra.buserror.net>
 <20140316045801.GA32188@pek-khao-d1.corp.ad.wrs.com>
 <1395184734.12479.250.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qrgsu6vtpU/OV/zm"
Content-Disposition: inline
In-Reply-To: <1395184734.12479.250.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qrgsu6vtpU/OV/zm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2014 at 06:18:54PM -0500, Scott Wood wrote:
> >  The sequence "write, readback, sync" will guarantee this according to =
the manual.=20
>=20
> If you're referring to the section you quoted above, the manual does not
> say that.  It only talks about when accesses "to memory regions affected
> by the configuration register write" can be safely made.

  To guarantee that the results of any sequence of writes to configuration
  registers are in effect, the final configuration register write should be
  immediately followed by a read of the same register, and that should be
  followed by a SYNC instruction. Then accesses can safely be made to memory
  regions affected by the configuration register write.

According to the above description in t4240 RM manual (2.6.1 Accessing CCSR
Memory from the Local Processor), that the writing to configuration register
takes effect is a prerequisite for the memory access to the affected region=
s.

>=20
> > If we just want to
> > order the delay loop after the load, the following sequence should be e=
nough:
> > 	store to CCSR_DDR_SDRAM_CFG_2
> > 	load from CCSR_DDR_SDRAM_CFG_2
> > 	isync or sync
> > 	delay loop
> >=20
> > Why do we need the 'date dependency' here? According to the e6500 manua=
l, the
> > instructions can execute out of order, but complete in order. So I am r=
eally
> > wondering why we need to order the load and the following delay loop if=
 there
> > is no intention to order the storage access?=20
>=20
> The data (not date) dependency means that the twi will not execute until
> after the load instruction returns data (thus, after the device has
> responded to the load).  The twi, being a flow control instruction
> rather than a storage instruction, should be fully ordered by isync.
>=20
> From the isync description in the ISA: "Except as described in the
> preceding sentence, the isync instruction may complete before storage
> accesses associated with instructions preceding the
> isync instruction have been performed."
>=20
> I don't know if that really applies to loads (as opposed to stores), and
> it probably doesn't apply to guarded loads, but I feel safer leaving the
> twi in.
>=20
> As for sync instead of isync, I see nothing to indicate that it would be
> adequate (though it may be that the only reason there needed to be a
> delay loop in the first place was the lack of a readback/sync before
> doing other I/O, in which case this is moot).

OK, so the intention of 'twi, isync' following the load is not to order the
following storage access, but order the following delay loop instructions,
right? But according to the e6500 manual, the instructions complete in orde=
r.
The following is the definition of 'complete':
  Complete=E2=80=94An instruction is eligible to complete after it finishes=
 executing
  and makes its results available for subsequent instructions. Instructions
  must complete in order from the bottom two entries of the
  completion queue (CQ). The completion unit coordinates how instructions (=
which
  may have executed out of order) affect architected registers to ensure the
  appearance of serial execution. This guarantees that the completed instru=
ction
  and all previous instructions can cause no exceptions. An instruction com=
pletes
  when it is retired, that is, deleted from the CQ.

So the following delay loop instructions should never complete before the
complete of the load instruction. After the complete of load instruction,
the data should already been updated to the architecture register. So we can
guarantee that the load instruction get the data (the device has responded =
to
the load) before the complete of the following delay loop instructions, why=
 do
we need the additional 'twi, isync'?  Then for a case like this (which don't
need order the following storage access), I think the following sequence sh=
ould
be enough:
	write to configuration register
	read back
	delay loop

> I mean that I do not understand why it says, "the load on which the
> Branch depends is performed before any loads caused by instructions
> following the isync" rather than "the Load on which the Branch depends
> is performed before any instructions following the isync".

When we talk about the 'performed' here, we should only mean the effect of
storage access. The following is the definition of 'performed':
  performed
  A load or instruction fetch by a processor or mech-
  anism (P1) is performed with respect to any pro-
  cessor or mechanism (P2) when the value to be
  returned by the load or instruction fetch can no
  longer be changed by a store by P2. A store by P1
  is performed with respect to P2 when a load by P2
  from the location accessed by the store will return
  the value stored (or a value stored subsequently).
  An instruction cache block invalidation by P1 is
  performed with respect to P2 when an instruction
  fetch by P2 will not be satisfied from the copy of
  the block that existed in its instruction cache when
  the instruction causing the invalidation was exe-
  cuted, and similarly for a data cache block invalida-
  tion.
  The preceding definitions apply regardless of
  whether P1 and P2 are the same entity.

>=20
> > > > So if we want to order all the storage access as well
> > > > as execution synchronization, we should choose sync here.
> > >=20
> > > Do we need execution synchronization or context synchronization?
> >=20
> > There is no context-altering instruction here, so I think an execution
> > synchronizing instruction should be enough here.
>=20
> Is the ISA ever explicit about what constitutes "context"?

The following is the definition of context-altering instruction:
  An instruction that alters the context in which data
  addresses or instruction addresses are interpreted, or
  in which instructions are executed or data accesses are
  performed, is called a context-altering instruction.

So the context should be:
  - in which data addresses or instruction addresses are interpreted
  - in which instructions are executed
  - in which data accesses are performed

Thanks,
Kevin

--Qrgsu6vtpU/OV/zm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTKtVXAAoJEJNY7TDerrFxFDIH/jJ8L8UXohZVkK4cWZQgVWgT
Eg9NzcXxMjbv4UFiKrlyoaQYh+YNbwetZwwM1eqPAS+/LHHnbR7Xu+/UiVSmh6zY
AqKCYPXcx/bpWFEPws4aASxfgRxYW0lQxyjwS80p8H1eGiNUZkzuygo+jOs1hSlL
s/FdsghCJzpqvhGW9NFs0CTG08fbtylp8orXsPEG65ptpM9u9nG7zt0owO+Cznx4
HcbskvIGvfTjx7WP/xg8v2uSVDwUOmPB1tWIkZsd7Nf4b+zsaNNxS0J8m6FwK7T1
SfdY2kxzVM3M2kxu4UflBVIpJVOdd+9LuZVNiqTKm4pv5pCvMFRArWTVmLqS3ws=
=nrfu
-----END PGP SIGNATURE-----

--Qrgsu6vtpU/OV/zm--
