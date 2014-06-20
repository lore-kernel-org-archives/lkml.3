Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966748AbaFTUxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:53:00 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:47250 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966224AbaFTUw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:52:58 -0400
Date: Fri, 20 Jun 2014 22:52:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "Clark, Rob" <robdclark@gmail.com>, Colin Cross <ccross@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REPOST PATCH 4/8] android: convert sync to fence api, v5
Message-ID: <20140620205252.GC28814@mithrandir>
References: <20140618102957.15728.43525.stgit@patser>
 <20140618103711.15728.97842.stgit@patser>
 <20140619011556.GE10921@kroah.com>
 <20140619063727.GL5821@phenom.ffwll.local>
 <20140619114825.GB28111@ulmo>
 <CAKMK7uE_B3pCZB9orh5+BJGooNfyEa0APrZqRpXqYu5xfQ0PCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+My9LyyhiUvIEro"
Content-Disposition: inline
In-Reply-To: <CAKMK7uE_B3pCZB9orh5+BJGooNfyEa0APrZqRpXqYu5xfQ0PCQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R+My9LyyhiUvIEro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2014 at 02:28:14PM +0200, Daniel Vetter wrote:
> On Thu, Jun 19, 2014 at 1:48 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> >> > With these changes, can we pull the android sync logic out of
> >> > drivers/staging/ now?
> >>
> >> Afaik the google guys never really looked at this and acked it. So I'm=
 not
> >> sure whether they'll follow along. The other issue I have as the
> >> maintainer of gfx driver is that I don't want to implement support for=
 two
> >> different sync object primitives (once for dma-buf and once for android
> >> syncpts), and my impression thus far has been that even with this we're
> >> not there.
> >>
> >> I'm trying to get our own android guys to upstream their i915 syncpts
> >> support, but thus far I haven't managed to convince them to throw peop=
le's
> >> time at this.
> >
> > This has been discussed a fair bit internally recently and some of our
> > GPU experts have raised concerns that this may result in seriously
> > degraded performance in our proprietary graphics stack. Now I don't care
> > very much for the proprietary graphics stack, but by extension I would
> > assume that the same restrictions are relevant for any open-source
> > driver as well.
> >
> > I'm still trying to fully understand all the implications and at the
> > same time get some of the people who raised concerns to join in this
> > discussion. As I understand it the concern is mostly about explicit vs.
> > implicit synchronization and having this mechanism in the kernel will
> > implicitly synchronize all accesses to these buffers even in cases where
> > it's not needed (read vs. write locks, etc.). In one particular instance
> > it was even mentioned that this kind of implicit synchronization can
> > lead to deadlocks in some use-cases (this was mentioned for Android
> > compositing, but I suspect that the same may happen for Wayland or X
> > compositors).
>=20
> Well the implicit fences here actually can't deadlock. That's the
> entire point behind using ww mutexes. I've also heard tons of
> complaints about implicit enforced syncing (especially from opencl
> people), but in the end drivers and always expose unsynchronized
> access for specific cases. We do that in i915 for upload buffers and
> other fun stuff. This is about shared stuff across different drivers
> and different processes.

Tegra K1 needs to share buffers across different drivers even for very
basic use-cases since the GPU and display drivers are separate. So while
I agree that the GPU driver can still use explicit synchronization for
internal work, things aren't that simple in general.

Let me try to reconstruct the use-case that caused the lock on Android:
the compositor uses a hardware overlay to display an image. The system
detects that there's little activity and instructs the compositor to put
everything into one image and scan out only that (for power efficiency).
Now with implicit locking the display driver has a lock on the image, so
the GPU (used for compositing) needs to wait for it before it can
composite everything into one image. But the display driver cannot
release the lock on the image until the final image has been composited
and can be displayed instead.

This may not be technically a deadlock, but it's still a stalemate.
Unless I'm missing something fundamental about DMA fences and ww mutexes
I don't see how you can get out of this situation.

Explicit vs. implicit synchronization may also become more of an issue
as buffers are imported from other sources (such as cameras).

> Finally I've never seen anyone from google or any android product guy
> push a real driver enabling for syncpts to upstream, and google itself
> has a bit a history of constantly exchanging their gfx framework for
> the next best thing. So I really doubt this is worthwhile to pursue in
> upstream with our essentially eternal api guarantees. At least until
> we see serious uptake from vendors and gfx driver guys. Unfortunately
> the Intel android folks are no exception here and haven't pushed
> anything like this in my direction yet at all. Despite multiple pokes
> from my side.
>=20
> So from my side I think we should move ahead with Maarten's work and
> figure the android side out once there's real interest.

The downside of that is that we may end up with two different ways to
synchronize buffers if it turns out that we can't make Android (or other
use-cases) work with DMA fence. However I don't think that justifies
postponing this patch set indefinitely.

Thierry

--R+My9LyyhiUvIEro
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTpJ8kAAoJEN0jrNd/PrOhj/sP/1FHSqAD3KFbXo7Q19dVlGMc
ROCK8DWKfxwGijJi701I/DK8h2ZdZJKbeDcStaQeKg1fbKGNtBW0KjsVyUm5s76Q
hhU5dLUb0swCiezMoEDv6tqxCtnTHm/u+fddMHIE3RLAKwBI0E0j+LLlzQYjq7CP
0vB3w3tz+ha9BO3jHHmVC9oJjQSvHYJFW6gBovsGlymoOCpL7+nQW/IMWWuKMIV7
7Mk093uQa1gMIyTObHRjnerL7Om+TFeDQixgsRrPainOTjpHZBh0X5EFbdJUS2GG
G0wv88yXW7/n75liq0LFtirQgEvYS6GajJTLJZeCyKSouGycS74GyTNOI2Wjztlx
QO5kZl3nVYQlST2qdsp2NgAwvl4cY8bSqqEW35qnLOtppEHyufGNUikZMoiPrCDl
lu0nFYJWwlg3lDVMfbltFQkkaufaCErd6TTA9RdooMdHigbbp372yTDf2h3gtXQx
ts6ZX6T8h8qBHWY1/SGQKd2xqYoWdBGj999MAZbwWKCH854ObWqFPGwcrbxoRXLs
k61AW/nNiBB6SGU0lq/CvYp55fAGTSlLGfJJUIgI+9XNGDN/c1k/uRfvh8QVDTkl
viI3i+vsVF/k/YbJOOgnGaxHDDy+HnAulBkod60YklfXsm23SDTeSMcuQ7RvuHVp
FZzdPuBO/4m2YSbuFZe/
=2k+6
-----END PGP SIGNATURE-----

--R+My9LyyhiUvIEro--
