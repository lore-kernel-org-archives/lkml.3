Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021AbaLPDVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 22:21:20 -0500
Received: from ozlabs.org ([103.22.144.67]:47726 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaLPDVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 22:21:19 -0500
Date: Tue, 16 Dec 2014 14:21:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the userns tree with the vfs tree
Message-ID: <20141216142109.4a67e8b0@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/B3bwB=h/qWtvDV32L.iN4yN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/B3bwB=h/qWtvDV32L.iN4yN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
kernel/user_namespace.c between commits 3c0411846118 ("switch the rest
of proc_ns_operations to working with &...->ns") and 64964528b24e
("make proc_ns_operations work with struct ns_common * instead of void
*") from the vfs tree and commits 273d2c67c3e1 ("userns: Don't allow
setgroups until a gid mapping has been setablished") and 9cc46516ddf4
("userns: Add a knob to disable setgroups on a per user namespace
basis") from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/user_namespace.c
index 1491ad00388f,ad419b04c146..000000000000
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@@ -842,12 -849,101 +850,106 @@@ static bool new_idmap_permitted(const s
  	return false;
  }
 =20
 +static inline struct user_namespace *to_user_ns(struct ns_common *ns)
 +{
 +	return container_of(ns, struct user_namespace, ns);
 +}
 +
+ int proc_setgroups_show(struct seq_file *seq, void *v)
+ {
+ 	struct user_namespace *ns =3D seq->private;
+ 	unsigned long userns_flags =3D ACCESS_ONCE(ns->flags);
+=20
+ 	seq_printf(seq, "%s\n",
+ 		   (userns_flags & USERNS_SETGROUPS_ALLOWED) ?
+ 		   "allow" : "deny");
+ 	return 0;
+ }
+=20
+ ssize_t proc_setgroups_write(struct file *file, const char __user *buf,
+ 			     size_t count, loff_t *ppos)
+ {
+ 	struct seq_file *seq =3D file->private_data;
+ 	struct user_namespace *ns =3D seq->private;
+ 	char kbuf[8], *pos;
+ 	bool setgroups_allowed;
+ 	ssize_t ret;
+=20
+ 	/* Only allow a very narrow range of strings to be written */
+ 	ret =3D -EINVAL;
+ 	if ((*ppos !=3D 0) || (count >=3D sizeof(kbuf)))
+ 		goto out;
+=20
+ 	/* What was written? */
+ 	ret =3D -EFAULT;
+ 	if (copy_from_user(kbuf, buf, count))
+ 		goto out;
+ 	kbuf[count] =3D '\0';
+ 	pos =3D kbuf;
+=20
+ 	/* What is being requested? */
+ 	ret =3D -EINVAL;
+ 	if (strncmp(pos, "allow", 5) =3D=3D 0) {
+ 		pos +=3D 5;
+ 		setgroups_allowed =3D true;
+ 	}
+ 	else if (strncmp(pos, "deny", 4) =3D=3D 0) {
+ 		pos +=3D 4;
+ 		setgroups_allowed =3D false;
+ 	}
+ 	else
+ 		goto out;
+=20
+ 	/* Verify there is not trailing junk on the line */
+ 	pos =3D skip_spaces(pos);
+ 	if (*pos !=3D '\0')
+ 		goto out;
+=20
+ 	ret =3D -EPERM;
+ 	mutex_lock(&userns_state_mutex);
+ 	if (setgroups_allowed) {
+ 		/* Enabling setgroups after setgroups has been disabled
+ 		 * is not allowed.
+ 		 */
+ 		if (!(ns->flags & USERNS_SETGROUPS_ALLOWED))
+ 			goto out_unlock;
+ 	} else {
+ 		/* Permanently disabling setgroups after setgroups has
+ 		 * been enabled by writing the gid_map is not allowed.
+ 		 */
+ 		if (ns->gid_map.nr_extents !=3D 0)
+ 			goto out_unlock;
+ 		ns->flags &=3D ~USERNS_SETGROUPS_ALLOWED;
+ 	}
+ 	mutex_unlock(&userns_state_mutex);
+=20
+ 	/* Report a successful write */
+ 	*ppos =3D count;
+ 	ret =3D count;
+ out:
+ 	return ret;
+ out_unlock:
+ 	mutex_unlock(&userns_state_mutex);
+ 	goto out;
+ }
+=20
+ bool userns_may_setgroups(const struct user_namespace *ns)
+ {
+ 	bool allowed;
+=20
+ 	mutex_lock(&userns_state_mutex);
+ 	/* It is not safe to use setgroups until a gid mapping in
+ 	 * the user namespace has been established.
+ 	 */
+ 	allowed =3D ns->gid_map.nr_extents !=3D 0;
+ 	/* Is setgroups allowed? */
+ 	allowed =3D allowed && (ns->flags & USERNS_SETGROUPS_ALLOWED);
+ 	mutex_unlock(&userns_state_mutex);
+=20
+ 	return allowed;
+ }
+=20
 -static void *userns_get(struct task_struct *task)
 +static struct ns_common *userns_get(struct task_struct *task)
  {
  	struct user_namespace *user_ns;
 =20

--Sig_/B3bwB=h/qWtvDV32L.iN4yN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUj6UqAAoJEMDTa8Ir7ZwVFPcP/jAutCuijWEp7LaQG0SjVO5R
Qw0ZG6QUIRdeoJlr53MXbPFHFRbmrFoBkhh7CDkOFby5BLnLtNNhC3wjCW24X8lK
ObkPu8/24BKvcfnqYYgOadHTHvAO+CRhYDGquRlZfxvd01rG9N+cEETbkmVH/2Mc
86kWVV4crLIYAQemWuTENUOB9N/yyR7TIQJ8TSZH/jbceAUuVOCY4B2L8NmHhA3d
gQAh5nr/rovycZYX8qDv0pidlS8FEzxzMkGJ1l30nVjH6pCe38ScXhXXftIsdgTU
m1Y/JJNsazhIPVzObzADj7VQdzjU9duDoGcDgKpUF72iHXC7Vueh8pgsdqnadKGo
aBeypOBfg5Ubh9y6824d30iSf2LleI70hjQ+/P3Hw6q+B2ctPj90oaWhaEMMeo8s
p7IFnHQ3tO2ub7MaqDuLEC3RYXi4rcAD39v9lrLig69nLUMan9Sfsk6t95O+cLWE
LXaYEZ0chqy6gXcEGmNO6vK6WYkZCS8yjuvVwqiw7aeHv6+CPuhSE2WVV8lrpAng
GGtkwNv73YMIIezHI18t6jxb92uMWdg6QnRqed+VkHdY0f80vjnNufgnWJKuXbKg
9usy28oK8GreHIymvym0Vherfo1DYd2rIhZnfhOit2aBvjvj6ivnEPxFduBktJsI
Py+QKpbbswLqdY/jUT7K
=sxbs
-----END PGP SIGNATURE-----

--Sig_/B3bwB=h/qWtvDV32L.iN4yN--
