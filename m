Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3IWKd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:33:29 -0400
Received: from multi.imgtec.com ([194.200.65.239]:45233 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab3IWKd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:33:27 -0400
Message-ID: <524018EA.9070202@imgtec.com>
Date: Mon, 23 Sep 2013 11:33:14 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [REVIEW][PATCH 2/2] sysfs: Restrict mounting sysfs
References: <878uzmhkqg.fsf@xmission.com> <874naahkng.fsf@xmission.com>
In-Reply-To: <874naahkng.fsf@xmission.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="H8cmSvr8pCBufnTMVnmelScsChfrT5LCa"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_09_23_11_33_26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--H8cmSvr8pCBufnTMVnmelScsChfrT5LCa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 27/08/13 22:46, Eric W. Biederman wrote:
>=20
> Don't allow mounting sysfs unless the caller has CAP_SYS_ADMIN rights
> over the net namespace.  The principle here is if you create or have
> capabilities over it you can mount it, otherwise you get to live with
> what other people have mounted.
>=20
> Instead of testing this with a straight forward ns_capable call,
> perform this check the long and torturous way with kobject helpers,
> this keeps direct knowledge of namespaces out of sysfs, and preserves
> the existing sysfs abstractions.
>=20
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Hi,

Unfortunately this patch causes problems for me in v3.12-rc1 if
CONFIG_NET=3Dn. Sysfs fails to mount with EPERM. Having networking enable=
d
seems an odd prerequisite for mounting sysfs :-P.

Cheers
James

> ---
>  fs/sysfs/mount.c           |   12 +++++++++---
>  include/linux/kobject_ns.h |    2 ++
>  lib/kobject.c              |   12 ++++++++++++
>  net/core/net-sysfs.c       |    8 ++++++++
>  4 files changed, 31 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index 4a2da3a..8c69ef4 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -112,9 +112,15 @@ static struct dentry *sysfs_mount(struct file_syst=
em_type *fs_type,
>  	struct super_block *sb;
>  	int error;
> =20
> -	if (!(flags & MS_KERNMOUNT) && !capable(CAP_SYS_ADMIN) &&
> -	    !fs_fully_visible(fs_type))
> -		return ERR_PTR(-EPERM);
> +	if (!(flags & MS_KERNMOUNT)) {
> +		if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
> +			return ERR_PTR(-EPERM);
> +
> +		for (type =3D KOBJ_NS_TYPE_NONE; type < KOBJ_NS_TYPES; type++) {
> +			if (!kobj_ns_current_may_mount(type))
> +				return ERR_PTR(-EPERM);
> +		}
> +	}
> =20
>  	info =3D kzalloc(sizeof(*info), GFP_KERNEL);
>  	if (!info)
> diff --git a/include/linux/kobject_ns.h b/include/linux/kobject_ns.h
> index f66b065..df32d25 100644
> --- a/include/linux/kobject_ns.h
> +++ b/include/linux/kobject_ns.h
> @@ -39,6 +39,7 @@ enum kobj_ns_type {
>   */
>  struct kobj_ns_type_operations {
>  	enum kobj_ns_type type;
> +	bool (*current_may_mount)(void);
>  	void *(*grab_current_ns)(void);
>  	const void *(*netlink_ns)(struct sock *sk);
>  	const void *(*initial_ns)(void);
> @@ -50,6 +51,7 @@ int kobj_ns_type_registered(enum kobj_ns_type type);
>  const struct kobj_ns_type_operations *kobj_child_ns_ops(struct kobject=
 *parent);
>  const struct kobj_ns_type_operations *kobj_ns_ops(struct kobject *kobj=
);
> =20
> +bool kobj_ns_current_may_mount(enum kobj_ns_type type);
>  void *kobj_ns_grab_current(enum kobj_ns_type type);
>  const void *kobj_ns_netlink(enum kobj_ns_type type, struct sock *sk);
>  const void *kobj_ns_initial(enum kobj_ns_type type);
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 4a1f33d..1853bd9 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -915,6 +915,18 @@ const struct kobj_ns_type_operations *kobj_ns_ops(=
struct kobject *kobj)
>  	return kobj_child_ns_ops(kobj->parent);
>  }
> =20
> +bool kobj_ns_current_may_mount(enum kobj_ns_type type)
> +{
> +	bool may_mount =3D false;
> +
> +	spin_lock(&kobj_ns_type_lock);
> +	if ((type > KOBJ_NS_TYPE_NONE) && (type < KOBJ_NS_TYPES) &&
> +	    kobj_ns_ops_tbl[type])
> +		may_mount =3D kobj_ns_ops_tbl[type]->current_may_mount();
> +	spin_unlock(&kobj_ns_type_lock);
> +
> +	return may_mount;
> +}
> =20
>  void *kobj_ns_grab_current(enum kobj_ns_type type)
>  {
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 981fed3..0b0ff95 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1157,6 +1157,13 @@ static void remove_queue_kobjects(struct net_dev=
ice *net)
>  #endif
>  }
> =20
> +static bool net_current_may_mount(void)
> +{
> +	struct net *net =3D current->nsproxy->net_ns;
> +
> +	return !ns_capable(net->user_ns, CAP_SYS_ADMIN);
> +}
> +
>  static void *net_grab_current_ns(void)
>  {
>  	struct net *ns =3D current->nsproxy->net_ns;
> @@ -1179,6 +1186,7 @@ static const void *net_netlink_ns(struct sock *sk=
)
> =20
>  struct kobj_ns_type_operations net_ns_type_operations =3D {
>  	.type =3D KOBJ_NS_TYPE_NET,
> +	.current_may_mount =3D net_current_may_mount,
>  	.grab_current_ns =3D net_grab_current_ns,
>  	.netlink_ns =3D net_netlink_ns,
>  	.initial_ns =3D net_initial_ns,
>=20


--H8cmSvr8pCBufnTMVnmelScsChfrT5LCa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSQBj0AAoJEKHZs+irPybfbtQP+weqGVyb8BP80M455HM/qmh2
QkYT38DBpvP4wivYxI0cne5XJpEheLL/TqNab+JN+oJcB+tdHUjiRBwTCfYDmTvw
ljMVNYzYEkCLdqIbbg49Plcny0EQ4GbmyQlf44vCLakVw2RpR5I4O5cIwm5lmrnt
QWDfeiMYkyPaIJGRnXM0/k0aF/fmOVdXFrjlIqZP3k+gxKRNkxjh8OtRYrfMLmbN
oOJm/hWVTbYcLDlzgBAztil6tM+nWDjzs2bF2Fw5Zjkklvua4SFNuwyjlTlXWTjy
G39VdtQT2qXTqxVniaR1S4SYNrSZQg/jv9erRlyWMWX0lfgwToLmDiW1qEd6SRif
TKr+YknpyWkOi6G5GAAWFEto9nEHO7VwWsazsu965gWqIovaUSCC16oJeR6v1i7/
Fg6eUoLnnjahuykHf9shiq+avavFUyJ25fkIxvqtovC8yr/7+MNxBlLk6WsNzPJZ
0h1UXJtI9UffpKRrCvIiprXKZPR2rv2XGwj5E8EI78mD2qVfn4uTmPCTEiCbDmQ/
TqFff0SHFdKGYJe8966BFYSKr3DMnw9bJi1xpYJxoxYVv51I+r8bO9XoV8a6MrNe
kg9e1TNHLLDfIeE46+m2HSo48e6yYMfDbdgQOdiQ6lBE91majqtbmz1rWC/lDMHE
fFt8KP83sKM73Z6fu1at
=25cz
-----END PGP SIGNATURE-----

--H8cmSvr8pCBufnTMVnmelScsChfrT5LCa--

