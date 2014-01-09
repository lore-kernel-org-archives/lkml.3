Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaAIBpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:45:25 -0500
Received: from ozlabs.org ([203.10.76.45]:52962 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaAIBpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:45:23 -0500
Date: Thu, 9 Jan 2014 12:45:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: linux-next: manual merge of the libata tree with the pci tree
Message-Id: <20140109124515.754c7d393b8c118766f1d2d2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_Jan_2014_12_45_15_+1100_nrr03Bu=lptLv49v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Jan_2014_12_45_15_+1100_nrr03Bu=lptLv49v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the libata tree got a conflict in
drivers/ata/ahci.c between commit 7b92b4f61ec4 ("PCI/MSI: Remove
pci_enable_msi_block_auto()") from the pci tree and commit d93414513966
("drivers: ata: Mark the function ahci_init_interrupts() as static in
ahci.c") from the libata tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/ata/ahci.c
index 3cf6dad71e11,74911c2cb1dd..000000000000
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@@ -1097,40 -1148,26 +1148,40 @@@ static inline void ahci_gtf_filter_work
  {}
  #endif
 =20
- int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 -static int ahci_init_interrupts(struct pci_dev *pdev, struct ahci_host_pr=
iv *hpriv)
++static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_port=
s,
 +			 struct ahci_host_priv *hpriv)
  {
 -	int rc;
 -	unsigned int maxvec;
 +	int rc, nvec;
 =20
 -	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI)) {
 -		rc =3D pci_enable_msi_block_auto(pdev, &maxvec);
 -		if (rc > 0) {
 -			if ((rc =3D=3D maxvec) || (rc =3D=3D 1))
 -				return rc;
 -			/*
 -			 * Assume that advantage of multipe MSIs is negated,
 -			 * so fallback to single MSI mode to save resources
 -			 */
 -			pci_disable_msi(pdev);
 -			if (!pci_enable_msi(pdev))
 -				return 1;
 -		}
 -	}
 +	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
 +		goto intx;
 +
 +	rc =3D pci_msi_vec_count(pdev);
 +	if (rc < 0)
 +		goto intx;
 +
 +	/*
 +	 * If number of MSIs is less than number of ports then Sharing Last
 +	 * Message mode could be enforced. In this case assume that advantage
 +	 * of multipe MSIs is negated and use single MSI mode instead.
 +	 */
 +	if (rc < n_ports)
 +		goto single_msi;
 +
 +	nvec =3D rc;
 +	rc =3D pci_enable_msi_block(pdev, nvec);
 +	if (rc)
 +		goto intx;
 =20
 +	return nvec;
 +
 +single_msi:
 +	rc =3D pci_enable_msi(pdev);
 +	if (rc)
 +		goto intx;
 +	return 1;
 +
 +intx:
  	pci_intx(pdev, 1);
  	return 0;
  }

--Signature=_Thu__9_Jan_2014_12_45_15_+1100_nrr03Bu=lptLv49v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSzf8wAAoJEMDTa8Ir7ZwVN4IP/idj3xZk7gJiAskPB8Fny3fN
ADqolQ/Bbzapri1rt67wkJm+JH6aAhv2Ph3/RfQSOUkIgXGgl0yDYhDxyOeW3LW2
UsFfiA9LFUHj1nGb/q7RqP2j4heuBEDucnAT90SEibzL5G+5dWHCSk3DATvlL1wp
a4liX2kBbaegLD8vHAw317adOF37OtPwZRVDjCo5vAXJDq9YzL1poo3774Nfc3Sy
3rVnhVC/fQqNLnEYxz1S2SIBf3FBCQxoTVf0U8vmjCEcwZ+D4VSyQ3q/90MJWF7h
v0ZtvDMuIUX9eiABkPaW8XpN+e/t0Hr+FqYLBE4HeRdXomq/aWd9SCo2LvEA3sAI
6waVcgByIPEn40S1rx9t9fiEjTFsZMEHTsvKUQabmqlEC39HJshfIbkEb+p6FgAl
qpaOdkmGOkW799JhznkyWWMwHVWIOguwAo175UbcXmhOaLWyIODZSLOKtjPK7CZw
7NtHFnR7XTurC20wDPDsaZRLZqdTsheJr9cSa53qMpgAEGxgtMRt9+pWPygYSw/K
HzJ+Nh/E2PwcRgDAhYTxgPBYH5hNuYMdJFe+x16dedP/nfTotqwdnbymtMYzCfDe
53ZHG3rr4L9xOg5lHhwERZqSFrDndiRsb1zyT5kefNTaJBvwy+nzfMYUtEww7Xjy
gutCJ4ncAmUaSjelj1SG
=e4R0
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Jan_2014_12_45_15_+1100_nrr03Bu=lptLv49v--
