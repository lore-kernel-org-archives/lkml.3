Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3JAVQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:16:39 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51505 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3JAVQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:16:35 -0400
Date: Tue, 1 Oct 2013 23:14:49 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] pwm-backlight: Allow backlight to remain disabled
 on boot
Message-ID: <20131001211448.GE9201@ulmo.nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
 <1379972467-11243-11-git-send-email-treding@nvidia.com>
 <524B198B.3010609@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fWddYNRDgTk9wQGZ"
Content-Disposition: inline
In-Reply-To: <524B198B.3010609@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fWddYNRDgTk9wQGZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2013 at 12:50:51PM -0600, Stephen Warren wrote:
> On 09/23/2013 03:41 PM, Thierry Reding wrote:
> > The default for backlight devices is to be enabled immediately when
> > registering with the backlight core. This can be useful for setups that
> > use a simple framebuffer device and where the backlight cannot otherwise
> > be hooked up to the panel.
> >=20
> > However, when dealing with more complex setups, such as those of recent
> > ARM SoCs, this can be problematic. Since the backlight is usually setup
> > separately from the display controller, the probe order is not usually
> > deterministic. That can lead to situations where the backlight will be
> > powered up and the panel will show an uninitialized framebuffer.
> >=20
> > Furthermore, subsystems such as DRM have advanced functionality to set
> > the power mode of a panel. In order to allow such setups to power up the
> > panel at exactly the right moment, a way is needed to prevent the
> > backlight core from powering the backlight up automatically when it is
> > registered.
> >=20
> > This commit introduces a new boot_off field in the platform data (and
> > also implements getting the same information from device tree). When set
> > the initial backlight power mode will be set to "off".
>=20
> > diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-back=
light.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight=
=2Etxt
>=20
> > +  - backlight-boot-off: keep the backlight disabled on boot
>=20
> A few thoughts:
>=20
> 1) Does this property indicate that:
>=20
> a) The current state of the backlight at boot. In which case, this will
> need bootloader involvement to modify the value in the DT at boot time
> based on whether the bootloader turned on the backlight:-(

I was pretty much following the regulator bindings here. But the meaning
is different indeed, see below.

> b) That the driver should not turn on the backlight immediately? That
> seems to describe driver behaviour more than HW. Is it appropriate to
> put that into DT?

That's what it was supposed to mean. The idea is, and I mentioned that
in the commit message, that when wired up with a higher-level API such
as DRM, then usually that framework knows exactly when to enable the
backlight. Having the backlight enable itself on probe may cause the
panel to light up with no content or garbage.

> Your suggestion to make the backlight not turn on by default might be a
> better fix?

I think so too, but the problem in this case is that users of this
driver heretofore assumed that it would be turned on by default. I think
that's been common practice for all backlight drivers. Adding a property
to DT was supposed to be a way to keep backwards compatibility with any
existing users while at the same time allowing the backlight to be used
in a more "modern" system. I don't really have any other ideas how to
achieve this.

It is quite possible that the only reason why turning on the backlight
at probe time is the current default is because backlight_properties'
=2Epower field is by default initialized to 0, which turns out to be the
value of FB_BLANK_UNBLANK. That's been the source of quite a bit of
confusion (I could tell you stories of how people tried to convince me
that there must be a bug in the Linux kernel because writing a 0 to the
backlight's bl_power field in sysfs turns the backlight on instead of
off). The same is true for DPMS modes in DRM and X, where "on" has the
value 0.

Now there have been plans to overhaul the backlight subsystem for quite
some time. One of the goals was to decouple it from the FB subsystem,
which might help solve this to some degree. At the same time sysfs is an
ABI, so we can't just go and change it randomly. The same is true for
the default behaviour of enabling the backlight at boot. That can
equally be considered an ABI and changing it will cause the majority of
devices to regress, and that's not something that I look forward to
taking the blame for...

> 2) Should the driver instead attempt to read the current state of the
> GPIO output to determine whether the backlight is on? This may not be
> possible on all HW.
>=20
> 3) Doesn't the following code in probe() (added in a previous patch)
> need to be updated?
>=20
> > +	if (gpio_is_valid(pb->enable_gpio)) {
> > +		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
> > +			gpio_set_value(pb->enable_gpio, 0);
> > +		else
> > +			gpio_set_value(pb->enable_gpio, 1);
> > +	}
>=20
> ... That assumes that the backlight is on at boot, and hence presumably
> after this patch still always turns on the backlight, only to turn it
> off very quickly once the following code in this patch executes:
>=20
> (and perhaps we also need to avoid turning the backlight off then on if
> it was already on at boot)

Yes, that's a good point. Depending on the outcome of the above
discussion I'll update this to match the expectations.

Thierry

--fWddYNRDgTk9wQGZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSztIAAoJEN0jrNd/PrOhhfsQAJutgCBmvJS6g93vTvHcXeEN
k1L5m7g1R1NZpyrUUszyNB3qqls2tg7xkNsJxOGNNIiCB9PsDQbui0UKGQL6u1ZH
bWQqTOGdxZFVF/fAaHh5ci5I3BHBNER/IMlrnJE2DSY6IX5A4OAkwJNFjtm1dWgA
gPpkSXsX3kCGC6I5haS9EfrCaWI5jo916u0XIVzcugvEsQTf0LwPCjT2eWY7UCit
o1LW5oA+DKFUkytkJGqW2/TmDMuFZDoXs3m6OQZItxGIzNRMKAmemZM41krMWiwN
k1zO9zrJgpS0WYCgxRQQvUeG/tx6V3zzRzdsXuJAMLGdKOoqY33Wzb+rchPgBGcs
2IKQlkNhUhKIOlKICj2uRk9EIANUFfO2njLL+a9wdq80RmfiXbEpfTfjL+4xhGNb
c0y2plyrmmsAXjSHApS/uvQ/MtCq4m9Gqn663nmEf0jrxHhQf5LoJ/fllc3pMnH0
QG3lhs3wGC/JgSP344x74m5tSpK9SmT7qwx6VTVM+GjZeD44sQbBDgXm75eoby8P
KyYnvo8svX3RSdzN71cenSG+D6pCzmYpkCNS936jSWcrBdPpC//wMtYJBkC+vvr4
u0/Jp0n2X9RvVbctc5TLTENFekw+NyhWUOV9UGh6N/ZJQPJT8PBYoaLuLu+6+OLC
zq4SyexpkfPFOpf3Td5c
=1K0L
-----END PGP SIGNATURE-----

--fWddYNRDgTk9wQGZ--
