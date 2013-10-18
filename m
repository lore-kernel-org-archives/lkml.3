Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986Ab3JRGVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 02:21:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3JRGVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 02:21:13 -0400
Date: Fri, 18 Oct 2013 17:20:53 +1100
From: NeilBrown <neilb@suse.de>
To: Andreas Fenkart <afenkart@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Venkatraman S <svenkatr@ti.com>, Balaji T K <balajitk@ti.com>,
        zonque@gmail.com, devicetree-discuss@lists.ozlabs.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 3/4] mmc: omap_hsmmc: Remux pins to support SDIO
 interrupt on AM335x
Message-ID: <20131018172053.70cf2c2b@notabene.brown>
In-Reply-To: <1380971830-21492-4-git-send-email-afenkart@gmail.com>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
	<1380971830-21492-4-git-send-email-afenkart@gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.i2Ap0RDt8DcOydutI46yBm"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.i2Ap0RDt8DcOydutI46yBm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  5 Oct 2013 13:17:09 +0200 Andreas Fenkart <afenkart@gmail.com> wro=
te:

> The am335x can't detect pending cirq in PM runtime suspend.
> This patch reconfigures dat1 as a GPIO before going to suspend.
> SDIO interrupts are detected with the GPIO, while in runtime
> suspend, standard detection of the module block otherwise.
>=20
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
>=20
> diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Do=
cumentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> index 1136e6b..146f3ad 100644
> --- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> +++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> @@ -21,8 +21,11 @@ ti,non-removable: non-removable slot (like eMMC)
>  ti,needs-special-reset: Requires a special softreset sequence
>  ti,needs-special-hs-handling: HSMMC IP needs special setting for handlin=
g High Speed
>  ti,quirk-swakup-missing: SOC missing the swakeup line, will not detect
> -SDIO irq while in suspend. Fallback to polling. Affected chips are
> -am335x,
> +SDIO irq while in suspend. The workaround is to reconfigure the dat1 lin=
e as a
> +GPIO upon suspend. Beyond this option and the GPIO config, you also need=
 to set
> +named pinctrl states "default", "active" and "idle ", see example below.=
  The
> +MMC driver will then then toggle between default and idle during the run=
time
> +Affected chips are am335x,
> =20
>                              ------
>                              | PRCM |
> @@ -49,3 +52,24 @@ Example:
>  		vmmc-supply =3D <&vmmc>; /* phandle to regulator node */
>  		ti,non-removable;
>  	};
> +
> +[am335x with with gpio for sdio irq]
> +
> +	mmc1_cirq_pin: pinmux_cirq_pin {
> +		pinctrl-single,pins =3D <
> +			0x0f8 0x3f	/* MMC0_DAT1 as GPIO2_28 */
> +		>;
> +	};
> +
> +	mmc1: mmc@48060000 {
> +		ti,non-removable;
> +		bus-width =3D <4>;
> +		vmmc-supply =3D <&ldo2_reg>;
> +		vmmc_aux-supply =3D <&vmmc>;
> +	        ti,quirk-swakeup-missing;
> +		pinctrl-names =3D "default", "active", "idle";
> +		pinctrl-0 =3D <&mmc1_pins>;
> +		pinctrl-1 =3D <&mmc1_pins>;
> +		pinctrl-2 =3D <&mmc1_cirq_pin>;
> +		ti,cirq-gpio =3D <&gpio3 28 0>;
> +	};


hi,
 I've been trying to get SD irq to work on my  OMAP3 DM3730.
I seems to need the magic to catch interrupts while FCLK is off, as
the only way I can get it to work at the moment is to keep FCLK on.

I discovered your patch and tried it out, but it doesn't seem to work for m=
e.

I have a Libertas WIFI chip attached to the second mmc (which is sometimes
called mmc1, and sometimes mmc2 - very confusing!).
I added:
	mmc2_cirq_pin: pinmux_cirq_pin {
		pinctrl-single,pins =3D <
			0x012e (PIN_INPUT_PULLUP | MUX_MODE4)	/* MMC2_DAT1 as GPIO5_5 */
		>;
	};

and

&mmc2 {
	ti,quirk-swakeup-missing;
	pinctrl-names =3D "default", "active", "idle";
	pinctrl-0 =3D <&mmc2_pins>;
	pinctrl-1 =3D <&mmc2_pins>;
	pinctrl-2 =3D <&mmc2_cirq_pin>;
	ti,cirq-gpio =3D <&gpio5 5 0>; /* GPIO133 =3D 128+5 */
};

to my dts file but it doesn't make any apparent difference.

Any idea what I might be doing wrong?
(the base kernel I am applying patches to is from 8th Oct,
 commit 0e7a3ed04f0cd4311096d691888f88569310ee6c)

BTW,
 - with the default polling, I get about 1Mb/sec with iperf
 - with sd-irq enabled and FCLK kept on the whole time, I get 4Mb/sec
 - with sd-irq enable, FCLK kept on, and the 5ms polling also
   running, I get over 5Mb/sec!
Still much less than the 40Mb/sec that I would like to get...

Thanks,
NeilBrown

--Sig_/.i2Ap0RDt8DcOydutI46yBm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmDTRTnsnt1WYoG5AQJ53hAAsE2v2MrDYKDpBDpSIHQzhaZ4SE57Mzl3
SrGc536xSAy8Skxz1+9m/WkjOhzssF/q9LE6jJtYL8INa8Fg6c7izFtZm0yLBLbb
pgYxNvcYKbueAcT4RbcwTxnODJOw7VZL1/NrSRKfvKCx7FOyKv+UpRHGwFwgGfmP
e5ND7m8lYP3rk5LzZ8X8RQTCL5gVKOpD2UXdMAwWDalMedsbI5Z8tY8I+w242ASX
Ul+lsoJNeA/BckTKxJK9S/GxN76ZMbOFkf1O+oFAmeV+jmKx/mqg4mdkcGVulqEo
6HNn2vOv1weNj48Z/yoln6WXJL+x/1oLmnTjxlN78KKhW/eKBlEG0yuL4PSdeo2h
MTSXIIlGrD+4uzDAqypFAT8rpG1lvd5bOk4nNvIPDMUKjV/6fEDtArQWIOcwaxN1
LBNYs7kNw3IwR22t+o5oK+/1OFD0y+7gHGDY+NSS4YuxLdeb5RLkvjjT19SCFw6o
2pcpLKZFlbFVl3nk33z1l3NPR498DXvKBwD7BNjdxuV8JKWRGXRd5PzYS5hqZXnc
w44oxzeLxVPrPiiIB6G74EBBXWDk+0uhIqT0G9H2pMIETbCTGeOrjkmuRYA1zwXv
01bLWDT0CoYEHzMnPrn3J8i4wa5JW47xWcik5HNl3u0l9XjRYbAPzEgHiRdYhRLP
tEk2JyUl864=
=M33O
-----END PGP SIGNATURE-----

--Sig_/.i2Ap0RDt8DcOydutI46yBm--
