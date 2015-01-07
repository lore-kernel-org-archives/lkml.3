Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbbAGN1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:27:17 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60285 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbbAGN1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:27:15 -0500
Date: Wed, 7 Jan 2015 14:27:10 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        swarren@wwwdotorg.org, gnurou@gmail.com, bskeggs@redhat.com,
        martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150107132709.GA6988@ulmo>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
 <1419426990.2179.7.camel@lynxeye.de>
 <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com>
 <54AD0F37.5080609@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <54AD0F37.5080609@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 06:49:27PM +0800, Vince Hsu wrote:
>=20
> On 01/07/2015 06:19 PM, Peter De Schrijver wrote:
> >On Mon, Jan 05, 2015 at 04:09:33PM +0100, Thierry Reding wrote:
> >>* PGP Signed by an unknown key
> >>
> >>On Thu, Dec 25, 2014 at 10:28:08AM +0800, Vince Hsu wrote:
> >>>On 12/24/2014 09:16 PM, Lucas Stach wrote:
> >>>>Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
> >>>>>The Tegra124 and later Tegra SoCs have a sepatate rail gating regist=
er
> >>>>>to enable/disable the clamp. The original function
> >>>>>tegra_powergate_remove_clamping() is not sufficient for the enable
> >>>>>function. So add a new function which is dedicated to the GPU rail
> >>>>>gating. Also don't refer to the powergate ID since the GPU ID makes =
no
> >>>>>sense here.
> >>>>>
> >>>>>Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> >>>>To be honest I don't see the point of this patch.
> >>>>You are bloating the PMC interface by introducing another exported
> >>>>function that does nothing different than what the current function
> >>>>already does.
> >>>>
> >>>>If you need a way to assert the clamp I would have expected you to
> >>>>introduce a common function to do this for all power partitions.
> >>>I thought about adding an tegra_powergate_assert_clamping(), but that
> >>>doesn't make sense to all the power partitions except GPU. Note the
> >>>difference in TRM. Any suggestion for the common function?
> >>I don't think extending the powergate API is useful at this point. We've
> >>long had an open TODO item to replace this with a generic API. I did
> >>some prototyping a while ago to use generic power domains for this, that
> >>way all the details and dependencies between the partitions could be
> >>properly modeled.
> >>
> >>Can you take a look at my staging/powergate branch here:
> >>
> >>	https://github.com/thierryreding/linux/commits/staging/powergate
> >>
> >>and see if you can use that instead? The idea is to completely hide the
> >>details of power partitions from drivers and use runtime PM instead.
> >>
> >>Also adding Peter whom I had discussed this with earlier. Can we finally
> >>get this converted? I'd rather not keep complicating this custom API to
> >>avoid making the conversion even more difficult.
> >Conceptually I fully agree that we should use runtime PM and powerdomain=
s.
> >However I don't think the implementation you mentioned is correct. The r=
esets
> >of all modules in a domain need to be asserted and the memory clients ne=
ed to
> >be flushed. All this needs to be done with module clocks enabled (resets=
 are
> >synchronous).  Then all module clocks need to be disabled and then the
> >partition can be powergated. After ungating, the module resets need to be
> >deasserted and the FLUSH bit cleared with clocks enabled.
> Yeah. I plan to have the information of all the clock client of the
> partitions and
> the memory clients be defined statically in c source, e.g. pmc-tegra124.c.
> All modules can declare which domain they belong to in DT. One domain can
> be really power gated only when no module is awake. Note the clock clients
> of
> one domain might not equal to the clocks of the module. The reset is not
> either.
> So I don't get the clock and reset from module. How do you think?

This whole situation is quite messy. The above sequence basically means
that drivers can't reset hardware modules because otherwise they might
race with the power domain code. It also means that we can't powergate
modules on demand because they might be in the same power domain as one
other module that's still busy.

How would we handle a situation where a hardware module hangs and we can
only get it back via a reset?

Thierry

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrTQtAAoJEN0jrNd/PrOh/9EQAKf/mZULHAs26/RBtIWdumbx
jVoe375Cmd/TwmcD0lpIaXep5OnDxid9cMRTNebJydKkTlp9QzNKWbMUdA0gX/Oz
ZqlkmlIKW60p1exFGPkuw0dXoB3aF5odXXtEopJv3QrbNzg8YUEQ+3IxPIAWn4iR
AwU1xi9GZpgEE5igMrRRAipBS+S02nDj2TRi4NPWu5ZvY/NL9cQatIhT7uEJCNzP
qC2lwkreXrLzYqKpCCqKo41XNL7Oi9HaUPUbWDZ1PUtYa0ZUkpa+tPJzFWf/3scD
VsgRks1WhJ9NyuONIZ1Fdithh0J0m0FFIt62CPrCnM/yGP4fezeHU7mdNysuvQmJ
WZX0TqPH17rLUwasthq2wvNzzWDx8DHQ7A8T469JE/qFNEB9eJZzzIx/ulyRiLJ5
g1rwZ57hZCOcxZR3F16uuUSGBQ/oxYY1S1DQzRDNT0D3SD7WPMyXQAA8F/VSrKp1
zlfS+g1m4FawJ9cWjJCy5yMqlqbmSPBsEQ4jTrGEhHR1j9IIzJIcOBqwbHjFDqHT
4M9/p4FRuk9VRerWKSLnUR4IoWhpqkEPNNJ7gmXLW3JLSGL538Swr2wAbwT+J35n
io2YjUfsctcysDAWSW9WfeInv9SX73MbqMLHzNPuKQbYARm180qJTWe2KrtSSYlv
LZ5n2w2iqYiO5nLk4e3t
=4j+5
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
