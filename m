Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3HDTdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 15:33:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39858 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3HDTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 15:33:00 -0400
Date: Sun, 4 Aug 2013 20:32:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20130804193229.GU9858@sirena.org.uk>
References: <20130731081806.244752d4@armhf>
 <20130803222332.GE23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OSpmqASCB2mWXNW4"
Content-Disposition: inline
In-Reply-To: <20130803222332.GE23006@n2100.arm.linux.org.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/4] ASoc: kirkwood: merge kirkwood-i2c and
 kirkwood-dma
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OSpmqASCB2mWXNW4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 03, 2013 at 11:23:33PM +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 31, 2013 at 08:18:06AM +0200, Jean-Francois Moine wrote:

> > To avoid the declaration of a 'kirkwood-pcm-audio' device in the DT,
> > this patch merges the kirkwood-i2c and kirkwood-dma drivers into one
> > module associated with 'kirkwood-i2s'.=20

> I suggest holding off on this stuff at the moment.  I think Mark and Liam
> (who now have a whole raft of emails from me today) have some work to do
> to fix ASoC to work how they're saying it should work, because to me
> ASoC seems to contradict what they're telling me.  To put it another way,
> it must be buggy.

Or push this stuff in there and help fix any issues that come up, what
issues there are with the CPU side stuff are there mostly because nobody
has been upstreaming anything and hence exercising the code.  This merge
is going to be needed for the DT conversion anyway so I can't see any
gain in waiting, other things depend on this rather than the other way
around.

> The DAPM stuff seems to be the worst thing since mouldy bread.  I'm
> chasing what seems to be multiple bugs through this stuff, and many of
> them are not particularly nice.

> For example - we register multiple copies of DAPM widgets for the same
> set of declarations if both a CPU DAI and a platform share the same
> struct device, and thereby end up overwriting some pointers in the DAI
> structure.  It seems that CPU DAIs themselves aren't supposed to have
> DAPM widgets, but the core creates some... but there's no explicit
> cleanup of them unlike the other DAPMs, and there's no debugfs for them.

CPU DAIs are supposed to be able to have widgets, I'm not sure why you
say they aren't.  It's possible this doesn't work since most hardware is
structured such that the control belongs in a DSP which tends to end up
in the platform device so even the out of tree users aren't likely to
exercise this path but from a framework point of view that seems like a
thing I'd expect to work and if it doesn't work we should make that so.

Removal paths are, by and by large, not really exercised since nobody
actually does that in production and most people's development model is
based on rebooting full kernels.

> For example, where a codec has no input/output widgets declared, it used
> to be powered up automatically by ASoC as a matter of course.  Things
> like UDA134x and other things.  Things like spdif-dit.  That "mysteriousl=
y"
> stopped happening.

This is DAPMless CODECs, frankly they're more trouble than they're
worth given how trivial it is to implement DAPM and the fact that they
constantly cause problems due to the special casing they need and the
fact that development is pretty much all happening on modern hardware
with CODEC drivers that support DAPM.  This isn't the first time they've
been missed, it won't be the last either.

> Now, about the spdif-dit, if we're going to have to add "pin" widgets
> to it, what the output of a SPDIF in terms of DAPM widgets?  At a guess,
> it's a "codec pin" despite there being no codec and no "pin" on that
> codec in reality, and that "pin" is always active.

There's an output from the S/PDIF device - the S/PDIF signal it sends,
either electrically or optically (usually the former).

> It looks to me like the DAPM stuff is - in one plain and simple word -
> buggered.

It does seem to be working adequately in a rather large number of
systems.  I think you're confusing DAPM with support for non-trivial
SoCs, currently all the mainline DAPM use is in CODEC devices.

As far as I can tell your problems here come from a combination of using
very old devices like the uda134x which haven't ever been particularly
well maintained and trying to do new things with the frameworks.  If
you're working on something that's not been done before it's likely that
the frameworks will need extending.

> I've no idea what the right fixes are in this area.  It needs someone
> like Mark or Liam who supposedly understand this to spend time checking
> that it actually operates as they _think_ it should operate, because
> at the moment it plainly doesn't.

This is all working fine for me with the systems I have available to me
in mainline - I don't have any systems at all with non-DAPM devices and
obviously nothing in mainline uses DPCM.

--OSpmqASCB2mWXNW4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR/qxKAAoJELSic+t+oim9AXQQAIX837TqLgHjFtViUQ8B3wtf
MwldZnZK0SRXFagoKP5oFkM3Jn9sU/u4+w/t9JODQ91czjF8obgn5dOsE2lyozzy
dtSMNl4MCGEA2lr/Aou2iUQvluOdaOiKeY0P3G5BxFP9gZx+esjZceioT8I7nO1o
Fx3VQQ4ZfUMgL7ogpkJAuPkbPBeaMEDGOeG0zVUlj/w7O1c4D8Jc1ey3eNpwOrYY
s42IWLWmeTIN+gURzbYLcDRAOGEOR6g0Wx4NDBnJwtDJsub3hXL1+ucNuFaEtEFI
elGebF2EhmOcGQ6LG2eFEY+RfXxgqZCnMuGVEKGxr85P0DHlyEbB5qY5J2UNL2gA
oOr2eL2pDO+Xj1s37v1MCDIJLfJB72DsaSc32h1oP4YYSojmowsGc5Sg8+l+BEzH
rMqh3dh29LJeYEzT9chgBS7Bi619mxAbYo5vOnRYM2KeYQupVUxH2ww/3Z05MsuV
Z0cExwK4exb7tBcQCTCUemtl2Df6NkowFUgTiRF1f0QiLqqwFXJXcTTHdg9FR40w
f4jo+RJO+sjlao2rSe2uDl6DBlpqBwpF3rCEb0n1/KYy3VreDR2WPthQHvPf7WlK
QfBWaweM1AATxzhHJghKCGxfyAGUmvEFmbuHp0/6hYc4nJG6CKBHf7FUSQu9bPQG
ghYDm4gGDTEEa/u/CHjt
=AP3B
-----END PGP SIGNATURE-----

--OSpmqASCB2mWXNW4--
