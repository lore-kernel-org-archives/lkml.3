Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3JWSLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 14:11:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35066 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab3JWSLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 14:11:33 -0400
Date: Wed, 23 Oct 2013 13:11:15 -0500
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <matt.porter@linaro.org>
CC: Rob Herring <robherring2@gmail.com>, Matthijs Kooijman <matthijs@stdin.nl>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Does PHY UTMI data width belong to DWC2 or PHY binding?
Message-ID: <20131023181115.GJ25954@gimli>
Reply-To: <balbi@ti.com>
References: <20131018141221.GH2721@beef>
 <5264F37E.9060307@ti.com>
 <20131022104829.GF15425@login.drsnuggles.stderr.nl>
 <20131022112520.GE29341@beef>
 <5266F06C.2080701@gmail.com>
 <20131023144242.GI29341@beef>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HTLCc13+3hfAZ6SL"
Content-Disposition: inline
In-Reply-To: <20131023144242.GI29341@beef>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HTLCc13+3hfAZ6SL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 23, 2013 at 10:42:42AM -0400, Matt Porter wrote:
> On Tue, Oct 22, 2013 at 04:38:52PM -0500, Rob Herring wrote:
> > On 10/22/2013 06:25 AM, Matt Porter wrote:
> > > On Tue, Oct 22, 2013 at 12:48:29PM +0200, Matthijs Kooijman wrote:
> > >> Hi Kishon,
> > >>
> > >> On Mon, Oct 21, 2013 at 02:57:26PM +0530, Kishon Vijay Abraham I wro=
te:
> > >>> I think it makes sense to keep the data width property in the dwc2 =
node itself.
> > >>> I mean it describes how the dwc2 IP is configured in that particula=
r SoC (given
> > >>> that it can be either <8> or <16>).
> > >> If I'm reading the RT3052 datasheet correctly (GHWCFG4 register), th=
e IP
> > >> can be configured for 8, 16 or 8 _and_ 16. In the latter case, the "8
> > >> and 16 supported" would make sense as a property of dwc2 (though this
> > >> value should be autodetectable through GHWCFG4), while the actual 8 =
or
> > >> 16 supported by the PHY would make sense as property of a phy.
> > >=20
> > > There would be no value in adding a property for an already detectable
> > > value to dwc2's binding. To be honest, it's pretty much useless
> > > information due to the existence of the "8 and 16" option.
> > >=20
> > >> Note sure if this is really useful in practice as well, or if just
> > >> setting the actual width to use on dwc2 makes more sense...
> > >=20
> > > The GHWCFG4 information itself is not useful in practice, as described
> > > in the original thread: https://lkml.org/lkml/2013/10/10/477
> > >=20
> > > It's certainly useful in practice to have this width property in eith=
er
> > > the dwc2 or the phy binding. One can make a case for either. As I
> > > mentioned in the original post, if we put it in the phy binding we'll=
 be
> > > updating the generic phy binding. We'll then need an api added into t=
he
> > > generic phy framework to fetch the width of a phy.
> > >=20
> > > Both cases are doable and trivial, we just need the canonical decision
> > > from a DT maintainer as to where the property belongs. Given that they
> > > are in ARM ksummit, I'm not expecting to hear anything right this
> > > moment. :)
> >=20
> > The host can support both, so it is not a property of the host and is a
> > property of the phy. It is no different than what mode a SPI slave
> > requires or whether an i2c slave supports 8 or 10-bit addressing. Those
> > examples are all 1 to many rather than 1 to 1 where it doesn't really
> > matter, but the same logic applies.
>=20
> Makes good sense, thanks.
>=20
> In this case, given the PHY ownership of width, we can completely avoid
> any DT properties. The generic phy compliant BCM Kona phy driver can
> report via the generic phy framework that it is 8-bit wide. There's no
> support for this type of thing now but it's pretty trivial to add.
>=20
> I went ahead and did a quick proof-of-concept that adds a free-form
> phy attributes struct for the generic phy. Given that generic phys can
> be for any transmission technology this could be filled with a jumble
> unrelated and often unpopulated attributes over time. In any case, the
> below patch allows the phy provider to choose to specify utmi_width and
> a controller driver that cares can use phy_get_attrs() to fetch the
> optional phy attributes and use the utmi_width field if applicable.
>=20
> Kishon: I'll start a separate thread to discuss what approach you'd like
> to see in the generic phy framework to manage this.
>=20
> -Matt
>=20
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index 6d72269..b763d7b 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -38,6 +38,14 @@ struct phy_ops {
>  };
>=20
>  /**
> + * struct phy_attrs - represents phy attributes
> + * @utmi_width: Data path width implemented by UTMI PHY
> + */
> +struct phy_attrs {
> +	int			utmi_width;

this is supposed to be a generic PHY layer and as such, it shouldn't
know about USB details such as the UTMI bus. How about calling bus_width
just to make it more generic ? Then it would work for UTMI, PIPE3, ULPI,
SLPI (did that even fly ?) or any other PHY <-> link interconnect.

--=20
balbi

--HTLCc13+3hfAZ6SL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSaBFCAAoJEIaOsuA1yqRE+c8P/A43PcEb9PNsjUpJKcrZv5BK
zJ+xVI36dOw7DgZwNwfpglR/K6gQfQ3OMH71+YKvXDXq73gpVb7XAg/YIrqIQrL+
4WxHtQ0o1ffTsJAgLwi5awkytyh7P7AZWQuP6eyaBv2sCZJCnHUFd6tAG7A3WUQf
6b0lVgwMJhgEsvxYrLNO5WN9m42pEtxiTfBLVjjfN2j3+Bqjc3qMimPOsRXOU71R
Wrof9bDPYBFNx0rUbVQ7ldpL1LxO14h9c76slLjm0vnkTa3aw9iV9UfDsltiyxB/
Pv8MVs7lJZewUeqLuyIolV1dhGkPzzgMQxSVt1A8XvvTa32joNpfTIbkIHAKdljH
oLWSJDJTeWNTk+jvcWNSj5JCq0kPllc6rwjiQVgkFwuE91lPDl+3unoB2Hb+3ulX
pt8IYwpHvXI279jcxzsHeso5vl77gRUM9AFfUzkTHDrqHoyTBVEkUsWXSiYmFM+Y
JnjsBUpBJlnzhghlplQW5ZFUska0w5iebzbCAAEr9UsC+Ub7LIoRKpu/IKh+qxIY
Gd/hqpYGhDCPF9+VJoCgJYP2Z5uR9JtNVYOi/FrwMPYjTg7Tb8eBeFL9NIDBpZlw
eE2ZMTr2/81Wh6nYZ7pRsuzVRO0BgfktfNJf0C5vxlFnb3fbmlkREMPiC/Y8cnhA
cw5Y1xQ9TerwPShzFtve
=z8HK
-----END PGP SIGNATURE-----

--HTLCc13+3hfAZ6SL--
