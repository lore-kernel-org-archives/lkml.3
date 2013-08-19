Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab3HSVwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:52:14 -0400
Received: from mail-bk0-f65.google.com ([209.85.214.65]:37987 "EHLO
	mail-bk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3HSVwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:52:12 -0400
Date: Mon, 19 Aug 2013 23:52:08 +0200
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
Message-ID: <20130819215208.GC9885@mithrandir>
References: <1376392346-14127-1-git-send-email-treding@nvidia.com>
 <1376392346-14127-4-git-send-email-treding@nvidia.com>
 <520BFA0C.5070001@wwwdotorg.org>
 <20130815103452.GA13740@ulmo>
 <520CF211.6060003@wwwdotorg.org>
 <20130819201623.GD5191@mithrandir>
 <52128650.7090009@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <52128650.7090009@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 02:55:44PM -0600, Stephen Warren wrote:
> On 08/19/2013 02:16 PM, Thierry Reding wrote:
> > On Thu, Aug 15, 2013 at 09:21:53AM -0600, Stephen Warren wrote:
> >> On 08/15/2013 04:34 AM, Thierry Reding wrote:
> >>> On Wed, Aug 14, 2013 at 03:43:40PM -0600, Stephen Warren
> >>> wrote:
> >>>> On 08/13/2013 05:12 AM, Thierry Reding wrote:
> >>>>> Implement the platform driver's .remove() callback to free
> >>>>> all resources allocated during driver setup and call=20
> >>>>> pci_common_exit() to cleanup ARM specific datastructures.
> >>>>> Unmap the fixed PCI I/O mapping by calling the new
> >>>>> pci_iounmap_io() function in the new .teardown() callback.
> >>>>>=20
> >>>>> Finally, no longer set the .suppress_bind_attrs field to
> >>>>> true to allow the driver to unbind from a device.
> >>>>=20
> >>>>> +static int tegra_pcie_remove(struct platform_device *pdev)
> >>>>> +{ +	struct tegra_pcie *pcie =3D platform_get_drvdata(pdev);
> >>>>> + struct tegra_pcie_bus *bus, *tmp; +	int err; + +=20
> >>>>> pci_common_exit(&pcie->sys); + +
> >>>>> list_for_each_entry_safe(bus, tmp, &pcie->busses, list) { +
> >>>>> vunmap(bus->area->addr); + kfree(bus); +	} + +	if
> >>>>> (IS_ENABLED(CONFIG_PCI_MSI)) { +		err =3D=20
> >>>>> tegra_pcie_disable_msi(pcie); +		if (err < 0) +			return
> >>>>> err; + }
> >>>>=20
> >>>> Wouldn't it make sense to do that as early as possible in
> >>>> the function, to make sure that no MSI accidentally fires
> >>>> after some of the cleanup has already happened?
> >>>=20
> >>> I don't think that's strictly necessary in this case. After
> >>> the call to pci_common_exit() there are no PCI devices left,
> >>> there's not even a bus left. All MSI users should have cleaned
> >>> up after themselves.
> >>>=20
> >>> Given that I thought it more useful to mirror the setup done
> >>> in .probe() to make it clearer what's being undone (and
> >>> potentially what's missing).
> >>=20
> >> That makes sense SW-wise, but what about mis-behaving HW that
> >> triggers an MSI even when it's been told not to? I assume that=20
> >> tegra_pcie_disable_msi() unrequests the IRQ, hence solves that=20
> >> problem, if done early enough.
> >=20
> > To be honest, I'm not sure about the side-effects that this will
> > have. tegra_pcie_disable_msi() does quite a bit more than just
> > masking the interrupts. It also completely removes the IRQ domain
> > that provides the MSI interrupts. While I haven't tried it yet I
> > can imagine that it will cause crashes at a later point when
> > drivers want to disable MSI on a device and the IRQ domain having
> > vanished from underneath.
>=20
> Surely by the time the PCIe controller device has been remove()d then
> all devices for PCIe "client" devices have also been removed.

The PCIe controller is the device being removed. Part of that removal
involves stopping and removing all PCI devices. That's done as part of
pci_common_exit().

But I was under the impression that you were arguing that the call to
tegra_pcie_disable_msi() should be the first call in .remove() in order
to prevent any spurious MSIs from occurring. That in turn would mean
calling tegra_pcie_disable_msi() before pci_common_exit(), and that
would lead to the problem that I described.

> But I guess the problem is if the controller is added back, yet the
> IRQ resources aren't re-parsed under the new IRQ domain? Still, that
> seems like an unrelated issue to exactly where the MSI IRQ domain gets
> cleaned up in the host controller's remove().

I don't think that should be a problem. Given that both the MSI IRQ
domain and the PCI devices will be setup from scratch I don't see how
any stale resources could mess things up.

Thierry

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEpOHAAoJEN0jrNd/PrOhjZMQAKBbVrvTFfi+cf2PeDm1b3Aj
vEcGVDMC/LdjF9Lju4umiC2oMhCKwyYKYBDIbM2VaUrLsVvu7MKvyph+o1QAU6B6
rxOWg5t35W/KxWflIlV5zBU5V+i9VrnxLfnBV0BmQebOIXs8gZk0gg1gvzimUik3
g7H6DK1InXjDl/7Xblsfs/h8qFnMs/MPuKdWS8b3Bs5OKNYn5I7D9TtUZjygh719
y56BiVdHX/3i1STRHGtfQf+9IjQPgNhJP3HuCz/xCZDe+yfkTztTydEK0V2AIsJT
FO4TXTvzPbXcyDXVhyE6d2jNhymr4rqjU05txeuXqtueTytnXA/tyH59LTKRUSyH
nA4i+EMXUugdOfRghzBI6RO/YSj8SHmWuGbfJ/sMXtZKEGKxtCSZaayO7KMDwDlz
3dP5/bQQ00pQueOebaYwtb4y00AKGcnIJTQ3JSajtuyBYCxq2ERieNb1scmlueHA
b2FPVAOM71eh+KJM5Bo04LT3RZYdECK1eu/P3lsI4oBU36bsVrurPnWAT+QV4tbh
lemTo5QXmcgxF/3doxqtGOa1sjjuNmvFyOJcv1V+RU3TNmx0gmZDP1+wKtQYrIBV
kjIBI8h1WfHGhMGAqwhkeUnBYs8BXpX+7IkP4WNlFmFkWTqbExk7aHN7vPWSCgNz
o28KrTE82RJq8gZeaqwl
=j1OU
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
