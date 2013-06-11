Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3FKSTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:19:40 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63410 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3FKSTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:19:38 -0400
Date: Tue, 11 Jun 2013 20:19:34 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Keith Packard <keithp@keithp.com>,
        "X.Org development" <xorg-devel@lists.x.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [PATCH 2/6] gpu: host1x: Fix syncpoint wait return value
Message-ID: <20130611181933.GA29842@mithrandir>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
 <1368791388-31441-3-git-send-email-amerilainen@nvidia.com>
 <20130526101243.GB1652@mithrandir>
 <51A30372.6080907@nvidia.com>
 <20130528103927.GB11547@mithrandir>
 <86y5ay6hrn.fsf@miki.keithp.com>
 <20130611104800.GA29395@mithrandir>
 <CAKMK7uF=A9zZ3VgdwzU3gfOjXaYsCqfCUSPmkLdL98nKX94jFQ@mail.gmail.com>
 <51B70D52.9060601@nvidia.com>
 <CAKMK7uGRW4uqsSaDEehTZwknZH+mNEgyKB6-4TgfgUOaTOcoLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <CAKMK7uGRW4uqsSaDEehTZwknZH+mNEgyKB6-4TgfgUOaTOcoLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 02:09:31PM +0200, Daniel Vetter wrote:
> On Tue, Jun 11, 2013 at 1:43 PM, Terje Bergstr=C3=B6m <tbergstrom@nvidia.=
com> wrote:
> > On 11.06.2013 14:00, Daniel Vetter wrote:
> >> We don't use the EAGAIN ioctl restarting to resubmit the batchbuffer
> >> which blew up the gpu (that one has been submitted already in a
> >> different ioctl call), but to be able to restart the ioctl after the
> >> reset has completed: We need to kick every thread which is potentially
> >> holding GEM locks and make sure that we block them (at a point where
> >> they don't hold any locks) until the reset handler completed. To avoid
> >> a validation nightmare we use the same codepaths as we use for signal
> >> interrupts, so ioctl restarting is a very natural fit for this.
> >>
> >> Resubmitting victim workloads when a gpu crash happened is something
> >> the reset handler would do (kernel work item currently), not any
> >> userspace process doing an ioctl. But atm we don't resubmit victimized
> >> workloads.
> >
> > I don't understand the end-to-end of how resubmit is supposed to work.
> > User space is not supposed to resubmit, but still EAGAIN is returned to
> > user space, and drmIoctl() in user space just calls the came ioctl
> > again. Sounds like drmIoctl() is completely wrong.
>=20
> Maybe it wasn't clear, but -EAGAIN does _not_ resubmit work. -EAGAIN
> is used to restart the ioctl if we had to kick a thread (to make sure
> it doesn't hold any locks), e.g. for a blocking wait on oustanding
> rendering. The codepaths taken work exactly as if the thread is
> interrupt with a signal.

Okay. So if I understand correctly that reserves EAGAIN for a very
specific purpose DRM-wide and therefore we can't really use it for
something Tegra-specific. Even if we wanted to side-step the issue
by not using drmIoctl(), it might be a bad idea (or even break in
some other path) if we use EAGAIN. I guess we'll have to find some
other error-code for the case where a zero timeout is given to the
syncpoint wait ioctl.

Maybe it's best to use ETIMEDOUT after, just like for the case of a
non-zero timeout and the syncpoint not being incremented in time.
Userspace should be able to differentiate between the two because it
knows what timeout it did pass to the ioctl.

Thierry

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRt2o1AAoJEN0jrNd/PrOh/lkQAJqzD4Ud8SbcoYOkDx3DmL4I
XHI2ZKJRyhtPYO+d5s3o2dNQMMNWF6zoXECQeYbFxXb+6C9gB/4/R7N7+durjcLK
MBjl3DBfNaF96fu6ytJHIM2WUvpSeA62ngT8TTchPNGExC65lutYt2EpNKvMr7m6
jcy5XgzZu9DLsQH5jBkRporeTgYPh7ZLS7E9xd6CELO88Blw2O7ghIuirNZLJ9Lb
BUynikCwbadgpuoCbFf0MuZl8ViNAfjpvxQs4wI3uvn5nZOK43Fpl+iS/xOS9KsN
38oa9GT/w4CVjhvSUuYxfEvOdziqemY7OdytH4U/mPlzJmGZq0/AzQ6e5UEKz290
7Zbpw5AtefVlyhdKDXcRUTl5vQrYxp6m7rsqZ49n/Mt7ks9cQ3Chp8K7dQ+8ksp6
CMOb9RfiK68vwcCRMnIVEOdwu38aKe1RxUmvhqy7kBDQZt1Bgho7Jdjps3ps5iZR
WPIzilIfcVVr3pvBjnfVW2bElTbo7YGVXRCr0/KTyvo+wR9BgTtWNevCNGt11lqr
26uJvYUzYAsxLeTmGj0tASRoFsi3ALg8C8OQDnq0XB3ojh58rmMeZ+R1rVVNctkA
hrxRUj//Y5hZE9D9vL/gXwUnCHeWC9mnoI8ySpDcj1PJweFnh+hU0ZEAyhl4CJPm
xigco2F8YWDx13dp2u8f
=mIw8
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
