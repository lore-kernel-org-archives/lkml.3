Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaGGLmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:42:11 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47154 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaGGLmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:42:09 -0400
Date: Mon, 7 Jul 2014 13:42:02 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 01/10] iommu: Add IOMMU device registry
Message-ID: <20140707114201.GA17036@ulmo>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <20140704134709.GA4203@ulmo>
 <20140704134928.GA25714@arm.com>
 <201407062017.23049.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <201407062017.23049.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 06, 2014 at 08:17:22PM +0200, Arnd Bergmann wrote:
> On Friday 04 July 2014, Will Deacon wrote:
> > On Fri, Jul 04, 2014 at 02:47:10PM +0100, Thierry Reding wrote:
> > > On Fri, Jul 04, 2014 at 01:05:30PM +0200, Joerg Roedel wrote:
> > > > On Thu, Jun 26, 2014 at 10:49:41PM +0200, Thierry Reding wrote:
> > > > > Add an IOMMU device registry for drivers to register with and imp=
lement
> > > > > a method for users of the IOMMU API to attach to an IOMMU device.=
 This
> > > > > allows to support deferred probing and gives the IOMMU API a conv=
enient
> > > > > hook to perform early initialization of a device if necessary.
> > > >=20
> > > > Can you elaborate on why exactly you need this? The IOMMU-API is
> > > > designed to hide any details from the user about the available IOMM=
Us in
> > > > the system and which IOMMU handles which device. This looks like it=
 is
> > > > going in a completly different direction from that.
> > >=20
> > > I need this primarily to properly serialize device probing order.
> > > Without it the IOMMU may be probed later than its clients, in which c=
ase
> > > the client drivers will assume that there is no IOMMU (iommu_present()
> > > for the parent bus fails).
> >=20
> > I can also vouch for needing a solution to this problem. The ARM SMMU (=
and
> > I think others) rely on initcall ordering rather than the driver probing
> > model to ensure the IOMMU is probed before any of its masters.
>=20
> I think it would be best to attach platform devices to IOMMUs from the
> of_dma_configure() we just introduced. That still requires handling
> IOMMUs special though, and I don't know how we should best deal
> with that. It would not be too hard to scan for IOMMUs in DT first
> and register them all in a way that we can later look them up
> by phandle, but that would break down if we ever get nested IOMMUs.

But even for nested IOMMUs each will have an associated device node, so
we could scan the tree up front. But given that it only solves the
problem partially I don't think that's a big advantage.

> Another possibility might be to register all devices as we do today,
> including IOMMU devices, but return -EPROBE_DEFER from
> platform_drv_probe() before we call into the driver's probe function
> if the IOMMU has not been set up at that point.

Right, Hiroshi already proposed a patch for that, but it was more or
less NAK'ed because people didn't want to have that functionality in the
device driver core.

> For PCI devices, we need a different way of dealing with the IOMMUs,
> some generic PCI code needs to be added to attach the correct IOMMU
> to a newly added PCI device based on how the host bridge is configured.

I'm curious. Without device tree, how do we find out what IOMMU a device
is connected to? Will it always be an ancestor of the device in the PCI
hierarchy?

> We can probably for now get away with not worrying about any bus type
> other than platform, amba or PCI: we don't use any other DMA master
> capable bus on ARM, and other architectures can probably rely on
> having only a single IOMMU implementation in the system.

Neither of the above proposals will work for cases where more than a
single IOMMU exists in the system. Currently we can only register one
IOMMU per bus and if we try to register a second IOMMU it will fail
(bus_set_iommu() returns -EBUSY).

Also, struct bus_type has only a pointer to a struct iommu_ops, but no
associated context. Hence my proposal, which I only posted partially
here since it didn't seem immediately relevant. But I guess to better
illustrate how I envisioned this to work, here goes:

The idea was to allow each device to have zero or more master on zero or
more IOMMUs. That's as general a case as it gets. Now to make this work
we'd need something like this:

	struct iommu_master {
		struct device *dev; /* the master device */
		struct iommu *iommu; /* the IOMMU that dev masters */
		struct list_head list; /* link in a list of all master
					  interfaces of dev */
	};

Then we could store a list in struct device:

	struct device {
		...
		struct list_head iommu_masters;
		...
	};

It was already mentioned in other threads that if a device does indeed
have more than one master interface, then it needs to control access to
them explicitly via the IOMMU API. Since we only have an API to allocate
an IRQ domain (which automatically forwards calls to the global IOMMU)
we'd need something new, such as:

	master =3D iommu_get(dev, "foo");

or

	master =3D iommu_get(dev, 0);

Or whichever variant we prefer. That could return a pointer to a struct
iommu_master, which could then be used to obtain a domain, like so:

	domain =3D iommu_master_alloc_domain(master);

To make that work, as far as I can tell only very minimal changes would
have to be done to iommu_ops. Most of the functions take a pointer to a
struct iommu_domain anyway, we could extend it with a reference to the
parent of a domain. For that we'll need a structure that represents the
IOMMU device's context (which is what this patch introduces as struct
iommu).

The only functions in struct iommu_ops that deal with an IOMMU directly
are .add_device(), .remove_device() and .device_group(), although they
may become obsolete with the new APIs. Currently .add_device() and
=2Eremove_device() are only used to register devices from a bus notifier
and that would be replaced by something more explicit like above. As for
device_group(), I don't see it being used at all currently.

Now for DMA mapping API integration we could make that use the first (or
only) IOMMU device registered. Perhaps we could even reject using this
layer of integration for multi-master devices, since it would be
difficult to tell whether or not the selected device is the correct one.

We still have the option to handle things mostly transparently with the
above by moving calls to iommu_get() into the core. But we also gain the
flexibility to work with multiple IOMMU contexts explicitly if required.

Thierry

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTuoeJAAoJEN0jrNd/PrOhb88P/1uENYOhXZVOnicN0RR0TfDv
Fn9hiPslFbsiYOXy9fE3rZzXaj/pILOjOIVBE1VMg21HnbT7rlgEe8yqnn8w2uts
cnzN2arYqvUBb1MW/96FabN4qaQZds8YIAf6zyLMqQt/+JSITCJ01t1ZA9FjkK+R
gRd0dtbStWBPVg8UuUsDUKIHpfUg4O5hF/xQMVPX0R+zbyM+xmWG2s0ZNwFQLXrF
hkQUYF48uKwzuIrA8tFnlX2OygZt5ZrxO9I3RmDbsp8hiBOFL+cSY0DD7NbqgWH6
ZYR9J5SuA8pyAcBpI0Cmwf/vDynIhlgIaBeGN4SJAagAD8bSP+zMz8dsKbxl0eVR
EJkQ4cPN6+KZPdkqth7KGuhiR1H0NL4j7f2JzqE970A/DauqQiLWQr0/n3l3x+O7
gODhol2aJOwVPMjs7Or38ldjB20pebEm7ngRcS2oL4ne4hO6Wl+I/hScIPaWhJqq
4/3BchbUKyB4rfs5olD6o8HmNasOUMh7UZiRzOzwprKpPLKhXyO+UUA+7CPqSj0M
eb6KZfLUi4iBQctP4/7jh877jYMpsPJB4Squ27eAaIb/o0YO6sJ460HpwM2sex62
HYGHJQE6aEpp+ZnMhAAYne2kNsZcK8kagpFWvXSqXHSmf98vOYlaH1KYS6J9vFYM
+ROTOvX3Wpqr3N/nZKQa
=Lj8G
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
