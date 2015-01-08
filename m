Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbbAHLmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:42:03 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:37418 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbAHLmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:42:00 -0500
Date: Thu, 8 Jan 2015 12:41:54 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Vince Hsu <vinceh@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        swarren@wwwdotorg.org, gnurou@gmail.com, bskeggs@redhat.com,
        martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150108114153.GL1987@ulmo.nvidia.com>
References: <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
 <1419426990.2179.7.camel@lynxeye.de>
 <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com>
 <54AD0F37.5080609@nvidia.com>
 <20150107141254.GS10073@tbergstrom-lnx.Nvidia.com>
 <20150107141938.GA7392@nvidia.com>
 <20150107151206.GG1621@ulmo>
 <20150108093205.GV10073@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y+Z5jE7Arku/2GrR"
Content-Disposition: inline
In-Reply-To: <20150108093205.GV10073@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y+Z5jE7Arku/2GrR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2015 at 11:32:06AM +0200, Peter De Schrijver wrote:
> > > And specify the dependencies between domains in DT?
> >=20
> > I think the dependencies could be in the driver. Of course the power
> > domains are per-SoC data, so really shouldn't be in the DTS either (the
> > data is all implied by the compatible value) but there's no good way to
> > get at the clocks and resets without DT, so I think that's a reasonable
> > trade-off.
> >=20
> > It seems to me like there are only two dependencies:
> >=20
> > 	DIS and DISB depend on SOR
> > 	VE depends on DIS
> >=20
> > That's according to 5.6.6 "Programming Guide for Power Gating and
> > Ungating" of the Tegra K1 TRM. It also seems like a bunch of modules are
> > part of seemingly unrelated domains. Especially SOR seems to cover a
> > large range of modules (MIPI-CAL, DPAUX, SOR, HDMI, DSI, DSIB and
> > HDA2HDMI).
> >=20
> > Given that we may want to more fine-grainedly control clocks to save
> > power, don't we need to control clocks and resets within the drivers? I
> > think the runtime PM framework makes sure to call this in the right
> > order, so for suspend, the sequence would be:
> >=20
> > 	1) device->suspend
> > 	2) domain->suspend
> >=20
> > and for resume:
> >=20
> > 	1) domain->resume
> > 	2) device->resume
> >=20
> > But then we're back to square one, namely that the MC flush doesn't work
> > properly, since it needs to be implemented in domain->suspend. Does that
> > mean we can't clock-gate modules? In order to ensure a proper powergate
> > sequence, the domain code would need to clk_enable() the module clock to
> > make sure it stays on during the reset sequence. But if the domain code
> > has a reference to the clock, then the driver can't clock-gate the
> > module anymore by calling clk_disable().
> >=20
> > Am I missing something?
> >=20
>=20
> There's a difference between having a reference and actually enabling the
> clock.

My point was that as long as anyone was keeping a reference the clock
couldn't in fact be turned off.

> the domain powergate method will only be called when the clocks of
> all modules in the domain are off.

No, the power domain will be disabled when all devices in the domain are
idle.

> So the powergate method can then turn them on again, do the module
> resets and client flushes and then disable them again. Same for
> ungate. So I don't see a problem here?

I think that could work, but we'd need to make sure that drivers that
use runtime PM and are connected to a power domain enable clocks only
after taking a runtime PM reference and disable the clocks before they
release that reference.

So to simplify things, maybe all clock handling for drivers should be
moved into runtime PM operations, and whenever the driver needs the
clock enabled it takes a runtime PM reference. That would ensure that
clocks aren't accidentally left on.

Thierry

--Y+Z5jE7Arku/2GrR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrm0BAAoJEN0jrNd/PrOhxTYP+gKxlkbgHFdzTVIsgFPY1His
btzOMfADMd/h4tzIxnsgjIFghK15I47GAWJVcKT1xp8xF8vr+QwL0yk43eTa8g6k
Y2UaDK/K/zSMJxaJXCu4OktzYhfrw7EAs0Jsv2xJ7A7Kr5RVLDJW3zVnD5L563Jf
K651AdtS3MWS13yd4FASbp/vOEqVYHzo6DvSaknOV32mVt2NmPS/Oo2OHGcwtvQO
TnAbECPpz5RZz95+dXZ0WL7ljaNsaMXydIe4vHtlp0cyI2sRCmcG9dG/5UjXWFah
ZcIu4UDePGdD/9fPQNSf37/KMzqbRHhXVHc6t52HXUjWsyc8n/hOmBuIdc+PsW4d
C3VxKgibJncyKnVdDBrqhcXqZkdW6KXGvzLlOf//TEEQVTqOY4XeqE7B/wza1kV1
s/KiGPz/d+DQacYKVc0qm2hvMw1AQmXGCjiQFPXKSAZEcVUiMB/KAwc9G1VoUiOa
1NDjM2J6BsQLv0hwUXMr60jSM/Yxi2Qqa3tZkB7K9gIYy4I683cwNnSx6k2g3SZb
LAharGVbyWbHiuhROXYWJObRIBNwsuQrScDegn2j1o9oA4Ujo7pibTtCkv8ZbDNz
JlmmJcAaQt5fmlQoYMgGuZTUUC39/Yq+9VdgdHaHd9FqBar49UNYDI8YXjmqEa25
LowEYpErJOQCM3YQyzc1
=gZD8
-----END PGP SIGNATURE-----

--Y+Z5jE7Arku/2GrR--
