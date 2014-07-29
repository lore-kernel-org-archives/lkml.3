Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaG2LdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:33:15 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61003 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaG2LdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:33:11 -0400
Date: Tue, 29 Jul 2014 13:33:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] resource: Add device-managed
 request/release_resource()
Message-ID: <20140729113302.GA21732@ulmo.nvidia.com>
References: <1405062505-2606-1-git-send-email-thierry.reding@gmail.com>
 <20140722185002.GC19181@google.com>
 <20140722190120.GM13851@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20140722190120.GM13851@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2014 at 03:01:20PM -0400, Tejun Heo wrote:
> Hello,
>=20
> On Tue, Jul 22, 2014 at 12:50:02PM -0600, Bjorn Helgaas wrote:
> > [+cc Tejun, LKML]
> >=20
> > On Fri, Jul 11, 2014 at 09:08:24AM +0200, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > >=20
> > > Provide device-managed implementations of the request_resource() and
> > > release_resource() functions. Upon failure to request a resource, the
> > > new devm_request_resource() function will output an error message for
> > > consistent error reporting.
> > >=20
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> >=20
> > This seems OK to me, but I don't consider myself a devres maintainer.  I
> > added Tejun and LKML for any comment.  Minor nit below.
>=20
> If there are gonna be users of the interface, sure.
>=20
> > > +int devm_request_resource(struct device *dev, struct resource *root,
> > > +			  struct resource *new)
> > > +{
> > > +	struct resource *conflict, **ptr;
> > > +
> > > +	ptr =3D devres_alloc(devm_resource_release, sizeof(*ptr), GFP_KERNE=
L);
> > > +	if (!ptr)
> > > +		return -ENOMEM;
> > > +
> > > +	*ptr =3D new;
> > > +
> > > +	conflict =3D request_resource_conflict(root, new);
> > > +	if (!conflict) {
> > > +		devres_add(dev, ptr);
> > > +		return 0;
> > > +	}
> > > +
> > > +	dev_err(dev, "resource collision: %pR conflicts with %s %pR\n", new,
> > > +		conflict->name, conflict);
> > > +	devres_free(ptr);
> > > +	return -EBUSY;
> >=20
> > Personally I would write this as:
> >=20
> >   conflict =3D request_resource_conflict(...);
> >   if (conflict) {
> >     dev_err(...);
> >     devres_free(...);
> >     return -EBUSY;
> >   }
> >=20
> >   devres_add(...);
> >   return 0;
> >=20
> > so the straight-line path is the normal, non-error path and errors are
> > detected and dealt with in the "if" bodies.  Right now the "if" bodies
> > are a mix of error handling and normal path.  But that's just my person=
al
> > preference.
>=20
> Agreed.
>=20
> > > +static int devm_resource_match(struct device *dev, void *res, void *=
data)
> > > +{
> > > +	struct resource **ptr =3D res;
> > > +
> > > +	if (WARN_ON(!ptr || !*ptr))
> > > +		return 0;
>=20
> How would !ptr or !*ptr possibly happen?  Wouldn't that be a bug
> already?

Honestly, I copied that from similar implementations. But checking the
code again, I don't think they can actually happen. The value returned
by devres_alloc() is a struct devres * with an added offset so that it
points at the payload immediately following the struct devres. So at
least !ptr can never happen.

!*ptr could happen since the devres code calls the match function on
every resource managed for the device and someone could've inserted a
NULL (or 0) value. But since we're not dereferencing *ptr this should
not be an issue. That said, having either res or data above be NULL
isn't something that devres was meant to deal with anyway, since it
relies on the pointers being unique for the matching.

Thierry

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT14ZuAAoJEN0jrNd/PrOhRvkP/RdgBG+pCc5uzZnj+9QEFfKS
0ArAQn5oLCn7VNPbnELU9z53JpDZMvite2H8R6HksifF6ZN56skOypr6gy9T8aOM
hn206DvUSYB8BWj17fJaDfFe+X1IXT8nLYyHxJoMrGvJubs0aRaST5EPKK6uvtOo
jFdHuHRFsLeA++qIaH44uoaIDaHGNUms1/kvogT3Afa9QJTUPfr6FGx4ExU9ifcU
4DmZrepwS1UtYxxuSjFsZDvVAzYu06yBoT5xReEN+un1SiUIKb2uyyvCFDY0dNmv
V5ugte1gvSrVOkRCrkt8gZn163PdL7s/zAL86yhv9BA0zJ/KlwnvGR7z5kygs1wa
p+t5/VRN6IEWbsFe1Fsrd7TN+YsShBfMTzaRB7SJ44kS4S/IADQmym/DauytWnxX
zm0wjjUFHmOG1xTeZjm+tYKckhhFjjiLUiABDnhZfqLxfq8TcLu5MxqxHoZrJQE3
36WsNvR2HFFtRJWyiIlnH05rtkb+1Wo18ur9rA4Nq20YQuPHP6J15nasj075YlOy
vLUZvnL9H/cVKJsTSR+LbV9E7oG+KYYibTVChMhcawVmYJbsdgQ9cgixq7EAIMu/
9iitR/Z/0X/RQ4Ag8cGwo7F6STVuQ3+QdolFrQvcQtxHmPe62rFVVo5QbS375YE2
yWF0ZIh9tByyPAjxwVJe
=tNi4
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
