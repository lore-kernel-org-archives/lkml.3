Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaCMEIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 00:08:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaCMEIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 00:08:11 -0400
Date: Thu, 13 Mar 2014 15:08:00 +1100
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fs: fix i_writecount on shmem and friends
Message-ID: <20140313150800.07878c80@notabene.brown>
In-Reply-To: <20140312181925.GK18016@ZenIV.linux.org.uk>
References: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
	<CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
	<20140312181925.GK18016@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LjDmD29GmWYAZtPkD7np/Cq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LjDmD29GmWYAZtPkD7np/Cq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Mar 2014 18:19:25 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Tue, Mar 11, 2014 at 12:05:09PM -0700, Linus Torvalds wrote:
> >=20
> > which returns ETXTBSY (most easily seen by just stracing it).
> >=20
> > The patch would also seem to make sense, with the i_readcount_inc()
> > being immediately below for the FMODE_READ case.
>=20
> I think it's trying to fix the problem in the wrong place.  The bug is re=
al,
> all right, but it's not that alloc_file() for non-regulars doesn't grab
> writecount; it's that drop_file_write_access() drops it for those.
>=20
> What the hell would we want to play with that counter for, anyway?  It's =
not
> as if they could be mmapped, so all it does is making pipe(2) and socket(=
2)
> more costly, for no visible reason.
>=20
> I would prefer to flip
>         put_write_access(inode);
>=20
>         if (special_file(inode->i_mode))
>                 return;
> in drop_file_write_access() instead.
>=20
> <goes to looks at i_writecount users>
> Oh, shit...
>=20
> drivers/md/md.c:
> /* similar to deny_write_access, but accounts for our holding a reference
>  * to the file ourselves */
> static int deny_bitmap_write_access(struct file * file)
> {
>         struct inode *inode =3D file->f_mapping->host;
>=20
>         spin_lock(&inode->i_lock);
>         if (atomic_read(&inode->i_writecount) > 1) {
>                 spin_unlock(&inode->i_lock);
>                 return -ETXTBSY;
>         }
>         atomic_set(&inode->i_writecount, -1);
>         spin_unlock(&inode->i_lock);
>=20
>         return 0;
> }
>=20
> Broken.  get_write_access() will happily increment i_writecount e.g. from
> 1 to 2, without even looking at i_lock.

I guess someone changed exactly how i_writecount is used without check all
users ... that isn't like you Al :-)


>                                          Moreover, it's paired with
> void restore_bitmap_write_access(struct file *file)
> {
>         struct inode *inode =3D file->f_mapping->host;
>=20
>         spin_lock(&inode->i_lock);
>         atomic_set(&inode->i_writecount, 1);
>         spin_unlock(&inode->i_lock);
> }
> Just what will happen if we do denywrite mmap() of that file in between?
> Even worse, the caller take file straight from fget(), with no sanity
> checks whatsoever.  Just what will happen if I give it e.g. a directory?
> Or a procfs/sysfs/whatnot file, for that matter?  Neil?  I realize that
> it's root-only, but still...

But as you point out, even "fixing" it to match the current i_writecount
behaviour wouldn't really be a proper fix.
Probably best to stop messing with i_writecount and just use it to guard
against using the same bitmap twice.
It won't prevent some other process writing to the file but that shouldn't
happen anyway.

Maybe something like the following once I've tested it.

Thanks,
NeilBrown

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 4195a01b1535..9a8e66ae04f5 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1988,7 +1988,6 @@ location_store(struct mddev *mddev, const char *buf, =
size_t len)
 		if (mddev->bitmap_info.file) {
 			struct file *f =3D mddev->bitmap_info.file;
 			mddev->bitmap_info.file =3D NULL;
-			restore_bitmap_write_access(f);
 			fput(f);
 		}
 	} else {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e28c9d2a1166..223126046e02 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5181,32 +5181,6 @@ static int restart_array(struct mddev *mddev)
 	return 0;
 }
=20
-/* similar to deny_write_access, but accounts for our holding a reference
- * to the file ourselves */
-static int deny_bitmap_write_access(struct file * file)
-{
-	struct inode *inode =3D file->f_mapping->host;
-
-	spin_lock(&inode->i_lock);
-	if (atomic_read(&inode->i_writecount) > 1) {
-		spin_unlock(&inode->i_lock);
-		return -ETXTBSY;
-	}
-	atomic_set(&inode->i_writecount, -1);
-	spin_unlock(&inode->i_lock);
-
-	return 0;
-}
-
-void restore_bitmap_write_access(struct file *file)
-{
-	struct inode *inode =3D file->f_mapping->host;
-
-	spin_lock(&inode->i_lock);
-	atomic_set(&inode->i_writecount, 1);
-	spin_unlock(&inode->i_lock);
-}
-
 static void md_clean(struct mddev *mddev)
 {
 	mddev->array_sectors =3D 0;
@@ -5427,7 +5401,6 @@ static int do_md_stop(struct mddev * mddev, int mode,
=20
 		bitmap_destroy(mddev);
 		if (mddev->bitmap_info.file) {
-			restore_bitmap_write_access(mddev->bitmap_info.file);
 			fput(mddev->bitmap_info.file);
 			mddev->bitmap_info.file =3D NULL;
 		}
@@ -5991,6 +5964,7 @@ static int set_bitmap_file(struct mddev *mddev, int f=
d)
=20
=20
 	if (fd >=3D 0) {
+		struct inode *inode;
 		if (mddev->bitmap)
 			return -EEXIST; /* cannot add when bitmap is present */
 		mddev->bitmap_info.file =3D fget(fd);
@@ -6001,13 +5975,20 @@ static int set_bitmap_file(struct mddev *mddev, int=
 fd)
 			return -EBADF;
 		}
=20
-		err =3D deny_bitmap_write_access(mddev->bitmap_info.file);
-		if (err) {
+		inode =3D mddev->bitmap_info.file->f_mapping->host;
+		if (!S_ISREG(inode->i_mode)) {
+			printk(KERN_ERR "%s: error: bitmap file must be a regular file\n",
+			       mdname(mddev));
+			fput(mddev->bitmap_info.file);
+			mddev->bitmap_info.file =3D NULL;
+			return -EBADF;
+		}
+		if (atomic_read(&inode->i_writecount) !=3D 1) {
 			printk(KERN_ERR "%s: error: bitmap file is already in use\n",
 			       mdname(mddev));
 			fput(mddev->bitmap_info.file);
 			mddev->bitmap_info.file =3D NULL;
-			return err;
+			return -EBUSY;
 		}
 		mddev->bitmap_info.offset =3D 0; /* file overrides offset */
 	} else if (mddev->bitmap =3D=3D NULL)
@@ -6027,10 +6008,8 @@ static int set_bitmap_file(struct mddev *mddev, int =
fd)
 		mddev->pers->quiesce(mddev, 0);
 	}
 	if (fd < 0) {
-		if (mddev->bitmap_info.file) {
-			restore_bitmap_write_access(mddev->bitmap_info.file);
+		if (mddev->bitmap_info.file)
 			fput(mddev->bitmap_info.file);
-		}
 		mddev->bitmap_info.file =3D NULL;
 	}
=20
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 07bba96de260..a49d991f3fe1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -605,7 +605,6 @@ extern int md_check_no_bitmap(struct mddev *mddev);
 extern int md_integrity_register(struct mddev *mddev);
 extern void md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mdde=
v);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int s=
cale);
-extern void restore_bitmap_write_access(struct file *file);
=20
 extern void mddev_init(struct mddev *mddev);
 extern int md_run(struct mddev *mddev);


--Sig_/LjDmD29GmWYAZtPkD7np/Cq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUyEvIDnsnt1WYoG5AQJDnQ/9Gt4PHWGLzpxSG/guib9yyvuWxIh2sIrL
yHNu/zF3430yO6YuO+bC7qOm7IIdORYR5bsq3bfvWERS0cRF6esJXfbzD7LK6kH6
qeyvoYtN84u5K/0UlKhBzYXHMU/wTM7yhgIe9m/cO+LxlHVF0HmR1sFuGPfRy+eH
hRpFebGD9kYhOPsqtG0wjCjPZvEK2tWNtX8YfkkTFJekMiGTmuKQGdiqIgU0DkSs
HxGiASWfEatgX9A2ne33etlnEuWqbv146R4ZAIWKE8Etc57tT0rz2PQS7RoqNMc+
+HEcrx2fYYOU3Umlae4IDGwgD5Zzm/Ile1kEisYkvX3y68LfLQecrO7ZvqMn6Gzh
/zmZPwt5MT8pStiKAzz/vxwY87tUORLMqnh77dJugIjtIlY+l/u6gZ+L3IqAcD+K
/APL+PxD0ctDuglY3twQaN5xrmU7pEl+BOokt6so3IuIkdK4pBzBr9L09emncE7H
ziNONcQNIs+3hAXjGSY8LKGbZecWUu2ut3cQj58swE6GTtBrWrcP55G+GADm6asU
C/uU5gpFm9sEN5SvmLYB4c6GYOTu629e5NwCiq5Xa9sCyW9mP16LC/cW++MqtwXo
eA8KX+zx6Hp046v7Ov9iiWRkVihNKjcX2DEi3GCDYaXH7C9upuv0owniETF3NNRW
+cxh4HGs8oE=
=7Y89
-----END PGP SIGNATURE-----

--Sig_/LjDmD29GmWYAZtPkD7np/Cq--
