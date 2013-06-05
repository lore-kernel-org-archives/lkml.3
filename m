Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3FECEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 22:04:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:55658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab3FECEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:04:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,803,1363158000"; 
   d="asc'?scan'208";a="324361599"
Date: Tue, 4 Jun 2013 21:56:42 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Betty Dall <betty.dall@hp.com>, rjw@sisk.pl, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ACPI/APEI: Force fatal AER severity when bus has
 been reset
Message-ID: <20130605015642.GB27550@gchen.bj.intel.com>
Mail-Followup-To: Bjorn Helgaas <bhelgaas@google.com>,
	Betty Dall <betty.dall@hp.com>, rjw@sisk.pl, ying.huang@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
 <1369924769-17183-3-git-send-email-betty.dall@hp.com>
 <20130604075336.GC20448@gchen.bj.intel.com>
 <20130604175434.GA6548@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <20130604175434.GA6548@google.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2013 at 11:54:34AM -0600, Bjorn Helgaas wrote:
> Date:	Tue, 4 Jun 2013 11:54:34 -0600
> From: Bjorn Helgaas <bhelgaas@google.com>
> To: Betty Dall <betty.dall@hp.com>, rjw@sisk.pl, ying.huang@intel.com,
>  linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
>  linux-pci@vger.kernel.org
> Subject: Re: [PATCH v2 2/3] ACPI/APEI: Force fatal AER severity when bus
>  has been reset
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Tue, Jun 04, 2013 at 03:53:36AM -0400, Chen Gong wrote:
> > On Thu, May 30, 2013 at 08:39:28AM -0600, Betty Dall wrote:
> > > Date:	Thu, 30 May 2013 08:39:28 -0600
> > > From: Betty Dall <betty.dall@hp.com>
> > > To: rjw@sisk.pl, bhelgaas@google.com
> > > Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
> > >  linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Betty Dall
> > >  <betty.dall@hp.com>
> > > Subject: [PATCH v2 2/3] ACPI/APEI: Force fatal AER severity when bus =
has
> > >  been reset
> > > X-Mailer: git-send-email 1.7.7.6
> > >=20
> > > The CPER error record has a reset bit that indicates that the platform
> > > has reset the bus. The reset bit can be set for any severity error
> > > including recoverable.  From the AER code path's perspective,
> > > any error is fatal if the bus has been reset. This patch upgrades the
> > > severity of the AER recovery to AER_FATAL whenever the CPER error rec=
ord
> > > indicates that the bus has been reset.
> > >=20
> > > Changes since v1:
> > > Fixed a typo in comment.
> > >=20
> > > Signed-off-by: Betty Dall <betty.dall@hp.com>
> > > ---
> > >=20
> > >  drivers/acpi/apei/ghes.c |   21 ++++++++++++++++++++-
> > >  1 files changed, 20 insertions(+), 1 deletions(-)
> > >=20
> > >=20
> > > diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> > > index d668a8a..1c67d5a 100644
> > > --- a/drivers/acpi/apei/ghes.c
> > > +++ b/drivers/acpi/apei/ghes.c
> > > @@ -451,7 +451,26 @@ static void ghes_do_proc(struct ghes *ghes,
> > >  				int aer_severity;
> > >  				devfn =3D PCI_DEVFN(pcie_err->device_id.device,
> > >  						  pcie_err->device_id.function);
> > > -				aer_severity =3D cper_severity_to_aer(sev);
> > > +				/*
> > > +				 * Some Firmware First implementations
> > > +				 * put the device in SBR to contain
> > > +				 * the error. This is indicated by the
> > > +				 * CPER Section Descriptor Flags reset
> > > +				 * bit which means the component must
> > > +				 * be re-initialized or re-enabled
> > > +				 * prior to use. Promoting the AER
> > > +				 * serverity to FATAL will cause the
> > > +				 * AER code to link_reset and allow
> > > +				 * drivers to reprogram their cards.
> > > +				 */
> > > +				if (gdata->flags & CPER_SEC_RESET)
> > > +					aer_severity =3D cper_severity_to_aer(
> > > +							CPER_SEV_FATAL);
> > > +				else
> > > +					aer_severity =3D
> > > +						cper_severity_to_aer(sev);
> > > +
> > > +
> >=20
> > How about this?
> >                                 if (gdata->flags & CPER_SEC_RESET)
> >                                         sev =3D CPER_SEV_FATAL;
> >                                 cper_severity_to_aer(sev);
>=20
> No.  If the object is to make the severity AER_FATAL, you should just
> do that.  You shouldn't fiddle around with the CPER severity, because
> then you depend on the mapping performed by cper_severity_to_aer().
>=20
> >=20
> > >  				aer_recover_queue(pcie_err->device_id.segment,
> > >  						  pcie_err->device_id.bus,
> > >  						  devfn, aer_severity);
>=20
> In other words, something like the patch below.  I don't really care
> if you use the original "if" above that only sets aer_severity once,
> or if you overwrite it as below.  I overwrote it because it doesn't
> wrap as many lines.  ghes_do_proc() really should just call helpers
> so the interesting code doesn't have to be indented three and four
> tab stops.
>=20
>=20
> ACPI/APEI: Force fatal AER severity when component has been reset
>    =20
> The CPER error record has a reset bit that indicates that the platform has
> reset the component.  The reset bit can be set for any severity error
> including recoverable.  From the AER code path's perspective, any error is
> fatal if the component has been reset. This patch upgrades the severity of
> the AER recovery to AER_FATAL in this case.
>    =20
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index d668a8a..ab31551 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -449,9 +449,19 @@ static void ghes_do_proc(struct ghes *ghes,
>  			    pcie_err->validation_bits & CPER_PCIE_VALID_AER_INFO) {
>  				unsigned int devfn;
>  				int aer_severity;
> +
>  				devfn =3D PCI_DEVFN(pcie_err->device_id.device,
>  						  pcie_err->device_id.function);
>  				aer_severity =3D cper_severity_to_aer(sev);
> +
> +				/*
> +				 * If firmware reset the component to contain
> +				 * the error, we must reinitialize it before
> +				 * use, so treat it as a fatal AER error.
> +				 */
> +				if (gdata->flags & CPER_SEC_RESET)
> +					aer_severity =3D AER_FATAL;
> +
>  				aer_recover_queue(pcie_err->device_id.segment,
>  						  pcie_err->device_id.bus,
>  						  devfn, aer_severity);
>

The patch looks good to me.

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRrpraAAoJEI01n1+kOSLHL1wQAJA61pJYqEONSGtNKgfOgDeR
ULO42Ol8FW3A8rvBkTUR1QKD1L9gzmjRmWeupy2lEmxdQkeF7F7c/QljKdwAYkBF
iKF0RfpWIOBWuuhafltA3djB7suzUiJ9NRKA9YhCDBN9qUaRBZ7k8MYASexvZGur
SISy1hl29RnMZ4HFn8xRHafxsQJU0OWeIjGSuvQYOTb5vCb4eGKRvYejkPS/5Y7u
2BYjpGuig/xW2Dh/81X3yK5+VF8RGldVA39WxKH07CqIvKztUKsCIGr9Cj8Txk2L
6HMsgucaD5qSr4cq6XZHOwev8VvMHczJtYuK2bUo8cKCk1ziXUe1z7VIaJMJKXpT
0XFg3cmxaR2FTCi3K54xUnK+KgwScLSGgxN4PXU5vCbYzK9qEhWvmC0LG2EaiNo2
XhCmrPQHXlKclvFRyLsm+0zMCh/IUXoW434k877gpzGRXxPg9XS+L6lPEWtpac4r
w7FgLwNWQUREa5jYf5LB01lIm87790qpYCdcRVs05xXPer25NBf27R/3lLBwGrnO
rmW2psQlKoVhiJoGcvuyTr/Rn+TioBVwnc5OWqe0k1/xIyAlBSECZhoDpLB28sea
afQSUczbMiEE0IEGKu+9G8FsQILsmudTYoJc0j7GHSvlLN9H8vcyVn1E31t4/Vbf
8GdtnsFQ8sIvvvZG/2ly
=+cqb
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
