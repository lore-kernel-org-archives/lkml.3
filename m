Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKIKRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 05:17:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53381 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaKIKRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 05:17:49 -0500
Date: Sun, 9 Nov 2014 10:17:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Message-ID: <20141109101712.GM2722@sirena.org.uk>
References: <1415525113-25598-1-git-send-email-b.galvani@gmail.com>
 <1415525113-25598-3-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xtx0sNU5lZ46KfgK"
Content-Disposition: inline
In-Reply-To: <1415525113-25598-3-git-send-email-b.galvani@gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.97
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] spi: meson: Add support for Amlogic Meson SPIFC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xtx0sNU5lZ46KfgK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 09, 2014 at 10:25:12AM +0100, Beniamino Galvani wrote:

> +static int meson_spifc_wait_ready(struct meson_spifc *spifc)
> +{
> +	unsigned long deadline = jiffies + msecs_to_jiffies(1000);
> +	u32 data;
> +
> +	do {
> +		regmap_read(spifc->regmap, REG_SLAVE, &data);
> +		if (data & SLAVE_TRST_DONE)
> +			return 0;
> +		cond_resched();
> +	} while (time_before(jiffies, deadline));

This will busy wait for up to a second, that seems like a long time to
busy wait.  We also appear to be using this for the entire duration of
the transfer which could be a fairly long time even during normal
operation if doing a large transfer such as a firmware download, or if
the bus speed is low.

> +	meson_spifc_setup_speed(spifc, xfer->speed_hz ? xfer->speed_hz :
> +				spi->max_speed_hz);
> +

Please avoid the ternery operator, it does nothing for legibility and in
this case it's not needed as the core will always ensure that there is a
per-transfer speed set.

> +	while (done < xfer->len && !ret) {
> +		len = min_t(int, xfer->len - done, SPIFC_BUFFER_SIZE);
> +		ret = meson_spifc_txrx(spifc, xfer, done, len,
> +				       last_xfer, done + len >= xfer->len);
> +		done += len;
> +	}

I noticed that the handling of /CS was done in the spifc_txrx() function
- will this do the right thing if the transfer needs to be split for the
buffer size?

> +	if (!ret && xfer->delay_usecs)
> +		udelay(xfer->delay_usecs);

The core will do this for you if you implement this as transfer_one().

> +static int meson_spifc_transfer_one_message(struct spi_master *master,
> +					    struct spi_message *msg)

This appears to do nothing that the core won't do - just implement
transfer_one() and remove this.

> +	spifc = spi_master_get_devdata(master);
> +	memset(spifc, 0, sizeof(struct meson_spifc));

There should be no need for this memset.

> +	spifc_regmap_config.max_register = resource_size(res) - 4;
> +	spifc_regmap_config.name = "amlogic,meson-spifc";

If you're dynamically initializing the structure you need to work with a
copy of it rather than directly since there may be multiple instances.
I'm not seeing a reason to override the regmap name here, this is only
really intended for devices with multiple register maps.

> +	ret = clk_prepare_enable(spifc->clk);
> +	if (ret) {
> +		dev_err(spifc->dev, "can't prepare clock\n");
> +		goto out_err;
> +	}

You should really implement runtime PM operations to disable this when
not in use and use auto_runtime_pm to make sure this happens.

> +	master->bus_num = pdev->id;

Leave this blank for DT only devices (and for non-DT devices this won't
work if you get two different buses).

--xtx0sNU5lZ46KfgK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXz8nAAoJECTWi3JdVIfQ6uwH/iipw+JCAVDWomXsQxHD7y/m
G4yhQgLNoMR4sBTI+iSc9KeGONbTLagnAcjnwjpjT/Dm1wY6q3pj9lFvz5cf6UIX
XhLlI/moio0mtYlYYlEN54dn8Sm/29pvH2HRLibEdalY7QuK/3tEySvkj0BXNCpc
xKxVDyvZcnLFlO4Mrvwvp6CEkQGe2DqKnjcGJ/gAxsRiq9qydh3MpBAj99PWZK42
u1pb6YmuggL3fqhZvyoKyx5wrxEeV0kzpj0NHESSSEnFOjeV33JZusCziMRw+0rq
h8iHOMWtPc9w1NKjV0zNIK0IKzOQP56pYvEMvED+lj5EPdUVWMtr7vFy/F8VNHk=
=dTtp
-----END PGP SIGNATURE-----

--xtx0sNU5lZ46KfgK--
