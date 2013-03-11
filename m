Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3CKJll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:41:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3CKJlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:41:39 -0400
Date: Mon, 11 Mar 2013 10:41:31 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 3/8] gpu: host1x: Add channel support
Message-ID: <20130311094131.GA9421@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-4-git-send-email-tbergstrom@nvidia.com>
 <20130225152457.GA29545@avionic-0098.mockup.avionic-design.de>
 <512C84E2.5090201@nvidia.com>
 <513A0ED0.4070701@nvidia.com>
 <20130308204301.GA30742@avionic-0098.mockup.avionic-design.de>
 <513D79E7.5000801@nvidia.com>
 <20130311071851.GA6033@avionic-0098.mockup.avionic-design.de>
 <513DA201.9010707@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <513DA201.9010707@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:1k83JGv/GVCJ+AkzKPX+y4q2GsQU3gnCl1YJ1OB9fSi
 wvnn7ofRKAMe7+tUCupkVmwSkPYWDEcxC8mC/Fq0OyNhe2nqKV
 OZBU26R3POFzqGwlK2xV0CuPaDZKcpnuDEUebKnKlHtpjYN7fN
 1hT3B0tIxD2ztYV/EGev/UbDREzAxk0JrlVLOFK1yCx8LhN4oH
 o0w2OF59TNWu5eGD8cQxCuZJYqiihowMrzocHGQJoxOXe/BGLy
 qREaxxhVMqMp4yrpQpH2Cqaj+olWfZ5Hc2c82vY9KgzUOvCKYu
 JgKBI67qfxCoYQ+paHycZ4FKqhB0bxZLwgL9rs9sYzzP9pQc7S
 vk9i6exBtJhF0vFaaz9zJviGxlCymxwmsVYn0BvT1C8xAeRXi7
 GghTWTqtjIC53Ur9xOf0lVJdla27duFnXOHA3+z2mWUpn+44A7
 pUGLo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2013 at 11:21:05AM +0200, Terje Bergstr=C3=B6m wrote:
> On 11.03.2013 09:18, Thierry Reding wrote:
> > This sound a bit over-engineered at this point in time. DRM is currently
> > the only user. Is anybody working on any non-DRM drivers that would use
> > this?
>=20
> Well, this contains beginning of that:
>=20
> http://nv-tegra.nvidia.com/gitweb/?p=3Dlinux-2.6.git;a=3Dblob;f=3Ddrivers=
/media/video/tegra_v4l2_camera.c;h=3D644d0be5380367aca4c826c49724c03aad0838=
7c;hb=3Dl4t/l4t-r16-r2
>=20
> I don't want to give these guys any excuse not to port it over to host1x
> code base. :-)

I was aware of that driver but I didn't realize it had been available
publicly. It's great to see this, though, and one more argument in
favour of not binding the host1x_bo too tightly to DRM/GEM.

> > So how about the following proposal, which I think might satisfy both of
> > us:
> >=20
> > 	struct host1x_bo;
> >=20
> > 	struct host1x_bo_ops {
> > 		struct host1x_bo *(*get)(struct host1x_bo *bo);
> > 		void (*put)(struct host1x_bo *bo);
> > 		dma_addr_t (*pin)(struct host1x_bo *bo, struct sg_table **sgt);
> > 		...
> > 	};
> >=20
> > 	struct host1x_bo *host1x_bo_get(struct host1x_bo *bo);
> > 	void host1x_bo_put(struct host1x_bo *bo);
> > 	dma_addr_t host1x_bo_pin(struct host1x_bo *bo, struct sg_table **sgt);
> > 	...
> >=20
> > 	struct host1x_bo {
> > 		const struct host1x_bo_ops *ops;
> > 		...
> > 	};
> >=20
> > 	struct tegra_drm_bo {
> > 		struct host1x_bo base;
> > 		...
> > 	};
> >=20
> > That way you can get rid of the host1x_memmgr_create_handle() helper and
> > instead embed host1x_bo into driver-/framework-specific structures with
> > the necessary initialization.
>=20
> This would make sense. We'll get back when we have enough of
> implementation done to understand it all. One consequence is that we
> cannot use drm_gem_cma_create() anymore. We'll have to introduce a
> function that does the same as drm_gem_cma_create(), but it takes a
> pre-allocated drm_gem_cma_object pointer. That way we can allocate the
> struct, and use DRM CMA just to initialize the drm_gem_cma_object.

I certainly think that introducing a drm_gem_cma_object_init() function
shouldn't pose a problem. If you do, make sure to update the existing
drm_gem_cma_create() to use it. Having both lets users have the choice
to use drm_gem_cma_create() if they don't need to embed it, or
drm_gem_cma_object_init() otherwise.

> Other way would be just taking a copy of DRM CMA helper, but I'd like to
> defer that to the next step when we implement IOMMU aware allocator.

I'm not sure I understand what you're saying, but if you add a function
as discussed above this shouldn't be necessary.

> > It also allows you to interact directly with the objects instead of
> > having to go through the memmgr API. The memory manager doesn't really
> > exist anymore so keeping the name in the API is only confusing. Your
> > current proposal deals with memory handles directly already so it's
> > really just making the naming more consistent.
>=20
> The memmgr APIs are currently just a shortcut wrapper to the ops, so in
> that sense the memmgr does not really exist. I think it might still make
> sense to keep static inline wrappers for calling the ops within, but we
> could rename them to host1x_bo_somethingandother. Then it'd follow the
> pattern we are using for the hw ops in the latest set.

Yes, that's exactly what I had in mind in the above proposal. They could
be inline, but it's probably also okay if they're not. They aren't meant
to be used very frequently so the extra function call shouldn't matter
much. It might be easier to do add some additional checks if they aren't
inlined. I'm fine either way.

Thierry

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPabLAAoJEN0jrNd/PrOhMpsQAI1l0q8bEmBoU2cOkEU1++J9
5P5m9eMdKYq4lD7oFmqIKhf5g78kDnglfz8LSkbjkY3m5zsIe0Vj5UiB7CWdta21
mlzODK09LdtzvGQg47DUK00ly3q2NdN41QRylel3JHhOVQ0pT484BqdXCZqI1csH
hJhKhGeWqmd/Fr47Yz6SPFKj2tTRYIPBQerivJz8Q8eC0t2sN8Wzn58cJi+AWBBO
K6ODhDWiUy2hCKlzyAy8egA7lSrIZ5EWmYoIf3rrOygdbYLT69eizTn5hMqrwIAd
C4XI87OHxICCDZe4WI2gRZCHD8JU6EWX8ssdZvivcPIAeZrm7SXn5TjSIwtNiLkD
uMKatCx4Hj3PaiYNjIJnkKRkM39VFkxLlxDvGSfsA8CLOpoqWyDeU+0ZpiHiZrG6
pkxSy1hYP8BU8QlxnnsfSvhvPenq6u0bpav6yakCaNuo+ff4jGLTpL/NUi5DQc9n
HdR2C/6cni7XBrSv413SXEkUQfLeaXFGPmjM92/7lELdUTb5bG56/V4nkLdP4LhS
BoIHBkJbJyBVAmK3QPpdv+muD2UnGUqdpTP4cvRYqgvbi9PxNM9iVhnUf5ik2udB
Y20j/ZPr0o73TX3s9qagJcRz26a+S9XXNmzfo8S+36i+TD4Ln6HBUM8BQ3askhOd
YtB0oq4eu/pzOm6Ikkss
=IbQd
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
