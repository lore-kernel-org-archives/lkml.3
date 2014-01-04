Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaADSO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 13:14:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbaADSO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 13:14:27 -0500
Message-ID: <52C84F76.6010505@suse.com>
Date: Sat, 04 Jan 2014 13:14:14 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH] kobject: provide kobject_put_wait to fix module unload
 race
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="A4jqelDbEGRqfVMpAGpW1gOs0FCn1Ekkj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A4jqelDbEGRqfVMpAGpW1gOs0FCn1Ekkj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 1/4/14, 1:06 PM, Mikulas Patocka wrote:
> Hi
>=20
> I noticed that Jeff Mahoney added a new structure kobj_completion, defi=
ned=20
> in include/linux/kobj_completion.h to the kernel 3.13-rc1 in the patch =

> eee031649707db3c9920d9498f8d03819b74fc23. In the current upstream kerne=
l,=20
> this interface is still unused.
>=20
> However, converting the drivers to use kobj_completion is not trivial=20
> (note that all users of the original kobject interface are buggy - so a=
ll=20
> of them need to be converted).
>=20
> I came up with a simpler patch to achieve the same purpose - this patch=
=20
> makes fixing the drivers easy - the driver is fixed just by replacing=20
> "kobject_put" with "kobject_put_wait" in the unload routine.
>=20
> I'd like to ask if you could revert=20
> eee031649707db3c9920d9498f8d03819b74fc23 (no code uses it) and replace =
it=20
> with this patch.

I have no objections to reverting it. There were concerns from Al Viro
that it'd be tough to get right by callers and I had assumed it got
dropped after that. I had planned on using it in my btrfs sysfs exports
patchset but came up with a better way.

-Jeff

> See http://www.redhat.com/archives/dm-devel/2013-October/msg00141.html =
for=20
> the bug that this patch fixes.
>=20
> Mikulas
>=20
>=20
>=20
> From: Mikulas Patocka <mpatocka@redhat.com>
>=20
> This patch introduces a new function kobject_put_wait. It decrements th=
e
> kobject reference count, waits until the count reaches zero. When this
> function returns, it is guaranteed that the kobject was freed.
>=20
> A rationale for this function:
>=20
> The kobject is keeps a reference count. The driver unload routine
> decrements the reference count, however, references to the kobject may
> still be held by other kernel subsystems. The driver must not free the
> memory that contains the kobject. Instead, the driver provides a "relea=
se"
> method. The "release" method is called by the kernel when the last kobj=
ect
> refernce is dropped. The "release" method should free the memory that
> contains the kobject.
>=20
> However, this pattern is buggy with respect to modules. The release met=
hod
> is placed in the driver's module. When the driver exits, the module
> reference count is zero, thus the module may be freed. However, there m=
ay
> still be references to the kobject. If the module is unloaded and then =
the
> release method is called, a crash happens.
>=20
> Recently, CONFIG_DEBUG_KOBJECT_RELEASE was added. This option deliberat=
ely
> provokes this race condition.
>=20
> This patch fixes the bug by providing new function kobject_put_wait.
> kobject_put_wait works like kobject_put, but it also waits until all ot=
her
> references were dropped and until the kobject was freed. When
> kobject_put_wait returns, it is guaranteed that the kobject was release=
d
> with the release method.
>=20
> Thus, we can change kobject_put to kobject_put_wait in the unload routi=
ne=20
> of various drivers to fix the above race condition.
>=20
> This patch fixes it for device mapper. Note that all kobject users in=20
> modules should be fixed to use this function.
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@kernel.org
>=20
> ---
>  drivers/md/dm-sysfs.c   |    2 +-
>  include/linux/kobject.h |    3 +++
>  lib/kobject.c           |   34 +++++++++++++++++++++++++++++-----
>  3 files changed, 33 insertions(+), 6 deletions(-)
>=20
> Index: linux-3.13-rc6/include/linux/kobject.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.13-rc6.orig/include/linux/kobject.h	2014-01-02 23:13:24.000=
000000 +0100
> +++ linux-3.13-rc6/include/linux/kobject.h	2014-01-02 23:14:02.00000000=
0 +0100
> @@ -27,6 +27,7 @@
>  #include <linux/wait.h>
>  #include <linux/atomic.h>
>  #include <linux/workqueue.h>
> +#include <linux/completion.h>
> =20
>  #define UEVENT_HELPER_PATH_LEN		256
>  #define UEVENT_NUM_ENVP			32	/* number of env pointers */
> @@ -66,6 +67,7 @@ struct kobject {
>  	struct kobj_type	*ktype;
>  	struct sysfs_dirent	*sd;
>  	struct kref		kref;
> +	struct completion	*free_completion;
>  #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
>  	struct delayed_work	release;
>  #endif
> @@ -106,6 +108,7 @@ extern int __must_check kobject_move(str
> =20
>  extern struct kobject *kobject_get(struct kobject *kobj);
>  extern void kobject_put(struct kobject *kobj);
> +extern void kobject_put_wait(struct kobject *kobj);
> =20
>  extern const void *kobject_namespace(struct kobject *kobj);
>  extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
> Index: linux-3.13-rc6/lib/kobject.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.13-rc6.orig/lib/kobject.c	2014-01-02 23:13:23.000000000 +01=
00
> +++ linux-3.13-rc6/lib/kobject.c	2014-01-02 23:17:01.000000000 +0100
> @@ -172,6 +172,7 @@ static void kobject_init_internal(struct
>  	if (!kobj)
>  		return;
>  	kref_init(&kobj->kref);
> +	kobj->free_completion =3D NULL;
>  	INIT_LIST_HEAD(&kobj->entry);
>  	kobj->state_in_sysfs =3D 0;
>  	kobj->state_add_uevent_sent =3D 0;
> @@ -577,15 +578,11 @@ static void kobject_cleanup(struct kobje
>  {
>  	struct kobj_type *t =3D get_ktype(kobj);
>  	const char *name =3D kobj->name;
> +	struct completion *free_completion =3D kobj->free_completion;
> =20
>  	pr_debug("kobject: '%s' (%p): %s, parent %p\n",
>  		 kobject_name(kobj), kobj, __func__, kobj->parent);
> =20
> -	if (t && !t->release)
> -		pr_debug("kobject: '%s' (%p): does not have a release() "
> -			 "function, it is broken and must be fixed.\n",
> -			 kobject_name(kobj), kobj);
> -
>  	/* send "remove" if the caller did not do it but sent "add" */
>  	if (kobj->state_add_uevent_sent && !kobj->state_remove_uevent_sent) {=

>  		pr_debug("kobject: '%s' (%p): auto cleanup 'remove' event\n",
> @@ -611,6 +608,10 @@ static void kobject_cleanup(struct kobje
>  		pr_debug("kobject: '%s': free name\n", name);
>  		kfree(name);
>  	}
> +
> +	/* if someone is waiting for the kobject to be freed, wake him up */
> +	if (free_completion)
> +		complete(free_completion);
>  }
> =20
>  #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
> @@ -651,6 +652,28 @@ void kobject_put(struct kobject *kobj)
>  	}
>  }
> =20
> +/**
> + * kobject_put - decrement refcount for object and wait until it reach=
es zero.
> + * @kobj: object.
> + *
> + * Decrement the refcount, and wait until the refcount reaches zero an=
d the
> + * kobject is freed.
> + *
> + * This function should be called from the driver unload routine. It m=
ust not
> + * be called concurrently on the same kobject. When this function retu=
rns, it
> + * is guaranteed that the kobject was freed.
> + */
> +void kobject_put_wait(struct kobject *kobj)
> +{
> +	if (kobj) {
> +		DECLARE_COMPLETION_ONSTACK(completion);
> +		BUG_ON(kobj->free_completion);
> +		kobj->free_completion =3D &completion;
> +		kobject_put(kobj);
> +		wait_for_completion(&completion);
> +	}
> +}
> +
>  static void dynamic_kobj_release(struct kobject *kobj)
>  {
>  	pr_debug("kobject: (%p): %s\n", kobj, __func__);
> @@ -1076,6 +1099,7 @@ void kobj_ns_drop(enum kobj_ns_type type
> =20
>  EXPORT_SYMBOL(kobject_get);
>  EXPORT_SYMBOL(kobject_put);
> +EXPORT_SYMBOL(kobject_put_wait);
>  EXPORT_SYMBOL(kobject_del);
> =20
>  EXPORT_SYMBOL(kset_register);
> Index: linux-3.13-rc6/drivers/md/dm-sysfs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.13-rc6.orig/drivers/md/dm-sysfs.c	2014-01-02 23:13:24.00000=
0000 +0100
> +++ linux-3.13-rc6/drivers/md/dm-sysfs.c	2014-01-02 23:14:02.000000000 =
+0100
> @@ -104,5 +104,5 @@ int dm_sysfs_init(struct mapped_device *
>   */
>  void dm_sysfs_exit(struct mapped_device *md)
>  {
> -	kobject_put(dm_kobject(md));
> +	kobject_put_wait(dm_kobject(md));
>  }
>=20


--=20
Jeff Mahoney
SUSE Labs


--A4jqelDbEGRqfVMpAGpW1gOs0FCn1Ekkj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJSyE95AAoJEB57S2MheeWyJuUP/01D6HB9DE1kxtxwhxNnzFcU
DKRK0X+vBWkd+MveGJle9MUrOT0CuZqWp3vFEAGClzp5aHYtv+LDnQq/n0z0SbME
D+hcEaQk5Tb1C22V3feaXvU7z/wwA97xfuBCs/265mN9cN5sbkTVVidyobVKEZic
MA0t/6Ed10VfNDaBwV9xntFJvtiHkYJm350/uiinBUGJ7kbHW0b6Cbgp6Wum1vfA
/ZpRH9dOYSSqsKo5PqEkNegS4J2wyUvi8d2x0aaUWEm1aTpFhCZvC1ObdL9x108S
sg3LDBxIR2D/J8KC04/0gUeLuQh9TnNpMneu+zdxTm+gsla/K817wNqy/2qGCuXe
UDrPnKpiBk/wuSR7yb1ehezQqr67Mw8fyqOF48sgeTiaRwWlc8/oaN8XAOiRAdBG
O+OGD2UVdfa7bJW8O4XoaIk/1oVp60oi5/dzo5ghYlA+NjkhIYoW+AyEe0SlK2uS
gSR7tP+jVxgNMpJK1zaYbt7fl0pmADzYDPWej4iWOXtrzU6YYOMbhw3kVkML/1hL
QNReA1IuKy6JOJ5D9cDD26Waw0AETiJgbRuIRyPWTetEIELcWZTvXxxKGfoakZqv
Tv2pJ4atjEU7RoWf+9fs/u/dzfA5oV7CoTDKYfIJNH1KR44mF/wLAoO0Kw5J2uJ4
7zo9mPcDk9Lb7Co4NvJO
=sK0E
-----END PGP SIGNATURE-----

--A4jqelDbEGRqfVMpAGpW1gOs0FCn1Ekkj--
