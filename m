Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaDDLJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:09:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51168 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaDDLJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:09:07 -0400
Date: Fri, 4 Apr 2014 12:08:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Punnaiah Choudary <kpc528@gmail.com>,
        punnaiah choudary kalluri <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Message-ID: <20140404110837.GS14763@sirena.org.uk>
References: <1396544587-10876-1-git-send-email-punnaia@xilinx.com>
 <203181a5-626f-437e-8efe-983a9d78ec5d@AM1EHSMHS017.ehs.local>
 <20140403212940.GY14763@sirena.org.uk>
 <CAFcVECJiSm8MMJ37c-Qfsu-UE0jgEYRmeGZ8OQG97wyRMaJ1LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aYKnuo739dxkFWAR"
Content-Disposition: inline
In-Reply-To: <CAFcVECJiSm8MMJ37c-Qfsu-UE0jgEYRmeGZ8OQG97wyRMaJ1LQ@mail.gmail.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] SPI: Add support for Zynq Quad SPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aYKnuo739dxkFWAR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 04, 2014 at 08:59:47AM +0530, Harini Katakam wrote:
> On Fri, Apr 4, 2014 at 2:59 AM, Mark Brown <broonie@kernel.org> wrote:

> > Why would a transfer be being set up without a transfer being provided?

> The setup function calls this function before a transfer is initiated.
> In this case NULL is passed to setup_transfer (see below) and
> SPI is initialized with default clock configuration.
> This initialization is necessary because otherwise this clock config
> would be done
> only after SPI is enabled in prepare_hardware, which is wrong.
> (I'm checking for master->busy in setup to address your previous
> comment on SPI).

The requirement for setup() to work when other transfers are in progress
is clear and unambiguous, it really isn't acceptable to reconfigure
hardware in use by a runing transfer in setup().

> I explained the same in SPI v2 changes and this valid there too.

This is v2?

> >> +static int zynq_qspi_setup(struct spi_device *qspi)
> >> +{
> >> +     if (qspi->master->busy)
> >> +             return -EBUSY;
> >> +
> >> +     return zynq_qspi_setup_transfer(qspi, NULL);
> >> +}

> > No, this is broken - you have to support setup() while the hardware is
> > active.  Just remove this if there's nothing to do and set up on the
> > transfer.

> But where do you suggest this clock configuration be done?
> I've looked at the option of doing it in prepare_hardware but
> spi_device structure is not passed to it.

You can readily access the device data from the master - look at how
other drivers do this.

> >> +static int __maybe_unused zynq_qspi_suspend(struct device *_dev)
> >> +{
> >> +     struct platform_device *pdev = container_of(_dev,
> >> +                     struct platform_device, dev);
> >> +     struct spi_master *master = platform_get_drvdata(pdev);
> >> +
> >> +     spi_master_suspend(master);
> >> +
> >> +     zynq_unprepare_transfer_hardware(master);

> > Why are you unpreparing the hardware - the framework should be doing
> > that for you if the device is active, if it's not you've got an extra
> > clock disable here?

> I called unprepare_hardware  becuase it does the things necessary
> after master suspend - disable clock and controller.
> (I thought this was your suggestion for SPI?)

Why are these things required after the core has already idled the
device (using exactly the same function)?

--aYKnuo739dxkFWAR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPpKyAAoJELSic+t+oim9dHUP/RX97nrWMG30Iq+bl1FndO5P
xdFcFx7lEEKjdEsb0bOV0qiBjUeZx+APssKublQfn68RRnu3sU4h8qGxTs3csCR6
yLb2/6EekiPKLmbKJkDXBQS18FGOKPyDhiWSSo0wOOX9c2Wk95Ov1kB1QM8HTtdk
fcPHIbHht1QRBKqcz586yyPBpjuabcBXfxoF9HO2x9Qwqj4PbMnxDL1GVcgCH8Vu
+MhwZqIWWFXY9V1JwgBlYg6tdXfjPppeeXHp7OW2WMBWn5s73Hl93GlobYfyVV23
2VNFVx0Phc5/uXEvh5QSDCd8CKOWZe0MxMpXG8Az4MrLA0MzmtO5eiH9N3qM6hft
FeEfgE8M3NBuHTnRF8modZeKtO4Krbt1srRNkIZ7oFuu3zMfSBThAxPvMGZn3euS
GGb+RDCH9WL2ustrnGg9MecWrUdqwPpo9sjRztcccT1mvXPXtQa1SQQMWbUZ/9n8
yBOJWplFOt/sz5IfgeU18NU9FVO6/xujMP2QdZAqEGqzkNp1cFaXgjIaISScOBsa
BlRcgxnX2fVQVLn31rRKklZXMpK2vgCpSoWrET3CU3vgrlKQLaCeKbu08vp49DaY
gJ1CveD/5iqhPNWnRqv15M/+LxfFIynAl4bEwFcb7CrR+Ym9AAQ8T7EUuRek8Vbi
G/Z9Hj29hTkVC36IM919
=QyjQ
-----END PGP SIGNATURE-----

--aYKnuo739dxkFWAR--
