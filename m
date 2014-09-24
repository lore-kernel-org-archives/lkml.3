Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaIXX7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 19:59:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaIXX7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 19:59:11 -0400
Date: Thu, 25 Sep 2014 09:58:57 +1000
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140925095857.2ca9427f@notabene.brown>
In-Reply-To: <20140924191727.GG7996@ZenIV.linux.org.uk>
References: <20140923140633.35efbe7a@notabene.brown>
	<20140924191727.GG7996@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5+RWLN21eLgSeRz4VkeYm.G"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5+RWLN21eLgSeRz4VkeYm.G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Sep 2014 20:17:27 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Tue, Sep 23, 2014 at 02:06:33PM +1000, NeilBrown wrote:
> >=20
> > For a write <=3D 128 characters, don't use kmalloc.
> >=20
> > mdmon, part of mdadm, will sometimes need to write
> > to a sysfs file in order to allow writes to the array
> > to continue.  This is important to support RAID metadata
> > types that the kernel doesn't know about.
> >=20
> > It is important that this write doesn't block on
> > memory allocation.  The safest way to ensure that is to
> > use an on-stack buffer.
>=20
> Is it, now?  What happens if caller of write(2) loses CPU and gets
> the page it's writing from swapped out, just as it's getting to
> issuing the actual syscall?  copy_from_user() will fault and cause
> memory allocation for you...

That problem is easily solved with

     mlockall(MCL_CURRENT|MCL_FUTURE);

That will prevent any swapout.

I see this effort a bit like an extension to MCL_FUTURE.

A process that wants to avoid latency from the memory system can use
mlockall() and then pre-allocate any memory that it might need.
Then it can be sure it will not block on memory accesses.

However it is not possible to pre-allocate memory that will be used
by the kernel, such as in a write to a sysfs file.

So my real goal is to ensure that when MCL_FUTURE has been set, it is
possible to pre-allocate any kernel memory that might be needed.
For this case it was easiest to simply "not need" any kernel memory.

I have a patch which ensures that O_DIRECT writes to a block device will not
block on memory allocations.  It keeps the 'struct dio' around precisely if
MCL_FUTURE was used.  So after the first access (read or write) future writ=
es
will not block in memory allocation.

An alternate approach might be to allow PF_MEMALLOC to be permanently set
from user-space, but I suspect that is too heavy handed and wouldn't be a
good solution.


A key point here is that it is the "process" rather than the "file" that is
special.   It isn't that accesses to the file should never block.  It is th=
at
the process should be able to avoid blocking.  That is why I don't really
want to special-case a few sysfs attribute files.

>=20
> > Writes are always small, typically less than 10 characters.
>=20
> Translation: "but my userland code uses it _that_ way; surely, nobody
> would do anything else..."

That isn't how I see it.
These are sysfs attribute files.  By definition they contain precisely one
value - typically a bool, enum, or integer.
I realise that this "definition" is often stretched and sometimes completely
ignored, but it is largely adhered to and when it is violated it is more
often the "read" side than the "write" side.

So it isn't just "my userland code" - it is any sane code on any sane sysfs
attribute.  "typically less than 10" is probably not helpful, but the code
was for "less than 128 is all interesting cases" and that covers all number=
s,
enums, bools and anything that isn't a gross violation of "one value".

But if you don't like a limit (and I do agree that it is usually good to
avoid arbitrary limits even though we already have an arbitrary limit of
PAGE_SIZE) we could do it like this.
This allows the userland code to pre-allocate a buffer  by performing a wri=
te.
I haven't made it conditional on
      current->mm->def_flags & VM_LOCKED
so it would only affect mlock(MCL_FUTURE) processes, but that would be easy.

Thanks for your comments,
NeilBrown


diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 4429d6d9217f..a4d28f78cae1 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -278,40 +278,49 @@ static ssize_t kernfs_fop_write(struct file *file, co=
nst char __user *user_buf,
 		len =3D min_t(size_t, count, PAGE_SIZE);
 	}
=20
-	buf =3D kmalloc(len + 1, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, user_buf, len)) {
-		len =3D -EFAULT;
-		goto out_free;
-	}
-	buf[len] =3D '\0';	/* guarantee string termination */
-
 	/*
 	 * @of->mutex nests outside active ref and is just to ensure that
 	 * the ops aren't called concurrently for the same open file.
+	 * Also protects of->buf.
 	 */
 	mutex_lock(&of->mutex);
 	if (!kernfs_get_active(of->kn)) {
 		mutex_unlock(&of->mutex);
-		len =3D -ENODEV;
-		goto out_free;
+		return -ENODEV;
 	}
=20
+	if (of->buf && of->buflen >=3D len+1)
+		buf =3D of->buf;
+	else
+		buf =3D kmalloc(len + 1, GFP_KERNEL);
+	if (!buf) {
+		len =3D -ENOMEM;
+		goto out_unlock;
+	}
+	if (buf !=3D of->buf) {
+		kfree(of->buf);
+		of->buf =3D buf;
+		of->buflen =3D len + 1;
+	}
+
+	if (copy_from_user(buf, user_buf, len)) {
+		len =3D -EFAULT;
+		goto out_unlock;
+	}
+	buf[len] =3D '\0';	/* guarantee string termination */
+
 	ops =3D kernfs_ops(of->kn);
 	if (ops->write)
 		len =3D ops->write(of, buf, len, *ppos);
 	else
 		len =3D -EINVAL;
=20
-	kernfs_put_active(of->kn);
-	mutex_unlock(&of->mutex);
-
 	if (len > 0)
 		*ppos +=3D len;
-out_free:
-	kfree(buf);
+
+out_unlock:
+	kernfs_put_active(of->kn);
+	mutex_unlock(&of->mutex);
 	return len;
 }
=20
@@ -728,6 +737,7 @@ static int kernfs_fop_release(struct inode *inode, stru=
ct file *filp)
=20
 	kernfs_put_open_node(kn, of);
 	seq_release(inode, filp);
+	kfree(of->buf);
 	kfree(of);
=20
 	return 0;
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 30faf797c2c3..c6addf635990 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -179,6 +179,8 @@ struct kernfs_open_file {
 	struct mutex		mutex;
 	int			event;
 	struct list_head	list;
+	char			*buf;
+	int			buflen;
=20
 	size_t			atomic_write_len;
 	bool			mmapped;

--Sig_/5+RWLN21eLgSeRz4VkeYm.G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCNawTnsnt1WYoG5AQL/zA//XIQ97dXGHaw0YfWmgtGI1U+f0eosJjPn
HETS0HS2AxVaRshJYbYeTowhQHAPqrF5RMWW5NuXWDzjbZsgpyznw378c7Fzm55u
6myb3R27swq0Rw6Cf3ycWgfwQCnnGhG3G5KlJzw697UaAvKh2Axg7l0dbLhjCuw+
fhFt9rWb3xEUl4dwdftVIGA/oYfsnIHlLqnA9tsJzyCSTQvh9PF6E/iB8Sd/PVhh
EGr4We6j/1VZ8AtBhGNHhIYXjiB0m86X9bFTGoSsjyQwF3sNxHFZiwfteVHX+Ic5
pbXH4YkinNmzjhbZMx1PL/HnXjv8xk0d2a8lIN7ThpRcOt2gzCuOTq49eKmbNBxo
4iR2lMm7gcUgNgkXPlNig0ACCm/2S4KCfIzsY53Q9rt3eU+tMWA6f5a7TJ3lgD48
QSvR1xeHMG0ntOeEABS4NSbXFT9TcTqLHGZm2DI3g6Peq/QkBn52zOMU8T+HrOk7
z8XIdM2mq/IQFsapH15TF/w4aL6JytJ+DwqU2DPTtykmPZDzK1d0kINc3iLdKuAQ
0flW/N2Y9Gat8w341zc9DirAhuzMG8bb9IEt7tLt/XKOCXsOS+o/3kXyaFsd5xIC
9W9l2jstD9f6piziQ62wEvxDUlvBWERJ+thAMd7U8hVcAHUdYqgXDYwB2bODaDis
Pm1PeNhJFJY=
=IEZf
-----END PGP SIGNATURE-----

--Sig_/5+RWLN21eLgSeRz4VkeYm.G--
