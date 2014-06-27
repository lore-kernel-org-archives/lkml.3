Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaF0G66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:58:58 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:39960 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaF0G6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:58:55 -0400
Date: Fri, 27 Jun 2014 08:58:51 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 01/10] iommu: Add IOMMU device registry
Message-ID: <20140627065850.GG9258@ulmo>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
 <1403815790-8548-2-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BzCohdixPhurzSK4"
Content-Disposition: inline
In-Reply-To: <1403815790-8548-2-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BzCohdixPhurzSK4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2014 at 10:49:41PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> Add an IOMMU device registry for drivers to register with and implement
> a method for users of the IOMMU API to attach to an IOMMU device. This
> allows to support deferred probing and gives the IOMMU API a convenient
> hook to perform early initialization of a device if necessary.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/iommu/iommu.c | 93 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/iommu.h | 27 +++++++++++++++
>  2 files changed, 120 insertions(+)

I thought that perhaps I should elaborate on this a bit since I have a
few ideas on how the API could be enhanced.

> +static int of_iommu_attach(struct device *dev)
> +{
> +	struct of_phandle_iter iter;
> +	struct iommu *iommu;
> +
> +	mutex_lock(&iommus_lock);
> +
> +	of_property_for_each_phandle_with_args(iter, dev->of_node, "iommus",
> +					       "#iommu-cells", 0) {
> +		bool found =3D false;
> +		int err;
> +
> +		/* skip disabled IOMMUs */
> +		if (!of_device_is_available(iter.out_args.np))
> +			continue;
> +
> +		list_for_each_entry(iommu, &iommus, list) {
> +			if (iommu->dev->of_node =3D=3D iter.out_args.np) {
> +				err =3D iommu->ops->attach(iommu, dev);
> +				if (err < 0) {
> +				}
> +
> +				found =3D true;
> +			}
> +		}
> +
> +		if (!found) {
> +			mutex_unlock(&iommus_lock);
> +			return -EPROBE_DEFER;
> +		}
> +	}
> +
> +	mutex_unlock(&iommus_lock);
> +
> +	return 0;
> +}
> +
> +static int of_iommu_detach(struct device *dev)
> +{
> +	/* TODO: implement */
> +	return -ENOSYS;
> +}
> +
> +int iommu_attach(struct device *dev)
> +{
> +	int err =3D 0;
> +
> +	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
> +		err =3D of_iommu_attach(dev);
> +		if (!err)
> +			return 0;
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(iommu_attach);

I think it might make sense to introduce an explicit object for an IOMMU
master attachment. Maybe something like:

	struct iommu_master {
		struct iommu *iommu;
		struct device *dev;

		...
	};

iommu_attach() could then return a pointer to that attachment and the
IOMMU user driver could subsequently use that as a handle to access
other parts of the API.

The reason is that if we ever need to support more than a single master
interface (and perhaps even multiple master interfaces on different
IOMMUs) for a single device, then we need a way for the IOMMU user to
differentiate between its master interfaces.

> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 284a4683fdc1..ac2ceef194d4 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -43,6 +43,17 @@ struct notifier_block;
>  typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
>  			struct device *, unsigned long, int, void *);
> =20
> +struct iommu {
> +	struct device *dev;
> +
> +	struct list_head list;
> +
> +	const struct iommu_ops *ops;
> +};

For reasons explained above, I also think that it would be a good idea
to modify the iommu_ops functions to take a struct iommu * as their
first argument. This may become important when one driver needs to
support multiple IOMMU devices. With the current API drivers have to
rely on global variables to track the driver-specific context. As far as
I can tell, only .domain_init(), .add_device(), .remove_device() and
=2Edevice_group(). .domain_init() could set up a pointer to struct iommu
in struct iommu_domain so the functions dealing with domains could gain
access to the IOMMU device via that pointer.

Thierry

--BzCohdixPhurzSK4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrRYqAAoJEN0jrNd/PrOhIvkP/1ZYrOwoxZyNI2D4H+SY3QYa
hva4qcLpP4RW+boQxBFRJ/v/fgpUSecMvW28vw5LadBlcwNrrOlDHwN02e8C5YV6
FL2nQ6t0cXFFqQm/udvc71xOQn1iatxss0g6ynq0M5o+458mqRZKQn6WGaKXURwI
D5LvOr/eL5m7c+a7OuHOB16G5gp1j4tzUZnzXNKlySEJ65bWl1sU7OShHni8C+Ne
sdeFATG6IO/z5Jq5UqNdv3ioeliBmwaBxdNoTS3peNMBSB9UyuEKpXaF10JrYHSO
aUzIj/vi0p+hrv4KxoIIxjzGaXtNoFB74YA7ix3aWo4Ba+zxql9poEWmewtbndKj
+HAlQ+9uXVs4utHVn7ne8Rhk1HLV+xtxznl9WrEkE8NE/YiBDPJCyKJd+ioVk91q
ElIlaYD8BnWcinkyuZuy1+ND58WeN7ACuYhdyT75Vj+tznClmEd46pC7h4WtfeAt
T2SfBN84OB/Yf7GiILsFnmDJO5RyVCtxG2FogHgiyOwBSLP2Rfbkb7Uev2ynr8ff
hcuqby1CqNRTEYF0HwowxRhzpDUq6ZfloVrcc98jP217X3BHRYlxRbtrIcCk7DiI
T2vvJx+wGs6BFePuT6dEFUTuFiqR/1qe+sUdGzH0qwgkqj6wfihE17I7qTF7WQB8
ukLyzmZa38pkxHLwMTBY
=JCV8
-----END PGP SIGNATURE-----

--BzCohdixPhurzSK4--
