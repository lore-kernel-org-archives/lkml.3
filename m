Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaIWEGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:06:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbaIWEGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:06:43 -0400
Date: Tue, 23 Sep 2014 14:06:33 +1000
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140923140633.35efbe7a@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Nx5OWLvjD19UP+ojLnsHH7O"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Nx5OWLvjD19UP+ojLnsHH7O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


For a write <=3D 128 characters, don't use kmalloc.

mdmon, part of mdadm, will sometimes need to write
to a sysfs file in order to allow writes to the array
to continue.  This is important to support RAID metadata
types that the kernel doesn't know about.

It is important that this write doesn't block on
memory allocation.  The safest way to ensure that is to
use an on-stack buffer.

Writes are always small, typically less than 10 characters.

Note that reads from a sysfs file are already safe due to the use for
seqfile.  The first read will allocate a buffer (m->buf) which will
be used for all subsequent reads.

Signed-off-by: NeilBrown <neilb@suse.de>

---
Hi Tejun,
 I wonder if you would consider this patch.
 When mdmon needs to update metadata after a device failure in an array
 there are two 'kmalloc' sources that can trigger deadlock if memory is tig=
ht
 and needs to be written to the array (which cannot be allowed until mdmon
 updates the metadata).
 One is in O_DIRECT writes which I have patches for.  The other is when
 writing to the sysfs file to tell md that it is safe to continue.
 This simple patch removes the second.

Thanks,
NeilBrown


diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 4429d6d9217f..75b58669ce55 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -269,6 +269,7 @@ static ssize_t kernfs_fop_write(struct file *file, cons=
t char __user *user_buf,
 	const struct kernfs_ops *ops;
 	size_t len;
 	char *buf;
+	char stackbuf[129];
=20
 	if (of->atomic_write_len) {
 		len =3D count;
@@ -278,7 +279,10 @@ static ssize_t kernfs_fop_write(struct file *file, con=
st char __user *user_buf,
 		len =3D min_t(size_t, count, PAGE_SIZE);
 	}
=20
-	buf =3D kmalloc(len + 1, GFP_KERNEL);
+	if (len < sizeof(stackbuf))
+		buf =3D stackbuf;
+	else
+		buf =3D kmalloc(len + 1, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
=20
@@ -311,7 +315,8 @@ static ssize_t kernfs_fop_write(struct file *file, cons=
t char __user *user_buf,
 	if (len > 0)
 		*ppos +=3D len;
 out_free:
-	kfree(buf);
+	if (buf !=3D stackbuf)
+		kfree(buf);
 	return len;
 }
=20

--Sig_/Nx5OWLvjD19UP+ojLnsHH7O
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCDxyTnsnt1WYoG5AQIpyRAAkZ4QZINcE3zWCEwTWMi9AlyCiRCzW6Ne
8Okxw90EP/5Mb/JTeibmQhtD4qTuyVlpN/sRzBRT5OLAYP1rHTPj+LGOh1ztL82x
n1fG7PP5GVVDSV9aDl+SeO8bQ4veCP5iJW1+72Ne2keNx/V5EEpdesqkbI5B6ghy
bC/tvPl5Z2fgApVaZ5lnxjJ9DdSevaEXUJOMtDu5opGETqeb14hpdWZaJ2dCeH6R
YbIXKLxOdzHQVAbd5LD5nbyKjaL2bAB9uzCGOq0mSY7rUnO6oN3XsPUkJFok3goC
lyZvAo9bjtB/XpkvIZRuT098IpW99D2U7iTHkYqgjRqXE+KslXzadftXOsk/K0go
7eNMoGoaNXvF+kBrq7fx2+Y1xpyhTttdGV2gm9/Os2XMZKrp8KoJDSyWmAkHmro+
nfQsx5Uv8htZ5UZ3X9wGeiss2MUr7jvMuKEMr/cA/TSxUnC0pkmQopeM+l1lFzsv
wcIP5kLoVg8hfdkVM/ubr6iFX0fZJGt/+8jlrJintQu2mw7at23i/Doelq0TC34t
2PdrUUrvG6328D27wIAom5815k4clqENvlme1kKT6uCd4xvc93YM20l1Vvh2m2aJ
42GFHuZXFHASwwe4DepNqVAa3pYJ5uKKWcB+cEQkJpEjqZncKZMhYUwc4jO4oWbs
2Ctjl4K4C6Y=
=ugVS
-----END PGP SIGNATURE-----

--Sig_/Nx5OWLvjD19UP+ojLnsHH7O--
