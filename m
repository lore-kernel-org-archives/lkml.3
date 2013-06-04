Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3FDE5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:57:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55545 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab3FDE5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:57:13 -0400
Date: Tue, 4 Jun 2013 14:57:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20130604145700.6abe693b7e4628cf62948624@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Jun_2013_14_57_00_+1000_jmsq7Yr.rHJFsGJu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Jun_2013_14_57_00_+1000_jmsq7Yr.rHJFsGJu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/staging/lustre/lustre/fid/../include/linux/lu=
stre_compat25.h:44:0,
                 from drivers/staging/lustre/lustre/fid/../include/linux/lv=
fs.h:48,
                 from drivers/staging/lustre/lustre/fid/../include/lvfs.h:4=
5,
                 from drivers/staging/lustre/lustre/fid/../include/obd_supp=
ort.h:41,
                 from drivers/staging/lustre/lustre/fid/../include/linux/ob=
d.h:44,
                 from drivers/staging/lustre/lustre/fid/../include/obd.h:40,
                 from drivers/staging/lustre/lustre/fid/fid_store.c:48:
drivers/staging/lustre/lustre/fid/../include/linux/lustre_patchless_compat.=
h: In function 'truncate_complete_page':
drivers/staging/lustre/lustre/fid/../include/linux/lustre_patchless_compat.=
h:56:3: error: too few arguments to function 'page->mapping->a_ops->invalid=
atepage'
   page->mapping->a_ops->invalidatepage(page, 0);
   ^

Lots of times.

Caused by the Lustre client patches interacting with commit d47992f86b30
("mm: change invalidatepage prototype to accept length") from the ext4
tree.

I added this merge fix patch:

=46rom 3873636f50eb89ba5e4f8e4e0523fd62f681edc8 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Jun 2013 14:41:00 +1000
Subject: [PATCH] staging/lustre: fix for invalidatepage() API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h | 2 =
+-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_c=
ompat.h b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_comp=
at.h
index f050808..67c4644 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
@@ -53,7 +53,7 @@ truncate_complete_page(struct address_space *mapping, str=
uct page *page)
 		return;
=20
 	if (PagePrivate(page))
-		page->mapping->a_ops->invalidatepage(page, 0);
+		page->mapping->a_ops->invalidatepage(page, 0, PAGE_CACHE_SIZE);
=20
 	cancel_dirty_page(page, PAGE_SIZE);
 	ClearPageMappedToDisk(page);
--=20
1.8.1

diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/l=
ustre/lustre/llite/rw26.c
index 27e4e64..f1a1c5f 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -72,7 +72,8 @@
  * aligned truncate). Lustre leaves partially truncated page in the cache,
  * relying on struct inode::i_size to limit further accesses.
  */
-static void ll_invalidatepage(struct page *vmpage, unsigned long offset)
+static void ll_invalidatepage(struct page *vmpage, unsigned int offset,
+			      unsigned int length)
 {
 	struct inode     *inode;
 	struct lu_env    *env;
@@ -89,7 +90,7 @@ static void ll_invalidatepage(struct page *vmpage, unsign=
ed long offset)
 	 * below because they are run with page locked and all our io is
 	 * happening with locked page too
 	 */
-	if (offset =3D=3D 0) {
+	if (offset =3D=3D 0 && length =3D=3D PAGE_CACHE_SIZE) {
 		env =3D cl_env_get(&refcheck);
 		if (!IS_ERR(env)) {
 			inode =3D vmpage->mapping->host;

But then got these errors:

drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c: In function 'cfs_cp=
t_bind':
drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c:630:3: error: implic=
it declaration of function 'set_cpus_allowed' [-Werror=3Dimplicit-function-=
declaration]
   rc =3D set_cpus_allowed(current, *cpumask);
   ^
cc1: some warnings being treated as errors
drivers/staging/lustre/lustre/obdclass/lu_object.c: In function 'key_fini':
drivers/staging/lustre/lustre/obdclass/lu_object.c:1354:4: error: implicit =
declaration of function 'module_refcount' [-Werror=3Dimplicit-function-decl=
aration]
    LINVRNT(module_refcount(key->lct_owner) > 0);
    ^
In file included from drivers/staging/lustre/include/linux/libcfs/libcfs.h:=
203:0,
                 from drivers/staging/lustre/lustre/obdclass/lu_object.c:47:
drivers/staging/lustre/lustre/obdclass/lu_object.c: In function 'lu_context=
_keys_dump':
drivers/staging/lustre/lustre/obdclass/lu_object.c:1936:42: error: derefere=
ncing pointer to incomplete type
           key->lct_owner ? key->lct_owner->name : "",
                                          ^
drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:221:41: note: in=
 definition of macro '__CDEBUG'
   libcfs_debug_msg(&msgdata, format, ## __VA_ARGS__);     \
                                         ^
drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:238:30: note: in=
 expansion of macro 'CDEBUG_LIMIT'
 #define CERROR(format, ...)  CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
                              ^
drivers/staging/lustre/lustre/obdclass/lu_object.c:1932:4: note: in expansi=
on of macro 'CERROR'
    CERROR("[%d]: %p %x (%p,%p,%p) %d %d \"%s\"@%p\n",
    ^
cc1: some warnings being treated as errors
drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c: In function 'ptlrpcd':
drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c:398:4: error: implicit decla=
ration of function 'set_cpus_allowed' [-Werror=3Dimplicit-function-declarat=
ion]
    cfs_set_cpus_allowed(current,
    ^
cc1: some warnings being treated as errors

So I gave up and just reverted commit 52f6317528c6 ("staging/lustre: drop
CONFIG_BROKEN dependency") (thus disabling the code again) for now.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Jun_2013_14_57_00_+1000_jmsq7Yr.rHJFsGJu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRrXOhAAoJEECxmPOUX5FEuAIP/1Iaa3sAnpBgsLAIAKomrwxg
hnh0O7gxoHYcuvQIY5dB2xpeuXojzYyXYB3J4Hp8zwl+YKjCLfGFDyeZyKPzbbDI
HezkqXurUokfnxI398GWYf/3vlNZRFnpqEg6zjpHYYGvjpgnhd3qcDY1B49i3ZPN
MB28FgdJ/7CZCML35BAtcUuG8jzawMl+5JeZbfDOVzRjAo7Hzdq5JxVoFol+bm3O
a98wtboXTPWmkki54I/YUHF5UaqqN1NSurLvxCN4SAttda7Af1ueROvhUKUbT6v6
0d8PQOEYFrBz59a3zUYHKU8kJRIpUtn5Rypl4MR6L3W9ZAzPTyrWX1IZ5oCp+rbW
dvZovxzzcnnEkrEXO5uaAkdI49eM+QeiFalwxfcwKdvgxMX86Rt0iAHMaAkUrW79
ZBA+f7c6oLsjEmSkODf8x35eZPEh9pveMlalcAuTDuI8t8/kfZHoHFeMnbaXwUIu
YeYCkiehGTq7TciFQ6FtW5jE47JtvLtbWJFCcLHSjh7gj7pmrZDxJnJgQQccKfDf
z7+M5Glt0DgtULcskCO7tQmKCPKvMaBwd6Vx/twy9XKzc9RHGXrIvOKld080hEtW
mKwyYRlIUfOuOvtO66hv8iksS5XZAyu7/HvMIbIFPyonw3SCSeaiP9hAN39uVN4b
8xueGDYmd/BR8vkAueAo
=b7Uy
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Jun_2013_14_57_00_+1000_jmsq7Yr.rHJFsGJu--
