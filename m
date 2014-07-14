Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaGNLK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:10:28 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64899 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaGNLKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:10:21 -0400
Date: Mon, 14 Jul 2014 13:10:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
Message-ID: <20140714111007.GB31460@ulmo>
References: <1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
 <20140711145146.GA6523@ulmo>
 <53C00A57.5070102@kapsi.fi>
 <53C38D07.4030402@nvidia.com>
 <20140714081524.GI2081@ulmo>
 <53C39D98.9040802@nvidia.com>
 <20140714093136.GB9755@ulmo>
 <53C3A986.9050602@nvidia.com>
 <20140714102954.GD9870@ulmo>
 <53C3B6EC.9090904@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <53C3B6EC.9090904@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 01:54:36PM +0300, Mikko Perttunen wrote:
> On 14/07/14 13:29, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> > ...
> >>Yes, this sounds sensible. I'll make such a patch. I suppose having ano=
ther
> >>timings table in the MC node with just the rate and mc-burst-data would
> >>separate the concerns best. It occurs to me that we could also write the
> >>regs in the pre-rate change notifier, but this would turn the dependency
> >>around and would mean that the regs are not written when entering backup
> >>rates. The latter shouldn't be a problem but the reversed dependency wo=
uld,
> >>so I guess a custom function is the way to go, and we need to add at le=
ast
> >>one anyway.
> >
> >It sounds like maybe moving enough code and data into the MC driver to
> >handle frequency changes would be a good move. From the above it sounds
> >like all the MC driver needs to know is that a frequency change is about
> >to happen and what the new frequency is.
> >
> >In addition to exposing things like number of DRAM banks, etc.
> >
>=20
> Yes, so there are two ways to do this:
> 1) EMC calls tegra_mc_emem_update(freq) at the correct time
> 2) MC has an optional clock phandle to the EMC clock and registers a
> pre-change notifier.
>=20
> Both work, but the dependency is reversed. In both cases, the other driver
> is also optional. In the first case, the EMC driver can give a warning if
> the call fails. (As mentioned, if the MC_EMEM updates don't happen, things
> still work but potentially with a hefty perf loss.)
> TBH, I haven't yet decided which one is better. If you have an opinion,
> I'll go with it.

I think I prefer 1. Using an explicit call into the MC driver allow us
to precisely determine the moment in time when the registers should be
updated. The pre-change notifier, as I understand it, doesn't give us
that. Also, the notifier doesn't give us a way to determine success or
failure of the MC call.

> >>The downstream kernel also overwrites most LA registers during EMC rate
> >>change without regard for the driver-set values, and we might have to r=
ead
> >>those values from the device tree too. Upstream can do this in rate cha=
nge
> >>notifiers if needed. I'll look into this a bit more.
> >
> >As I understand it, the latency allowance should be specified in terms
> >of the maximum amount of time that requests are delayed, so that the
> >proper values for the LA registers can be recomputed on an EMC rate
> >change.
>=20
> That's how I understand it too, but in downstream, the LA register values
> are hardcoded into EMC tables in platform data/DTS that are just written
> into the LA registers as-is during rate change.

Hehe, well, we don't want any of that upstream. =3D) If it can be computed
at runtime, then let's compute it. Also, if it's encoded in platform
data or DTS, then there's no way it can be adjusted based on use-case.
For example if you have a device with two display outputs (an internal
panel and HDMI for example) but you never have HDMI plugged in, then
there's no reason why you would want to program the latency allowance
for the second display controller. If you provide the values in a static
frequency/register value table, then you need to account for any
possible scenario up front, irrespective of what (if any) HDMI monitor
is attached.

Thierry

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw7qPAAoJEN0jrNd/PrOhHO8P/3AhMgARrx8rFpVQ1+daaOOZ
MljE4DhJljjwt9CJ6GL49PZwDz8SH9yjWe41Fo28JEsVf12fiDw11YYITOsNUxjQ
3dkxqNxQmO9aIKD93QZX/caNM3wWSkT+K2q8ejTsbFsrCfenIFpy/gnNX6NjL3JE
rs+5HdL5giydsaPh0G1ylAj5v2++hbBRNxpIY2X62OWqyjv1Fs6gggK2wC4S7bPM
aQMxCzI97L10WAaNoS0xzHXVK+A6H3TZeucV2McYwrHfjSjWx1qUd+G2AUu5OQKo
CixhXORG4r7po2W8wz2UA3ZcfGDzUhi++dPPoTWgirxlgIxlXDo1L22t0Tzf9aF4
rflj+HPpdRfKquorHdgGY9WF/KYHAtdKzGE1fQpfM58sezrEW9kRSOujTTM0f80x
uwBet6EWLbt/VZjqC4P1J0cFcL/zbt1oDwak7laaRsFckvsPc7DK9oQmDHheHT3K
B/sTAzvU29UzlcZqCio1DwMFPiHS24kqHiJUUhZl7EuMtVP1nIBTx5tBdpS8lAV8
WsWqwfcuZOVADY8bN2GIovFgki6BKoX9/fERUbE0nF9zb/bSJqqXb58sngVuSap5
DsJbefeeym/gRVX67Bu94774sRpW4qAuOgpaDsKqi2G3Zuaz13j+ISiZnLDJ2DFQ
fLZKmEWOn0D4jPql0Ep6
=e+na
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
