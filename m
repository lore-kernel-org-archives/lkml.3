Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3HPWWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:22:43 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:49685 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3HPWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:22:25 -0400
Date: Fri, 16 Aug 2013 23:55:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
Message-ID: <20130816215530.GA14464@mithrandir>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
 <1376685563-1053-3-git-send-email-treding@nvidia.com>
 <20130816210637.GC2198@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20130816210637.GC2198@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2013 at 02:06:37PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Aug 16, 2013 at 10:39:21PM +0200, Thierry Reding wrote:
> > +static DEFINE_MUTEX(device_early_mutex);
> > +static LIST_HEAD(device_early_list);
> > +static bool device_is_early =3D true;
> > +
> > +/*
> > + * Keep a list of early registered devices so that they can be fully
> > + * registered at a later point in time.
> > + */
> > +static void device_early_add(struct device *dev)
>=20
> __init?

Yes.

> > +{
> > +	mutex_lock(&device_early_mutex);
> > +	list_add_tail(&dev->p->early, &device_early_list);
> > +	mutex_unlock(&device_early_mutex);
> > +}
> > +
> > +/*
> > + * Mark the early device registration phase as completed.
> > + */
> > +int __init device_early_init(void)
> > +{
> > +	device_is_early =3D false;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Fixup platform devices instantiated from device tree. The problem is
> > + * that since early registration happens before interrupt controllers
> > + * have been setup, the OF core code won't know how to map interrupts.
> > + */
> > +int __init platform_device_early_fixup(struct platform_device *pdev)
>=20
> This shouldn't be in this file, because:
>=20
> > +/*
> > + * Fully register early devices.
> > + */
> > +int __init device_early_done(void)
> > +{
> > +	struct device_private *private;
> > +
> > +	list_for_each_entry(private, &device_early_list, early) {
> > +		struct device *dev =3D private->device;
> > +		int err;
> > +
> > +		if (dev->bus =3D=3D &platform_bus_type) {
>=20
> Why special case the platform bus?  We are trying to move things off of
> the platform bus, don't make it harder to do that :)

I heard about that, but I must have missed the thread where this was
discussed. Can you point me to it?

> > +			struct platform_device *pdev =3D to_platform_device(dev);
> > +
> > +			err =3D platform_device_early_fixup(pdev);
> > +			if (err < 0)
> > +				dev_err(&pdev->dev,
> > +					"failed to fixup device %s: %d\n",
> > +					dev_name(&pdev->dev), err);
> > +		}
>=20
> You should just have a bus callback that can be made here that, if
> present, can be called.  That way any bus can handle this type of thing,
> not just the platform one.

You mean something like an .early_fixup() in struct bus_type? That would
indeed be much cleaner. As I mentioned this is a very early prototype
and this particular hunk exists specifically to fixup the platform
devices created by the device tree helpers so that the kernel actually
boots to the login prompt.

> Not that I really like the whole idea anyway, but I doubt there's much I
> can do about it...

Well, getting feedback from you and others is precisely the reason why I
wanted to post this early. There must be a reason why you don't like it,
so perhaps you can share your thoughts and we can mould this into
something that you'd be more comfortable with.

To be honest I don't particularly like it either. It's very hackish for
core code. But on the other hand there are a few device/driver ordering
problems that this (or something similar) would help solve. I'm
certainly open to discuss alternatives and perhaps there's a much
cleaner way to solve the problem.

Thierry

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDp/SAAoJEN0jrNd/PrOhPDAP/1cfjih5OXbBVQIcZ3D0Peza
igSR4DLmLQz8QuVJeT82lHr+xNSLrdCBk8x5ToCsz0q7fEcrIBWGfoU3ikGuKYRR
pJjRoYBKi3ZjUFWCzO3S3CfOe0HObXnissy2GmU9gM/eBkWGiBjbRxgJk+03P6QP
hrqMuc0yy2w3isnFRX7QyknDNNX6pIOzo8zUYaO3/3OGsYusNMr/J0k++kPGKm1U
BXMmpJyS/FDU72H0yOSvbTZ8xYgTE2Y8kC03N6pwUrqasVkwuXcVKgdCI6Id8Crm
ZhNl8DdQGNu5ZqX/ja5j93QY9kfngXn18fJKRcvUny3Vv3txjl1G9oIGct6mFATP
2e3fwEMhd2AoIGijq06AsqoxvOTD1jDsS1Epch4kMmmyqInqFwror7XMz73Ib/w0
EUkSisqM6xRQGTiVJwF0SKtibQbaiH9B7VSPcMGvxWIpcQdJqcK5IrqlzUevgr0B
0vDAs6jN45wXZ5/WlPZG7/87saWuCInWEs2Sw9K6CBA6JQC2ESlYGQoRkOfXpPoA
FkoqsaBrQw3J0B7e7fYF/AZc7gFxw1G6wIeBbFpQPrftkV5xN9rjO/qJg7KDLWCW
WmMGkqYHbqJ4VL2ctsBNKV3AbcNSaqVGfsCqNt5yzuRYgNGXcTCyAuF7IhjKm9wo
RSgrmnpFrBTgf4YxdJYx
=dpU5
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
