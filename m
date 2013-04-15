Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935070Ab3DOGFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 02:05:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57216 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab3DOGFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 02:05:14 -0400
Date: Mon, 15 Apr 2013 08:04:44 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Clark <robdclark@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        arm@kernel.org, linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Latest randconfig build errors
Message-ID: <20130415060444.GA7746@avionic-0098.mockup.avionic-design.de>
References: <20130304095136.GI17833@n2100.arm.linux.org.uk>
 <20130304184649.GO11806@atomide.com>
 <CAF6AEGv=3453KKS9-8YAgHrxMMbNvLMvt0pz-=qdG+zcd-Trrw@mail.gmail.com>
 <20130413214539.GA32613@avionic-0098.mockup.avionic-design.de>
 <CAF6AEGtbqT23bjniwmGP-PhcxRPk5Q9aDaWM-=vVgkVrvDbCaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <CAF6AEGtbqT23bjniwmGP-PhcxRPk5Q9aDaWM-=vVgkVrvDbCaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:5JwGHkLHlCUYHTQTxIhBNiQXTbsJrD/i6GwO/i8jAhH
 vaj5K5dRHrN99vTAeESoZymDlYOAWNC7+M2h+CNn6pfzOogH9m
 jevyvt7K+RA0fg7HDGqRqb2FweAwwq8RD6vnh88OkQidt5Tieh
 f11xG+QvLjasF/Q0YUVUF+CSRCMWhUhaFJJjJtv1rZ6Zl9R+Lk
 1fZkXGicpYmWMvr0uRRb8Tc7KZYyfl6jm/CWUEnXHORaxgGlyM
 dV2gMPE5jOTPEncELHzOaP+eHO6zCUk+nz1lcLwYaeuIY4yADR
 rdfteOgJyNyrGXXnYzmKz0u2s1wT+BtVqWYXlyPJ9aGdzf5wse
 45LBWst4tV/QP6XGhj23T3Lgtof+MY43QvdkYLg4pbMKmfghSH
 w3GbI5FFjzpMBr6zPlAg10gd9Euq5jsf5omU3HCMBW0QkW3Wsj
 e7teX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 14, 2013 at 12:29:46AM -0400, Rob Clark wrote:
> On Sat, Apr 13, 2013 at 5:45 PM, Thierry Reding
[...]
> > I had been thinking about this on and off for a while, but I haven't
> > come up with anything concrete. Ideally we could just have some kind of
> > event that userspace would listen for, so that new outputs can be
> > dynamically added and userspace informed about them. Last time I checked
> > most of the helpers assumed that the complete output configuration is
> > known when the DRM device is registered, so some major rework will be
> > required to efficiently make use of such dynamicity.
>=20
> I'm less worried about the kernel re-work.. more worried about the
> fact that we have no way to know whether userspace knows to listen for
> this new event.  So anything down this path could, I think, be
> considered as breaking userspace.

Yes, that's probably true. Although the typical use-case would be that
the application would run on any of the detected outputs and if there is
none to begin with it will just fail. If there already is one, it will
try to use that instead and only fail to use a second one if it becomes
available.

> I think in the end, we need some way to have sort of "dummy"
> connectors for output drivers which might or might not be probed, so
> that from userspace perspective, non-present panels appear as displays
> that are not plugged in.

I can imagine that quite a few userspace programs will be broken by this
as well. For instance if you have an LVDS panel, I'm pretty sure people
will just assume that it can't be in a disconnected state and therefore
won't deal with that case.

=46rom a driver's point of view this isn't all that different from the
case you're trying to solve now. You still need to find out which
outputs can eventually become available. But instead of waiting until
they do before registering the DRM device you'd have to create dummy
outputs and keep checking whether the device is actually there each time
somebody interacts with the output.

But maybe this case is different. For Tegra the problem is that some
outputs (such as HDMI) require other drivers to be loaded first because
they provide resources (regulators, GPIOs, ...) that the output drivers
require. All of the drivers use deferred probing to resolve this
dependency and we can be reasonably sure that eventually probing of the
output will succeed (and therefore the output will become available).
Postponing the DRM registration until that point doesn't hurt. From what
I understand your use-case is similar. You need to load drivers for
different panels based on a runtime decision. So the only thing you need
is to be able to postpone the DRM registration until the panel driver
has been loaded, right?

Thierry

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRa5h8AAoJEN0jrNd/PrOhVOMQAKcUGnsir9C6fpvrbof72Cn9
azTQPTdBCszIDNqqvxkG9tnPX/6RX8gjufZfgfza51J+vSG1qiuhoKswq4mk5cry
JgG8szHHyv7apoGsjyRApEkYjbi+5npVFEaVEuFTp218x1NG0uJFtMFqAAj/jaUo
Yp7nb99YE2icPjVEkuZmJjwnQa+ReO+l+cRxVRseA3SIqXp5zhfvETsER/ev4d7E
cMxvFhboewxAoPMjEYJYwZe8tNAiqZI+ojXE9M18DiBlHw6Ciqacy1SfvtdGfh6h
kkc2li0qMAGAC08JjyTl9yqS/yA9N5gkPmkGOG5yP8Ms9H4lKMb8slGdGFSWqvMs
+m85nDYLPDXjJgtQw2DeirGdSzVfaZ9tbJ1sKHN6KHQvzGP5iP0JreBS7mDE5WGr
P02bKuZFThaNpP/w+tO1s6TARNPurc+KkdSpn+WmTiGvakrr0BiLj7ZBd50ANPP6
jOU9vuRtCOXeHxmqrYIq/7cmil6AllcpzpkkyqHeXLNNO870Bh0gWpbgDLhUEvKs
pctrsc/F75Z8up3+KErtzmeyr0sjqjZyC3Vvw0kTfW2T5pxKrqoP2dJDPrzRUn2S
zN1vrbWXvURMe1DyXTKVN5cGqndV2WpDpFHmDOOZugYWGSZlCZgThlmf+5AGjzCl
QcHNHhvSmfd068+xYXrV
=VoP6
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
