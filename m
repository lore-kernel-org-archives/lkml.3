Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab3FFDzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 23:55:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37226 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818Ab3FFDz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 23:55:29 -0400
Date: Thu, 6 Jun 2013 13:55:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: linux-next: manual merge of the kvm tree with the s390 tree
Message-Id: <20130606135520.f8ab22c8419681b90b833df5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Jun_2013_13_55_20_+1000_0NjV/TsfWlwhbUyn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Jun_2013_13_55_20_+1000_0NjV/TsfWlwhbUyn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/s390/include/asm/pgtable.h between commit 338679f7ba4a
("s390/pgtable: Fix guest overindication for change bit") from the s390
tree and commit 0d0dafc1e48f ("s390/kvm: rename RCP_xxx defines to
PGSTE_xxx") from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/include/asm/pgtable.h
index e8b6e5b,1d0ad7d..0000000
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@@ -632,11 -628,10 +628,11 @@@ static inline void pgste_set_unlock(pte
  {
  #ifdef CONFIG_PGSTE
  	asm(
- 		"	nihh	%1,0xff7f\n"	/* clear RCP_PCL_BIT */
+ 		"	nihh	%1,0xff7f\n"	/* clear PCL bit */
  		"	stg	%1,%0\n"
  		: "=3DQ" (ptep[PTRS_PER_PTE])
 -		: "d" (pgste_val(pgste)), "Q" (ptep[PTRS_PER_PTE]) : "cc");
 +		: "d" (pgste_val(pgste)), "Q" (ptep[PTRS_PER_PTE])
 +		: "cc", "memory");
  	preempt_enable();
  #endif
  }
@@@ -712,19 -700,17 +708,19 @@@ static inline void pgste_set_key(pte_t=20
  {
  #ifdef CONFIG_PGSTE
  	unsigned long address;
 -	unsigned long okey, nkey;
 +	unsigned long nkey;
 =20
 -	if (!pte_present(entry))
 +	if (pte_val(entry) & _PAGE_INVALID)
  		return;
 +	VM_BUG_ON(!(pte_val(*ptep) & _PAGE_INVALID));
  	address =3D pte_val(entry) & PAGE_MASK;
 -	okey =3D nkey =3D page_get_storage_key(address);
 -	nkey &=3D ~(_PAGE_ACC_BITS | _PAGE_FP_BIT);
 -	/* Set page access key and fetch protection bit from pgste */
 -	nkey |=3D (pgste_val(pgste) & (PGSTE_ACC_BITS | PGSTE_FP_BIT)) >> 56;
 -	if (okey !=3D nkey)
 -		page_set_storage_key(address, nkey, 0);
 +	/*
 +	 * Set page access key and fetch protection bit from pgste.
 +	 * The guest C/R information is still in the PGSTE, set real
 +	 * key C/R to 0.
 +	 */
- 	nkey =3D (pgste_val(pgste) & (RCP_ACC_BITS | RCP_FP_BIT)) >> 56;
++	nkey =3D (pgste_val(pgste) & (PGSTE_ACC_BITS | PGSTE_FP_BIT)) >> 56;
 +	page_set_storage_key(address, nkey, 0);
  #endif
  }
 =20

--Signature=_Thu__6_Jun_2013_13_55_20_+1000_0NjV/TsfWlwhbUyn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsAgsAAoJEECxmPOUX5FEdDgP/3pjwJCeAmN4772wKpMOcypD
EgZQ5sLWYBXMzYSC2hSo0wmgS5vq1vbdcik5E72Bqf2p8Z/sEAYwrc3aZVsXRfQV
mzQbAeHTlxXRmc1pJbxSfRCn71qA9mAr+qvdf5C15FGMxg5pEKMOgC4+qWriiYaT
xnxjVvDOODHLMCn7sqlk5sQj3FkrzZelkZKNXgryXBDg/MaxHTTt8Dw8J0GRjPkk
nirjvTf8xbknW0CoIULvc/HaVlViw8fGDEvPZBLxO2xPWTU1NmwhUrAtEeh/VZW2
TJsGMHdSn5vm1FzEUf5AP4nqrP03zI72ctCzpPgkmtE5uGOnQMpeFtpFyBOZC5Vi
iqGsyR155nW7lMHNRf3TYCwCf7B/a5yJEf5wI5NWp8b3i1xLmVa+PIYT3QxyP3Ni
Srzaq3LIyoXT3ucd304DZd8jz1h2gpAZEU7EvdXxYcBpqH/4jmg+ZX9GorxXFxLc
PX3w4WD360bpZPreaWnVIXBOxNDfxpLj2Qr79FFX1Xp6lD7gc2Eq/s/MQppwqUZ/
z/d4gBNXwZpgtL7CGOnkxuwG8ZKAI1YXvB+CRfzeL1y6tO9GvKMA73Btdazh88An
t7Klwy8i8LMD5hXGdVwgAWloeBCGadLzTKTl7Qm36c6JGyqmbjaK6c701m1F1KzH
2sjbVlRMvqCsO8kv1RJo
=eISG
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Jun_2013_13_55_20_+1000_0NjV/TsfWlwhbUyn--
