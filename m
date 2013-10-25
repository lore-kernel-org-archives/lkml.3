Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3JYHeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 03:34:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3JYHd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 03:33:59 -0400
Date: Fri, 25 Oct 2013 18:33:45 +1100
From: NeilBrown <neilb@suse.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: Any news on Runtime Interpreted Power Sequences
Message-ID: <20131025183345.2b963e13@notabene.brown>
In-Reply-To: <526A0E71.100@nvidia.com>
References: <20131025112224.6e5265e6@notabene.brown>
	<526A0E71.100@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uqZTWPL9UeMa1zqIdcb1xm3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uqZTWPL9UeMa1zqIdcb1xm3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Oct 2013 15:23:45 +0900 Alex Courbot <acourbot@nvidia.com> wrote:

> Hi Neil,
>=20
> On 10/25/2013 09:22 AM, NeilBrown wrote:
> >   I'm wondering if there was any news on the Runtime Interpreted Power
> > Sequences?
> > The most recent news I can find is
> >    https://lkml.org/lkml/2013/4/27/73
> > where you say they might be ready for 3.11.  Clearly that didn't work
> > (predictions being hard, especially about the future).
> >
> > I'm really keen to see them turning into a reality and I gather others =
are
> > too. So ... can we hope?
>=20
> A prerequisite of power sequences was to merge the gpiod interface, and=20
> this is finally happening. It took much longer than I wanted, sorry=20
> about that.
>=20
> Logically speaking nothing should now stand in the way of a new version=20
> of the power sequences. Expected maybe my own skepticism about them.
>=20
> The first version of the power seqs is mainly the result of my=20
> misunderstanding of the device tree. Reconsidering it now, if we strip=20
> the DT support away power seqs would just become a simplified way to=20
> describe how to power a device up and down. In other words, it would be=20
> another way to express what can be expressed with C code and would not=20
> bring any additional flexibility that DT-described power seqs would have=
=20
> (and I say this totally convinced now that power sequences in the device=
=20
> tree were a bad idea).
>=20
> The advantage I could see is that using power sequences we could get rid=
=20
> of the cumbersome and mistake-prone error checking code which is=20
> basically the same for most devices. You would just need to describe=20
> what you want to activate, and in which order, and the power seqs=20
> framework would catch and report any error.
>=20
> I'm not sure if this is a sufficient reason to introduce another=20
> framework into the kernel, but if this is deemed a good reason by more=20
> experienced people then I'm ok to give it a shot. If you have other=20
> motivations for this, please also state them so I can get the whole=20
> picture. Maybe I just need to be a little bit more motivated about this=20
> idea myself. :)
>=20
> Thanks,
> Alex.

Hmmm... I'm not encouraged that you don't see them as belonging in
device-tree, as that is exactly where I want them.

Let me explain what I'm thinking.

I have two (or three) use-cases on my board ("GTA04" replacement motherboard
for Openmoko Phone).

Firstly the wifi chip is very fussy about being reset properly before being
accessed.  However it shares the same power regulator as the bluetooth chip.
So if the bluetooth is in use when you "ifconfig down; ifconfig up" the
wifi, it won't get powered down, so it won't get reset, so it won't work.

What I need to do is to tell the 'mmc/sdio' driver that when it wants to
power-on the wifi, it must
   pull a reset-gpio low
   turn-on the regulator (which might already be on)
   pull the reset-gpio high again

I currently have that hacked into the omap-hsmmc driver but I don't think t=
he
code really belongs there.
I would much rather that the omap-hsmmc could be given a 'RIPS' instead
of (or as well as) the regulator and be told to just turn that RIPS on or o=
ff.
The RIPS would do the appropriate timed fiddling with GPIO and Regulator.
The only place I can think of the describe the RIPS would be in device-tree.

Secondly I have two devices that are behind serial ports - a GPS and the
bluetooth.
It makes perfect sense to tie the  power-on/off of these to the serial-port
concept of "DTR".  The omap-serial doesn't have a physical DTR, but is can =
be
configured with a GPIO to use as the DTR (it gets asserted on 'open' and
de-asserted on 'close').

I currently have a "gpio-to-regulator" converting driver plugged between the
serial port and the blue-tooth's regulator.  When I open the serial port for
bluetooth it asserts the gpio line which is routed through gpiolib to my
driver which enables the appropriate regulator.  I have something similar f=
or
the GPS.

I think the gpio-to-regulator driver is a kludge.  I would much rather tell
the omap-serial to activate/de-activate a RIPS as the DTR action.  That RIPS
could then control GPIO for a "real" dtr line, or control a regulator to
support my bluetooth.

For the GPS, power on/off is really messy.  There is a toggle connected to a
GPIO so you need to know what the current state is before you can know how =
to
"turn off".  So you need to either plug into the serial driver and watch for
input, or use pinctrl to grab the RX pin and treat it like a GPIO.
This is admittedly quite horrible and it makes sense to have a dedicated
driver for it, but as the purpose of the driver would be to power
something up or down it would be nice if the interface it presented was a
power-up-down interface which is exactly what RIPS promised.


I imagine a device-tree interface a bit like GPIO but with more details.
We would have #defines for=20
#define RIPS_REG_ON <0>,
#define RIPS_REG_OFF <1>,
#define RIPS_GPIO_ASSERT <2>,
#define RIPS_GPIO_DEASSERT <3>,
#define RIPS_DELAY <4>,
#define RIPS_NATIVE_ON <5>,
#define RIPS_NATIVE_OFF <6>,

Then

 rips-on =3D RIPS_GPIO_ASSERT  "wifi-reset",
           RIPS_DELAY         <10>,
           RIPS_REG_ON       "wifi",
           RIPS_DELAY         <10>,
           RIPS_GPIO_DEASSERT "wifi-reset";
 wifi-reset-gpio =3D <&gpio1 0 GPIO_ACTIVE_HIGH>;
 wifi-supply =3D <&vaux4>;

would would power-on my wifi-chip.  It's probably a bit ugly, but it is
simple and does follow an established pattern to some extent.

I expect some people will hate it and I won't be able to argue coherently
with them, so please pay more attention to my proposed use-case than to my
concrete example.

Thanks,
NeilBrown

--Sig_/uqZTWPL9UeMa1zqIdcb1xm3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmoe2jnsnt1WYoG5AQLA8A/+MII6iC4sVwMzP9W6cP6FYcCeW8W/VZFe
DASvgkqcvuE2+JSIFG3zVkiqWoWiujRe5Q8qkpzU4EMEstsEgigY0/H/1z8NVX7z
EfihJyfP541N/oqD7NJlSXQVU/vtXbITEpXE22ULpTCKe9K4NnAij/J/t00OfDul
CbdR3iJF5hu9IjJp27eFoZpP1RMIprGhWTxJSTdtKGlVwyo52Lrq8nlXOzSrhJzz
1jUOkvcYc/HjHqVAXQsg0tm+tqAtzypBRI6nQWY46OwBK2ng0197Dl9ddLzABIS+
g7BqQn9Qlyd6t8jgeD9FsxYma5PEhTxW62XVTIMS2MLF1jQN3jyFcwJv5iJrgzZH
LNbwe2jkG8P/7doiMmyqAI02wUhsurFOfT1GqHs1QHiCt+M1X5GwLz1LX9Vx4I/L
8jRnK2t46G6M/lKjxRFsRfridwEpRrBN2YXE9T6aM3qn+ywmOKJEAdKEXlO2Txe5
G0uwhmakxh7FXYodnUn1P0QVoDKPC80Jas6POqrF0OGZZuDK2xY4TGkjXQIYWyrc
YSIgcmBd1oCxAdyNeLn2F3ofdSQSRkAxDlaOhrcfzIx2Pinb2cajCa9SegkmYK7y
xnJ8vfyICDvaf/MTpfivVUCieTzuz6L8rGRtB7JsSrGPvzao+XN67eJlsqbQWqyj
YW++z2vCmU8=
=RyAQ
-----END PGP SIGNATURE-----

--Sig_/uqZTWPL9UeMa1zqIdcb1xm3--
