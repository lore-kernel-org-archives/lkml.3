Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3CAEcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 23:32:03 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51221 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3CAEcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 23:32:01 -0500
Date: Fri, 1 Mar 2013 15:31:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20130301153151.1c44c6af6283a3be8c715a1a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Mar_2013_15_31_51_+1100_NpnacA0mVjplfHC4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Mar_2013_15_31_51_+1100_NpnacA0mVjplfHC4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/aio.c: In function 'exit_aio':
fs/aio.c:522:60: error: macro "hlist_for_each_entry_safe" passed 5 argument=
s, but takes just 4
fs/aio.c:522:2: error: 'hlist_for_each_entry_safe' undeclared (first use in=
 this function)
fs/aio.c:522:2: note: each undeclared identifier is reported only once for =
each function it appears in
fs/aio.c:522:62: error: expected ';' before '{' token

I added this fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 1 Mar 2013 15:30:24 +1100
Subject: [PATCH] aio: fixup for hlist_for_each_entry_safe API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/aio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index b36c2b6..2512232 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -517,9 +517,9 @@ EXPORT_SYMBOL(wait_on_sync_kiocb);
 void exit_aio(struct mm_struct *mm)
 {
 	struct kioctx *ctx;
-	struct hlist_node *p, *n;
+	struct hlist_node *n;
=20
-	hlist_for_each_entry_safe(ctx, p, n, &mm->ioctx_list, list) {
+	hlist_for_each_entry_safe(ctx, n, &mm->ioctx_list, list) {
 		/*
 		 * We don't need to bother with munmap() here -
 		 * exit_mmap(mm) is coming and it'll unmap everything.
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Mar_2013_15_31_51_+1100_NpnacA0mVjplfHC4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMC83AAoJEECxmPOUX5FEJ6QP/1c7iwHWt6f8AVZpQVlQpxFK
F45AR/DTv5iMJz8Jg/09jfdZFP7OhDxevxu6NdL4GEA7nYz1rFGAqsry/BP0xBsB
Q3ddlCAGoSdNgI6YLWHFZNik2/9kuLei0T406cqRG9ybflE1rFSNcqqP6f+LJO3w
Aqb+CFExfmenYp6AF0gX1ADSm9KnT8I2Fe74gjLLDSiWbFIZtHnrJ2386QQcG57a
CAlIslqjhGTsvsxvcfJGv7W5wfwu1NL6t1/AYzwyg64yuP31GXgSrmvmOMg8hnNi
jGDk2ojCGoem77ne5QRU4WOGRHbixQfH0rDgTGt+c+YspLEcSYSbzkgudoGkJ9zr
cEGcJna3nll5fdLBW675mBFH40u1tNI87S7Bc2rf08AOiAiWnO8gy9xYLbYpIuqJ
EXYw+5sOllUisHBs6fVKevvBKqcb6Rcfs0vIK+cvSSFC+k6SRz6hhPxIscJuGKcx
/1upQ44yE53MCTn2iE4DJ6TlNM7raKC7c9hGPuWdUHFLod3TlCEdIEQxw0RE/8ls
5Y8IbGoNJ6RBCCbgHPB5LqaQIdGSyB6cdzan+QbsmZKIHVNScvMoti170AfmJvM8
JjCgDpgOKjM0xLLH/LWSmttHTCTujPjxzEKYlyzjJqp6fxjJYFaKVHKgZmE60Adg
qWuao6Uuxyjt2QpNTF4H
=uNVZ
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Mar_2013_15_31_51_+1100_NpnacA0mVjplfHC4--
