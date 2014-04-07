Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaDGBle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 21:41:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59766 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbaDGBla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 21:41:30 -0400
Message-ID: <1396834881.11513.41.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 17/18] cifs: ensure that uncached writes handle
 unmapped areas correctly
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Raphael Geissert <geissert@debian.org>, 741958@bugs.debian.org
Date: Mon, 07 Apr 2014 02:41:21 +0100
In-Reply-To: <lsq.1396827348.486893332@decadent.org.uk>
References: <lsq.1396827348.486893332@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/CkUR901hND6GfwHYMAr"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/CkUR901hND6GfwHYMAr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-04-07 at 00:35 +0100, Ben Hutchings wrote:
> 3.2.57-rc1 review patch.  If anyone has any objections, please let me kno=
w.
[...]

Raphael Geissert previously prepared a backport of this for Debian,
which I overlooked while trying to handle it for 3.2-stable.  When
comparing the two, I found bugs in mine, so here's my v2.

Ben.

---
From: Jeff Layton <jlayton@redhat.com>
Date: Fri, 14 Feb 2014 07:20:35 -0500
Subject: cifs: ensure that uncached writes handle unmapped areas correctly

commit 5d81de8e8667da7135d3a32a964087c0faf5483f upstream.

It's possible for userland to pass down an iovec via writev() that has a
bogus user pointer in it. If that happens and we're doing an uncached
write, then we can end up getting less bytes than we expect from the
call to iov_iter_copy_from_user. This is CVE-2014-0069

cifs_iovec_write isn't set up to handle that situation however. It'll
blindly keep chugging through the page array and not filling those pages
with anything useful. Worse yet, we'll later end up with a negative
number in wdata->tailsz, which will confuse the sending routines and
cause an oops at the very least.

Fix this by having the copy phase of cifs_iovec_write stop copying data
in this situation and send the last write as a short one. At the same
time, we want to avoid sending a zero-length write to the server, so
break out of the loop and set rc to -EFAULT if that happens. This also
allows us to handle the case where no address in the iovec is valid.

[Note: Marking this for stable on v3.4+ kernels, but kernels as old as
       v2.6.38 may have a similar problem and may need similar fix]

Reviewed-by: Pavel Shilovsky <piastry@etersoft.ru>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
[bwh: Backported to 3.2:
 - Adjust context
 - s/nr_pages/npages/
 - s/wdata->pages/pages/
 - In case of an error with no data copied, we must kunmap() page 0,
   but in neither case should we free anything else]
 Thanks to Raphael Geissert for an independent backport that showed some
 bugs in my first version.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/file.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2107,7 +2107,7 @@ cifs_iovec_write(struct file *file, cons
 {
 	unsigned int written;
 	unsigned long num_pages, npages, i;
-	size_t copied, len, cur_len;
+	size_t bytes, copied, len, cur_len;
 	ssize_t total_written =3D 0;
 	struct kvec *to_send;
 	struct page **pages;
@@ -2165,17 +2165,45 @@ cifs_iovec_write(struct file *file, cons
 	do {
 		size_t save_len =3D cur_len;
 		for (i =3D 0; i < npages; i++) {
-			copied =3D min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
+			bytes =3D min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
 			copied =3D iov_iter_copy_from_user(pages[i], &it, 0,
-							 copied);
+							 bytes);
 			cur_len -=3D copied;
 			iov_iter_advance(&it, copied);
 			to_send[i+1].iov_base =3D kmap(pages[i]);
 			to_send[i+1].iov_len =3D copied;
+			/*
+			 * If we didn't copy as much as we expected, then that
+			 * may mean we trod into an unmapped area. Stop copying
+			 * at that point. On the next pass through the big
+			 * loop, we'll likely end up getting a zero-length
+			 * write and bailing out of it.
+			 */
+			if (copied < bytes)
+				break;
 		}
=20
 		cur_len =3D save_len - cur_len;
=20
+		/*
+		 * If we have no data to send, then that probably means that
+		 * the copy above failed altogether. That's most likely because
+		 * the address in the iovec was bogus. Set the rc to -EFAULT,
+		 * free anything we allocated and bail out.
+		 */
+		if (!cur_len) {
+			kunmap(pages[0]);
+			if (!total_written)
+				total_written =3D -EFAULT;
+			break;
+		}
+
+		/*
+		 * i + 1 now represents the number of pages we actually used in
+		 * the copy phase above.
+		 */
+		npages =3D min(npages, i + 1);
+
 		do {
 			if (open_file->invalidHandle) {
 				rc =3D cifs_reopen_file(open_file, false);


--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-/CkUR901hND6GfwHYMAr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAU0ICQee/yOyVhhEJAQpzZxAAltwWOl6rXB064L37azcxouHtQTrMW/bJ
t9ih/uKXwfGnHn6G+DFVKAEjrrtSZX4Z4Mb8oMgeQWi5iQqJoZtXaSVeKsuMsxBd
LiYdOPghx2nSpK4ywU190x0GGD1FSMo730cydWkoLrqMUwE8eiOTBklqqZ7VYnn8
2xlmVqGgVHqS4z5z9rK9O+gXZXZVx4m6jMkGsp0U5LTICVHmTTClQVhvq+FEgz5e
FoLyJFFIkU08+dNaOTefoXejK6xEcM/1XKwBOdBtHamMRZLdOh44RfjfsTv77A9g
QvTsqlOYIVrPThuYxY2XRXkz89ciXF00N1uUD5Rt7CeM4HjCjAjXKLgG7euZ59Ue
OwZoLr0sBd4j2pYm6OgV5BVfGPcW4u73JFMO08jnju1lpXS6r0y6mHC5+wVGE3me
RCKjjFOfxXoLaF51iwtcZB3Kmkbzsd61Eka2OLtL+2yWKA/D+IDHjUz+wGl+CIE4
gmq6tc2Y5GXLdNItjku8vVsNrXd/SMoFpAZNREk94z9Nx31ooOvxI5HeVKhRd3rf
bOwBtKrfpTDadH+m/LD2ZKgDdHW0kqnvq8rcm3Z9xT/S19+3n5BoIz3VaM5eHOoy
RDNX7dY3MIKYepIKirmeQDHBdvRTDDidxJNFDTm+dtMtybBFw2/+xCKZOYdAH8OF
oUDY/uMMn6c=
=4qao
-----END PGP SIGNATURE-----

--=-/CkUR901hND6GfwHYMAr--
