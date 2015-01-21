Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbbAUH30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:29:26 -0500
Received: from ozlabs.org ([103.22.144.67]:56344 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbbAUH3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:29:17 -0500
Date: Wed, 21 Jan 2015 18:29:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Khebnikov <khlebnikov@yandex-team.ru>,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20150121182908.4d8263e2@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/58lniFmdwIYIGJECMN+_AmH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/58lniFmdwIYIGJECMN+_AmH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

mm/page-writeback.c: In function 'account_page_cleared':
mm/page-writeback.c:2122:23: error: 'struct address_space' has no member na=
med 'backing_dev_info'
   dec_bdi_stat(mapping->backing_dev_info,
                       ^

Caused by commit d475bc581640 ("page_writeback: cleanup mess around
cancel_dirty_page()") (hmm, that commit has no Signed-off-by from
Andrew?) interacting with commit b83ae6d42143 ("fs: remove
mapping->backing_dev_info") from the block tree.

I have applied the following fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 21 Jan 2015 18:23:41 +1100
Subject: [PATCH] fs: remove mapping->backing_dev_info fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/page-writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a8397a6923be..ab922616e522 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2119,7 +2119,7 @@ void account_page_cleared(struct page *page, struct a=
ddress_space *mapping)
 {
 	if (mapping_cap_account_dirty(mapping)) {
 		dec_zone_page_state(page, NR_FILE_DIRTY);
-		dec_bdi_stat(mapping->backing_dev_info,
+		dec_bdi_stat(inode_to_bdi(mapping->host),
 				BDI_RECLAIMABLE);
 		task_io_account_cancelled_write(PAGE_CACHE_SIZE);
 	}
--=20
2.1.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/58lniFmdwIYIGJECMN+_AmH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUv1VLAAoJEMDTa8Ir7ZwVkGYP/2YUWZFVFR8p790qI5EgbeRO
fiveUttEPUe1p428HBZdat4iXuz9/kV3HpDA9gSo0pM+KTj3ygA9fZLVq/NXPysw
M+mRx220KqT7i5XvkF52IUfqhteXU3UdphpYxO702KVPix5VamCHcU0sN983nIqR
c8aIutGnsWAblVTtzaGHw92fvxk1y4ylwsfC+M8OvXOuAa9b9CyXW/mHboFhdQgO
Cvcn1hzAFiYa8ZYxeRo+Lk0ka/V9LkB5Mn3wbPPj1GQ2FQdDc3PbqFB8B5/4AT1p
i0OmL9EQpwPw2eTaXQLEQ6bdahlUgig0adgpkrgc+THmityAUoR8kRhs5NGnFbjF
glS8YWcZPjLcmPcT7eoOn+Q72bIZ3DkEF5YwfZevs3M8fW/pXcCGSlNRCuwl7U4z
LMTGD9SKxOxvdr2XNpjeJJrc7g1ofd0evuzvXDQtYme/86slAw0830isaycDZZml
H0KnKNvd5dQHKxOnr+9RhYAv+VAHK/W6hOj+HnaEJSA2SoW8O5+TiEXdcoW8DuXA
V3YwPCL5lCvksB5lILYmoTbFczA/6t6bAaCzEGqfo65nG4YodGilliosuqpt5OpX
GkFaDVBVbid+q9pWuqtL9IfPudCfos+Ds8mYOYFV9GbMeRgiXslCk6f0H6SJ10/D
7B/Z0ddSfRLJLf+tHkSn
=97J4
-----END PGP SIGNATURE-----

--Sig_/58lniFmdwIYIGJECMN+_AmH--
