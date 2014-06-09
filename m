Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbaFIKwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:52:08 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:51332 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaFIKwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:52:03 -0400
Date: Mon, 9 Jun 2014 12:49:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140609104905.GD2687@ulmo>
References: <20140606224542.GA22188@mithrandir>
 <4306568.dZTtF4xhhK@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eqp4TxRxnD4KrmFZ"
Content-Disposition: inline
In-Reply-To: <4306568.dZTtF4xhhK@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 07, 2014 at 03:22:13PM +0200, Arnd Bergmann wrote:
> On Saturday 07 June 2014 00:45:45 Thierry Reding wrote:
> > This is somewhat off-topic, but given the various concepts discussed in
> > this thread I'm beginning to wonder how they will be implemented.
>=20
> I think it's good you raised the question.
>=20
> > The
> > current implementation hooks the IOMMU API into the DMA mapping API, and
> > the way this is done is by setting a single IOMMU (or rather a set of
> > IOMMU operations) globally per bus type.
>=20
> I hadn't realized that we have a per-bus iommu_ops pointer. I agree
> this will become a limitation as soon as we have a soc with two different
> IOMMUs that have platform devices attached, and it has to be moved into
> the device or a structure related to that.
>=20
> If that turns out controversial, we can probably have a set of pseudo
> iommu ops that just call into dev->archdata->iommu_ops->function()
> for ARM.
>=20
> > There are two issues that I can see with that: one is that we can't
> > support multiple IOMMUs in the system at all, and the other is that
> > there is no context associated with the IOMMU ops, and therefore there
> > is no way to differentiate between two instances of the same IOMMU. A
> > few drivers use global variables to keep track of context information
> > but that won't work with multiple instances, unless they keep a global
> > list of all instances and then require explicit lookup in each of the
> > IOMMU operations. That sounds more like a workaround rather than a
> > proper solution to me.
>=20
> Supporting multiple iommus that share one iommu driver should work
> without such hacks, as you can put the per-device information into
> dev->device_dma_parameters (this works only for very simple IOMMUs)
> or dev->archdata->iommu

I was talking about the lack of a place to store context for the IOMMU
itself. Currently none of the functions in iommu_ops have a way to get
access to the IOMMU context itself. In fact there's not even a common
structure that could be used for this purpose. I have a couple of local
patches that try to add something like that, along with functions to
more explicitly hook up a device with it's IOMMU(s). It looks somewhat
like this:

	struct iommu {
		struct device *dev;

		struct list_head list;

		const struct iommu_ops *ops;
	};

	/* register and unregister IOMMU device with core */
	int iommu_add(struct iommu *iommu);
	void iommu_remove(struct iommu *iommu);

	/*
	 * Attach a device to one or more IOMMUs (according to the
	 * iommus property).
	 */
	int iommu_attach(struct device *dev);
	int iommu_detach(struct device *dev);

Does that look like a direction that we would want to pursue?

> (we may want to generalize that, I think someone just posted patches
> for it).

Perhaps you mean this:

	[PATCHv3 1/3] device.h: arm dma-iommu: Move out dma_iommu_mapping struct

? From a quick glance that indeed looks like a promising step towards
unifying this across architectures.

> > Discussion in this thread indicates that both of the above will be
> > required at some point. Have I completely missed something or will we
> > have to rework (parts of) the IOMMU API to make this work?
> >=20
> > One other thing that I have some difficulty understanding is how we can
> > support things like process isolation using the current IOMMU API. Since
> > a device will be statically assigned to one IOMMU domain at probe time
> > there is no way we can change the address space upon a context switch.
>=20
> We have just introduced a way to parse dma-ranges in of_dma_configure().
>=20
> The only way I see this done for platform devices is to do the IOMMU
> configuration in the same place: if an iommus property is found there,
> we call out to the iommu driver that matches the respective iommu device
> and let it configure the master device.
>=20
> The device already has multiple properties related to iommus:
> 'struct device_dma_parameters', 'archdata', 'iommu_group', and
> pdev_archdata for platform devices. This should be enough to set up
> the default iommu dma_map_ops so we can have non-isolated DMA using
> dma_map_* and dma_alloc_coherent.

Right, I think up to that point things should be fine with the existing
IOMMU API and using only DMA mapping functions.

> I haven't given much thought to devices that want to use the IOMMU
> API directly so they can have multiple domains rather than rely on
> the dma-mapping abstraction.

I'm specifically thinking about cases where we want to use the IOMMU to
isolate processes from each other. This is probably most relevant for
GPUs, since they are driven to a large degree from userspace. Other
peripherals are mostly services in kernel space exclusively, so I don't
think the issue is as relevant there.

On Tegra there's two IOMMUs, one system-wide and another one directly
used by the GPU (and programmed by the GPU driver (nouveau)). For the
latter it probably doesn't make sense to expose it via the IOMMU API,
and we may be able to get sufficient process isolation using only it
rather than in combination with the SMMU. However some of the graphics
components don't master through the GPU's IOMMU, so if we want any kind
of process isolation there we may need to control the IOMMU more
explicitly. I'm still trying to get a more full understanding of this,
but it would seem to me that we'd need some way to use different domains
(which I think is the proper abstraction for what the Tegra SMMU calls
an Address Space ID (ASID)) in one driver, depending on the current
process.

Thierry

--eqp4TxRxnD4KrmFZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTlZEhAAoJEN0jrNd/PrOh7K4QAIhAT8R1UyC7rp/hm215jpaQ
/KXTWRXvGBswoOBcW7YSk8z2mVlJKyruhbW1jV8pKEbZqBdgJBeoFGSsbvc9YwK6
iABlgHtqYiZZFBhudwDS5kVQiVIOISK2zkKbGJizP7uraWls74LS2OQUgGndLbmA
zh5dptghZn2F9ifSg/8N1+WZj5+DogKF4CukO8dpXllK+VSMm9Owid2shaYSbwWp
6dJ+bg2Gb4bpOwJCDVefHI84Ohi+2yKOwJ8N/ahwxL3nRFdkn2uyRtg6MAbTambF
BlJ7dTGdHcG7YgcqUtH/8Hfpi+nSCheSrS7R0hN71WnF1Y2lKbEL4lH6sSBDc6o6
H+aPnSbGev7lFiPLRV+8egcIsMpRdDrMJ0SspVQFkBqiJT7V/XZdKrxQAi3ZooZq
yPlJ8cy65+1ig3sItOfUlYD7GRX6QXDxHG2yitbIzeCITD28iHcw8eUPV/Qob8z0
wcvvoEzHP91T/9XnBGf7upqVJ5TvEco50u8cM9SF4G5KuG48iNBxOqdEXRLjlxLa
qX5VWLzTGnu+lJGzMmeLmsgJTiDgt7RWWqhAXlgqRWAuQCfBt3vxHykHmiDNlyjm
2jdagxgiqdZ2ToTW332Q4rZ00vNIKNYW3m1kRpKVEVkOXV9EPwAFtgHHm72YjEsY
B2asu4t59lPypkSq5DfR
=0t66
-----END PGP SIGNATURE-----

--eqp4TxRxnD4KrmFZ--
