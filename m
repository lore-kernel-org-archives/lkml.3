Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbbAHK5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:57:51 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64235 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbbAHK5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:57:48 -0500
Date: Thu, 8 Jan 2015 11:57:43 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dmitry Osipenko <digetx@gmail.com>, Alexandre Courbot <gnurou@gmail.com>,
        Joseph Lo <josephl@nvidia.com>, stable@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Use PMC scratch register 40 for
 tegra_resume() location store
Message-ID: <20150108105742.GI1987@ulmo.nvidia.com>
References: <1419202392-1159-1-git-send-email-digetx@gmail.com>
 <54984429.8040905@wwwdotorg.org>
 <5498549B.8070101@gmail.com>
 <54985C30.7020605@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CNK/L7dwKXQ4Ub8J"
Content-Disposition: inline
In-Reply-To: <54985C30.7020605@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CNK/L7dwKXQ4Ub8J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2014 at 11:00:16AM -0700, Stephen Warren wrote:
> On 12/22/2014 10:27 AM, Dmitry Osipenko wrote:
> >22.12.2014 19:17, Stephen Warren =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>On 12/21/2014 03:52 PM, Dmitry Osipenko wrote:
> >>>Commit 7232398abc6a ("ARM: tegra: Convert PMC to a driver") changed
> >>>tegra_resume()
> >>>location storing from late to early and as result broke suspend on teg=
ra20.
> >>>PMC scratch register 41 was used by tegra lp1 suspend core code for st=
oring
> >>>physical memory address of common resume function and in the same time=
 used by
> >>>tegra20 cpuidle driver for storing cpu1 "resettable" status, so it imp=
lied
> >>>strict order of scratch register use. Fix it by using scratch 40 inste=
ad of 41
> >>>for tegra_resume() location store.
> >>
> >>You likely can't simply change the PMC scratch register usage arbitrari=
ly;
> >>specific registers are designated for specific purposes, and code outsi=
de the
> >>Linux kernel (bootloaders, LP0 resume code, secure monitors, etc.) may =
depend on
> >>those specific values being in those registers. Without significant res=
earch,
> >>I'd suggest not changing the PMC scratch register usage.
> >
> >Sure, that's why I asked to verify if scratch register 40 is in use in t=
he
> >comment after commit message.
>=20
> Sorry, I didn't notice that.
>=20
> >I've checked that u-boot doesn't use it (since
> >upstream kernel doesn't care about any other bootloader), but no idea ab=
out
> >secure monitor. It's definitely safer to avoid changing scratch regs usa=
ge, I
> >thought that proposed solution would be best from the pure code point of=
 view.
> >So, I'm considering your answer as a rejection of the patch (please, let=
 me know
> >if I'm wrong) and will prepare another one. Btw, it would be nice to have
> >scratch registers usage publicly documented somewhere (on "Tegra Public
> >Application Notes" webpage for example), if it's possible, of course.
>=20
> At this stage in Tegra20 development, I think it'd be best to avoid chang=
ing
> any scratch register usage if at all possible.

Sorry, I had completely missed this discussion. When looking at the code
it doesn't look like this particular "resettable" status needs to be
stored in a PMC scratch register. It can't be stored in RAM because that
goes into self-refresh as part of LP1, but how about just putting it
into IRAM? That stays on in both LP1 and LP2, so should be suitable for
this use-case. It would make the code slightly more complex but using a
single scratch register for multiple purposes sounds brittle and easy to
break (as evidenced by the offending commit).

Otherwise it would seem that PMC_SCRATCH40 is only used to store EMC
configuration data across LP0 suspend/resume, so I wouldn't think it'd
cause problems if we used that instead of PMC_SCRATCH41 to store the
"resettable" state.

Changing the storage location for tegra_resume() isn't such a good idea
since that's a documented use of PMC_SCRATCH41.

Thierry

--CNK/L7dwKXQ4Ub8J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrmKmAAoJEN0jrNd/PrOhma4P/2v+xR+E6QNCNmgN3Gg/2fDW
VSMv8fCkceMfohbXzHbbCbkAScyAPLfJMvelISLFTQ1bV01phI64R5BRLSIYZrbz
h/H9VK5jVDUtmSka8GYL/XM18DD9jafsLcrObul/2bIB1ajkAM6U2OD1vGUkfmaI
30yFYJL9A6zjmyFXU7yc92pFniV3dsW3ZvnZBuB3Whw6KsBo1pXfO7l2AudfwVqO
okILYAfJiQF7lzPuhNdTgHce4dq8DLQR+QdvFeR6S6Pt2U6Kz/gRpVG1h2yF+KYm
R2VovwRWhGfv65Yk2gou0ki7HumlGQQVB05zmCmePSFptjFE92NzWdKb1xLJH6Uo
O1aN7uat9BBhTpWwOa6tklqsxyG8ipiRmzkLXSSXrxoF8u9kTYIOwQFNlcQAI5k6
5V3AJW8xXv2lBbNHE3LELJDlbK5xOdnQLT2iteJzfjCRDPUUcQZWb2IH7mCO0ewL
QR5RdNwkM4fUT66iwEaaqGo9kXlaWhk5obf1/YjtGaHMB/iRvmFClB5hDzn2am2D
XGhjUdlx6m+cxjRaOBuaCArp6CDhO5V6k2d64DSEcXgkHJJvP8s9OW8oz9JlcR5e
Q1OVcE+OdV4kTBMafzvJvi0QUv4eukAFzhv+PF3jMvvPm+pAOPoMfpfnluh/P/0q
MGnzVNFMjDqPEphn7Mxd
=QfS9
-----END PGP SIGNATURE-----

--CNK/L7dwKXQ4Ub8J--
