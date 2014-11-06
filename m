Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaKFKZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:25:37 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64463 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaKFKZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:25:35 -0500
Date: Thu, 6 Nov 2014 11:25:32 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] core: Add generic object registry implementation
Message-ID: <20141106102531.GI26297@ulmo>
References: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
 <20141104163845.GA369@kroah.com>
 <20141105091351.GA12033@ulmo>
 <20141106021815.GA17253@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G3juXO9GfR42w+sw"
Content-Disposition: inline
In-Reply-To: <20141106021815.GA17253@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G3juXO9GfR42w+sw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 06:18:15PM -0800, Greg Kroah-Hartman wrote:
> On Wed, Nov 05, 2014 at 10:13:53AM +0100, Thierry Reding wrote:
> > On Tue, Nov 04, 2014 at 08:38:45AM -0800, Greg Kroah-Hartman wrote:
> > > On Tue, Nov 04, 2014 at 05:29:27PM +0100, Thierry Reding wrote:
> > [...]
> > > > diff --git a/drivers/base/registry.c b/drivers/base/registry.c
> > [...]
> > > > +/**
> > > > + * registry_record_ref - reference on the registry record
> > > > + * @record: record to reference
> > > > + *
> > > > + * Increases the reference count on the record and returns a point=
er to it.
> > > > + *
> > > > + * Return: A pointer to the record on success or NULL on failure.
> > > > + */
> > > > +struct registry_record *registry_record_ref(struct registry_record=
 *record)
> > > > +{
> > > > +	if (!record)
> > > > +		return NULL;
> > > > +
> > > > +	/*
> > > > +	 * Refuse to give out any more references if the module owning the
> > > > +	 * record is being removed.
> > > > +	 */
> > > > +	if (!try_module_get(record->owner))
> > > > +		return NULL;
> > > > +
> > > > +	kref_get(&record->kref);
> > >=20
> > > You "protect" from a module being removed, but not from someone else
> > > releasing the kref at the same time.  Where is the lock that prevents
> > > this from happening?
> >=20
> > You're right, we need a record lock to serialize ref/unref.
> >=20
> > > And do we really care about module reference counts here?
> >=20
> > We need this so that the code of the .release() callback stays in
> > memory as long as there are any references.
> >=20
> > Also we need the module reference count for registries because they
> > would typically be statically allocated and go away along with a module
> > when it is unloaded.
>=20
> Never use a 'static' variable as a dynamic one with a kref, that's just
> asking for trouble.

The registry itself isn't reference counted, precisely because it is
meant to stay around as long as the subsystem stays around. It also has
the nice benefit that it can be statically initialized and therefore we
don't have to worry about initcall ordering or any of that jazz.

> > > > +/**
> > > > + * registry_add - add a record to a registry
> > > > + * @registry: registry to add the record to
> > > > + * @record: record to add
> > > > + *
> > > > + * Tries to increase the reference count of the module owning the =
registry. If
> > > > + * successful adds the new record to the registry.
> > > > + *
> > > > + * Return: 0 on success or a negative error code on failure.
> > > > + */
> > > > +int registry_add(struct registry *registry, struct registry_record=
 *record)
> > > > +{
> > > > +	if (!try_module_get(registry->owner))
> > > > +		return -ENODEV;
> > > > +
> > > > +	mutex_lock(&registry->lock);
> > > > +	list_add_tail(&record->list, &registry->list);
> > > > +	mutex_unlock(&registry->lock);
> > >=20
> > > No incrementing of the reference of the record at all?
> >=20
> > I'm not sure if we really need one. Drivers will have to remove the
> > record from the registry before dropping their reference. I guess we
> > could throw in another kref_get() here (and a kref_put() in
> > registry_remove()) for good measure to prevent breakage with buggy
> > drivers.
>=20
> Or at least warn people that they need to clean stuff up properly if
> they do not, otherwise they will get it wrong.  You need to make it very
> hard to get wrong.

Perhaps a WARN_ON() if a record is still in the registry when the last
reference is dropped would do the trick? Something like the following
perhaps?

	static void registry_record_release(struct kref *kref)
	{
		struct registry_record *record =3D to_registry_record(kref);

		/*
		 * Drivers must remove the device from the registry before dropping
		 * the last reference. Try to detect this by warning if a record's
		 * last reference goes away but it is still registered.
		 */
		if (WARN_ON(!list_empty(&record->list)))
			list_del_init(&record->list);

		record->release(record);
	}

Unfortunately we don't have a pointer to the registry around at this
point, so we can't do proper locking. In that case perhaps the WARN is
good enough. Alternatively we could keep a pointer to the registry in
each record.

One other alternative would be to not remove the entry at all. That will
likely cause a crash later on but in that case the WARN should be an
indication about what went wrong. Or maybe this should be BUG_ON?

> > > You seem to be using 2 reference counts for the record / registry, a
> > > module count, and a kref count, which can cause confusion...
> >=20
> > There is one reference count (kref actually) per registry record and one
> > module count for the record owner and the registry owner.
>=20
> But both counts are in the same structure, which is a mess.

The refcount makes sure that the data stays around, but the module count
is needed to keep the code around, which will be necessary because the
record owner will typically have code that's called when the last
reference goes away.

> > Can you elaborate what you think is confusing? Perhaps I can add more
> > kerneldoc to clarify.
>=20
> You have 2 references in the same structure, with different lifecycles,
> causing confusion, and odds are, bugs...

The module reference count really belongs to the driver that creates the
records. We just keep a pointer to the module in the record since for
each record reference we need to make sure that we have one module
reference.

> Sure, document it better if you want, but I think something needs to be
> done differently if at all possible.

try_module_get() is the only way I know of that ensures that the code of
a module stays around. Everytime we give out a new reference to a record
we also need to increment the module reference count accordingly to make
sure the underlying code doesn't go away all of a sudden.

I guess that's not entirely accurate. The module reference count doesn't
have to be increment for every record reference, it only needs to track
each record. So the try_module_get() and module_put() could move into
registry_add() and registry_get(), respectively. But the ->owner field
would still be in the record structure.

Would that alleviate your concerns?

Thierry

--G3juXO9GfR42w+sw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUW0ybAAoJEN0jrNd/PrOhMQYP/iQ/brUCPLeQyRYm67MuUVV6
AtHG6V53DlXe2JaKKGjSf/J9gcVyd8qjWp0wJY1289DYdKDH7hqB7igmgEg/KZIr
NG48SXdx1KhJk/F2DuL3C0F+h3KHsobNmOYuJdZ7EKvAxd9ErKJ464nvgUkjK+6P
qiFFvwXKbv8DHApRGhLXFCDcEj2cWWqkudgidipsjZ9JMSaAoX66ARn5hka3zmu1
GqhKoCOndpmE8jaV3x52VJgB+fxi/TjteppnYd15pLYmVB+aZYltLRClB9u93dPV
B9DI6RbT87PiWnjGsl3CHJTwUT5C7Bkiu3qejsVmfYQudN5ItQLh+wG5qsNBJQ6M
WBUJFHiUp25R+heBIubru1+SNhLRM0gBxNyp9YSXAOrPXLzlJpK8g9XzcHlFde10
6L3gWPGwU0tpG38PosKn8CQ+aDH70C7+mCJqrglnBUFqhlXirIBucfuBz7sTYkEj
2o3WgJmveHrHLiQfdOAIyPzLaK5aXTMRpWM6WjGVFVKP9czqTnzFa/mp/65X/rX4
0hCu6UIesMeX8/HE1EQG9HlhbXY7bBdSvxQRW96xrpYkOIgkvLdBkwvCSNwbQrOu
cut5dt/BZb2auPL2N0FA/qrNkrQrUvLYQ/icgx4UEJKgLHxPd0YoHlb83ph27KFr
AIRj61jt+12ffK6K/76G
=sVev
-----END PGP SIGNATURE-----

--G3juXO9GfR42w+sw--
