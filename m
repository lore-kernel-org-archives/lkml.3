Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaJNF5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 01:57:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbaJNF5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 01:57:39 -0400
Date: Tue, 14 Oct 2014 16:57:26 +1100
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 2/2 - revised] sysfs/kernfs: make read requests on pre-alloc
 files use the buffer.
Message-ID: <20141014165726.3afed8dd@notabene.brown>
In-Reply-To: <20141013054128.19481.21008.stgit@notabene.brown>
References: <20141013053733.19481.43981.stgit@notabene.brown>
	<20141013054128.19481.21008.stgit@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CxpoI62v1CncTMZ6JhoZ0g3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CxpoI62v1CncTMZ6JhoZ0g3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



To match the previous patch which used the pre-alloc buffer for
writes, this patch causes reads to use the same buffer.
This is not strictly necessary as the current seq_read() will allocate
on first read, so user-space can trigger the required pre-alloc.  But
consistency is valuable.

The read function is somewhat simpler than seq_read() and, for example,
does not support reading from an offset into the file: reads must be
at the start of the file.

As seq_read() does not use the prealloc buffer, ->seq_show is
incompatible with ->prealloc and caused an EINVAL return from open().
sysfs code which calls into kernfs always chooses the correct function.

As the buffer is shared with writes and other reads, the mutex is
extended to cover the copy_to_user.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Tejun Heo <tj@kernel.org>

---

Please use this version instead.  Original had a last minute change which
lead to a compile error - sorry.

NeilBrown


diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 70186e2e692a..697390ea47b8 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -189,13 +189,16 @@ static ssize_t kernfs_file_direct_read(struct kernfs_=
open_file *of,
 	const struct kernfs_ops *ops;
 	char *buf;
=20
-	buf =3D kmalloc(len, GFP_KERNEL);
+	buf =3D of->prealloc_buf;
+	if (!buf)
+		buf =3D kmalloc(len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
=20
 	/*
-	 * @of->mutex nests outside active ref and is primarily to ensure that
-	 * the ops aren't called concurrently for the same open file.
+	 * @of->mutex nests outside active ref and is used both to ensure that
+	 * the ops aren't called concurrently for the same open file, and
+	 * to provide exclusive access to ->prealloc_buf (when that exists).
 	 */
 	mutex_lock(&of->mutex);
 	if (!kernfs_get_active(of->kn)) {
@@ -210,21 +213,22 @@ static ssize_t kernfs_file_direct_read(struct kernfs_=
open_file *of,
 	else
 		len =3D -EINVAL;
=20
-	kernfs_put_active(of->kn);
-	mutex_unlock(&of->mutex);
-
 	if (len < 0)
-		goto out_free;
+		goto out_unlock;
=20
 	if (copy_to_user(user_buf, buf, len)) {
 		len =3D -EFAULT;
-		goto out_free;
+		goto out_unlock;
 	}
=20
 	*ppos +=3D len;
=20
+ out_unlock:
+	kernfs_put_active(of->kn);
+	mutex_unlock(&of->mutex);
  out_free:
-	kfree(buf);
+	if (buf !=3D of->prealloc_buf)
+		kfree(buf);
 	return len;
 }
=20
@@ -690,6 +694,14 @@ static int kernfs_fop_open(struct inode *inode, struct=
 file *file)
 	 */
 	of->atomic_write_len =3D ops->atomic_write_len;
=20
+	error =3D -EINVAL;
+	/*
+	 * ->seq_show is incompatible with ->prealloc,
+	 * as seq_read does its own allocation.
+	 * ->read must be used instead.
+	 */
+	if (ops->prealloc && ops->seq_show)
+		goto err_free;
 	if (ops->prealloc) {
 		int len =3D of->atomic_write_len ?: PAGE_SIZE;
 		of->prealloc_buf =3D kmalloc(len + 1, GFP_KERNEL);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4a959d231b43..29a7c6f9dd9c 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -102,6 +102,22 @@ static ssize_t sysfs_kf_bin_read(struct kernfs_open_fi=
le *of, char *buf,
 	return battr->read(of->file, kobj, battr, buf, pos, count);
 }
=20
+/* kernfs read callback for regular sysfs files with pre-alloc */
+static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
+			     size_t count, loff_t pos)
+{
+	const struct sysfs_ops *ops =3D sysfs_file_ops(of->kn);
+	struct kobject *kobj =3D of->kn->parent->priv;
+
+	/*
+	 * If buf !=3D of->prealloc_buf, we don't know how
+	 * large it is, so cannot safely pass it to ->show
+	 */
+	if (pos || WARN_ON_ONCE(buf !=3D of->prealloc_buf))
+		return 0;
+	return ops->show(kobj, of->kn->priv, buf);
+}
+
 /* kernfs write callback for regular sysfs files */
 static ssize_t sysfs_kf_write(struct kernfs_open_file *of, char *buf,
 			      size_t count, loff_t pos)
@@ -184,13 +200,18 @@ static const struct kernfs_ops sysfs_file_kfops_rw =
=3D {
 	.write		=3D sysfs_kf_write,
 };
=20
+static const struct kernfs_ops sysfs_prealloc_kfops_ro =3D {
+	.read		=3D sysfs_kf_read,
+	.prealloc	=3D true,
+};
+
 static const struct kernfs_ops sysfs_prealloc_kfops_wo =3D {
 	.write		=3D sysfs_kf_write,
 	.prealloc	=3D true,
 };
=20
 static const struct kernfs_ops sysfs_prealloc_kfops_rw =3D {
-	.seq_show	=3D sysfs_kf_seq_show,
+	.read		=3D sysfs_kf_read,
 	.write		=3D sysfs_kf_write,
 	.prealloc	=3D true,
 };
@@ -238,9 +259,12 @@ int sysfs_add_file_mode_ns(struct kernfs_node *parent,
 				ops =3D &sysfs_prealloc_kfops_rw;
 			else
 				ops =3D &sysfs_file_kfops_rw;
-		} else if (sysfs_ops->show)
-			ops =3D &sysfs_file_kfops_ro;
-		else if (sysfs_ops->store) {
+		} else if (sysfs_ops->show) {
+			if (mode & SYSFS_PREALLOC)
+				ops =3D &sysfs_prealloc_kfops_ro;
+			else
+				ops =3D &sysfs_file_kfops_ro;
+		} else if (sysfs_ops->store) {
 			if (mode & SYSFS_PREALLOC)
 				ops =3D &sysfs_prealloc_kfops_wo;
 			else

--Sig_/CxpoI62v1CncTMZ6JhoZ0g3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDy7Rjnsnt1WYoG5AQKsIxAAl5kuhcFch19zdNwoRqCgRZDpAdBqa5fu
UljTkkrMQY3cLcsDDH4IC51fjuz2XwBID8tcOg27b00CkOX7QpftNerzI4sp62bX
GWEUhB/vIprJ1b5gr+ZQKw3cCYHcxbTo2QA3YNCNdhAOJwiV/DeVGiy3oarEFVla
SGDpzKspU+qdksl+Mmy+fPDcG3IpNgO+hAwQ62jTXieGRILeykUa2TnlEhu68gO+
hef3kxaTwBkaVbdes9rdVAx1CkjHjP9+AT1xgzA8hKDOR5Ulafcsc9N8tCgmSdRf
61h4mD6jTt5Zk/+VsnvIUT2eGCL37zlyoAD3nfh2bVNw8Hr2KrBUtk2kRNHLxnk5
/H9PZek+TDgaGRVlUmthRmVRXJWbJ4a0KiENiET7TrlIb920kmiVN27vD3zrGNQL
++RUwvE0RhkE3lwgrBiLlKTqhirSj20bAjRuSL4zjtueDaCTzQt36I8OpLLvVGce
jHarb/ApezNdweZ5W33VPYAchWIVIdCNUptxg6hcOZzYpOsSMGTmwEW5QUlTitUy
Ne4v9V5RXz3x0XnAY5mTIh09cy06EKP4DuV1JtHjFN208+gtcHcQBM6D/I35RBVW
FBRF536XYEw02a8rGivjK6InSpeblNEMe14slEC3+1pB7P9ijEvKdOUjQ0e5U4jQ
W7zlCDIALhw=
=okRi
-----END PGP SIGNATURE-----

--Sig_/CxpoI62v1CncTMZ6JhoZ0g3--
