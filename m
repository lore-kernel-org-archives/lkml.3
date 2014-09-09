Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbaIIHiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:38:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:49470 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbaIIHip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:38:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="383387732"
Date: Tue, 9 Sep 2014 03:03:22 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: rdunlap@infradead.org, bp@alien8.de, tony.luck@intel.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND 2/5] PCIe, AER: Replenish missed AER status bits for AER
 driver
Message-ID: <20140909070321.GA27821@gchen.bj.intel.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
 <1407910961-7798-3-git-send-email-gong.chen@linux.intel.com>
 <20140905231543.GK8080@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20140905231543.GK8080@google.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 05, 2014 at 05:15:43PM -0600, Bjorn Helgaas wrote:
> Date: Fri, 5 Sep 2014 17:15:43 -0600
> From: Bjorn Helgaas <bhelgaas@google.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: rdunlap@infradead.org, bp@alien8.de, tony.luck@intel.com,
>  linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: Re: [RESEND 2/5] PCIe, AER: Replenish missed AER status bits for
>  AER driver
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Wed, Aug 13, 2014 at 02:22:38AM -0400, Chen, Gong wrote:
> > Since commit 6c2b374d is commited, the capability of PCI-e AER
> > has changed a lot. This patch adds all missed CE/UC error bits
> > existed in PCI-e SPEC r3.0. Meanwhile, adjust the code format
> > to make it simpler to read/maintain.
> >=20
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> > ---
> >  drivers/pci/pcie/aer/aerdrv_errprint.c | 60 ++++++++++++++------------=
--------
> >  1 file changed, 25 insertions(+), 35 deletions(-)
> >=20
> > diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/=
aer/aerdrv_errprint.c
> > index 35d06e177917..5c4f7e252e5e 100644
> > --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> > +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> > @@ -75,44 +75,34 @@ static const char *aer_error_layer[] =3D {
> >  };
> > =20
> >  static const char *aer_correctable_error_string[] =3D {
> > -	"Receiver Error",		/* Bit Position 0	*/
> > -	NULL,
> > -	NULL,
> > -	NULL,
> > -	NULL,
> > -	NULL,
> > -	"Bad TLP",			/* Bit Position 6	*/
> > -	"Bad DLLP",			/* Bit Position 7	*/
> > -	"RELAY_NUM Rollover",		/* Bit Position 8	*/
> > -	NULL,
> > -	NULL,
> > -	NULL,
> > -	"Replay Timer Timeout",		/* Bit Position 12	*/
> > -	"Advisory Non-Fatal",		/* Bit Position 13	*/
> > +	[0] =3D "Receiver Error",
> > +	[6] =3D "Bad TLP",
> > +	[7] =3D "Bad DLLP",
> > +	[8] =3D "RELAY_NUM Rollover",
> > +	[12] =3D "Replay Timer Timeout",
> > +	[13] =3D "Advisory Non-Fatal Error",
> > +	[14] =3D "Corrected Internal Error",
> > +	[15] =3D "Header Log Overflow",
>=20
> You replaced bare numbers with the existing #defines in the previous patch
> (thank you), but now we're adding them here.  I'm pretty sure you can use
> the #defines here, e.g.,
>=20
>     [PCI_ERR_COR_RCVR] =3D "Receiver Error",
Considering PCI_ERR_COR_* stuff are not BIT offset, I need a conversion like
[ilog2(PCI_ERR_COR_RCVR)] =3D "xxx". But in ras_event.h I need the same
conversion like aer_correctable_error_string[ilog2(PCI_ERR_COR_RCVR)]. It l=
ooks
like a little bit clumsy and suboptimal. I can add extra BIT definition in
include/uapi/linux/pci_regs.h like below:

#define  PCI_ERR_COR_RCVR       0x00000001      /* Receiver Error Status */
+#define  PCI_ERR_COR_RCVR_BIT   ilog2(PCI_ERR_COR_RCVR)

or more direct way:
#define  PCI_ERR_COR_RCVR       0x00000001      /* Receiver Error Status */
+#define  PCI_ERR_COR_RCVR_BIT   0

I can't find better method by now.
>=20
> In fact, it would be really nice if you could figure out a way to have on=
ly
> one set of these strings.  Right now, we have the set in
As above implied, I can export aer_correctable_error_string etc.

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDqY5AAoJEI01n1+kOSLHfLcP/jlEkegqXCk7gP7haEfcB/PQ
J/mDiASICQRiaTJICGZhfRjo7OxKE/kfkraL0Dwq/Xx3UDbOq+7KnSgV35jdj7A+
KEgNv/TYXTy+WVGf1k/3TlJghkY13qkvnBQ3KoO7JyaulpQ+x0vTBC6ZE75QzjuL
TjJIjpOA74w6OuSr42OoIDmUWfymdRscX0VH5kdlMeY5Ssy7/OT1MUnuLaK5HunS
UGqwpcDdNClUr8P9CTkGLD1G7YZwjFQUOVw2gx8SHTW6NUK1t4aXCcHZC/2Spv6p
IQQhEfdLWaBLa+wyaTXLI/FmMoDYrq7iikymZk40NYZRX+HX5h20bxf2IOmQASYf
fWok9OBO/BHKgU9HWa57tUSFL+x3AukFMeCbCsv38o/v8aHSCyh1ZVSzh4y52Pqj
nGheI0oj1EXo+pf16lOM+vFvSNN6U38teA2pFZLev07g85Zo/ppT5I+a5Ddv7Qoi
DyzRujanKZ+7AHi2QWTzbCzTHzlTxR1o4hIxJWj8VJYVMUVp59kZs3pF2cifc3Qs
hz1ESXye1+u4cG0LCPp38DRJxAZdgxgnr3qsW8uBDiAb+yxZzOzYb8U9PYAIRtch
PE7dZpACWwvpF1RAM7xvi7lqwYD4yu//iteN0lVPfBdJxLiQeZHXjCRravaNkmkt
OcGA8vx09Q2hqAKn+BBA
=xm6t
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
