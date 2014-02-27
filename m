Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaB0Km3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:42:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58612 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaB0Km0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:42:26 -0500
Message-ID: <530F1673.2070609@ti.com>
Date: Thu, 27 Feb 2014 12:41:55 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>			 <1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>			 <530DE8A9.9050809@ti.com>		 <1393426623.3248.70.camel@paszta.hi.pengutronix.de>		 <530DFF4C.8080807@ti.com>	 <1393429676.3248.110.camel@paszta.hi.pengutronix.de>	 <530EF294.7070801@ti.com> <1393498356.4507.32.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1393498356.4507.32.camel@paszta.hi.pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="WFA9x1L7gj9wb4VBljvqxw4H05VShFGIN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WFA9x1L7gj9wb4VBljvqxw4H05VShFGIN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 27/02/14 12:52, Philipp Zabel wrote:

> This is a bit verbose, and if your output port is on an encoder device
> with multiple inputs, the correct port number would become a bit
> unintuitive. For example, we'd have to use port@4 as the output encoder=

> units that have a 4-port input multiplexer and port@1 for those that
> don't.

Hmm, sorry, I don't follow...

The port numbers should be fixed for a particular device. If the device
has 4 input ports, the output port would always be port@4, no matter how
many of the input ports are actually used.

I don't have anything against having the ports described in the SoC
dtsi. But I do think it may make it a bit unclear that the ports are
from the same device, and share things like pinmuxing. Both approaches
should work fine, afaics.

However, if, instead, we could have the pinmuxing and other relevant
information in the port or endpoint nodes, making the ports independent
of each other and of the device behind them, I argument above would
disappear.

Also, while I'm all for making the dts files clear, I do think the one
writing the dts still needs to go carefully through the binding docs.
Say, a device may need a gpio list with a bunch of gpios. The developer
just needs to read the docs and know that gpio #3 on the list is GPIO_XYZ=
=2E

So I don't see it as a major problem that the board developer needs to
know that port@1 on OMAP3's DSS is SDI output.

>> Here I guess I could have:
>>
>> &dss {
>> 	status =3D "ok";
>>
>> 	pinctrl-names =3D "default";
>> 	pinctrl-0 =3D <&dss_sdi_pins>;
>>
>> 	vdds_sdi-supply =3D <&vaux1>;
>> };
>=20
> What is supplied by this regulator. Is it the PHY?

Yes.

>> Actually, somewhat aside the subject, I'd like to have the pinctrl and=

>> maybe regulator supply also per endpoint, but I didn't see how that
>> would be possible with the current framework. If a board would need to=

>> endpoints for the same port, most likely it would also need to differe=
nt
>> sets of pinctrls.
>=20
> I have a usecase for this the other way around. The i.MX6 DISP0 paralle=
l
> display pads can be connected to two different display controllers via
> multiplexers in the pin control block.
>=20
> parallel-display {
> 	compatible =3D "fsl,imx-parallel-display";
> 	#address-cells =3D <1>;
> 	#size-cells =3D <0>;
>=20
> 	port@0 {
> 		endpoint {
> 			remote-endpoint =3D <&ipu1_di0>;
> 		};
> 	};
>=20
> 	port@1 {
> 		endpoint {
> 			remote-endpoint =3D <&ipu2_di0>;
> 		};
> 	};
>=20
> 	disp0: port@2 {
> 		endpoint {
> 			pinctrl-names =3D "0", "1";
> 			pinctrl-0 =3D <&pinctrl_disp0_ipu1>;
> 			pinctrl-1 =3D <&pinctrl_disp0_ipu2>;
> 			remote-endpoint =3D <&lcd_in>;
> 		};
> 	}
> };
>=20
> Here, depending on the active input port, the corresponding pin control=

> on the output port could be set. This is probably quite driver specific=
,
> so I don't see yet how the framework should help with this. In any case=
,
> maybe this is a bit out of scope for the generic graph bindings.

Hmm, why wouldn't you have the pinctrl definitions in the ports 0 and 1,
then, if it's about selecting the active input pins?

I think the pinctrl framework could offer ways to have pinctrl
definitions anywhere in the DT structure. It'd be up to the driver to
point to the pinctrl in the DT, ask the framework to parse them, and
eventually enable/disable the pins.

But yes, it's a bit out of scope =3D).

 Tomi



--WFA9x1L7gj9wb4VBljvqxw4H05VShFGIN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTDxZzAAoJEPo9qoy8lh71R34P/1wI9kUf/LSqdXaqIuTtdg4d
ekGrUnMSNGciQ5eSUyoNrJbKOtJAmI2cDIZBJ62tVn5nEMibTTsj/M41+icQMNLa
6o8xqmSXotShg7xAGNm8DdtFR2LcChVLt4WwBVjog9JRA23KroDZAz2zH1XnRx8o
oDk+JOje0GdaSx11NG4W0Xs9eLZN424p0AydzGSVg/dxQ4WdC1YBry5WKdRnH3Ug
+JcoCaSwtMMJo0pRsQjnA1QHakRqmhUqKfxhfRtn96qKtSyLTVk09epvXMb5bSSr
Wu+4ofJqEZ+ZIOZWPIVH6GjmO5eTn1ni/bbtlTeWaq8Qz7kVTOjZKgtSCCrc0S2r
iGe61YsFac3NWEU5nCUtOJL9uQdivRXaASl64ckVllMNboyJrPUISdbYbcaPQl4O
0drko5SlGG7cFKIUehVOjrqpC6gbXRuHIC2WD2TBXhXH4G0l9z/jVf353ovFetzk
VYvey7vPkCnoDG4y8oS9PoPN8fsorSiy5eGubel1tCqOYKEfUP+dHKFqBKhk/okI
TiohJbsxjwQMwM7U4EgPthhPniYfsbrZBib2Uf5AjhMZEMqGQYI4hqbUcFIXPKG4
iB0IaaqiU33aYkDlgrcO/RvvJVSufD18dRzjcH+Q67DsnllO7goUgPIdrainyZQx
gPsWY9dXN/IvRp5drBnM
=qDlF
-----END PGP SIGNATURE-----

--WFA9x1L7gj9wb4VBljvqxw4H05VShFGIN--
