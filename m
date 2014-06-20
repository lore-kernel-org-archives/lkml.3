Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966990AbaFTW1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:27:19 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60849 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbaFTW1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:27:17 -0400
Date: Sat, 21 Jun 2014 00:27:13 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Ajit Pal <ajitpal.singh@st.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        Maxime COQUELIN <maxime.coquelin@st.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "srinivas.kandagatla@gmail.com" <srinivas.kandagatla@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 6/7] pwm: st: Add new driver for ST's PWM IP
Message-ID: <20140620222712.GB29400@mithrandir>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <1403103172-19856-6-git-send-email-lee.jones@linaro.org>
 <20140618231127.GF26514@mithrandir>
 <20140619084404.GA26560@lee--X1>
 <53A2F342.7030606@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Content-Disposition: inline
In-Reply-To: <53A2F342.7030606@st.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2014 at 07:57:14PM +0530, Ajit Pal wrote:
> On Thursday 19 June 2014 02:14 PM, Lee Jones wrote:
> >On Thu, 19 Jun 2014, Thierry Reding wrote:
> >>On Wed, Jun 18, 2014 at 03:52:51PM +0100, Lee Jones wrote:
[...]
> >>>+                   cdata->max_prescale + 1, sizeof(unsigned long),
> >>>+                   st_pwm_cmp_periods);
> >>>+   if (!found) {
> >>>+           dev_err(dev, "failed to find matching period\n");
> >>>+           return -EINVAL;
> >>>+   }
> >>>+
> >>>+   prescale =3D found - &pc->pwm_periods[0];
> >>
> >>This is somewhat unconventional. None of the other drivers precompute
> >>possible periods and I'm not convinced that it's an advantage. Setting
> >>the period (and configuring the PWM in general) is a fairly uncommon
> >>operation.
> >
> >Another one for Ajit I feel.
>=20
> For ST PWM IP, the PWM period is fixed to 256 local clock pulses.There is=
 no
> register interface to select PWM periods.To change the period we have to
> change the prescaler.
> We precompute the possible periods, so as to avoid the calculations
> everytime the .config function is called. Based upon a matching period we
> then select the prescaler.
> Sorry but why do you think precomputing is not helpful ?

Mostly I dislike it here because it sticks out as nobody else is doing
it. Secondly I'm not convinced that it gives you much of a performance
gain since the computations aren't that involved and typically the
period isn't changed all that often.

Also computing the value directly in .config() makes the code much
easier to follow.

> >>>+static int st_pwm_enable(struct pwm_chip *chip, struct pwm_device *pw=
m)
> >>>+{
> >>>+   struct st_pwm_chip *pc =3D to_st_pwmchip(chip);
> >>>+   struct device *dev =3D pc->dev;
> >>>+   int ret;
> >>>+
> >>>+   ret =3D clk_enable(pc->clk);
> >>>+   if (ret)
> >>>+           return ret;
> >>>+
> >>>+   ret =3D regmap_field_write(pc->pwm_en, 1);
> >>>+   if (ret)
> >>>+           dev_err(dev, "%s,pwm_en write failed\n", __func__);
>=20
> >>
> >>This error message is somewhat cryptic, perhaps:
> >>
> >>       "failed to enable PWM"
> >
> >Agreed.  I also can't believe I missed that nasty __func__ too.
> >
> >>? Also what implications does this have on controllers with multiple
> >>channels?
> >
> >I believe this enables both channels, but I'm sure Ajit will correct
> >me if I'm wrong.
>=20
> Yes it enables all channels.Unfortunately we do not have the facility to
> enable/disable individual channels on the ST PWM IP.

That's bad. If you can't control them separately then there's no way you
can guarantee the semantics of the PWM framework.

> >>>+   dev_dbg(dev, "pwm counter :%u\n", val);
> >>>+
> >>>+   clk_disable(pc->clk);
> >>>+}
> >>>+
> >>>+static const struct pwm_ops st_pwm_ops =3D {
> >>>+   .config =3D st_pwm_config,
> >>>+   .enable =3D st_pwm_enable,
> >>>+   .disable =3D st_pwm_disable,
> >>>+   .owner =3D THIS_MODULE,
> >>>+};
> >>>+
> >>>+static int st_pwm_probe_dt(struct st_pwm_chip *pc)
> >>>+{
> >>>+   struct device *dev =3D pc->dev;
> >>>+   const struct reg_field *reg_fields;
> >>>+   struct device_node *np =3D dev->of_node;
> >>>+   struct st_pwm_compat_data *cdata =3D pc->cdata;
> >>>+   u32 num_chan;
> >>>+
> >>>+   of_property_read_u32(np, "st,pwm-num-chan", &num_chan);
> >>>+   if (num_chan)
> >>>+           cdata->num_chan =3D num_chan;
> >>
> >>I don't like this very much. What influences the number of channels? Is
> >>it that specific SoC revisions have one and others have two?
> >
> >Ajit?
> >
> Depends on the board type on which the SoC is used.

I don't understand. How can the board influence the number of PWM
channels that the SoC supports? It does make sense for a board to define
how many of them are actually *used*, but that's nothing that DT should
contain nor that the driver should care about. The driver (and DT for
that matter) should expose the hardware block's full capabilities. The
use-case is what should determine what's used and what not.

Thierry

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTpLVAAAoJEN0jrNd/PrOhxo8P/2NPA4B7hscu4BkkbyMkVUYu
lZlU4XCZx5r2SMg6i+GKHrJPr/P51g3g5t7B7mTmSTz42HIWc+zHheaYqMr9ABU+
jR27jQlt697tLX7IeRsKAAIJkH2OR8LsSwy00NxpdPBufQjM1slWBCgzymKcTd4O
JE2GO0CIerUl375GX/CR8lnjHXe3LWfQ5F7OYYlRi8N1EowV7CjvWKqwDicBa+ii
vA4ZIGkhnrHl4avRTDAOLF85pg5cf5sMLrm5Coe+MoHucoHVvD/Gz9U3rrUdETK9
r3n59o1noDifzxPd9epznPjS4uas2ROtoQuUfEzIxnGOdNm6UtI5N6nhksivtD/d
DGae3rgDR9DgAsqTgBiAXL32IwFTGXzK5LRvzVQIHEjtL12Eivgd/zZYnlWHsJGK
2tcwRFaKuuMY8dqVPnaBGi3LMOFYoDq01Gp+GUMvea6xrry0R3Ph5ArCDKhcW0OV
dB6Osf1y9zemKuZaLb5t/AjkFOu+caf1cfZXRepIvkcOxMHQsa8yR6em/tnX6vYn
implY79FOS2yOZk55OEQ20nQBlGp93jXon66qm6QZ5Tbyqnag0FKPiI20aHRVZJm
BRRW3X87vmKbukj7H4KPG9j7p4R0x8UbLGyARBfUWyRCtlXtDw6SAB0BmpIFL8EC
vBQeyN6E7slGtf7GbvZ7
=3bAs
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
