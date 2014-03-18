Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaCRLE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:04:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47558 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaCRLEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:04:23 -0400
Date: Tue, 18 Mar 2014 11:04:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harini.katakam@xilinx.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>
Message-ID: <20140318110401.GH11706@sirena.org.uk>
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <20140317173017.GW11706@sirena.org.uk>
 <255edf4f-05a8-4d9a-b32d-1a4a8ddaffb5@CH1EHSMHS004.ehs.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PBu/a+gn9/ndsyD5"
Content-Disposition: inline
In-Reply-To: <255edf4f-05a8-4d9a-b32d-1a4a8ddaffb5@CH1EHSMHS004.ehs.local>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PBu/a+gn9/ndsyD5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2014 at 05:16:26AM +0000, Harini Katakam wrote:

Please fix your mailer to word wrap within paragraphs, this will make
your mail much more legible.

> > > +	if (bits_per_word !=3D 8) {
> > > +		dev_err(&spi->dev, "%s, unsupported bits per word %x\n",
> > > +			__func__, spi->bits_per_word);
> > > +		return -EINVAL;
> > > +	}

> > The core will check this for you.

> I dint find that the core does this.

bpw_mask.

> > It's not clear to me why this has been split into a separate function a=
nd the
> > function will write to the hardware which you're not allowed to do in
> > setup() if it might affect an ongoing transfer.

> Are you saying  that there's a chance cdns_spi_setup() will be called
> when there's an ongoing transfer?  In that case I have to remove the
> cdns_setup_transfer() call from here but then there's nothing left to
> do in setup.

yes.

> > I see from further up the file that there are error interrupt states wh=
ich
> > might be flagged but these are just being ignored.

> I'm not sure I understand what you are referring to -
> The only interrupts enabled (See CNDS_IXR_DEFAULT_MASK) are TXOW and MODF.

The code had:

> +#define CDNS_SPI_IXR_TXOW_MASK 0x00000004 /* SPI TX FIFO Overwater */
> +#define CDNS_SPI_IXR_MODF_MASK 0x00000002 /* SPI Mode Fault */
> +#define CDNS_SPI_IXR_RXNEMTY_MASK 0x00000010 /* SPI RX FIFO Not Empty */

> +#define CDNS_SPI_IXR_TXFULL_MASK       0x00000008 /* SPI TX Full */

and defined:

> +#define CDNS_SPI_IXR_ALL_MASK  0x0000007F /* SPI all interrupts */

> > > +	return IRQ_HANDLED;

> > This should only be returned if an interrupt was actually handled - if =
the line
> > is shared in some system this will break.

> In this case both possible interrupt conditions are handled.

Are you sure that's the case, and even if you are that's still not
handling the case where the device isn't flagging an interrupt at all.

> > > +	cdns_spi_write(xspi->regs + CDNS_SPI_IER_OFFSET,
> > > +		       CDNS_SPI_IXR_DEFAULT_MASK);
> > > +
> > > +	ret =3D wait_for_completion_interruptible_timeout(&xspi->done,
> > > +							CDNS_SPI_TIMEOUT);
> > > +	if (ret < 1) {

> > If you return a positive value from transfer_one() the core will wait f=
or you.

> I don't understand. Here, if the ret from
> wait_for_completion_interruptible_timeout is positive, then this
> function (spi_start_transfer) will return (transfer->len) -
> (xspi->remaining_bytes) to cdns_transfer_one_message(the calling
> funtion). Which will just use this return as information on how many
> bytes were transferred (see variable length).=20
> cdns_transfer_one_messag() only returns 0 or error value (-ve) (see
> variable status).  It doesn't return positive value to core.

I'm saying you should be implementing a transfer_one() operation and
returning a positive value from it so the core can do the delay for you.

> > > +	ret =3D of_property_read_u16(pdev->dev.of_node, "num-chip-select",
> > > +				   &master->num_chipselect);
> > > +	if (ret < 0) {
> > > +		dev_err(&pdev->dev, "couldn't determine num-chip-
> > select\n");
> > > +		goto clk_dis_all;
> > > +	}

> > Is there no reasonable default?

> Are you saying if I cant read num-chipselect from dts,=20
> I should set it to a default (that will be 4) and proceed?

Yes.

> > > +	/* Set to default valid value */
> > > +	xspi->speed_hz =3D clk_get_rate(xspi->ref_clk) / 4;

> > The driver should set max_speed_hz as well.

> This is the max_speed_hz - 4 is the lowest divisor possible. 2 is invalid.
> It is set in init_hw (see config register default mask).

I'm saying you should set max_speed_hz, not set speed_hz to the maximum
value.  This tells the core what the maximum speed is so it can error
check the driver operations.

--PBu/a+gn9/ndsyD5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKCgeAAoJELSic+t+oim9XN8QAIH4OFQRrDRwa/1eQb8K+LEA
a0fZiNPZbIr7YMAAbLFSJtAEH0uJH9dZrjH0oJsEEHct7x/UIdhk8JNmXYK540Ra
LyGq2RmiQ86fzeU/P41a/5BnWmliNdOZgh65OUUHOhT8Biv9AR+/D5O7tUVGt/cY
jCdkrmYFjOWwemPOC2hWoAXY5GsrMmu0HWL7bGXMUPdsvf95QVkikrYxUcadoQwQ
9Co9WHCir7Y0C8BZqOKfde9tPP4+cXsyyMsEW/jFNXyyBXUybs6X3ppyQLu1MJI1
J4lGwwVTRM6mw+tygKkoqsAxb12j2waezSF1pWBGDRQ1IDsYSfCAf3hhJa4gIs9d
84/shG5schnvkhTDCwNMgidOF8mwBZ9KVB4fKDS2Uy1EoocG2EX/Y27MZS2H3Xmb
sJzXa76TrkyVPzWy1rELEPMx1ezdGSq3VpymXJ/v7y5prBb1g8I1wnbOH2jzIPTU
mnq0a+v5/zaB/1sETYdvUTR09b/EtUUDt6hXsie1p9QWd8qO1GaHScUBCCE8yqvN
0cJs0waK+61Pzeufp2wYKcZVfe7ad6siurI0oqk4Y9YDTAHnuku+MoDYkC7Jc+82
lslZ0NIYhicGTqVdcG9V9q2LRT5P9mY5xLEtzPdB/HLsQULexwWOiwk3kjssmSsz
SRFnCtZoekI1F2nOGmqU
=0b0f
-----END PGP SIGNATURE-----

--PBu/a+gn9/ndsyD5--
