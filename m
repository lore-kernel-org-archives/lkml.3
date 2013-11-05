Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3KEXHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:07:50 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58026 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab3KEXHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:07:49 -0500
Date: Wed, 6 Nov 2013 10:07:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <ak@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the modules tree
Message-Id: <20131106100741.6dd82590c3a24f6a32fce247@canb.auug.org.au>
In-Reply-To: <20131105141702.GE1962@tassilo.jf.intel.com>
References: <20131104134134.48665968dd006e3310333993@canb.auug.org.au>
	<87fvrba8su.fsf@rustcorp.com.au>
	<20131105141702.GE1962@tassilo.jf.intel.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Nov_2013_10_07_41_+1100_Pnx5z6+=5oQy6/tP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Nov_2013_10_07_41_+1100_Pnx5z6+=5oQy6/tP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Tue, 5 Nov 2013 06:17:02 -0800 Andi Kleen <ak@linux.intel.com> wrote:
>
> > modpost creates an entry when it sees the CRC, then when it sees the
> > actual symbol, it complains that it's seen it before.  The preloaded
> > flag already exists for the equivalent case where we loaded from
> > Module.symvers, so use that.
>=20
> Looks good. Thanks for fixing.

I added this as a merge fix today (thanks):

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: modpost: fix bogus 'exported twice' warnings.

Andi's change in e0f244c63fc9 ("asmlinkage, module: Make ksymtab and
kcrctab symbols and __this_module __visible") make the crc appear
first in the symbol table.

modpost creates an entry when it sees the CRC, then when it sees the
actual symbol, it complains that it's seen it before.  The preloaded
flag already exists for the equivalent case where we loaded from
Module.symvers, so use that.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 9b873ac6ed7b..5c677a3e7487 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -164,7 +164,7 @@ struct symbol {
 	unsigned int vmlinux:1;    /* 1 if symbol is defined in vmlinux */
 	unsigned int kernel:1;     /* 1 if symbol is from kernel
 				    *  (only for external modules) **/
-	unsigned int preloaded:1;  /* 1 if symbol from Module.symvers */
+	unsigned int preloaded:1;  /* 1 if symbol from Module.symvers, or crc */
 	enum export  export;       /* Type of export */
 	char name[0];
 };
@@ -332,8 +332,11 @@ static void sym_update_crc(const char *name, struct mo=
dule *mod,
 {
 	struct symbol *s =3D find_symbol(name);
=20
-	if (!s)
+	if (!s) {
 		s =3D new_symbol(name, mod, export);
+		/* Don't complain when we find it later. */
+		s->preloaded =3D 1;
+	}
 	s->crc =3D crc;
 	s->crc_valid =3D 1;
 }

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__6_Nov_2013_10_07_41_+1100_Pnx5z6+=5oQy6/tP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeXpBAAoJEMDTa8Ir7ZwVZpwP/AiH/fj6T9CWvO5F/5fFsYdS
PnNTvZBLauuBEZYCZgeCKM7QekQDwlK5lfWh4GfoEdnQRD0RjdKfFp7jq8Uj0LO9
lfU7kmC/8bVBYpBR5LsaPoEG62YaM2k7+TiUVC8eWD7VewlJTeUdsYsm4oQAaKZE
iPq+w3WqP8lw3wBOYDUsW8xa2n5imG0EIZU868g3WrJtvNhBgNF9pTnusVdj47hO
Ik0jZ1yR14V0GyLRcQJzekT/f1PLNOqIusKahev3UHLAH8kiTb0ujYhQS4SFIYNR
v6XjaCJIqb4CdiF+4LRNbrm5DrC7fMslMsoKivDHKSA7UnpXOKRpgaJgv6JfPlCr
Fsh4KICTnwilBd+kDftUbVIVbaKx4ncyoanYOV8Xiyd9lz8U+VldbvlyJ9F7O5uz
2hPh0m3TwhKR+OetnC3gYxYpTiVbNlvVHM+9Px9sCllzIbf0WPajDRiOX5Dqeg+E
WYpDNkqHGsiSKCwEJeQZekDM5s0v3eU6wEK4XKYzMctCkVzU45NulKRm66uU7BDd
VHbRsW5bh0kwYkwY41RlhGcO2LZHN7/2Cja3GBBBsOt7xF5Jo+05EuvetntzXX+m
OU6DwyAEp+H605XZWFQhGfNUfAjOktnE16oYoG3EoQLJddmRb+OXQv4hjFaSIhPC
IqtOM8OEvnxL/ajcm5AN
=tiy7
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Nov_2013_10_07_41_+1100_Pnx5z6+=5oQy6/tP--
