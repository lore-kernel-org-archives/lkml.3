Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaHNLA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:00:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43816 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaHNLAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:00:54 -0400
Date: Thu, 14 Aug 2014 13:00:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, changcheng.liu@intel.com,
        xiaoming.wang@intel.com, souvik.k.chakravarty@intel.com
Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Message-ID: <20140814110040.GI16043@twins.programming.kicks-ass.net>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G3juXO9GfR42w+sw"
Content-Disposition: inline
In-Reply-To: <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G3juXO9GfR42w+sw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 12:29:32PM +0200, Daniel Lezcano wrote:
> Hi Chuansheng,
>=20
> On 14 August 2014 04:11, Chuansheng Liu <chuansheng.liu@intel.com> wrote:
>=20
> > We found sometimes even after we let PM_QOS back to DEFAULT,
> > the CPU still stuck at C0 for 2-3s, don't do the new suitable C-state
> > selection immediately after received the IPI interrupt.
> >
> > The code model is simply like below:
> > {
> >         pm_qos_update_request(&pm_qos, C1 - 1);
> >                 < =3D=3D Here keep all cores at C0
> >         ...;
> >         pm_qos_update_request(&pm_qos, PM_QOS_DEFAULT_VALUE);
> >                 < =3D=3D Here some cores still stuck at C0 for 2-3s
> > }
> >
> > The reason is when pm_qos come back to DEFAULT, there is IPI interrupt =
to
> > wake up the core, but when core is in poll idle state, the IPI interrupt
> > can not break the polling loop.

So seeing how you're from @intel.com I'm assuming you're using x86 here.

I'm not seeing how this can be possible, MWAIT is interrupted by IPIs
just fine, which means we'll fall out of the cpuidle_enter(), which
means we'll cpuidle_reflect(), and then leave cpuidle_idle_call().

It will indeed not leave the cpu_idle_loop() function and go right back
into cpuidle_idle_call(), but that will then call cpuidle_select() which
should pick a new C state.

So the interrupt _should_ work. If it doesn't you need to explain why.

--G3juXO9GfR42w+sw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7JbYAAoJEHZH4aRLwOS6EGUP/28NXBBtg5PBMF9g060zyHge
Mo5bnR5UUD2bGEq0uCQ8GpbJTfeyMKqjP7r1vQ9zK4nHbsFLiSIp/rPsGS0AOOtL
SHqMWaVyvtSppikUvBuGbiqDLn50SNMxLwhyGaMWfovKB7L5mKdHMB1W5AwAwRi1
M4J6tkrbeQy0UwsFeydx5+j1Gwu+aWc672/VUAJ7a8i/BAyEpeFlD31Wz4NoI8iE
XdpIxJK7r3dhcn+XMtkolYPHr0Vn7Dho18Q5sFZXu3U6FsUtb83+Sz6p1WXtxb+7
VEhF0DocGMkacKqBvKscT2m/tCwp7wKXVoI4+VVdjyezyF8u4ezcE6sEs0401tyS
S1cgkzxTxQF6r+0ahb5YzxWn5SiISMaf2ju5TllUmjwyCmbEFKj2qv+0gGBbqARr
4QIXiBE/QiCEnfu1ADMKHkpmGyYuJswCR/hnylanZpp2h4TSzRJCCuq08rEo/ZxE
CcoQEhOt0z33Rd7xU4Hff9v82/zcRVP1qwmNy1HEkDUrnQMEVEFJzOJUoHnzGxYn
gIYfu5klMsW+Y6f9h4MayWUj37+47a8trJw8WbX3sIVWEKB3YIsMYA9iU6Hhl1Hz
d4bUxjrHd9tmFKht8vl4fC6e0YzYlDgQnBw18ARHbSWnDvOh91YxJeuJiUZav5N1
gq57BNtnPMx5Yano4oDq
=w+M0
-----END PGP SIGNATURE-----

--G3juXO9GfR42w+sw--
