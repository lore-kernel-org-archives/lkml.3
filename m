Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaEUISe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:18:34 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63902 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaEUIS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:18:28 -0400
Date: Wed, 21 May 2014 10:16:09 +0200
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
Message-ID: <20140521081608.GA11068@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <4161434.ylGuoPKcfs@wuerfel>
 <20140520135956.GA23140@ulmo>
 <5123714.0MpMQfsmcr@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <5123714.0MpMQfsmcr@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 10:31:29PM +0200, Arnd Bergmann wrote:
> On Tuesday 20 May 2014 16:00:02 Thierry Reding wrote:
> > On Tue, May 20, 2014 at 03:34:46PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 20 May 2014 15:17:43 Thierry Reding wrote:
> > > > On Tue, May 20, 2014 at 02:41:18PM +0200, Arnd Bergmann wrote:
> > > > > On Tuesday 20 May 2014 14:02:43 Thierry Reding wrote:
> > > > [...]
> > > > > > Couldn't a single-master IOMMU be windowed?
> > > > >=20
> > > > > Ah, yes. That would actually be like an IBM pSeries, which has a =
windowed
> > > > > IOMMU but uses one window per virtual machine. In that case, the =
window could
> > > > > be a property of the iommu node though, rather than part of the a=
ddress
> > > > > in the link.
> > > >=20
> > > > Does that mean that the IOMMU has one statically configured window =
which
> > > > is the same for each virtual machine? That would require some other
> > > > mechanism to assign separate address spaces to each virtual machine,
> > > > wouldn't it? But I suspect that if the IOMMU allows that it could be
> > > > allocated dynamically at runtime.
> > >=20
> > > The way it works on pSeries is that upon VM creation, the guest is as=
signed
> > > one 256MB window for use by assigned DMA capable devices. When the gu=
est
> > > creates a mapping, it uses a hypercall to associate a bus address in =
that
> > > range with a guest physical address. The hypervisor checks that the b=
us
> > > address is within the allowed range, and translates the guest physical
> > > address into a host physical address, then enters both into the I/O p=
age
> > > table or I/O TLB.
> >=20
> > So when a VM is booted it is passed a device tree with that DMA window?
>=20
> Correct.
>=20
> > Given what you describe above this seems to be more of a configuration
> > option to restrict the IOMMU to a subset of the physical memory for
> > purposes of virtualization. So I agree that this wouldn't be a good fit
> > for what we're trying to achieve with iommus or dma-ranges in this
> > binding.
>=20
> Thinking about it again now, I wonder if there are any other use cases
> for windowed IOMMUs. If this is the only one, there might be no use
> in the #address-cells model I suggested instead of your original
> #iommu-cells.

So in this case virtualization is the reason why we need the DMA window.
The reason for that is that the guest has no other way of knowing what
other guests might be using, so it's essentially a mechanism for the
host to manage the DMA region and allocate subregions for each guest. If
virtualization isn't an issue then it seems to me that the need for DMA
windows goes away because the operating system will track DMA regions
anyway.

The only reason I can think of why a windowed IOMMU would be useful is
to prevent two or more devices from stepping on each others' toes. But
that's a problem that the OS should already be handling during DMA
buffer allocation, isn't it?

> > > > > I would like to add an explanation about dma-ranges to the bindin=
g:
> > > > >=20
> > > > > 8<--------
> > > > > The parent bus of the iommu must have a valid "dma-ranges" proper=
ty
> > > > > describing how the physical address space of the IOMMU maps into
> > > > > memory.
> > > >=20
> > > > With physical address space you mean the addresses after translatio=
n,
> > > > not the I/O virtual addresses, right? But even so, how will this wo=
rk
> > > > when there are multiple IOMMU devices? What determines which IOMMU =
is
> > > > mapped via which entry?
> > > >=20
> > > > Perhaps having multiple IOMMUs implies that there will have to be s=
ome
> > > > partitioning of the parent address space to make sure two IOMMUs do=
n't
> > > > translate to the same ranges?
> > >=20
> > > These dma-ranges properties would almost always be for the entire RAM,
> > > and we can treat anything else as a bug.
> >=20
> > Would it typically be a 1:1 mapping? In that case could we define an
> > empty dma-ranges property to mean exactly that? That would make it
> > consistent with the ranges property.
>=20
> Yes, I believe that is how it's already defined.

I've gone through the proposal at [0] again, but couldn't find a mention
of an empty "dma-ranges" property. But regardless I think that a 1:1
mapping is the obvious meaning of an empty "dma-ranges" property.

[0]: http://www.openfirmware.org/ofwg/proposals/Closed/Accepted/410-it.txt

One thing I'm not sure about is whether dma-ranges should be documented
in this binding at all. Since there's an accepted standard proposal it
would seem that it doesn't need to be specifically mentioned. One other
option would be to link to the above proposal from the binding and then
complement that with what an empty "dma-ranges" property means.

Or we could possible document this in a file along with other standard
properties. I don't think we currently do that for any properties, but
my concern is that there will always be a limited number of people
knowing about how such properties are supposed to work. If all of a
sudden all these people would disappear, everybody else would be left
with references to these properties but nowhere to look for their
meaning.

> > > > > A device with an "iommus" property will ignore the "dma-ranges" p=
roperty
> > > > > of the parent node and rely on the IOMMU for translation instead.
> > > >=20
> > > > Do we need to consider the case where an IOMMU listed in iommus isn=
't
> > > > enabled (status =3D "disabled")? In that case presumably the device=
 would
> > > > either not function or may optionally continue to master onto the p=
arent
> > > > untranslated.
> > >=20
> > > My reasoning was that the DT should specify whether we use the IOMMU
> > > or not. Being able to just switch on or off the IOMMU sounds nice as
> > > well, so we could change the text above to do that.
> > >=20
> > > Another option would be to do this in the IOMMU code, basically
> > > falling back to the IOMMU parent's dma-ranges property and using
> > > linear dma_map_ops when that is disabled.
> >=20
> > Yes, it should be trivial for the IOMMU core code to take care of this
> > special case. Still I think it's worth mentioning it in the binding so
> > that it's clearly specified.
>=20
> Agreed.

Okay, I have a new version of the binding that I think incorporates all
the changes discussed so far. It uses #address-cells and #size-cells to
define the length of the specifier, but if we decide against that it can
easily be changed again.

Thierry

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfGDIAAoJEN0jrNd/PrOhVooP/27Bf22lkTAWzMAboZ3YpGFh
e7okRs+gzx4zl75Du9xT38uDzDvdHY/TBrmPtuziyBdb6VVAX+tcTiWQrFhqXHFl
7jRqtWAhMgFkZRuD5cZ7MuwuuqfX0+3Oi0ctqH8+V6fMsKSP1s5pRElLBWigaG/p
ggqIeioDIYLtVE4rFSq6HpjF7gqMA6+HsT3V/MGlNd+ej9LpMBgeiCWQxZaFANYi
N/AVmE9PmlxMupt0sAeU6mYhhUcAFsZRqZG6BAvtax94B1SvYu5vBDj2HHlXkf2C
yW1Gj5gUdMr6GT3/kAprsZQggxEUdk+4n/zco5l7NhzJxTdKCUVbtBcZdBZUxq6U
qVqtng+54UW3/FQC+MWt7+9SzdcSAuuceI7nxj5SDLW8bg44rewz84jC82g08EIc
0zgZvzOuIN2UuGc1k2whSMFCrFTcSFZB0FJnPNU44qAUhS0qy7s1qj0sDYbV7r2F
b8j+11zeFuuNChS+3mjyX6UfYy+r6X811vTrkosRrQw7898zQI5HsOcWia2q1CrY
cIaLsLNGA/M+R6ywwbl9B5ED6hWD+bvQz+VhvHX0LqOVmHQCi59DdAhfPzE5owOy
3Fhxb0pXNs4/KA6alQGcpy0FHikotDWQsWIkXK+avCfnSB54nWwmKorkwCa8tRBv
5K+uVvmdZN6R6zVXp36C
=5MKV
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
