Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaJGE7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 00:59:37 -0400
Received: from ozlabs.org ([103.22.144.67]:52742 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbaJGE7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 00:59:36 -0400
Date: Tue, 7 Oct 2014 15:59:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the s390 tree
Message-ID: <20141007155926.7ac19cdf@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qh.VIviW9_f=h8Zxi/8=d8R"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qh.VIviW9_f=h8Zxi/8=d8R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/s390/mm/pgtable.c between commit 9511571c4f0e ("s390: mm: fixing
calls of pte_unmap_unlock") from the s390 tree and commit dc77d344b41f
("KVM: s390/mm: fix up indentation of set_guest_storage_key") from the
kvm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/mm/pgtable.c
index a0f934a435e2,296b61a4af59..000000000000
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@@ -644,82 -656,29 +656,29 @@@ void __gmap_zap(struct gmap *gmap, unsi
  	}
  	pgste_set_unlock(ptep, pgste);
  out_pte:
 -	pte_unmap_unlock(*ptep, ptl);
 +	pte_unmap_unlock(ptep, ptl);
  }
-=20
- /*
-  * this function is assumed to be called with mmap_sem held
-  */
- void __gmap_zap(unsigned long address, struct gmap *gmap)
- {
- 	unsigned long *table, *segment_ptr;
- 	unsigned long segment, pgstev, ptev;
- 	struct gmap_pgtable *mp;
- 	struct page *page;
-=20
- 	segment_ptr =3D gmap_table_walk(address, gmap);
- 	if (IS_ERR(segment_ptr))
- 		return;
- 	segment =3D *segment_ptr;
- 	if (segment & _SEGMENT_ENTRY_INVALID)
- 		return;
- 	page =3D pfn_to_page(segment >> PAGE_SHIFT);
- 	mp =3D (struct gmap_pgtable *) page->index;
- 	address =3D mp->vmaddr | (address & ~PMD_MASK);
- 	/* Page table is present */
- 	table =3D (unsigned long *)(segment & _SEGMENT_ENTRY_ORIGIN);
- 	table =3D table + ((address >> 12) & 0xff);
- 	pgstev =3D table[PTRS_PER_PTE];
- 	ptev =3D table[0];
- 	/* quick check, checked again with locks held */
- 	if (((pgstev & _PGSTE_GPS_USAGE_MASK) =3D=3D _PGSTE_GPS_USAGE_UNUSED) ||
- 	    ((pgstev & _PGSTE_GPS_ZERO) && (ptev & _PAGE_INVALID)))
- 		gmap_zap_unused(gmap->mm, address);
- }
  EXPORT_SYMBOL_GPL(__gmap_zap);
 =20
- void gmap_discard(unsigned long from, unsigned long to, struct gmap *gmap)
+ void gmap_discard(struct gmap *gmap, unsigned long from, unsigned long to)
  {
-=20
- 	unsigned long *table, address, size;
+ 	unsigned long gaddr, vmaddr, size;
  	struct vm_area_struct *vma;
- 	struct gmap_pgtable *mp;
- 	struct page *page;
 =20
  	down_read(&gmap->mm->mmap_sem);
- 	address =3D from;
- 	while (address < to) {
- 		/* Walk the gmap address space page table */
- 		table =3D gmap->table + ((address >> 53) & 0x7ff);
- 		if (unlikely(*table & _REGION_ENTRY_INVALID)) {
- 			address =3D (address + PMD_SIZE) & PMD_MASK;
- 			continue;
- 		}
- 		table =3D (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
- 		table =3D table + ((address >> 42) & 0x7ff);
- 		if (unlikely(*table & _REGION_ENTRY_INVALID)) {
- 			address =3D (address + PMD_SIZE) & PMD_MASK;
+ 	for (gaddr =3D from; gaddr < to;
+ 	     gaddr =3D (gaddr + PMD_SIZE) & PMD_MASK) {
+ 		/* Find the vm address for the guest address */
+ 		vmaddr =3D (unsigned long)
+ 			radix_tree_lookup(&gmap->guest_to_host,
+ 					  gaddr >> PMD_SHIFT);
+ 		if (!vmaddr)
  			continue;
- 		}
- 		table =3D (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
- 		table =3D table + ((address >> 31) & 0x7ff);
- 		if (unlikely(*table & _REGION_ENTRY_INVALID)) {
- 			address =3D (address + PMD_SIZE) & PMD_MASK;
- 			continue;
- 		}
- 		table =3D (unsigned long *)(*table & _REGION_ENTRY_ORIGIN);
- 		table =3D table + ((address >> 20) & 0x7ff);
- 		if (unlikely(*table & _SEGMENT_ENTRY_INVALID)) {
- 			address =3D (address + PMD_SIZE) & PMD_MASK;
- 			continue;
- 		}
- 		page =3D pfn_to_page(*table >> PAGE_SHIFT);
- 		mp =3D (struct gmap_pgtable *) page->index;
- 		vma =3D find_vma(gmap->mm, mp->vmaddr);
- 		size =3D min(to - address, PMD_SIZE - (address & ~PMD_MASK));
- 		zap_page_range(vma, mp->vmaddr | (address & ~PMD_MASK),
- 			       size, NULL);
- 		address =3D (address + PMD_SIZE) & PMD_MASK;
+ 		vmaddr |=3D gaddr & ~PMD_MASK;
+ 		/* Find vma in the parent mm */
+ 		vma =3D find_vma(gmap->mm, vmaddr);
+ 		size =3D min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
+ 		zap_page_range(vma, vmaddr, size, NULL);
  	}
  	up_read(&gmap->mm->mmap_sem);
  }
@@@ -994,13 -943,13 +943,13 @@@ retry
  	}
  	if (!(pte_val(*ptep) & _PAGE_INVALID) &&
  	     (pte_val(*ptep) & _PAGE_PROTECT)) {
- 			pte_unmap_unlock(ptep, ptl);
- 			if (fixup_user_fault(current, mm, addr, FAULT_FLAG_WRITE)) {
- 				up_read(&mm->mmap_sem);
- 				return -EFAULT;
- 			}
- 			goto retry;
 -		pte_unmap_unlock(*ptep, ptl);
++		pte_unmap_unlock(ptep, ptl);
+ 		if (fixup_user_fault(current, mm, addr, FAULT_FLAG_WRITE)) {
+ 			up_read(&mm->mmap_sem);
+ 			return -EFAULT;
  		}
+ 		goto retry;
+ 	}
 =20
  	new =3D old =3D pgste_get_lock(ptep);
  	pgste_val(new) &=3D ~(PGSTE_GR_BIT | PGSTE_GC_BIT |

--Sig_/qh.VIviW9_f=h8Zxi/8=d8R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUM3MyAAoJEMDTa8Ir7ZwVWkoP/jgnNohJfMYOk9FkC5ZNnE5j
G2aKVoXuPIdeatS2y/UPkWB/k4dfdReM5k9qpUXjQ8Ag51s8ez4SIVZg0+NAnkTg
oOmirTgS5ZB8F82n+p/ywL9AEbtvtDECcMmnKSVpVAF+J8n48rz/HuIcsHP3UvRi
78vNocm16Je2olcI3++7XTF3ADsfh5m9eWFiIWR4/LxipLYfWvaOC899h2Fm2zJ7
h2o6RGPZqqNrp2dHW6Hmk3Z0qBGRhePHpPTDRj4B9+klspDQaXH+xnzcRs9hA+lu
V9Ft7NwXwfBVHfYmRhy9xVfV33lEhjQ8SiewehzwMjmoMquvwJFKuUp75CUosxeq
DyUt9xDTMkq5qKOCDnVw1ZNoIA6RBNOjTnru3RHGDMaX3KHf4AocMkyXOxkT4uHH
ykpmo9moymuWC83+S0kx0lXpYDDUboyXPgpWiSWMR6VUFq8mzP6yyHrMyit8UHOf
xOuYp87qNtDICJJELLxh58J/aBsohIRI7/SuFhAx2EbKGqtrWreVFKDlv6iELyZd
6IhiRSewZWF47NdtF44cvU5wIAs0hagd3h32bH83KdBtqXXbAtEbJ5BF+bWXaZ/E
qhsjK2RFhEKjCLmrCwa8TNfLyIKhTZF27id+gVfETUiLHwcdxr7ti8ff+kJLhKfd
/nQeTFgcwaO2rIvNw3uk
=YaVE
-----END PGP SIGNATURE-----

--Sig_/qh.VIviW9_f=h8Zxi/8=d8R--
