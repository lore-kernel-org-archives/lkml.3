Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3BEJyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:54:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3BEJyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:54:13 -0500
Date: Tue, 5 Feb 2013 10:54:04 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 8/8] drm: tegra: Add gr2d device
Message-ID: <20130205095403.GF20437@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-9-git-send-email-tbergstrom@nvidia.com>
 <20130204125618.GD595@avionic-0098.mockup.avionic-design.de>
 <511095F9.6040607@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dgjlcl3Tl+kb3YDk"
Content-Disposition: inline
In-Reply-To: <511095F9.6040607@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:TZr4I+pKpxREoBcL1G2I2yP/MEB3hYHLCHZpKG+t6b8
 zjUmD0zPTQEdIzUMofeiKeNNLEA0mWVfEETQu9epUoYuI+/fra
 Cp0mLQUbj5xRuGnyDgoO8b/0g5Sa/H7esiqluI0N1wXbkFP134
 HQK1MATlO5m6eebxGs2GLCdRi6gKFaEDy3uevqgZA6JbNtqc/l
 bZ0T4fC5DHDsMgT0IHgX3i8BJfcWSdndlGSnArLi88nqocVWuf
 BnUQgPHcYPtl6isF3qnh3cHzrFrIdDgc+Li9GtzhvlF465eJnF
 Bs331kyAvfnuggVsJ2zw0YKuSkyRZi5Ea5ENbMKtYkLYReBgHu
 OrDgsgkaan/IlDh0nHTRXmq4k/GBHbJNjhsoRHH0LZ8AV6FtIx
 Lk53aC+UA2uvFN79F6YGcxy6m7pvayDvN4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2013 at 09:17:45PM -0800, Terje Bergstr=C3=B6m wrote:
> On 04.02.2013 04:56, Thierry Reding wrote:
> > On Tue, Jan 15, 2013 at 01:44:04PM +0200, Terje Bergstrom wrote:
> >> +{
> >> +     struct host1x *host1x =3D drm->dev_private;
> >> +     struct tegra_drm_syncpt_read_args *args =3D data;
> >> +     struct host1x_syncpt *sp =3D
> >> +             host1x_syncpt_get_bydev(host1x->dev, args->id);
> >=20
> > I don't know if we need this, except maybe to work around the problem
> > that we have two different structures named host1x. The _bydev() suffix
> > is misleading because all you really do here is obtain the syncpt from
> > the host1x.
>=20
> Yeah, it's actually working around the host1x duplicate naming.
> host1x_syncpt_get takes struct host1x as parameter, but that's different
> host1x than in this code.

So maybe a better way would be to rename the DRM host1x after all. If it
avoids the need for workarounds such as this I think it justifies the
additional churn.

> > Also, how useful is it to create a context? Looking at the gr2d
> > implementation for .open_channel(), it will return the same channel to
> > whichever userspace process requests them. Can you explain why it is
> > necessary at all? From the name I would have expected some kind of
> > context switching to take place when different applications submit
> > requests to the same client, but that doesn't seem to be the case.
>=20
> Hardware context switching will be a later submit, and it'll actually
> create a new structure. Hardware context might live longer than the
> process that created it, so they'll need to be separate.

Why would it live longer than the process? Isn't the whole purpose of
the context to keep per-process state? What use is that state if the
process dies?

> We've used the context as a place for storing flags and the reference to
> hardware context. It'd allow also opening channels to multiple devices,
> and context would be used in submit to find out the target device. But
> as hardware context switching is not implemented in this patch set, and
> neither is support for anything but 2D, it's difficult to justify it.
>=20
> Perhaps the justification is that this way we can keep the kernel API
> stable even when we add support for hardware contexts and other clients.

We don't need a stable kernel API. But I guess it is fine to keep it if
for no other reason to fill the context returned in the ioctl() with
meaningful data.

> >> diff --git a/drivers/gpu/host1x/drm/drm.h b/drivers/gpu/host1x/drm/drm=
=2Eh
> > [...]
> >> +struct host1x_drm_fpriv {
> >> +     struct list_head contexts;
> >>  };
> >=20
> > Maybe name this host1x_drm_file. fpriv isn't very specific.
>=20
> host1x_drm_file sounds a bit odd, because it's not really a file, but a
> private data pointer stored in driver_priv.

The same is true for struct drm_file, which is stored in struct file's
=2Eprivate_data field. I find it to be very intuitive if the inheritance
is reflected in the structure name. struct host1x_drm_file is host1x'
driver-specific part of struct drm_file.

> >> +static u32 handle_cma_to_host1x(struct drm_device *drm,
> >> +                             struct drm_file *file_priv, u32 gem_hand=
le)
> >> +{
> >> +     struct drm_gem_object *obj;
> >> +     struct drm_gem_cma_object *cma_obj;
> >> +     u32 host1x_handle;
> >> +
> >> +     obj =3D drm_gem_object_lookup(drm, file_priv, gem_handle);
> >> +     if (!obj)
> >> +             return 0;
> >> +
> >> +     cma_obj =3D to_drm_gem_cma_obj(obj);
> >> +     host1x_handle =3D host1x_memmgr_host1x_id(mem_mgr_type_cma, (u32=
)cma_obj);
> >> +     drm_gem_object_unreference(obj);
> >> +
> >> +     return host1x_handle;
> >> +}
> >=20
> > I though we had settled in previous reviews on only having a single
> > allocator and not do the conversion between various types?
>=20
> I'll need to agree with Lucas on how to handle this. He intended to make
> a patch to fix this, but he hasn't had time to do that.
>=20
> But, I'd still like to keep the possibility open to add dma_buf as
> memory handle type, and fit that into the same API, so there's still a
> need to have the mem_mgr_type abstraction.

I fail to see how dma_buf would require a separate mem_mgr_type. Can we
perhaps postpone this to a later point and just go with CMA as the only
alternative for now until we have an actual working implementation that
we can use this for?

> >> +static int gr2d_submit(struct host1x_drm_context *context,
> >> +             struct tegra_drm_submit_args *args,
> >> +             struct drm_device *drm,
> >> +             struct drm_file *file_priv)
> >> +{
> >> +     struct host1x_job *job;
> >> +     int num_cmdbufs =3D args->num_cmdbufs;
> >> +     int num_relocs =3D args->num_relocs;
> >> +     int num_waitchks =3D args->num_waitchks;
> >> +     struct tegra_drm_cmdbuf __user *cmdbufs =3D
> >> +             (void * __user)(uintptr_t)args->cmdbufs;
> >> +     struct tegra_drm_reloc __user *relocs =3D
> >> +             (void * __user)(uintptr_t)args->relocs;
> >> +     struct tegra_drm_waitchk __user *waitchks =3D
> >> +             (void * __user)(uintptr_t)args->waitchks;
> >=20
> > No need for all the uintptr_t casts.
>=20
> Will try to remove - but I do remember getting compiler warnings without
> them.

I think you shouldn't even have to cast to void * first. Just cast to
the target type directly. I don't see why the compiler should complain.

> (...)
> > Most of this looks very generic. Can't it be split out into separate
> > functions and reused in other (gr3d) modules?
>=20
> That's actually how most of this is downstream. I thought to make
> everything really simple and make it all 2D specific in the first patch
> set, and split into generic when we add support for another device.

Okay, that's fine then.

> >> +static int gr2d_is_addr_reg(struct platform_device *dev, u32 class, u=
32 reg)
> >> +{
> >> +     int ret;
> >> +
> >> +     if (class =3D=3D NV_HOST1X_CLASS_ID)
> >> +             ret =3D reg =3D=3D 0x2b;
> >> +     else
> >> +             switch (reg) {
> >> +             case 0x1a:
> >> +             case 0x1b:
> >> +             case 0x26:
> >> +             case 0x2b:
> >> +             case 0x2c:
> >> +             case 0x2d:
> >> +             case 0x31:
> >> +             case 0x32:
> >> +             case 0x48:
> >> +             case 0x49:
> >> +             case 0x4a:
> >> +             case 0x4b:
> >> +             case 0x4c:
> >> +                     ret =3D 1;
> >> +                     break;
> >> +             default:
> >> +                     ret =3D 0;
> >> +                     break;
> >> +             }
> >> +
> >> +     return ret;
> >> +}
> >=20
> > I should probably bite the bullet and read through the (still) huge
> > patch 3 to understand exactly why this is needed.
>=20
> That's the security firewall. It walks through each submit, and ensures
> that each register write that writes an address, goes through the host1x
> reloc mechanism. This way user space cannot ask 2D to write to arbitrary
> memory locations.

I see. Can this be made more generic? Perhaps adding a table of valid
registers to the device and use a generic function to iterate over that
instead of having to provide the same function for each client.

> >> +static int __exit gr2d_remove(struct platform_device *dev)
> >> +{
> >> +     struct host1x *host1x =3D
> >> +             host1x_get_drm_data(to_platform_device(dev->dev.parent));
> >> +     struct gr2d *gr2d =3D platform_get_drvdata(dev);
> >> +     int err;
> >> +
> >> +     err =3D host1x_unregister_client(host1x, &gr2d->client);
> >> +     if (err < 0) {
> >> +             dev_err(&dev->dev, "failed to unregister host1x client: =
%d\n",
> >> +                     err);
> >> +             return err;
> >> +     }
> >> +
> >> +     host1x_syncpt_free(gr2d->syncpt);
> >> +     return 0;
> >> +}
> >=20
> > Isn't this missing a host1x_channel_put() or host1x_free_channel()?
>=20
> All references should be handled in gr2d_open_channel() and
> gr2d_close_channel(). I think we'd need to ensure all contexts are
> closed at this point.

Yes, that'd work as well. Actually I would assume that all contexts
associated with a given file should be freed when the file is closed.
That way all of this should work pretty much automatically.

> >> +struct tegra_drm_syncpt_wait_args {
> >> +     __u32 id;
> >> +     __u32 thresh;
> >> +     __s32 timeout;
> >> +     __u32 value;
> >> +};
> >> +
> >> +#define DRM_TEGRA_NO_TIMEOUT (-1)
> >=20
> > Is this the only reason why timeout is signed? If so maybe a better
> > choice would be __u32 and DRM_TEGRA_NO_TIMEOUT 0xffffffff.
>=20
> I believe it is so. In fact we'd need to rename it to something like
> INFINITE_TIMEOUT, because we also have a case of timeout=3D0, which
> returns immediately, i.e. doesn't have a timeout either.

For timeout =3D=3D 0 I don't think we need a symbolic name. It is pretty
common for 0 to mean no timeout. But yes, DRM_TEGRA_INFINITE_TIMEOUT
should be okay.

> >> +struct tegra_drm_syncpt_incr {
> >> +     __u32 syncpt_id;
> >> +     __u32 syncpt_incrs;
> >> +};
> >=20
> > Maybe the fields would be better named id and incrs. Though I also
> > notice that incrs is never used. I guess that's supposed to be used in
> > the future to allow increments by more than a single value. If so,
> > perhaps value would be a better name.
>=20
> It's actually used in the dreaded patch 3, as part of tegra_drm_submit_ar=
gs.

Okay. The superfluous syncpt_ prefixes should still go away.

Thierry

--dgjlcl3Tl+kb3YDk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRENa7AAoJEN0jrNd/PrOhCyEP/A3roS+c/M0mH6QXMy6cm/UV
eWVBqqLSLTLg2+eBA4iwt7jOdNXysPqodt5GH3KMmb56ZJ9aoTlFLGdPJnuiLJAP
DzU0+JbPjur6tSJAmGCixcaQdUI5T0Z6O/h/OcHo9o92dSI3AJn2Ir/TsKUISKzj
yOZig1K0lPGHt8c5HBcjcJEVj1zge3aAoQrvb/qkwMwRLVspWXnskG/I/OTVshEr
TAiaAJuh0ELG5LOyZc3l+4HDMRuq+GA/hIz8Z+jbDfytsymRBm0jH2dQvgv62pyt
TJI1/ip7xLGo8TvjEeJD3tcsX9gPKbHnFF92QaV+cKGpi2d88xCvDPW2p6tDxros
7lPUYDEGqh/36A+oqwkcMRc/DtXIAyjPIglz9YA3vAduoyX10y0e/j3UNoBZnbjt
OsQvyDKqQh3N1dhfg/VwuxdjjkHXUdHcTWgf3zASz+v7UOfDweptbsHIybUuLDLb
vkrJCzUWQvZ0jMPCx8Y+khCa7l6aoUsddFgP6bbpxWE9n1Sedh36iClIHaNRJrZh
ATfzzZ3RhY7HOFOA86g2DaN5v0phQGmRMHN928S2QLwU0aUsOUxkuOarjVhuPCZ/
r9yfaicJQFqoqZJTDOJo21YG5JOSiLEdfDiGnt0X1PzsswYMnEKsHSSk9F1XrOZn
uhFTL1wmMlD7CpDuYpSS
=6/Q0
-----END PGP SIGNATURE-----

--dgjlcl3Tl+kb3YDk--
