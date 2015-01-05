Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbbAEPrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:47:07 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47335 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbbAEPrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:47:04 -0500
Date: Mon, 5 Jan 2015 16:46:59 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Oded Gabbay <oded.gabbay@amd.com>, David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dana Elifaz <Dana.Elifaz@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        iommu@lists.linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/2] Change order of linkage in kernel makefiles for
 amdkfd
Message-ID: <20150105154657.GJ12010@ulmo.nvidia.com>
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
 <1621810.aTt9O4Ghzs@avalon>
 <549FEB52.4020103@amd.com>
 <1678486.9ZXZnn5och@avalon>
 <54A12028.7020303@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pN9MePJoZbRKbUk1"
Content-Disposition: inline
In-Reply-To: <54A12028.7020303@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pN9MePJoZbRKbUk1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2014 at 10:34:32AM +0100, Christian K=C3=B6nig wrote:
> Am 29.12.2014 um 09:16 schrieb Laurent Pinchart:
> >Hi Oded,
> >
> >On Sunday 28 December 2014 13:36:50 Oded Gabbay wrote:
> >>On 12/26/2014 11:19 AM, Laurent Pinchart wrote:
> >>>On Thursday 25 December 2014 14:20:59 Thierry Reding wrote:
> >>>>On Mon, Dec 22, 2014 at 01:07:13PM +0200, Oded Gabbay wrote:
> >>>>>This small patch-set, was created to solve the bug described at
> >>>>>https://bugzilla.kernel.org/show_bug.cgi?id=3D89661 (Kernel panic wh=
en
> >>>>>trying use amdkfd driver on Kaveri). It replaces the previous patch-=
set
> >>>>>called [PATCH 0/3] Use workqueue for device init in amdkfd
> >>>>>(http://lists.freedesktop.org/archives/dri-devel/2014-December/07440=
1.ht
> >>>>>ml)
> >>>>>
> >>>>>That bug appears only when radeon, amdkfd and amd_iommu_v2 are compi=
led
> >>>>>inside the kernel (not as modules). In that case, the correct loading
> >>>>>order, as determined by the exported symbol used by each driver, is
> >>>>>not enforced anymore and the kernel loads them based on who was link=
ed
> >>>>>first. That makes radeon load first, amdkfd second and amd_iommu_v2
> >>>>>third.
> >>>>>
> >>>>>Because the initialization of a device in amdkfd is initiated by rad=
eon,
> >>>>>and can only be completed if amdkfd and amd_iommu_v2 were loaded and
> >>>>>initialized, then in the case mentioned above, this initalization fa=
ils
> >>>>>and there is a kernel panic as some pointers are not initialized but
> >>>>>used nontheless.
> >>>>>
> >>>>>To solve this bug, this patch-set moves iommu/ before gpu/ in
> >>>>>drivers/Makefile and also moves amdkfd/ before radeon/ in
> >>>>>drivers/gpu/drm/Makefile.
> >>>>>
> >>>>>The rationale is that in general, AMD GPU devices are dependent on A=
MD
> >>>>>IOMMU controller functionality to allow the GPU to access a process's
> >>>>>virtual memory address space, without the need for pinning the memor=
y.
> >>>>>That's why it makes sense to initialize the iommu/ subsystem ahead of
> >>>>>the gpu/ subsystem.
> >>>>I strongly object to this patch set. This makes assumptions about how
> >>>>the build system influences probe order. That's bad because seemingly
> >>>>unrelated changes could easily break this in the future.
> >>>>
> >>>>We already have ways to solve this kind of dependency (driver probe
> >>>>deferral), and I think you should be using it to solve this particular
> >>>>problem rather than some linking order hack.
> >>>While I agree with you that probe deferral is the way to go, I believe
> >>>linkage ordering can still be used as an optimization to avoid deferri=
ng
> >>>probe in the most common cases. I'm thus not opposed to moving iommu/
> >>>earlier in link order (provided we can properly test for side effects,=
 as
> >>>the jump is pretty large), but not as a replacement for probe deferral.
> >>My thoughts exactly. If this was some extreme use case, than it would be
> >>justified to solve it with probe deferral. But I think that for most co=
mmon
> >>cases, GPU are dependent on IOMMU and *not* vice-versa.
>=20
> Fixing this through deferred probing sounds like the correct long term
> solution to me as well.
>=20
> But what Thierry is referring to here is probably the approach of returni=
ng
> -EAGAIN from the probe method (at least that was the last status when I
> looked into this).

-EPROBE_DEFER would be the one that I was referring to.

> The problem with this approach is the interface design between radeon and
> amdkfd. amdkfd simply doesn't have a probe method which gets called when =
the
> hardware is detected and can return -EAGAIN. Instead amdkfd is called by
> radeon after hardware initialization when it is way to late for such a
> thing.

That sounds like a pretty brittle design. It sounds like nowhere in the
code you've encoded this dependency and you rely on symbols only to
ensure probe ordering.

Couldn't you simply make radeon check for availability of the IOMMU
early and defer probing if it's not there yet? Or if radeon depends on
the IOMMU via amdkfd, then perhaps calling into amdkfd to check for the
availability of the IOMMU would be a more correct representation of the
dependency.

> >>BTW, my first try at solving this was to use probe deferral (using
> >>workqueue), but the feedback I got from Christian and Dave was that mov=
ing
> >>iommu/ linkage before gpu/ was a much more simpler solution.
> >To clarify my position, I believe changing the link order can be a worth=
while
> >optimization, but I'm uncertain about the long term viability of that ch=
ange
> >as a fix. Probe deferral has been introduced because not all probe order=
ing
> >issues can be fixed through link ordering, so we should fix the problem
> >properly.
> >
> >This being said, if modifying the link order can help for now without
> >introducing negative side effects, it would only postpone the real fix, =
so I'm
> >not opposed to it.
>=20
> Yeah, that sounds like the right approach to me as well.

I don't think that's a good approach at all. It doesn't encode the
dependency anywhere. All you have is some Makefile that lists a bunch of
directories. What happens if anybody was to change that order for some
other reason? If you're not Cc'ed on the patch and nobody else NAK's it
because they are accidentally aware of the dependency that patch is
going to break radeon.

> In general I would prefer that modules compiled into the kernel load
> by the order of their symbol dependency just like standalone modules
> do.

That I generally agree with. But it can't be a replacement for properly
describing the runtime dependencies between modules. There can be other
reasons than link order that influence probe ordering. What if the IOMMU
driver for some reason gains deferred probe support and therefore
doesn't succeed on the first probe? Or only sometimes.

Properly describing the dependency is the only way to prevent any of
that.

Thierry

--pN9MePJoZbRKbUk1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUqrHxAAoJEN0jrNd/PrOhXfAP/1MoFwg5gpuv0FYKn9cmkSgn
PIwfF/20vxlX61jAshN/Vj++QtshjeslspDXpqjcR0Ylm/MoaITdsb4WqNOUdplM
g180HQkWsZw5jemg1dvOihS6nsV5wtFiuDUtSg2bFYIo5uX1cKtXr0Dvw5FplHBL
x7cBo1W6/q89qkjuLKe0XUtlqAveaMfVp4SDzFMXW0d65x9yEGkBNkOJ7xmWXLQJ
Oy99mjjfXetFW8CTBz4GCG55Wx+dvbylueRYIDE13r3HkH7YlJY2yf4+OD5rBJO+
NDk1AyKKvxO3BAF50GjtcHZ3KXLpapaXp1mWBuO09vSovLSCyXvHcPMmP1JJpf5i
Xo4ZUqTWY92k9nzIXS7o6xy/pZuWsHkZbebaQsFLp+ZW31bWlas9kBItdoxmSDBc
sEAqoEHrQvnhNBJxJb9HITQ4pyS8VMP4Fy1gXcx7f8vLSk8q/bgnGtKjSWeHuKPg
wQtLf+czbKe/VPmQnhOmwc4MKi11NU5dYu1wskmnR81ntZ1LHWBfuUCtklYxT7+Y
+VYJoG3WIzT2lZkbFNRnq0AEnnIqr7sw9ua8tNkM/CSkNniCrf3UbGM6DUZ5r9v1
gMGIfCz81XP6sXzjhbovI6U1Qmm8khLWC6Dhkoim47oDiJ//E5q8b26y5jyt/pNa
7vyTasieNBGV7aREdIm1
=Qy3q
-----END PGP SIGNATURE-----

--pN9MePJoZbRKbUk1--
