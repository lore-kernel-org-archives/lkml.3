Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbaLJG1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:27:13 -0500
Received: from ozlabs.org ([103.22.144.67]:54468 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaLJG1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:27:12 -0500
Date: Wed, 10 Dec 2014 17:27:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the userns tree with the vfs tree
Message-ID: <20141210172705.766c7b7b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/BSrF2TBmtkLVobERebLtkPd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BSrF2TBmtkLVobERebLtkPd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
kernel/user_namespace.c between commits 3c0411846118 ("switch the rest
of proc_ns_operations to working with &...->ns") and 64964528b24e
("make proc_ns_operations work with struct ns_common * instead of void
*") from the vfs tree and commit 2b714ea67ed4 ("userns: Add a knob to
disable setgroups on a per user namespace basis") from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/user_namespace.c
index 1491ad00388f,1db950ec08ce..000000000000
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@@ -842,12 -851,99 +852,104 @@@ static bool new_idmap_permitted(const s
  	return false;
  }
 =20
 +static inline struct user_namespace *to_user_ns(struct ns_common *ns)
 +{
 +	return container_of(ns, struct user_namespace, ns);
 +}
 +
+ static void *setgroups_m_start(struct seq_file *seq, loff_t *ppos)
+ {
+ 	struct user_namespace *ns =3D seq->private;
+=20
+ 	return (*ppos =3D=3D 0) ?  ns : NULL;
+ }
+=20
+ static void *setgroups_m_next(struct seq_file *seq, void *v, loff_t *ppos)
+ {
+ 	++*ppos;
+ 	return NULL;
+ }
+=20
+ static void setgroups_m_stop(struct seq_file *seq, void *v)
+ {
+ }
+=20
+ static int setgroups_m_show(struct seq_file *seq, void *v)
+ {
+ 	struct user_namespace *ns =3D seq->private;
+=20
+ 	seq_printf(seq, "%s\n",
+ 		   test_bit(USERNS_SETGROUPS_ALLOWED, &ns->flags) ?
+ 		   "allow" : "deny");
+ 	return 0;
+ }
+=20
+ const struct seq_operations proc_setgroups_seq_operations =3D {
+ 	.start	=3D setgroups_m_start,
+ 	.stop =3D setgroups_m_stop,
+ 	.next =3D setgroups_m_next,
+ 	.show =3D setgroups_m_show,
+ };
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
+ 	ret =3D -EACCES;
+ 	if (!file_ns_capable(file, ns, CAP_SYS_ADMIN))
+ 		goto out;
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
+ 	if (setgroups_allowed) {
+ 		ret =3D -EPERM;
+ 		if (!userns_setgroups_allowed(ns))
+ 			goto out;
+ 	} else {
+ 		userns_disable_setgroups(ns);
+ 	}
+=20
+ 	/* Report a successful write */
+ 	*ppos =3D count;
+ 	ret =3D count;
+ out:
+ 	return ret;
+ }
+=20
 -static void *userns_get(struct task_struct *task)
 +static struct ns_common *userns_get(struct task_struct *task)
  {
  	struct user_namespace *user_ns;
 =20

--Sig_/BSrF2TBmtkLVobERebLtkPd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUh+e+AAoJEMDTa8Ir7ZwVvCMP/R7wD4ueaXQ8Yx4iRqwdQmWF
7fWA+kobsVmlxGHjGlQafna20Xt5K19hKtQR8wnSsSIiCsn7GLRQkIyINcrR4W49
rG68ocHxQ+y7Nn+nc2FgQV18mlvxJkrPNqq1yjvUJSIl1DlW475ECS0g0yI71izI
x0cUilPgAhwWmFUqQbARCapcj9ZQ9ioJnhomEewomtxoA8wMbGwQqzOYUhbr988l
KxIIGWBL3d66Kjtwj9yuAcYq9NuKQytY9G6URb8Lxbs9clVhr3ZmU5oOxOqwduLK
knNGGa2KnJFQ/k7cuMkQTgQeEwUGzz4GrBn5na2623YVqPNluGE0JueeLNrcaWzG
Jef2kEav07nOcSvMMyU7QsNvXyy/Fyw/VV4JORqzbIol+aUPk02a0ldM752MJR1w
y0PU608kqwBf61FiVHaRS3CKyU8i5Z+TPmCxXI3PoVmYQIrkyH5kAq4/tRuGoF9o
nJav3tChIhnKhva6KQfW2IaQ8fQsf3rOhg/bSpQ+6OqtkmGMIYJfx8NcQvmmFdWZ
KwMMPlMqWRgbxk1qEz3pQbRZNxrtV8A87TXZ25S+YcwkQUIiDgDouUfXllIMq3Jg
IQv0VLK+EJ6guZcu/hmXGN9i+rzCizyrbqPPUIRbtb2I2mKZL6jF/d/9ClZhm9u7
oVkd4OnlidjgUQlMI2fD
=Xxr3
-----END PGP SIGNATURE-----

--Sig_/BSrF2TBmtkLVobERebLtkPd--
