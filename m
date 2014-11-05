Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaKEJN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:13:59 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33558 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaKEJN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:13:56 -0500
Date: Wed, 5 Nov 2014 10:13:53 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] core: Add generic object registry implementation
Message-ID: <20141105091351.GA12033@ulmo>
References: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
 <20141104163845.GA369@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20141104163845.GA369@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2014 at 08:38:45AM -0800, Greg Kroah-Hartman wrote:
> On Tue, Nov 04, 2014 at 05:29:27PM +0100, Thierry Reding wrote:
[...]
> > diff --git a/drivers/base/registry.c b/drivers/base/registry.c
[...]
> > +/**
> > + * registry_record_ref - reference on the registry record
> > + * @record: record to reference
> > + *
> > + * Increases the reference count on the record and returns a pointer t=
o it.
> > + *
> > + * Return: A pointer to the record on success or NULL on failure.
> > + */
> > +struct registry_record *registry_record_ref(struct registry_record *re=
cord)
> > +{
> > +	if (!record)
> > +		return NULL;
> > +
> > +	/*
> > +	 * Refuse to give out any more references if the module owning the
> > +	 * record is being removed.
> > +	 */
> > +	if (!try_module_get(record->owner))
> > +		return NULL;
> > +
> > +	kref_get(&record->kref);
>=20
> You "protect" from a module being removed, but not from someone else
> releasing the kref at the same time.  Where is the lock that prevents
> this from happening?

You're right, we need a record lock to serialize ref/unref.

> And do we really care about module reference counts here?

We need this so that the code of the .release() callback stays in
memory as long as there are any references.

Also we need the module reference count for registries because they
would typically be statically allocated and go away along with a module
when it is unloaded.

> > +/**
> > + * registry_add - add a record to a registry
> > + * @registry: registry to add the record to
> > + * @record: record to add
> > + *
> > + * Tries to increase the reference count of the module owning the regi=
stry. If
> > + * successful adds the new record to the registry.
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int registry_add(struct registry *registry, struct registry_record *re=
cord)
> > +{
> > +	if (!try_module_get(registry->owner))
> > +		return -ENODEV;
> > +
> > +	mutex_lock(&registry->lock);
> > +	list_add_tail(&record->list, &registry->list);
> > +	mutex_unlock(&registry->lock);
>=20
> No incrementing of the reference of the record at all?

I'm not sure if we really need one. Drivers will have to remove the
record from the registry before dropping their reference. I guess we
could throw in another kref_get() here (and a kref_put() in
registry_remove()) for good measure to prevent breakage with buggy
drivers.

> You seem to be using 2 reference counts for the record / registry, a
> module count, and a kref count, which can cause confusion...

There is one reference count (kref actually) per registry record and one
module count for the record owner and the registry owner.

Can you elaborate what you think is confusing? Perhaps I can add more
kerneldoc to clarify.

Thierry

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUWepPAAoJEN0jrNd/PrOhC1IQAKCBbMBPKn4bBQCLDSFZlF8T
KlNe54TXy1bLOjCfxJjfPMowYucbfMkrJgP3g82zmae3gSE7dysodJZlvFFGhTML
XCW6H/EKIlk5SN3loW/tr3YasVJvV1s8eSgxxwyf66x0bKQBunkLfw4ZYSkk5op1
7FwL8SDMl/QQMjydnclNzQEooQxyaOHiaXnGRqCqIIK/Bpx3IVTpMK0PjIlYPl3S
UDKTeg+4thvf64IPTW9uIlJGXRrTN8UZgPjuA5dkPtd1egA1M4F+e2sycN3YIJnC
Bizvl1Hp+yRnzOYJcthYI0CQU4LP0p6vTgQw7UOSDID/YSyMCCXWoVZipkj09TNV
YgPfnB2d46SoVBgYqjctlrnmIOW/yPHznvf3PzY15yeBj5NBvAGWbYC+Gx3hI8YA
3nxIZfjUUbyXogXyfvGt9JUFS080opUcPxP7Etb6pN8yfDJUpkhfXiThN+ZHJoNI
tvUr0HfvXDNP8qmAECwQKJsCbOlw3/9MeQpWokmdQBpolJkuGRqBfvG611OPdCpS
hRRdFbijlr0ymVE2+g3NO1+Y8tyL+faMJu5/koboXZedNoUVAha2rMSRk8azah2W
HDGJXiu+XAi4zwLKRALWMtOVgWq48NgI9zR2OOJ0L3F4efg0zl5oqYx0YAgFaQr5
SCdBwTJv5rJR3Y4asrY9
=iKSF
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
