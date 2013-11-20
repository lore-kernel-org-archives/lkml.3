Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3KTNPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:15:21 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:37648 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3KTNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:15:17 -0500
Date: Wed, 20 Nov 2013 14:14:48 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
Message-ID: <20131120131447.GA8279@ulmo.nvidia.com>
References: <20131119102506.GG31504@ulmo.nvidia.com>
 <20131119.140351.1342214267287135109.hdoyu@nvidia.com>
 <528BD6A7.3030908@wwwdotorg.org>
 <20131120.051708.396722414386125310.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20131120.051708.396722414386125310.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 20, 2013 at 04:17:08AM +0100, Hiroshi Doyu wrote:
> Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 19 Nov 2013 22:22:47 =
+0100:
>=20
> > On 11/19/2013 05:03 AM, Hiroshi Doyu wrote:
> > > Hi Thierry,
> > >=20
> > > Thierry Reding <thierry.reding@gmail.com> wrote @ Tue, 19 Nov 2013 11=
:25:07 +0100:
> > >=20
> > >> From earlier discussions I thought the goal was to actually defer th=
is
> > >> until all nodes referred to by the iommus property were actually
> > >> registered. The above only checks that the phandles can be resolved =
to
> > >> valid struct device_node:s. That doesn't mean that an actual IOMMU h=
as
> > >> been registered for it, only that the devices have been created.
> > >=20
> > > Currently "bus->iommu_ops" is set at the end of tegra_smmu_probe(). So
> > > if "bus->iommu_ops" is set, it means that an iommu instance is
> > > populated at that time.
> >=20
> > Yes, but that's the register bus, upon which the device is a client, not
> > the bus upon which the device is a bus master. They aren't necessarily
> > the same.
> >=20
> > There's no getting around the fact that, as Thierry said, you need to
> > search for a registered IOMMU device for each phandle, and defer probe
> > if any aren't registered yet.
> >=20
> > If we do that, then you shouldn't need to look at the value of
> > dev->bus->iommu_ops at all; if all IOMMUs in the list were registered,
> > then iommu_ops must have been set when (one of them) was registered, and
> > if not, then it possibly wasn't, so defer probe.
> >=20
> > That way, this code won't have to change if the core IOMMU code gets
> > extended to support multiple IOMMUs, devices mastering transactions onto
> > buses other than their register bus, etc.
>=20
> Does the above mean the following?
>=20
> int of_iommu_attach(struct device *dev)
> {
> 	int i;
> 	struct of_phandle_args args;
>=20
> 	of_property_for_each_phandle_with_args(dev->of_node, "iommus",
> 					       "#iommu-cells", i, &args)
> 		if (!args->np->dev->driver)
> 			return -EPROBE_DEFER;
> 	return 0;
> }

Not quite. The above would only check that a driver was bound to the
device. But if that device isn't an IOMMU then this doesn't help you.

The standard way to solve this issue is to add the IOMMU to a global
list upon registration. Typically subsystems have some way to do that
already, but it seems like IOMMU doesn't. It looks like that's one of
the side-effects of the assumption that there will always only be a
single IOMMU (per bus).

There's also no base object that IOMMU drivers implement, which is the
way it's usually done in other subsystems. The absence of that makes it
more difficult. I suspect the easiest way to do that would be to add a
new type, something like this:

	struct iommu {
		struct list_head list;
		struct device *dev;
	};

Then modify the driver to do something like this (tegra-smmu.c):

	struct smmu_device {
		struct iommu iommu;

		...
	};

	...

	static int tegra_smmu_probe(struct platform_device *pdev)
	{
		struct smmu_device *smmu;

		...

		smmu->iommu.dev =3D &pdev->dev;

		iommu_add(&smmu->iommu);

		...
	}

	static int tegra_smmu_remove(struct platform_device *pdev)
	{
		struct smmu_device *smmu;

		...

		iommu_del(&smmu->iommu);
	}

The implementation of iommu_add() and iommu_del() could be as simple as:

	static DEFINE_MUTEX(iommus_lock);
	static LIST_HEAD(iommus_list);

	void iommu_add(struct iommu *iommu)
	{
		INIT_LIST_HEAD(&iommu->list);
		mutex_lock(&iommus_lock);
		list_add_tail(&iommu->list, &iommus_list);
		mutex_unlock(&iommus_lock);
	}

	void iommu_del(struct iommu *iommu)
	{
		INIT_LIST_HEAD(&iommu->list);
		mutex_lock(&iommus_lock);
		list_del(&iommu->list);
		mutex_unlock(&iommus_lock);
	}

And then you can implement a lookup function to match an IOMMU to the
phandle, like so:

	struct iommu *of_find_iommu_by_node(struct device_node *np)
	{
		struct iommu *iommu;

		mutex_lock(&iommus_lock);

		list_for_each_entry(iommu, &iommus_list, list) {
			if (iommu->dev->of_node =3D=3D np) {
				mutex_unlock(&iommus_lock);
				return iommu;
			}
		}

		mutex_unlock(&iommus_lock);
		return NULL;
	}

With that you can use of_find_iommu_by_node() in the loop to check
whether an IOMMU has really been registered.

Of course that all is somewhat intrusive and Joerg might have some
objections.

Thierry

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjLXHAAoJEN0jrNd/PrOhMqEP/3AGsma7ZRS9FdhYRMPDoFLN
Lvea+xvEygWbOSYgU0a/ktPDTWkQjg79FQgOuItIxkOtZSEiuDaL0B9aLwJfVix+
Z2mT+wORdTtmqvq+OKJT9nRjWNWTpjDMzH8FzwujoaMYqX5O+59s/VgxGPamZ7zF
zbBjXiloXyA8jpkXr+C5vH3WFuXDz4t8cwe4Bz5/CJPHx6KrczwIbkSvaCv4Njcg
5hjbJAtup1WDRbN+3vQDvo5AuyEPyC0GcTO6fmZYrtXFmjROdypMgdVIDAhOwxK1
m+/H+s6RN1ZbZdYlXdTSp/0pdwLmFM+w6gymlbd0YuHu/brf/aAXYG+LgjRXYfxV
KaZucI/ffn6dH8mfTihRPWf4igH95OXFUd1AhWh1XH+W/74WY8VyylwaKjRrwBf7
kgYOMqQvfgI2W+FXveintRGPrLWmZuedJn4qcunBTvRzIHFvPlA3TDo3bhUf+Hhx
fZDWqFcLu8mm1m12Ou9G3pxeBIAJLN3Szfo5T6ztyLiAPFM4puKNFPD+YSggs8AQ
8SI5SMAD+RVgPLB+no+lqGDlPhGPFAw0hbQlHu8q1xijg2TV7N0PGdFHyjgNIWd1
hTb3KTd5KxgxSpZhoeDNbpMbKlsB0orRA3VcVP2h2CmFPRF4BVnVK2fIntZy2Knp
DeTkWc7plwVOWzU4B+uC
=aTJK
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
