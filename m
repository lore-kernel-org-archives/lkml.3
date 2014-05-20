Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaETOCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:02:24 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53134 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbaETOCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:02:19 -0400
Date: Tue, 20 May 2014 16:00:02 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140520135956.GA23140@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <8663464.40PHEumOar@wuerfel>
 <20140520131741.GB6240@ulmo>
 <4161434.ylGuoPKcfs@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <4161434.ylGuoPKcfs@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 03:34:46PM +0200, Arnd Bergmann wrote:
> On Tuesday 20 May 2014 15:17:43 Thierry Reding wrote:
> > On Tue, May 20, 2014 at 02:41:18PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 20 May 2014 14:02:43 Thierry Reding wrote:
> > [...]
> > > > Couldn't a single-master IOMMU be windowed?
> > >=20
> > > Ah, yes. That would actually be like an IBM pSeries, which has a wind=
owed
> > > IOMMU but uses one window per virtual machine. In that case, the wind=
ow could
> > > be a property of the iommu node though, rather than part of the addre=
ss
> > > in the link.
> >=20
> > Does that mean that the IOMMU has one statically configured window which
> > is the same for each virtual machine? That would require some other
> > mechanism to assign separate address spaces to each virtual machine,
> > wouldn't it? But I suspect that if the IOMMU allows that it could be
> > allocated dynamically at runtime.
>=20
> The way it works on pSeries is that upon VM creation, the guest is assign=
ed
> one 256MB window for use by assigned DMA capable devices. When the guest
> creates a mapping, it uses a hypercall to associate a bus address in that
> range with a guest physical address. The hypervisor checks that the bus
> address is within the allowed range, and translates the guest physical
> address into a host physical address, then enters both into the I/O page
> table or I/O TLB.

So when a VM is booted it is passed a device tree with that DMA window?
Given what you describe above this seems to be more of a configuration
option to restrict the IOMMU to a subset of the physical memory for
purposes of virtualization. So I agree that this wouldn't be a good fit
for what we're trying to achieve with iommus or dma-ranges in this
binding.

> > > I would like to add an explanation about dma-ranges to the binding:
> > >=20
> > > 8<--------
> > > The parent bus of the iommu must have a valid "dma-ranges" property
> > > describing how the physical address space of the IOMMU maps into
> > > memory.
> >=20
> > With physical address space you mean the addresses after translation,
> > not the I/O virtual addresses, right? But even so, how will this work
> > when there are multiple IOMMU devices? What determines which IOMMU is
> > mapped via which entry?
> >=20
> > Perhaps having multiple IOMMUs implies that there will have to be some
> > partitioning of the parent address space to make sure two IOMMUs don't
> > translate to the same ranges?
>=20
> These dma-ranges properties would almost always be for the entire RAM,
> and we can treat anything else as a bug.

Would it typically be a 1:1 mapping? In that case could we define an
empty dma-ranges property to mean exactly that? That would make it
consistent with the ranges property.

> The mapping between what goes into the IOMMU and what comes out of it
> is not reflected in DT at all, since it only happens at runtime.
> The dma-ranges property I mean above describes how what comes out of
> the IOMMU maps into physical memory.

Understood. That makes sense.

> > > A device with an "iommus" property will ignore the "dma-ranges" prope=
rty
> > > of the parent node and rely on the IOMMU for translation instead.
> >=20
> > Do we need to consider the case where an IOMMU listed in iommus isn't
> > enabled (status =3D "disabled")? In that case presumably the device wou=
ld
> > either not function or may optionally continue to master onto the parent
> > untranslated.
>=20
> My reasoning was that the DT should specify whether we use the IOMMU
> or not. Being able to just switch on or off the IOMMU sounds nice as
> well, so we could change the text above to do that.
>=20
> Another option would be to do this in the IOMMU code, basically
> falling back to the IOMMU parent's dma-ranges property and using
> linear dma_map_ops when that is disabled.

Yes, it should be trivial for the IOMMU core code to take care of this
special case. Still I think it's worth mentioning it in the binding so
that it's clearly specified.

> > > Using an "iommus" property in bus device nodes with "dma-ranges"
> > > specifying how child devices relate to the IOMMU is a possible extens=
ion
> > > but is not recommended until this binding gets extended.
> >=20
> > Just for my understanding, bus device nodes with iommus and dma-ranges
> > properties could be equivalently written by explicitly moving the iommus
> > properties into the child device nodes, right? In which case they should
> > be the same as the other examples. So that concept is a convenience
> > notation to reduce duplication, but doesn't fundamentally introduce any
> > new concept.
>=20
> The one case  where that doesn't work is PCI, because we don't list the
> PCI devices in DT normally, and the iommus property would only exist
> at the PCI host controller node.

But it could work in classic OpenFirmware where the device tree can be
populated with the tree of PCI devices enumerated by OF. There are also
devices that have a fixed configuration and where technically the PCI
devices can be listed in the device tree. This is somewhat important if
for example one PCI device is a GPIO controller and needs to be
referenced by phandle from some other device.

I'll make a note in the binding document about this possible future
extension.

Thierry

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTe1/cAAoJEN0jrNd/PrOhkR8P/RDBGxIvfWfn4jiC1iY5GWsP
WCd7Bpkht4e5XN5drJDbS7+gG6pN79Ga0kXYJvX9gwoBpnkdTGg6mVLkEHWzfPe+
5Cd6kUqt99sIQjCkkgxw3cV6S2s4qITcwPnAo20ZVOLuvbDlAwdSFlC3ld78Z+pZ
aqi0lFYAR2Y2m2vs24f/hebwwdWQdJCGrTWCCvMdKsVQrYbnLw/r4wC3MpfjUfv6
inUev07n7dlMzZz+X2XkdFLmqH59jkCFPh4bZ6EIiwbwXrF5fbRZXh2DM3UgtffV
n56XVuxwNg6ehSyfmhMXDDLysexOosU7zS4AbxKzwfdHAxImsqRmk85l+oWPyDZ8
6Ub8XE/sYspxJnOhJZMMexCLtsPW3XTUpSUL1uLQByviBylYHrTX1cKVlyeRfHEl
zzXfZclBh0QyY09PAXOrUoCsoDJNY5nbWdpU0nFkWI8RrxYE6AiYKMhfsIJcVZ10
wNind7Z06rQO6EpTt/iPo0pZPYz884BZICm9sEbF7hsPGXgDfIGXyoj/6M8ap1Es
uG5m6rNZQuti5p1E8QRgHFPYBNTc6P8vHMUuOv0O8qsQAwoc4pnPR3koPPUnjcDD
zEUeOTywgjS/ZgBNvWBmzkersRn4UohLiK0/rTOQ9L7qkKgeFFDeK0Lfx7QOVx/f
2obbFFKrmwvP2OosFlGV
=8zHY
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
