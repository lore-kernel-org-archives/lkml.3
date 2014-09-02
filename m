Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaIBL4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:56:13 -0400
Received: from sauhun.de ([89.238.76.85]:54181 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbaIBL4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:56:11 -0400
Date: Tue, 2 Sep 2014 13:56:15 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>, ldewangan@nvidia.com,
        thierry.reding@gmail.com, pdeschrijver@nvidia.com,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i2c-tegra: Move clk_prepare/clk_set_rate to probe
Message-ID: <20140902115615.GH1266@katana>
References: <1408096034-17270-1-git-send-email-mperttunen@nvidia.com>
 <53EE32C7.6000500@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1xGqyAVbSpAWs5A"
Content-Disposition: inline
In-Reply-To: <53EE32C7.6000500@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1xGqyAVbSpAWs5A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2014 at 10:18:15AM -0600, Stephen Warren wrote:
> On 08/15/2014 03:47 AM, Mikko Perttunen wrote:
> >Currently the i2c-tegra bus driver prepares, enables
> >and set_rates its clocks separately for each transfer.
> >This causes locking problems when doing I2C transfers
> >from clock notifiers; see
> >http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/268653.h=
tml
> >
> >This patch moves clk_prepare/unprepare and clk_set_rate calls to
> >the probe function, leaving only clk_enable/disable to be
> >done on each transfer. This solves the locking issue.
>=20
> >diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-teg=
ra.c
>=20
> >@@ -380,34 +380,33 @@ static inline int tegra_i2c_clock_enable(struct te=
gra_i2c_dev *i2c_dev)
> >  {
> >  	int ret;
> >  	if (!i2c_dev->hw->has_single_clk_source) {
> >-		ret =3D clk_prepare_enable(i2c_dev->fast_clk);
> >+		ret =3D clk_enable(i2c_dev->fast_clk);
>=20
> Here, both the prepare and enable wrap just the I2C transfer, ...
>=20
> >@@ -428,9 +427,6 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_=
dev)
> >  	i2c_writel(i2c_dev, val, I2C_CNFG);
> >  	i2c_writel(i2c_dev, 0, I2C_INT_MASK);
> >
> >-	clk_multiplier *=3D (i2c_dev->hw->clk_divisor_std_fast_mode + 1);
> >-	clk_set_rate(i2c_dev->div_clk, i2c_dev->bus_clk_rate * clk_multiplier);
>=20
> ... whereas the rate is set up when the controller is initialized, i.e. m=
uch
> earlier.
>=20
> >@@ -777,17 +774,39 @@ static int tegra_i2c_probe(struct platform_device =
*pdev)
>=20
> >+	if (!i2c_dev->hw->has_single_clk_source) {
> >+		ret =3D clk_prepare(i2c_dev->fast_clk);
> >+		if (ret < 0) {
> >+			dev_err(i2c_dev->dev, "Clock prepare failed %d\n", ret);
> >+			return ret;
> >+		}
> >+	}
> >+
> >+	ret =3D clk_prepare(i2c_dev->div_clk);
> >+	if (ret < 0) {
> >+		dev_err(i2c_dev->dev, "Clock prepare failed %d\n", ret);
> >+		goto unprepare_fast_clk;
> >+	}
> >+
> >+	clk_multiplier *=3D (i2c_dev->hw->clk_divisor_std_fast_mode + 1);
> >+	ret =3D clk_set_rate(i2c_dev->div_clk,
> >+			   i2c_dev->bus_clk_rate * clk_multiplier);
> >+	if (ret) {
> >+		dev_err(i2c_dev->dev, "Clock rate change failed %d\n", ret);
> >+		goto unprepare_div_clk;
> >+	}
>=20
> However, the new code sets the clock rate after the clock is prepared. I
> think the rate should be set first, then the clock prepared. While this
> likely doesn't apply to the Tegra clock controller, prepare() is allowed =
to
> enable the clock if enable() can't be implemented in an atomic fashion (in
> which case enable/disable would be no-ops), and we should make sure that =
the
> driver correctly configures the clock before potentially enabling it.
>=20
> I'm not sure if a similar change to our SPI drivers is possible; after al=
l,
> the SPI transfer rate can vary per message, so if clk_set_rate() acquires=
 a
> lock, it seems there's no way to avoid the issue there. Luckily, we don't
> have any SPI-based chips that do anything related to clocks on any of our
> current boards...
>=20
> Aside from this issue, the patch looks fine to me.

May I count this as an Ack?


--X1xGqyAVbSpAWs5A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBbBfAAoJEBQN5MwUoCm2NkgP/337zgF++rkar6BR6f2b+q37
x1pFVkiwaJVS52jFuCeTwqTilZmNgH5aAFld0pyXDq8kw5+opWhOcZfq/2ZWdspD
OTTiWsI8cSuIBXASqmQhYpDjljf9RxKeeE0Sq49zMOpiyigCFnvIUJvuOUKkes/5
2Idi5N/S0uimY6ofbbAV5Te6m9ON/+M8WwGPa/6Ob/ZjB9x6gXuCmPy6QM1gEmtT
qKFdMNHZy6z9tFDHMrZP3BxLVTpYtOgtplg1UBjUy2APs1wHECU0iKtXmOMqYQVq
6mncDGTFNT91cnECa8Epp077Gy9cQrp8NRfBBNxiMCDC3ov5k7OlNYR+dmLFvD5g
3YWofTDcLYBvcCu6ygllzzjV8qj/re6g2Q3KeP6mwqh0U6veqd6x1zIiNfsi+Viq
Qi5vAoYbBx0yIV9f6+6uLiz5aj9z4y6W8fq6qKmHtOgfQR6fpW0i/iBlNE0/n4UQ
FlU9WO5/JLfTWat1bhPZ7JNpk5djTKOPAMG1vjngOEGU+3hQXWg26PABybfs7HU2
Etz7+u88uJDAWU95Wj40Y7/BOJb3BkPYFclBIQJcww8Rte3/SlMR47hYMvCr2YlR
BjgLS2HbnAHwWNTbKGT0s6XE/tvGMiHv/+eT4/mZGAmouRDqjFoUk4OCQXoc+yGn
yAow6dO94wkm3Nm48d2k
=hG72
-----END PGP SIGNATURE-----

--X1xGqyAVbSpAWs5A--
