Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3HOKfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:35:01 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:58854 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3HOKe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:34:58 -0400
Date: Thu, 15 Aug 2013 12:34:52 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [RFC 3/3] PCI: tegra: Support driver unbinding
Message-ID: <20130815103452.GA13740@ulmo>
References: <1376392346-14127-1-git-send-email-treding@nvidia.com>
 <1376392346-14127-4-git-send-email-treding@nvidia.com>
 <520BFA0C.5070001@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <520BFA0C.5070001@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 03:43:40PM -0600, Stephen Warren wrote:
> On 08/13/2013 05:12 AM, Thierry Reding wrote:
> > Implement the platform driver's .remove() callback to free all resources
> > allocated during driver setup and call pci_common_exit() to cleanup ARM
> > specific datastructures. Unmap the fixed PCI I/O mapping by calling the
> > new pci_iounmap_io() function in the new .teardown() callback.
> >=20
> > Finally, no longer set the .suppress_bind_attrs field to true to allow
> > the driver to unbind from a device.
>=20
> > +static int tegra_pcie_remove(struct platform_device *pdev)
> > +{
> > +	struct tegra_pcie *pcie =3D platform_get_drvdata(pdev);
> > +	struct tegra_pcie_bus *bus, *tmp;
> > +	int err;
> > +
> > +	pci_common_exit(&pcie->sys);
> > +
> > +	list_for_each_entry_safe(bus, tmp, &pcie->busses, list) {
> > +		vunmap(bus->area->addr);
> > +		kfree(bus);
> > +	}
> > +
> > +	if (IS_ENABLED(CONFIG_PCI_MSI)) {
> > +		err =3D tegra_pcie_disable_msi(pcie);
> > +		if (err < 0)
> > +			return err;
> > +	}
>=20
> Wouldn't it make sense to do that as early as possible in the function,
> to make sure that no MSI accidentally fires after some of the cleanup
> has already happened?

I don't think that's strictly necessary in this case. After the call to
pci_common_exit() there are no PCI devices left, there's not even a bus
left. All MSI users should have cleaned up after themselves.

Given that I thought it more useful to mirror the setup done in .probe()
to make it clearer what's being undone (and potentially what's missing).

Thierry

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDK7MAAoJEN0jrNd/PrOh0m8QALzBtXwsLkiXEr0+v4xvtudS
1Vnb6gV6JhHl09DNYs3KYcCX8CsFzs7AJ19wgJj6Q++QuHou0m8kSfvHx8r6k8zO
UApq3rEsi1ujh6+ICS+7smKZCqKrb+m/rDSmJ68EjyA1zqvbgkXloNganOAD5wxM
o22uq6DZyi+BhE/pX/51bODLrLw3vrUbn6MCgU1XNgK/A0+YlPj30D2NUNofmVtG
ejnJ5g9UskhwMOzyZoFoyn7eEgCI0nY4OfoPqWakAQJlc3WHEbkp9lhBN3K924/Y
ZltIcNyb+CmhSfCgCgcx4w99gyt4QRcSlChaVergD28rG2c3mJWyZc4M6UmgFfbT
ZeVTaAc1cZu6QwGbUqV4sLTj0bRn5k8CvFLEKf+AIxXPZjV2zdmYYWCaI9Z2jfiK
sdjoZOEbSlHMIuXW2riDYfg2dFA3BVzax8I4Obffsj8iJ222vOTRR05d7+aKNS2w
Kzdy1uSQvZIoawqXAQTrHUNojgAID3yDUnsQ5w4bwlglUgtBpFPabeOxY9guNqwv
uXizyXnggK0ZMNhLyn3lP1nDz63Hv7d0dHsMXOltbGLFuYhWeWV8gL1vtWUa/mJN
OtaSVXNzzjLRNeHS4iL8S59/pWnwQvIK0Dc/m15wrTgaC8v92NsHQHVs3/YFJiKt
jF72U0N4upufhDkop6SV
=vhvx
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
