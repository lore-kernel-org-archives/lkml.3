Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3LLPKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:10:19 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40234 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3LLPKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:10:15 -0500
Date: Thu, 12 Dec 2013 16:08:59 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20131212150858.GA1889@ulmo.nvidia.com>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <20131212145305.GK9804@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20131212145305.GK9804@phenom.ffwll.local>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 03:53:05PM +0100, Daniel Vetter wrote:
> On Thu, Dec 12, 2013 at 03:36:29PM +0100, Thierry Reding wrote:
[...]
> > diff --git a/drivers/base/dma-buf-test.c b/drivers/base/dma-buf-test.c
[...]
> > +struct dmabuf_create {
> > +	__u32 flags;
> > +	__u32 size;
> > +};
> > +
> > +#define DMABUF_IOCTL_BASE	'D'
> > +#define DMABUF_IOCTL_CREATE	_IOWR(DMABUF_IOCTL_BASE, 0, struct dmabuf_=
create)
> > +#define DMABUF_IOCTL_DELETE	_IOWR(DMABUF_IOCTL_BASE, 1, int)
> > +#define DMABUF_IOCTL_EXPORT	_IOWR(DMABUF_IOCTL_BASE, 2, int)
>=20
> Shouldn't we put this into an uapi header somewhere?

Yes, definitely. I just didn't want to go through all that trouble
before checking that anyone else actually thought this was a good
idea.

There are a few other things that probably need to be solved before this
can be merged, though. For instance, it currently doesn't compile on x86
because it uses dma_alloc_writecombine(). So there's ample room for
improvement.

> Also I think the ioctl interface is a bit convoluted - I'd just make
> one single interface which directly returns a new dma-buf fd. Removing
> it can be handled with close, no other ioctls required imo. The
> explicit export step is kinda only for subsystems that already have an
> existing buffer handle space, but we don't have this here.

I initially thought that this allowed more flexibility, but on the other
hand having to keep track of a number of buffers would add complexity to
the implementation and like you said it's probably not worth it. Also,
it's not like the code currently copes well with multiple buffers being
created. It just chickens out by returning -EBUSY.

The equivalent could be achieved by beefing up the DMABUF_IOCTL_CREATE
thusly:

	struct dmabuf_create {
		__u32 flags;
		__u32 size;
		__u32 fd;
		__u32 pad;
	};

Then use the size and flags parameters as before, but return the file
descriptor to the DMA-BUF in .fd. Then simply keep it open until the
descriptor is closed. That would also seem to be a more reliable
interface since closing the fd just decrements the reference count on
the DMA-BUF and therefore would keep it alive if somebody still kept
around a reference (the importer for instance).

Thierry

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqdGKAAoJEN0jrNd/PrOhtEsP+wfE2sHSCE3ee4QgUMAq3Bq6
GOMOFpF/IgLKMFv4oOlLRV7CNzhf8bB98zcPPzsg+jcZuWG3fkUtd9xxzlw3EFHh
M/oMKFGkpkxd6s1hAFRth8WOswQon+GDIpvb6lWVwyatP0dZjguCR2y2uwxquELo
dY9E+tVjVMBeIDfqLUPsZtRyMXwjX76u5kShubIhp+ZeRXExhYKzPoVzAYUViMYw
k4PelmuSRZoVRZS8SMSzff7vI0HKKADPvBA9oxyv2q5ik15MPrpN14GMDc0Ssxud
9xv+DZsBbMoPC7Daoh2Vbys+E1cuYTVCL2L2hVRIDhUHBics9TF1DT6JdgFaC7Dc
4/R7NSB0gz+JKvv4h2QvICozS3Tlufzu/bDG6lwFhsMLD4KjX2a58fvBdOza6Hlm
dP2ZSQR4Fo0sZ5iOFjnTqS/GhGZ26hMxHPUPvh35uH70BnfaCah/MMIj/tm/TFoS
uFgmUtcgMvTWgOc0rMJ9ImDbnhddz1KiDP7AOjFVKVx3fHRkOmxTAIyIEDdFnscL
SaCHrI5y75pFQHHxaasfol+aDI9gixsPzjeY7C7H+t240Ta/CqmBVt1iOZGAKf7l
84zWtJCJuX0lAF6Xtc9/VLHj2+/uVtBvQe2RBigi5Cl/q440t/pk9/Ts3D5jp2NB
hXmsUKVoBDkN1VNw6Dhx
=VYd/
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
