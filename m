Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaEWGoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 02:44:11 -0400
Received: from ozlabs.org ([103.22.144.67]:43349 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbaEWGoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 02:44:09 -0400
Date: Fri, 23 May 2014 16:44:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Steve Capper <steve.capper@linaro.org>
Subject: linux-next: manual merge of the tip tree with the arm64 tree
Message-ID: <20140523164402.37eceb11@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/o1L+NY9/KG=Pl4znMo5x2aA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/o1L+NY9/KG=Pl4znMo5x2aA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm64/mm/mmu.c between commit a501e32430d4 ("arm64: Clean up the
default pgprot setting") and 206a2a73a62d ("arm64: mm: Create gigabyte
kernel logical mappings where possible") from the arm64 tree and commit
d7ecbddf4cae ("arm64: Add function to create identity mappings") from
the tip tree.

I fixed it up (maybe - see below - this may not be complete) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/mm/mmu.c
index 3a729de96f15,4a829a210bb6..000000000000
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@@ -158,6 -192,17 +160,17 @@@ static void __init alloc_init_pmd(pud_
  {
  	pmd_t *pmd;
  	unsigned long next;
+ 	pmdval_t prot_sect;
+ 	pgprot_t prot_pte;
+=20
+ 	if (map_io) {
+ 		prot_sect =3D PMD_TYPE_SECT | PMD_SECT_AF |
+ 			    PMD_ATTRINDX(MT_DEVICE_nGnRE);
+ 		prot_pte =3D __pgprot(PROT_DEVICE_nGnRE);
+ 	} else {
 -		prot_sect =3D prot_sect_kernel;
++		prot_sect =3D PROT_SECT_NORMAL_EXEC;
+ 		prot_pte =3D PAGE_KERNEL_EXEC;
+ 	}
 =20
  	/*
  	 * Check for initial section mappings in the pgd/pud and remove them.
@@@ -195,30 -242,7 +210,30 @@@ static void __init alloc_init_pud(pgd_
 =20
  	do {
  		next =3D pud_addr_end(addr, end);
 -		alloc_init_pmd(pud, addr, next, phys, map_io);
 +
 +		/*
 +		 * For 4K granule only, attempt to put down a 1GB block
 +		 */
 +		if ((PAGE_SHIFT =3D=3D 12) &&
 +		    ((addr | next | phys) & ~PUD_MASK) =3D=3D 0) {
 +			pud_t old_pud =3D *pud;
 +			set_pud(pud, __pud(phys | PROT_SECT_NORMAL_EXEC));
 +
 +			/*
 +			 * If we have an old value for a pud, it will
 +			 * be pointing to a pmd table that we no longer
 +			 * need (from swapper_pg_dir).
 +			 *
 +			 * Look up the old pmd table and free it.
 +			 */
 +			if (!pud_none(old_pud)) {
 +				phys_addr_t table =3D __pa(pmd_offset(&old_pud, 0));
 +				memblock_free(table, PAGE_SIZE);
 +				flush_tlb_all();
 +			}
 +		} else {
- 			alloc_init_pmd(pud, addr, next, phys);
++			alloc_init_pmd(pud, addr, next, phys, map_io);
 +		}
  		phys +=3D next - addr;
  	} while (pud++, addr =3D next, addr !=3D end);
  }

--Sig_/o1L+NY9/KG=Pl4znMo5x2aA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfu43AAoJEMDTa8Ir7ZwVi3gP/A5Va4NWmxVYekFMSZoEHiGw
yPRG7i4l3veCE+q31fkSsTG41fxcQH79S1gwHj44dfLtFlfpxqVaFGZZa8S2bxOY
5UWNA9wTx4WG3dVCaSABPjFijPoDVr593pcW+xJNSnNp1QAKPpli/tV4hTxDE+jV
AL8hVLKNEuQNH0iVOrm411zLxKIGrkUCX9fGmGl+On679QQCydDd6djzBAlOmDNI
MvdlBrRpjBATUichzqgwF4yX/paN4P8z52PrWa1+WcHwRqGkDVxhKqIxGps37y3l
oaeRkY+WxWdiP3YPgykd7hgQq13sq8UymJXjSya7GYuQZsQqIFiAnOfjuEXigS57
qoEzNzXaFw1aZA+zxO84c5TxLr1r7uwmy6dLK3xJTqO6o9UUEq6dCf4RSmskIT+l
87xjfc/qE56dwqHjK2D7v4FIKzYxlSlsAnLEZeMTFk8P034mlPHSJ66wl0xeFvPG
MA2Wh821R77JebxLYULbAPBt8GePiutxvrXzQr1ezCYbDPki1zSate4gDMl2k8aj
/EYv90uXQJgkpLcRFA1AUSnekHaZx7/6xRtzUctHHq9L2mCGm32Yxa+t09kKwQfo
V1Yb0iueHl80l/UGEcABHFrZU7i7kxhPQ2EIcVic6T0TaSW5so9UDx8NGizSi/PD
mpD5cLlt2YK8PairSV/M
=p85v
-----END PGP SIGNATURE-----

--Sig_/o1L+NY9/KG=Pl4znMo5x2aA--
